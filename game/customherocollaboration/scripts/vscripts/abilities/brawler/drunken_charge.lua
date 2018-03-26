function DrunkenCharge(event)
	local caster = event.caster
	local ability = event.ability
	local distance = ability:GetLevelSpecialValueFor( "distance", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	EmitSoundOn("Hero_Brewmaster.Brawler.Crit", caster)
	local casterPos = caster:GetAbsOrigin()
	local casterFv = caster:GetForwardVector()
	local destination = casterPos + casterFv * distance
	while IsOutOfBounds(destination) and (destination-casterPos):Length2D()>25 do
		destination = destination - casterFv * 25
	end
	local info = 
	{
		Ability = ability,
    	EffectName = "",
    	vSpawnOrigin = caster:GetAbsOrigin(),
    	fDistance = (destination - casterPos):Length2D(),
    	fStartRadius = radius,
    	fEndRadius = radius,
    	Source = caster,
    	bHasFrontalCone = false,
    	bReplaceExisting = false,
    	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
    	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    	fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = casterFv * 99999,
		bProvidesVision = true,
		iVisionRadius = 1,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
	FindClearSpaceForUnit(caster, destination, false)

	local particle = ParticleManager:CreateParticle("particles/custom_particles/abilities/brawler/brawler_shadow_wave.vpcf", PATTACH_WORLDORIGIN, caster )
	ParticleManager:SetParticleControl( particle, 0, casterPos + Vector(0,0,30))
	ParticleManager:SetParticleControl( particle, 1, destination + Vector(0,0,30))

end