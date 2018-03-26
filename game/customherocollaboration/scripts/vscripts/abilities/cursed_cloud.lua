function CursedCloudInterval ( event )
  local caster = event.caster
  local target = event.target
  local ability = event.ability
  local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
  local bounces = ability:GetLevelSpecialValueFor( "bounces", ability:GetLevel() - 1 )
  local lightning_radius = ability:GetLevelSpecialValueFor( "lightning_radius", ability:GetLevel() - 1 )
  local bounce_radius = ability:GetLevelSpecialValueFor( "bounce_radius", ability:GetLevel() - 1 )
  local damage_decay = ability:GetLevelSpecialValueFor( "damage_decay", ability:GetLevel() - 1 )/100
  local time_between_bounces = ability:GetLevelSpecialValueFor( "time_between_bounces", ability:GetLevel() - 1 )
  local victim = nil
  local units = FindUnitsInRadius(caster:GetTeam() , target:GetAbsOrigin()  , nil, lightning_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
  for k,v in pairs(units) do
    if v ~= target then
      victim = v
      break
    end
  end
  if victim == nil then
    return
  end

  EmitSoundOn("Hero_Zuus.ArcLightning.Cast", target)

  local targetsStruck = {}
  targetsStruck[victim] = true

  local lightningBolt = ParticleManager:CreateParticle("particles/custom_particles/abilities/cursed_cloud/cursed_cloud_lightning.vpcf", PATTACH_WORLDORIGIN, target)
  ParticleManager:SetParticleControl(lightningBolt,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z )) 
  ParticleManager:SetParticleControl(lightningBolt,1,Vector(victim:GetAbsOrigin().x,victim:GetAbsOrigin().y,victim:GetAbsOrigin().z + victim:GetBoundingMaxs().z ))
  EmitSoundOn("Hero_Zuus.ArcLightning.Target", victim)
  ApplyDamage({ victim = victim, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
  damage = damage - (damage*damage_decay)

  Timers:CreateTimer(time_between_bounces,function()
    target = victim
    local foundTarget = false
    local units = FindUnitsInRadius(caster:GetTeam() , victim:GetAbsOrigin()  , nil, bounce_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for k,v in pairs(units) do
      if not targetsStruck[v] == true then
        targetsStruck[v] = true
        victim = v
        foundTarget = true
        break
      end
    end

    if foundTarget == false then
      return
    end

    local lightningBolt = ParticleManager:CreateParticle("particles/custom_particles/abilities/cursed_cloud/cursed_cloud_lightning.vpcf", PATTACH_WORLDORIGIN, target)
    ParticleManager:SetParticleControl(lightningBolt,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z )) 
    ParticleManager:SetParticleControl(lightningBolt,1,Vector(victim:GetAbsOrigin().x,victim:GetAbsOrigin().y,victim:GetAbsOrigin().z + victim:GetBoundingMaxs().z ))
    EmitSoundOn("Hero_Zuus.ArcLightning.Target", victim)
    ApplyDamage({ victim = victim, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
    damage = damage - (damage*damage_decay)

    bounces = bounces - 1

    if bounces > 0 then
      return time_between_bounces
    end
  end)
end