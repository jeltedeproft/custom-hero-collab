function spit(keys)
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local teamnumber = caster:GetTeamNumber()
	local origin = caster:GetAbsOrigin()
	local forward = caster:GetForwardVector()
	local fireparticle = keys.fireparticlename
	local poisonparticle = keys.poisonparticlename
	local target = keys.target_points[1]
	local direction = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()

	--fire
	local fire_range = ability:GetLevelSpecialValueFor("fire_range", ability:GetLevel() - 1 )
	local start_radius = ability:GetLevelSpecialValueFor("start_radius", ability:GetLevel() - 1 )
	local end_radius = ability:GetLevelSpecialValueFor("end_radius", ability:GetLevel() - 1 )
	local fire_speed = ability:GetLevelSpecialValueFor("fire_speed", ability:GetLevel() - 1 )

	--poison
	local speed = ability:GetLevelSpecialValueFor("speed", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )
	local distance = ability:GetLevelSpecialValueFor("distance", ability:GetLevel() - 1 )

	--talent
	local talent = caster:FindAbilityByName("chimera_spit_range")

	if talent:GetLevel() > 0 then
		fire_range = fire_range + talent:GetSpecialValueFor("value")
		distance = distance + talent:GetSpecialValueFor("value")
	end

	local fireprojectile = ProjectileManager:CreateLinearProjectile( {
		Ability				= ability,
		EffectName			= fireparticle,
		vSpawnOrigin		= caster_location,
		fDistance			= fire_range,
		fStartRadius		= start_radius,
		fEndRadius			= end_radus,
		Source				= caster,
		bHasFrontalCone		= true,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_CUSTOM + DOTA_UNIT_TARGET_BASIC,
		--	fExpireTime			= ,
		bDeleteOnHit		= false,
		vVelocity			= direction * fire_speed,
		bProvidesVision		= false,
	} )
	caster:EmitSound("Hero_DragonKnight.BreathFire")	

	local poisonprojectile = ProjectileManager:CreateLinearProjectile( {
		Ability				= ability,
		EffectName			= poisonparticle,
		vSpawnOrigin		= caster_location,
		fDistance			= distance,
		fStartRadius		= radius,
		fEndRadius			= radius,
		Source				= caster,
		bHasFrontalCone		= true,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_CUSTOM + DOTA_UNIT_TARGET_BASIC,
		--	fExpireTime			= ,
		bDeleteOnHit		= false,
		vVelocity			= direction * speed,
		bProvidesVision		= false,
	} )
end