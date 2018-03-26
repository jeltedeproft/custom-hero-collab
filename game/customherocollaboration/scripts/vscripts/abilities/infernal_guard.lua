function InfernalGuard(event)
	local caster = event.caster
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local first_distance = ability:GetLevelSpecialValueFor( "first_distance", ability:GetLevel() - 1 )
	local second_distance = ability:GetLevelSpecialValueFor( "second_distance", ability:GetLevel() - 1 )
	local cast_damage = ability:GetLevelSpecialValueFor( "cast_damage", ability:GetLevel() - 1 )
	local cast_radius = ability:GetLevelSpecialValueFor( "cast_radius", ability:GetLevel() - 1 )
	local casterPos = caster:GetAbsOrigin()
	caster.lastpos = casterPos

	EmitSoundOn("Hero_Oracle.PurifyingFlames.Damage", caster) 

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl( particle, 0, casterPos)

	local units = FindUnitsInRadius(caster:GetTeam() , casterPos , nil, cast_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k,v in pairs(units) do
		ApplyDamage({victim = v, attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, damage = cast_damage})
	end

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl( particle, 0, casterPos)
	ParticleManager:SetParticleControl( particle, 1, casterPos)
	ParticleManager:SetParticleControl( particle, 2, casterPos)
	ParticleManager:SetParticleControl( particle, 3, casterPos)

	local fv = caster:GetForwardVector()
	local pos1 = casterPos + RotatePosition(Vector(0,0,0), QAngle(0,90,0), fv) * first_distance
	local pos2 = casterPos + RotatePosition(Vector(0,0,0), QAngle(0,-90,0), fv) * second_distance

	local dummy1 = CreateUnitByName("dummy_unit", pos1, false, nil, nil, caster:GetTeam())
	ability:ApplyDataDrivenModifier(caster, dummy1, "modifier_infernal_guard_damage", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, dummy1, "modifier_infernal_guard", {duration = duration})
	ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy1)
	dummy1:AddNewModifier(dummy1, nil, "modifier_phased", {duration = duration})
	dummy1.distance = first_distance
	dummy1.lastpos = dummy1:GetAbsOrigin()

	local dummy2 = CreateUnitByName("dummy_unit", pos2, false, nil, nil, caster:GetTeam())
	ability:ApplyDataDrivenModifier(caster, dummy2, "modifier_infernal_guard_damage", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, dummy2, "modifier_infernal_guard", {duration = duration})
	ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy2)
	dummy2:AddNewModifier(dummy1, nil, "modifier_phased", {duration = duration})
	dummy2.distance = second_distance
	dummy2.lastpos = dummy2:GetAbsOrigin()
end

function InfernalGuardOrbit(event)
	local dummy = event.target
	local caster = event.caster
	local offset = dummy.distance
	local dummyPos = dummy.lastpos
	local dummyNewPos = dummy:GetAbsOrigin()
	local casterPos = caster.lastpos
	local casterNewPos = caster:GetAbsOrigin()

	local diff = casterNewPos - casterPos
    local diffNormalized = diff:Normalized()
    local diffLength = diff:Length2D()

    local distance = dummyNewPos - casterNewPos
    local distanceNormalized = distance:Normalized()
    local rotatedDistanceNormalized = RotatePosition(Vector(0,0,0), QAngle(0,5,0), distanceNormalized)
    local distanceOffset = rotatedDistanceNormalized * offset

    local recalculatedDiff = diffNormalized * diffLength

    dummy:SetAbsOrigin(casterNewPos + diff + distanceOffset)

    dummy.lastpos = dummyNewPos
    caster.lastpos = casterNewPos
end

function InfernalGuardTreeDestroy (event)
	local target = event.target
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	GridNav:DestroyTreesAroundPoint(target:GetAbsOrigin(), radius, false)
end