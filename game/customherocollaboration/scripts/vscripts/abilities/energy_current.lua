function EnergyCurrent ( event )
  local hero = event.caster
  local point = event.target_points[1]
  local ability = event.ability
  local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
  local height = ability:GetLevelSpecialValueFor( "height", ability:GetLevel() - 1 )
  local projectile_speed = ability:GetLevelSpecialValueFor( "wave_speed", ability:GetLevel() - 1 )
  local projectile_distance = ability:GetLevelSpecialValueFor( "wave_distance", ability:GetLevel() - 1 )
  local projectile_radius = ability:GetLevelSpecialValueFor( "wave_radius", ability:GetLevel() - 1 )
  local wave_release_delay = ability:GetLevelSpecialValueFor( "wave_release_delay", ability:GetLevel() - 1 )
  local heroPos = hero:GetAbsOrigin()
  local heroGroundPos = GetGroundPosition(heroPos, hero)
  local diff = heroGroundPos - point
  diff.z = 0
  local diffLength = diff:Length()
  local ndiff = -diff

  StartAnimation(hero, {duration=duration, activity=ACT_DOTA_RUN, rate=1.0, translate="haste"})


  ProjectileManager:ProjectileDodge(hero)
  hero:SetPhysicsFriction(0)
  hero:SetPhysicsVelocity(Vector(ndiff.x/duration,ndiff.y/duration,  900 * duration/2))
  hero:SetPhysicsAcceleration(Vector(0,0, -900))
  Timers:CreateTimer(duration,function()
    hero:SetPhysicsFriction(0.05)
    hero:SetPhysicsVelocity(Vector(0,0,0))
    hero:SetPhysicsAcceleration(Vector(0,0,0))
    FindClearSpaceForUnit(hero, hero:GetAbsOrigin() , false)
    ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ghost_walk.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
    EmitSoundOn("Hero_Invoker.Invoke", hero)
    Timers:CreateTimer(wave_release_delay,function()
      local fv = hero:GetForwardVector()
      local wave = CreateUnitByName("dummy_unit", hero:GetAbsOrigin(), false, nil, nil, hero:GetTeam())
      wave.hit = {}
      ability:ApplyDataDrivenModifier(hero, wave, "modifier_energy_current_wave", {duration = projectile_distance/projectile_speed})
      local particle = ParticleManager:CreateParticle("particles/custom_particles/abilities/energy_current/invoker_deafening_blast_fixed_lifetime.vpcf", PATTACH_ABSORIGIN, wave)
      local wavePos = wave:GetAbsOrigin()
      wave:SetForwardVector(fv)
      EmitSoundOn("Hero_Invoker.DeafeningBlast", wave)
      ParticleManager:SetParticleControl( particle, 0, wavePos )
      ParticleManager:SetParticleControl( particle, 1, fv * projectile_speed )
      ParticleManager:SetParticleControl( particle, 3, wavePos )
      Timers:CreateTimer(projectile_distance/projectile_speed,function()
        ParticleManager:DestroyParticle(particle, false) 
      end)
    end)
  end)
end

function EnergyCurrentWaveMove(event)
  local caster = event.caster
  local wave = event.target
  local ability = event.ability
  local projectile_speed = ability:GetLevelSpecialValueFor( "wave_speed", ability:GetLevel() - 1 )
  local damage = ability:GetLevelSpecialValueFor( "wave_damage", ability:GetLevel() - 1 )
  local radius = ability:GetLevelSpecialValueFor( "wave_radius", ability:GetLevel() - 1 )
  local fv = wave:GetForwardVector()
  local origin = wave:GetAbsOrigin()
  local front_position = origin + fv * 30
  projectile_speed = projectile_speed/30
  local units = FindUnitsInRadius(wave:GetTeam() , wave:GetAbsOrigin() , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
  for k,v in pairs(units) do
    if wave.hit[v] == nil then
      wave.hit[v] = true
      ApplyDamage({victim = v, attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage})
    end
    local push = v:GetAbsOrigin() + fv * 30
    FindClearSpaceForUnit(v, push, false)
    v:AddNewModifier(caster, nil, "modifier_stunned", {duration = 0.03, IsHidden = 1})
  end
  wave:SetAbsOrigin(front_position)
end