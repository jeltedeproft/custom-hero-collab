function ScatterArrows(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local projectile_distance = ability:GetLevelSpecialValueFor( "projectile_distance", ability:GetLevel() - 1 )
	local projectile_speed = ability:GetLevelSpecialValueFor( "projectile_speed", ability:GetLevel() - 1 )
	local projectile_radius = ability:GetLevelSpecialValueFor( "projectile_radius", ability:GetLevel() - 1 )
	local arrows = ability:GetLevelSpecialValueFor( "arrows", ability:GetLevel() - 1 )
	local cone_degrees = ability:GetLevelSpecialValueFor( "cone_degrees", ability:GetLevel() - 1 )
	local startFv = (point-caster:GetAbsOrigin()):Normalized()
	local startingDegree = -cone_degrees/2 - (cone_degrees/2)/arrows
	local incrementDegree = cone_degrees/arrows
	local fv = nil
	for i =1,arrows do
		fv = RotatePosition(Vector(0,0,0), QAngle(0,startingDegree + incrementDegree * i,0), startFv)

		info = 
		{
		Ability = ability,
        EffectName = "particles/custom_particles/abilities/gorgon/scatter_shot.vpcf",
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = projectile_distance,
        fStartRadius = projectile_radius,
        fEndRadius = projectile_radius,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = true,
		vVelocity = fv * projectile_speed,
		bProvidesVision = true,
		iVisionRadius = 10,
		iVisionTeamNumber = caster:GetTeamNumber()
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end