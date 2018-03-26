function Up ( event )
  local hero = event.caster
  local ability = event.ability
  hero:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY) 
end

function Down ( event )
  local hero = event.caster
  local ability = event.ability
  hero:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND) 
  FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), false)
end

function Unstuck(event)
  local hero = event.caster
  local point = hero:GetAbsOrigin()
  local lastpos = hero.lastpos
  if lastpos == nil then
    hero.lastpos = point
    return
  end

  if (lastpos - point):Length() > 200 then
    return
  end

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
      hero.lastpos = point
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
      hero.lastpos = point
      return
    end
  end
  --FindClearSpaceForUnit(hero, lastpos, false) 
  hero:SetAbsOrigin(lastpos)
end