function CombustionParticle(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	local distance = ability:GetLevelSpecialValueFor( "distance", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	ability.pdummy = CreateUnitByName("particle_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeam())
	ability:ApplyDataDrivenModifier(caster, ability.pdummy, "modifier_combustion_particle", {duration = distance/speed})
	ability.pdummy:SetForwardVector((point-caster:GetAbsOrigin()):Normalized())
	Timers:CreateTimer(0,function()
		ability.pdummy:SetAbsOrigin(ability.pdummy:GetAbsOrigin() + ability.pdummy:GetForwardVector() * radius)
		ability.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_thunder_strike_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, ability.pdummy)
	end)
end

function CombustionParticleMove(event)
	local caster = event.target
	local ability = event.ability
	local speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	speed = speed/30
	local fv = caster:GetForwardVector()
	local groundPos = GetGroundPosition(caster:GetAbsOrigin(), caster)
	caster:SetAbsOrigin(groundPos + fv * speed + Vector(0,0,80))
end

function CombustionHit(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local radius = ability:GetLevelSpecialValueFor( "combustion_radius", ability:GetLevel() - 1 )
	local mana_ratio = ability:GetLevelSpecialValueFor( "mana_ratio", ability:GetLevel() - 1 )
	if IsValidEntity(ability.pdummy) then
		ability.pdummy:RemoveSelf()
	end
	local maxMana = target:GetMaxMana()
	local currentMana = target:GetMana()
	local damage = (maxMana - currentMana) * mana_ratio

	EmitSoundOn("Hero_Antimage.ManaVoid", target)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl( particle, 0, target:GetAbsOrigin() +Vector(0,0,64))
	ParticleManager:SetParticleControl( particle, 1, Vector(radius,0,0))

	local units = FindUnitsInRadius(caster:GetTeam() , target:GetAbsOrigin() , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k,v in pairs(units) do
		ApplyDamage({victim = v, attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage})
	end
end