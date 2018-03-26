function FrostBurst(event)
	local caster = event.caster
	local ability = event.ability
	local point = caster:GetAbsOrigin()
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local projectiles = ability:GetLevelSpecialValueFor( "projectiles", ability:GetLevel() - 1 )
	local projectile_damage = ability:GetLevelSpecialValueFor( "projectile_damage", ability:GetLevel() - 1 )
	local projectile_distance = ability:GetLevelSpecialValueFor( "projectile_distance", ability:GetLevel() - 1 )
	local projectile_speed = ability:GetLevelSpecialValueFor( "projectile_speed", ability:GetLevel() - 1 )
	local projectile_radius_start = ability:GetLevelSpecialValueFor( "projectile_radius_start", ability:GetLevel() - 1 )
	local projectile_radius_end = ability:GetLevelSpecialValueFor( "projectile_radius_end", ability:GetLevel() - 1 )
	local projectile_effect = "particles/units/heroes/hero_tusk/tusk_ice_shards_projectile.vpcf"
	local particle = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl( particle, 0, point )
	ParticleManager:SetParticleControl( particle, 1, Vector(radius,0,0) )
	ParticleManager:SetParticleControl( particle, 2, point)
	ParticleManager:SetParticleControl( particle, 3, Vector(radius,0,0))
	GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), radius, false)
	DestroyRocksAroundPoint(caster:GetAbsOrigin(), radius)
	local fv = nil
	local info = nil
	local projectile = nil
	local rotation = 360/projectiles
	local rotated = nil
	for i =1,projectiles do
		rotated = rotation * i
		fv = RotatePosition(Vector(0,0,0), QAngle(0,rotated,0), caster:GetForwardVector())
		info = 
		{
		Ability = ability,
        EffectName = projectile_effect,
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = projectile_distance,
        fStartRadius = projectile_radius_start,
        fEndRadius = projectile_radius_end,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = fv * projectile_speed,
		bProvidesVision = true,
		iVisionRadius = 10,
		iVisionTeamNumber = caster:GetTeamNumber()
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end