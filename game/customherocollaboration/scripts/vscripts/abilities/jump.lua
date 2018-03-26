function Jump ( event )
  local hero = event.caster
  local point = event.target_points[1]
  local ability = event.ability
  local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
  local height = ability:GetLevelSpecialValueFor( "height", ability:GetLevel() - 1 )
  local heroPos = hero:GetAbsOrigin()
  local heroGroundPos = GetGroundPosition(heroPos, hero)
  local diff = heroGroundPos - point
  diff.z = 0
  local diffLength = diff:Length()
  local ndiff = -diff
  ProjectileManager:ProjectileDodge(hero)
  hero:SetPhysicsFriction(0)
  hero:SetPhysicsVelocity(Vector(ndiff.x/duration,ndiff.y/duration,  900 * duration/2))
  hero:SetPhysicsAcceleration(Vector(0,0, -900))
  Timers:CreateTimer(duration,function()
    hero:SetPhysicsFriction(0.05)
    hero:SetPhysicsVelocity(Vector(0,0,0))
    hero:SetPhysicsAcceleration(Vector(0,0,0))
    FindClearSpaceForUnit(hero, hero:GetAbsOrigin() , false)
  end)


  --hero:AddNewModifier(hero, ability, "modifier_knockback", {
  --  should_stun = 1,
  --  knockback_height = height,
  --  knockback_distance = -diffLength,
  --  knockback_duration = duration,
  --  duration = duration,
  --  center_x = point.x,
  --  center_y = point.y,
  --  center_z = point.z})
end