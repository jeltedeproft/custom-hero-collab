function ZeppelinBombing(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]

	local explosives = ability:GetLevelSpecialValueFor( "explosives", ability:GetLevel() - 1 )
	local speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	local distance = ability:GetLevelSpecialValueFor( "distance", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local delay = ability:GetLevelSpecialValueFor( "delay", ability:GetLevel() - 1 )

	local flight_time = distance/speed

	local bombing_interval = flight_time / explosives
	bombing_interval = bombing_interval

	local dummy = CreateUnitByName("dummy_unit", point, false, nil, nil, caster:GetTeam())
	local dummy_modifier = dummy:FindAbilityByName("dummy_passive")
	dummy_modifier:SetLevel(1)
	local dir = point - caster:GetAbsOrigin()
	dir.z = 0
	dir = dir:Normalized()
	local particle = nil
	local zeppelin = CreateUnitByName("dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeam())
	local dummy_modifier = zeppelin:FindAbilityByName("dummy_passive")
	dummy_modifier:SetLevel(1)
	EmitSoundOn("Hero_Phoenix.IcarusDive.Cast", zeppelin) 
	Timers:CreateTimer(function()
		zeppelin:SetForwardVector(dir)
		zeppelin:SetModel("models/courier/courier_mech/courier_mech_flying.vmdl")
		zeppelin:SetModelScale(1.2)
		--StartAnimation(zeppelin, {duration=flight_time, activity=ACT_DOTA_RUN , rate=1.0})
	end)
	Timers:CreateTimer(function()
		if IsValidEntity(zeppelin) == false then
			return
		end
		local pos = zeppelin:GetAbsOrigin()
		local groundPos = GetGroundPosition(pos, zeppelin)
		zeppelin:SetAbsOrigin(groundPos + Vector(0,0,450))
		if IsValidEntity(zeppelin) then
			return 0.03
		end
	end)
	ability:ApplyDataDrivenModifier(caster, zeppelin, "modifier_zeppelin", {duration = flight_time})

	Timers:CreateTimer(bombing_interval -0.03,function()
		explosives = explosives - 1
		local zepPos = zeppelin:GetAbsOrigin()
		local barrel = CreateUnitByName("dummy_unit", zepPos, false, nil, nil, zeppelin:GetTeam())
		local dummy_modifier = barrel:FindAbilityByName("dummy_passive")
		dummy_modifier:SetLevel(1)
		EmitSoundOn("Hero_Techies.RemoteMine.Toss", barrel)
		ability:ApplyDataDrivenModifier(zeppelin, barrel, "modifier_barrel", {duration = 10})
		barrel:SetAbsOrigin(zepPos + Vector(0,0,-50))
		barrel:SetModel("models/heroes/techies/fx_techies_remotebomb.vmdl")
		Timers:CreateTimer(delay,function()
			local groundPos = GetGroundPosition(barrel:GetAbsOrigin(), barrel)
			EmitSoundOn("Hero_Techies.RemoteMine.Detonate", barrel)
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl( particle, 0, groundPos )
			ParticleManager:SetParticleControl( particle, 1, Vector(radius,0,0) )
			ParticleManager:SetParticleControl( particle, 2, groundPos)
			ParticleManager:SetParticleControl( particle, 3, groundPos)
			GridNav:DestroyTreesAroundPoint(groundPos, radius, false)
			DestroyRocksAroundPoint(groundPos, radius)
			local units = FindUnitsInRadius(barrel:GetTeam()  , groundPos  , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for k,v in pairs(units) do
				ApplyDamage({victim = v, attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage})
			end
			Timers:CreateTimer(0.03,function()
				barrel:RemoveSelf()
			end)
		end)
		if explosives > 0 then 
			return bombing_interval
		end
	end)
end

function ZeppelinMove(event)
	local caster = event.target
	local ability = event.ability
	local speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	local actualspeed = speed /30
	local fv = caster:GetForwardVector()
	local origin = caster:GetAbsOrigin()
	local new_position = origin + fv * actualspeed
	caster:SetAbsOrigin(new_position)
end

function BarrelMove(event)
	local caster = event.target
	local ability = event.ability
	local delay = ability:GetLevelSpecialValueFor( "delay", ability:GetLevel() - 1 )
	local speed = 400 / delay
	local actualspeed = speed / 30
	local origin = caster:GetAbsOrigin()
	local new_position = origin + Vector(0,0,-actualspeed)
	caster:SetAbsOrigin(new_position)
end