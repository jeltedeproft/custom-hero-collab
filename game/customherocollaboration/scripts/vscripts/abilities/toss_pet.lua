function TossPetCheck(event)
  	local caster = event.caster
  	local ability = event.ability
  	if caster.bear == nil or IsValidEntity(caster.bear) == false then
    	caster:Interrupt()
  	elseif caster.bear:IsAlive() == false then
    	caster:Interrupt()
  	elseif caster.bear:HasModifier("modifier_bear_ride") or caster.bear:HasModifier("modifier_toss_pet") then
  		caster:Interrupt()
  	end
end

function TossPet(event)
	local caster = event.caster
	local bear = caster.bear
	local ability = event.ability
	local point = event.target_points[1]
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local bounces = ability:GetLevelSpecialValueFor( "bounces", ability:GetLevel() - 1 )
	local toss_duration = ability:GetLevelSpecialValueFor( "toss_duration", ability:GetLevel() - 1 )
	local toss_distance = ability:GetLevelSpecialValueFor( "toss_distance", ability:GetLevel() - 1 )
	local casterPos = caster:GetAbsOrigin()
	local diff = point - casterPos
	local direction = diff:Normalized()
	local destination = direction * toss_distance
	local spawnPos = casterPos + direction * -100

	EmitSoundOn("Hero_LoneDruid.SpiritBear.Cast", bear)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_start.vpcf", PATTACH_WORLDORIGIN, bear)
  	ParticleManager:SetParticleControl( particle, 0, bear:GetAbsOrigin() )
  	ParticleManager:SetParticleControlForward(particle, 0, bear:GetForwardVector()) 
  	FindClearSpaceForUnit(bear, spawnPos, false)
  	bear:SetForwardVector(direction)
  	ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, bear)
  	bear:Interrupt()

  	ProjectileManager:ProjectileDodge(bear)
    Physics:Unit(bear)
  	bear:SetPhysicsFriction(0)
  	bear:SetPhysicsVelocity(Vector(destination.x/toss_duration,destination.y/toss_duration,  1350 * toss_duration/2))
  	bear:SetPhysicsAcceleration(Vector(0,0, -1350))
  	ability:ApplyDataDrivenModifier(caster, bear, "modifier_toss_pet", {duration = toss_duration + toss_duration * bounces}) 

  	Timers:CreateTimer(toss_duration,function()
  		if IsValidEntity(bear) == false then
    	  	return
    	end
    	local units = FindUnitsInRadius(bear:GetTeam() , bear:GetAbsOrigin() , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    	for k,v in pairs(units) do
    	  ApplyDamage({ victim = v, attacker = bear, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
    	end
    	EmitSoundOn("Hero_Centaur.HoofStomp", bear)
    	local particleName = "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf"
    	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, bear )
    	ParticleManager:SetParticleControl( particle1, 0, bear:GetAbsOrigin() )
    	ParticleManager:SetParticleControl( particle1, 1, Vector(radius,0,0) )
    	ParticleManager:SetParticleControl( particle1, 2, bear:GetAbsOrigin() )  
    	ParticleManager:SetParticleControl( particle1, 3, Vector(radius,0,0) )
    	ParticleManager:SetParticleControl( particle1, 4, Vector(radius,0,0) )
    	ParticleManager:SetParticleControl( particle1, 5, Vector(radius,0,0) )
    	ParticleManager:SetParticleControl( particle1, 6, Vector(radius,0,0) )
    	bear:SetPhysicsFriction(0.05)
    	bear:SetPhysicsVelocity(Vector(0,0,0))
    	bear:SetPhysicsAcceleration(Vector(0,0,0))
    	GridNav:DestroyTreesAroundPoint(bear:GetAbsOrigin(), radius, false)
      DestroyRocksAroundPoint(bear:GetAbsOrigin(), radius)
    	if bounces > 0 then
    		bounces = bounces - 1
    		bear:SetPhysicsFriction(0)
  			bear:SetPhysicsVelocity(Vector(destination.x/toss_duration,destination.y/toss_duration,  1350 * toss_duration/2))
  			bear:SetPhysicsAcceleration(Vector(0,0, -1350))
    		return toss_duration
    	end
  	end)
end