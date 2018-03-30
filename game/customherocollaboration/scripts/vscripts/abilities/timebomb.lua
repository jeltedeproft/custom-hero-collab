function Timebomb(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local time = ability:GetLevelSpecialValueFor( "time", ability:GetLevel() - 1 )
	local explosion_delay = ability:GetLevelSpecialValueFor( "explosion_delay", ability:GetLevel() - 1 )
	local dummy = CreateUnitByName("dummy_unit", point, false, nil, nil, caster:GetTeam())
	local dummy_modifier = dummy:FindAbilityByName("dummy_passive")
	dummy_modifier:SetLevel(1)
	local timer = time

	local random = RandomInt(1, 100)
	if random <= 10 then
		time = RandomInt(1, 10)
		timer = time
		print("Changed bomb timer to: "..time)
	end

	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_timebomb", {duration = time + explosion_delay})
	dummy:SetModel("models/heroes/techies/fx_techiesfx_mine.vmdl") 
	dummy:SetModelScale(1.2)
	EmitSoundOn("Hero_Techies.LandMine.Plant", dummy)
	EmitSoundOn("ThePredator.Tick", dummy)

	Timers:CreateTimer(0,function()
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, dummy)
		ParticleManager:SetParticleControl( particle, 0, dummy:GetAbsOrigin())
		ParticleManager:SetParticleControl( particle, 1, Vector(0,timer,1))
		ParticleManager:SetParticleControl( particle, 2, Vector(2,0,0))
		Timers:CreateTimer(0.5,function()
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, dummy)
			ParticleManager:SetParticleControl( particle, 0, dummy:GetAbsOrigin())
			ParticleManager:SetParticleControl( particle, 1, Vector(0,timer,8))
			ParticleManager:SetParticleControl( particle, 2, Vector(2,0,0))
		end)
		timer = timer - 1
		if timer > 0 then
			return 1.0
		end
	end)
end

function TimebombExplode(event)
	local caster = event.target
	local casterPos = caster:GetAbsOrigin()
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )

	StopSoundOn("ThePredator.Tick",caster)

	local pdummy = CreateUnitByName("particle_dummy_unit", casterPos, true, caster, caster, caster:GetTeam())
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_ABSORIGIN, pdummy)
	ParticleManager:SetParticleControl( particle, 0, casterPos )
	ParticleManager:SetParticleControl( particle, 1, Vector(radius*2,0,0))
	ParticleManager:SetParticleControl( particle, 2, Vector(radius*2,0,0))

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_suicide.vpcf", PATTACH_ABSORIGIN, pdummy)
	ParticleManager:SetParticleControl( particle, 0, casterPos )
	ParticleManager:SetParticleControl( particle, 1, Vector(radius/4,0,0))
	ParticleManager:SetParticleControl( particle, 2, Vector(radius*2,0,0))
	ParticleManager:SetParticleControl( particle, 3, casterPos)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf", PATTACH_ABSORIGIN, pdummy)
	ParticleManager:SetParticleControl( particle, 0, casterPos )
	ParticleManager:SetParticleControl( particle, 1, Vector(radius*1.5,0,0) )
	ParticleManager:SetParticleControl( particle, 2, casterPos)
	ParticleManager:SetParticleControl( particle, 3, casterPos)

	EmitSoundOn("Hero_Techies.LandMine.Detonate", pdummy)

	GridNav:DestroyTreesAroundPoint(casterPos, radius, false)
	DestroyRocksAroundPoint(casterPos, radius)
	local units = FindUnitsInRadius(caster:GetTeam()  , casterPos  , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k,v in pairs(units) do
		local vPos = v:GetAbsOrigin()
		local diff = (vPos - casterPos):Length2D()
		if diff < radius * (1/3) then
			ApplyDamage({victim = v, attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage*2})
		elseif diff < radius * (2/3) then
			ApplyDamage({victim = v, attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage*1.5})
		else
			ApplyDamage({victim = v, attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage})
		end
	end
end