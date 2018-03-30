function SoaringAnger ( event )
  local hero = event.caster
  local point = event.target_points[1]
  local ability = event.ability
  local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
  local height = ability:GetLevelSpecialValueFor( "height", ability:GetLevel() - 1 )
  local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
  local berserker_bonus = ability:GetLevelSpecialValueFor( "berserker_bonus", ability:GetLevel() - 1 )
  local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
  local offset = ability:GetLevelSpecialValueFor( "offset", ability:GetLevel() - 1 )

  if hero:HasModifier("modifier_berserkers_rush") then
    damage = damage + berserker_bonus
  end

  StartAnimation(hero, {duration=duration, activity=ACT_DOTA_ATTACK_EVENT, rate=0.25})

  local heroPos = hero:GetAbsOrigin()
  local heroGroundPos = GetGroundPosition(heroPos, hero)
  local diff = heroGroundPos - point
  diff.z = 0
  local diffLength = diff:Length()
  local diffNormalized = diff:Normalized()
  local offsetVector = diffNormalized * offset
  local ndiff = -diff
  ndiff = ndiff
  ProjectileManager:ProjectileDodge(hero)
  Physics:Unit(hero)
  hero:SetPhysicsFriction(0)
  hero:SetPhysicsVelocity(Vector(ndiff.x/duration,ndiff.y/duration,  900 * duration/2) + offsetVector)
  hero:SetPhysicsAcceleration(Vector(0,0, -900))
  Timers:CreateTimer(duration,function()
    if IsValidEntity(hero) == false then
      return
    end
    hero:SetPhysicsFriction(0.05)
    hero:SetPhysicsVelocity(Vector(0,0,0))
    hero:SetPhysicsAcceleration(Vector(0,0,0))
    GridNav:DestroyTreesAroundPoint(hero:GetAbsOrigin()-offsetVector, radius, false)
    DestroyRocksAroundPoint(hero:GetAbsOrigin()-offsetVector, radius)
    EmitSoundOn("Hero_Centaur.HoofStomp", hero)
    local particleName = "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf"
    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
    ParticleManager:SetParticleControl( particle1, 0, point )
    ParticleManager:SetParticleControl( particle1, 1, Vector(radius,0,0) )
    ParticleManager:SetParticleControl( particle1, 2, point )  
    ParticleManager:SetParticleControl( particle1, 3, Vector(radius,0,0) )
    ParticleManager:SetParticleControl( particle1, 4, Vector(radius,0,0) )
    ParticleManager:SetParticleControl( particle1, 5, Vector(radius,0,0) )
    ParticleManager:SetParticleControl( particle1, 6, Vector(radius,0,0) )
    local units = FindUnitsInRadius(hero:GetTeam() , hero:GetAbsOrigin()-offsetVector , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for k,v in pairs(units) do
      ApplyDamage({ victim = v, attacker = hero, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
    end
    FindClearSpaceForUnit(hero, hero:GetAbsOrigin() , false)
  end)
end