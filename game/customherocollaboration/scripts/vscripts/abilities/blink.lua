function CheckBlink ( event )
  local hero = event.caster
  local point = event.target_points[1]

  local bound1 = Entities:FindByName(nil, "target_bounds1"):GetAbsOrigin()
  local x1 = bound1.x
  local y1 = bound1.y
  local bound2 = Entities:FindByName(nil, "target_bounds2"):GetAbsOrigin()
  local x2 = bound2.x
  local y2 = bound2.y
  local pointx = point.x
  local pointy = point.y
  if pointx > x1 and pointx < x2 then
    if pointy > y1 and pointy < y2 then
      return
    end
  end

  local bound3 = Entities:FindByName(nil, "target_pit_bounds1"):GetAbsOrigin()
  local x1 = bound3.x
  local y1 = bound3.y
  local bound4 = Entities:FindByName(nil, "target_pit_bounds2"):GetAbsOrigin()
  local x2 = bound4.x
  local y2 = bound4.y
  local pointx = point.x
  local pointy = point.y
  if pointx > x1 and pointx < x2 then
    if pointy > y1 and pointy < y2 then
      return
    end
  end

  hero:Interrupt()
end

function Blink ( event )
  local hero = event.caster
  local targetGroundPos = event.target_points[1]
  local ability = event.ability
  local radius = ability:GetLevelSpecialValueFor( "distance", ability:GetLevel() - 1 )
  local heroPos = hero:GetAbsOrigin()
  local heroGroundPos = GetGroundPosition(heroPos, hero)
  local diff = heroGroundPos - targetGroundPos
  diff.z = 0
  local diffLength = diff:Length()
  if diffLength > radius then
    targetGroundPos = heroGroundPos + (targetGroundPos - heroGroundPos):Normalized() * radius
  end
  ProjectileManager:ProjectileDodge(hero)
  FindClearSpaceForUnit(hero, targetGroundPos, true)
end