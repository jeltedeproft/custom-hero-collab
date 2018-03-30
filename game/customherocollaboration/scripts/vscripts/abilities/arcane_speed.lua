function ArcaneSpeed(event)
	local caster = event.caster
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local attacks = ability:GetLevelSpecialValueFor( "attacks", ability:GetLevel() - 1 )
	ability.point = caster:GetAbsOrigin() + caster:GetForwardVector() * radius
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_arcane_speed", {duration=duration})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_arcane_speed_attacks", {duration=duration})
end


function ArcaneSpeedMove(event)
	local caster = event.caster
	local ability = event.ability
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local angle = (360/30)/duration

	local distanceNormalized = (caster:GetAbsOrigin() - ability.point):Normalized()
	local rotatedDistanceNormalized = RotatePosition(Vector(0,0,0), QAngle(0,angle,0), distanceNormalized)
	local distanceOffset = rotatedDistanceNormalized * radius
	caster:SetAbsOrigin(ability.point + distanceOffset)
	caster:SetForwardVector(-distanceNormalized) 
end

function ArcaneSpeedAttack(event)
	local caster = event.caster
	local ability = event.ability
	local attack_duration = ability:GetLevelSpecialValueFor( "attack_duration", ability:GetLevel() - 1 )
	StartAnimation(caster, {duration=0.1, activity=ACT_DOTA_ATTACK, rate=2.0})
	EmitSoundOn("Hero_PhantomAssassin.PreAttack", caster)
	local dummy = CreateUnitByName("dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeam())
	local dummy_modifier = dummy:FindAbilityByName("dummy_passive")
	dummy_modifier:SetLevel(1)
	dummy.hit = {}
	ability:ApplyDataDrivenModifier(caster, dummy, "modifier_arcane_speed_attack_move", {duration=attack_duration})
	dummy.particle = ParticleManager:CreateParticle("particles/custom_particles/abilities/arcane_speed/assassin_arcane_speed.vpcf", PATTACH_ABSORIGIN, caster)
	dummy:SetForwardVector(caster:GetForwardVector())
	ParticleManager:SetParticleControlForward(dummy.particle, 0, dummy:GetForwardVector())
	ParticleManager:SetParticleControlForward(dummy.particle, 1, dummy:GetForwardVector())
	ParticleManager:SetParticleControlForward(dummy.particle, 2, caster:GetForwardVector()) 
	ParticleManager:SetParticleControl( dummy.particle, 0, dummy:GetAbsOrigin())
	ParticleManager:SetParticleControl( dummy.particle, 1, dummy:GetAbsOrigin())
	ParticleManager:SetParticleControl( dummy.particle, 2, dummy:GetAbsOrigin())
end

function ArcaneSpeedAttackTick(event)
	local caster = event.caster
	local dummy = event.target
	local ability = event.ability
	local attack_duration = ability:GetLevelSpecialValueFor( "attack_duration", ability:GetLevel() - 1 )
	local attack_radius = ability:GetLevelSpecialValueFor( "attack_radius", ability:GetLevel() - 1 )
	local attack_range = ability:GetLevelSpecialValueFor( "attack_range", ability:GetLevel() - 1 )
	local attack_damage = ability:GetLevelSpecialValueFor( "attack_damage", ability:GetLevel() - 1 )
	local attack_rotation = ability:GetLevelSpecialValueFor( "attack_rotation", ability:GetLevel() - 1 )

	DestroyRocksAroundPoint(dummy:GetAbsOrigin(), attack_radius)

	local units = FindUnitsInRadius(caster:GetTeam() , dummy:GetAbsOrigin() , nil, attack_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for k,v in pairs(units) do
		if dummy.hit[v] == nil then
			dummy.hit[v] = true
			EmitSoundOn("Hero_PhantomAssassin.Attack", v)
			ApplyDamage({victim = v, attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, damage = attack_damage})
			ParticleManager:CreateParticle("particles/generic_gameplay/generic_hit_blood.vpcf", PATTACH_ABSORIGIN, v)
		end
	end

	local dummyPos = dummy:GetAbsOrigin()
	local angle = (attack_rotation/30)/attack_duration
	local rotatedFv = RotatePosition(Vector(0,0,0), QAngle(0,angle,0), dummy:GetForwardVector())
	dummy:SetForwardVector(rotatedFv)
	dummy:SetAbsOrigin(dummyPos + rotatedFv * ((attack_range/30)/attack_duration))
	ParticleManager:SetParticleControlForward(dummy.particle, 0, dummy:GetForwardVector())
	ParticleManager:SetParticleControlForward(dummy.particle, 1, dummy:GetForwardVector())
	ParticleManager:SetParticleControlForward(dummy.particle, 2, caster:GetForwardVector()) 
	ParticleManager:SetParticleControl( dummy.particle, 0, dummy:GetAbsOrigin())
	ParticleManager:SetParticleControl( dummy.particle, 1, dummy:GetAbsOrigin())
	ParticleManager:SetParticleControl( dummy.particle, 2, dummy:GetAbsOrigin())

end