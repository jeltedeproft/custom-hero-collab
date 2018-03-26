function WaterCannonStart(event)
	local caster = event.caster
	local ability = event.ability
	ability.point = event.target_points[1]
end

function WaterCannonTick(event)
	local caster = event.caster
	local casterPos = caster:GetAbsOrigin()
	local ability = event.ability
	local point = ability.point
	local missile_speed = ability:GetLevelSpecialValueFor( "missile_speed", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local finalPoint = point + RandomVector(RandomInt(0, radius))
	local distance = (finalPoint - casterPos):Length2D()
	local fv = (finalPoint - casterPos):Normalized()
	local info = 
	{
		Ability = ability,
        EffectName = "particles/custom_particles/abilities/neutral/water_cannon.vpcf",
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = distance,
        fStartRadius = 64,
        fEndRadius = 64,
        Source = caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = false,
		vVelocity = fv * missile_speed,
		bProvidesVision = false,
		iVisionRadius = 1000,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	EmitSoundOn("Hero_Morphling.attack", caster)
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function WaterCannonHit(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local radius = ability:GetLevelSpecialValueFor( "explosion_radius", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local units = FindUnitsInRadius(caster:GetTeam() , point , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for k,v in pairs(units) do
    	ability:ApplyDataDrivenModifier(caster, v, "modifier_water_cannon_stun", {})
	    ApplyDamage({ victim = v, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
    end
    EmitSoundOnLocationWithCaster(point, "Hero_Morphling.projectileImpact", caster) 
end