function BlenderStopSound ( event )
  local hero = event.caster
  StopSoundOn("Hero_Juggernaut.BladeFuryStart", hero)
end

function BlenderStartSound( event )
  local hero = event.caster
  EmitSoundOn("Hero_Juggernaut.BladeFuryStart", hero)
end

function BlenderCheckRush( event )
  local hero = event.caster
  local ability = event.ability
  local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
  if hero:HasModifier("modifier_berserkers_rush") == true then
    ability:ApplyDataDrivenModifier(hero, hero, "modifier_berserkers_blender_rush", {duration = duration})
  end
end

--function BlenderRushTick (event)
--  local hero = event.caster
--  local heroPos = hero:GetAbsOrigin()
--  local ability = event.ability
--  local radius = ability:GetLevelSpecialValueFor( "pull_radius", ability:GetLevel() - 1 )
--  GridNav:DestroyTreesAroundPoint(heroPos, radius, false)
--  local units = FindUnitsInRadius(hero:GetTeam()  , heroPos  , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
--  for k,v in pairs(units) do
--    v:AddNewModifier(hero, nil, "modifier_stunned", {duration = 0.03, IsHidden = 1})
--    local vPos = v:GetAbsOrigin()
--    Timers:CreateTimer(0.03,function()
--      local newVPos = v:GetAbsOrigin()
--      local newHeroPos = hero:GetAbsOrigin()
--      local diff = newHeroPos - heroPos
--      local diffNormalized = diff:Normalized()
--      local diffLength = diff:Length2D()
--
--      local distance = newVPos - newHeroPos
--      local distanceNormalized = distance:Normalized()
--      local distanceOffset = distanceNormalized * 125
--
--      local recalculatedDiff = diffNormalized * diffLength
--
--      if v:HasModifier("modifier_phased") == false then
--        v:AddNewModifier(hero, nil, "modifier_phased", {duration = 0.5, IsHidden = 1})
--      end
--      v:SetAbsOrigin(newHeroPos + recalculatedDiff + distanceOffset)
--    end)
--  end
--end

function BlenderRushTick (event)
  local hero = event.caster
  local heroPos = hero.lastpos
  if heroPos == nil then
    hero.lastpos = hero:GetAbsOrigin()
    return
  end
  local ability = event.ability
  local radius = ability:GetLevelSpecialValueFor( "pull_radius", ability:GetLevel() - 1 )
  GridNav:DestroyTreesAroundPoint(heroPos, radius, false)
  DestroyRocksAroundPoint(heroPos, radius)
  local units = FindUnitsInRadius(hero:GetTeam()  , heroPos  , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
  for k,v in pairs(units) do
    v:AddNewModifier(hero, nil, "modifier_rooted", {duration = 0.03, IsHidden = 1})
    local vPos = v.lastpos
    if vPos == nil then
      v.lastpos = v:GetAbsOrigin()
      break
    end
    local newVPos = v:GetAbsOrigin()
    local newHeroPos = hero:GetAbsOrigin()
    local diff = newHeroPos - heroPos
    local diffNormalized = diff:Normalized()
    local diffLength = diff:Length2D()

    local distance = newVPos - newHeroPos
    local distanceNormalized = distance:Normalized()
    local rotatedDistanceNormalized = RotatePosition(Vector(0,0,0), QAngle(0,5,0), distanceNormalized)
    local distanceOffset = rotatedDistanceNormalized * 125

    local recalculatedDiff = diffNormalized * diffLength

    v:AddNewModifier(hero, nil, "modifier_phased", {duration = 0.12, IsHidden = 1})
    v:SetAbsOrigin(newHeroPos + recalculatedDiff + distanceOffset)

    v.lastpos = v:GetAbsOrigin()
  end
  hero.lastpos = hero:GetAbsOrigin()
end

function BlenderRushClearLastpos(event)
  local hero = event.caster
  local units = FindUnitsInRadius(hero:GetTeam()  , hero:GetAbsOrigin()  , nil, 30000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
  for k,v in pairs(units) do
    v.lastpos = nil
  end
end


--function BlenderRushTick (event)
--  local hero = event.caster
--  local heroPos = hero:GetAbsOrigin()
--  local ability = event.ability
--  local radius = ability:GetLevelSpecialValueFor( "pull_radius", ability:GetLevel() - 1 )
--  GridNav:DestroyTreesAroundPoint(heroPos, radius, false)
--  local units = FindUnitsInRadius(hero:GetTeam()  , heroPos  , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
--  for k,v in pairs(units) do
--    v:AddNewModifier(hero, nil, "modifier_stunned", {duration = 0.03, IsHidden = 1})
--    local vPos = v:GetAbsOrigin()
--    Timers:CreateTimer(0.03,function()
--      local newVPos = v:GetAbsOrigin()
--      local newHeroPos = hero:GetAbsOrigin()
--      local diff = newHeroPos - heroPos
--      local diffNormalized = diff:Normalized()
--      local diffLength = diff:Length2D()
--
--      local distance = newVPos - newHeroPos
--      local distanceNormalized = distance:Normalized()
--      local distanceOffset = distanceNormalized * 125
--
--      local recalculatedDiff = diffNormalized * diffLength
--
--      v:AddNewModifier(hero, nil, "modifier_phased", {duration = 0.12, IsHidden = 1})
--      v:SetAbsOrigin(newHeroPos + recalculatedDiff + distanceOffset)
--    end)
--  end
--end