function BatForm(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local projectile_speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	local delay = ability:GetLevelSpecialValueFor( "delay", ability:GetLevel() - 1 )
	local projectile_effect = ""
	local diff = caster:GetAbsOrigin() - point
	local diffLength = diff:Length2D()
	local fv = caster:GetForwardVector() 
	local finished = false
	--local modelscale = caster:GetModelScale()
	EmitSoundOn("Hero_DeathProphet.Death", caster) 
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_CAST_ABILITY_1 , rate=0.5})
	local initialparticle = ParticleManager:CreateParticle("particles/units/heroes/hero_death_prophet/death_prophet_spawn.vpcf", PATTACH_ABSORIGIN, caster )
	local info = 
	{
		Ability = ability,
    	EffectName = projectile_effect,
    	vSpawnOrigin = caster:GetAbsOrigin(),
    	fDistance = diffLength,
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
		vVelocity = fv * projectile_speed,
		bProvidesVision = true,
		iVisionRadius = 1,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_bat_form", {duration = 2.0})

	Timers:CreateTimer(delay,function()
		caster:AddNoDraw()
		--caster:SetModelScale(0.0001)
		EmitSoundOn("Hero_DeathProphet.CarrionSwarm", caster) 
		projectile = ProjectileManager:CreateLinearProjectile(info)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_death_prophet/death_prophet_carrion_swarm.vpcf", PATTACH_WORLDORIGIN, caster )
		ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( particle, 1, fv * projectile_speed )
		ParticleManager:SetParticleControl( particle, 2, Vector(50,50,50) ) --height and radiuses in 2-5
		ParticleManager:SetParticleControl( particle, 3, Vector(50,50,50) )
		ParticleManager:SetParticleControl( particle, 4, Vector(50,50,50) )
		ParticleManager:SetParticleControl( particle, 5, Vector(50,50,50) )
		Timers:CreateTimer(0.03,function()
			if finished == false then
				local velocity = fv * projectile_speed
				local fvelocity = velocity /30
				caster:SetAbsOrigin(caster:GetAbsOrigin() + fvelocity) 
				return 0.03
			else
				return
			end
		end)
		Timers:CreateTimer(diffLength/projectile_speed,function()
			finished = true
			ParticleManager:DestroyParticle(particle, false) 
			ParticleManager:DestroyParticle(initialparticle, false) 
			FindClearSpaceForUnit(caster, point, false) 
			caster:SetAbsOrigin(point)
			caster:RemoveModifierByName("modifier_bat_form")
			--caster:SetModelScale(modelscale) 
			caster:RemoveNoDraw()
			StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_SPAWN  , rate=1.0})
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_death_prophet/death_prophet_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		end)
	end)
end