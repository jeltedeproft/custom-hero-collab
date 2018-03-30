function DragonEscortStart(event)
  local caster = event.caster
  local target = event.target
  local ability = event.ability
  local dest = target:GetAbsOrigin() - target:GetForwardVector() * 600 + Vector(0,0,500)
  local dragon = CreateUnitByName("dragon_dummy_unit", dest, true, caster, caster, caster:GetTeamNumber())
  local dummy_modifier = dragon:FindAbilityByName("dummy_passive")
  dummy_modifier:SetLevel(1)
  dragon:StartGesture(ACT_DOTA_RUN)
  dragon.target = target
  dragon:SetAbsOrigin(dest)
  dragon:SetForwardVector(target:GetForwardVector())
  ability:ApplyDataDrivenModifier(caster, dragon, "modifier_dragon_escort_dragon_start", {})
  EmitSoundOn("Hero_DragonKnight.ElderDragonForm", dragon)
  ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green_spotlight.vpcf", PATTACH_ABSORIGIN_FOLLOW, dragon )
end

function DragonEscortStartMove(event)
  local caster = event.caster
  local dragon = event.target
  local target = dragon.target
  local ability = event.ability
  local speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )/30
  --Check if target exists
  if IsValidEntity(target) == false or target:IsAlive() == false then
    dragon:RemoveModifierByName("modifier_dragon_escort_dragon_start")
    ability:ApplyDataDrivenModifier(dragon, dragon, "modifier_dragon_escort_dragon_flying_away", {})
    return
  end
  local dragonPos = dragon:GetAbsOrigin()
  local targetPos = target:GetAbsOrigin()
  local dragonFv = dragon:GetForwardVector()
  local length = (targetPos - dragonPos):Length2D()

  local heightChange = 15
  local dragonHeight = dragonPos.z
  local targetHeight = targetPos.z
  local heightDiff = math.abs(dragonHeight - targetHeight)
  if heightChange > heightDiff then
    heightChange = heightDiff
  end
  if dragonHeight > targetHeight then
    heightChange = -heightChange
  end

  local destFv = (targetPos - dragonPos):Normalized()
  local rotDiff = RotationDelta(VectorToAngles(dragonFv), VectorToAngles(destFv))
  if dragon.rotation == nil then
    dragon.rotation = 10
  end
  local rotation = dragon.rotation
  dragon.rotation = dragon.rotation + 0.1
  
  if rotDiff.y<0 then
    if rotDiff.y < rotation then
      rotation = -rotation
    else
      rotation = rotDiff.y
    end
  elseif rotDiff.y>0 then
    if rotDiff.y > rotation then
      rotation = rotation
    else
      rotation = rotDiff.y
    end
  else
    rotation = 0
  end

  local newFv = RotatePosition(destFv, QAngle(0,rotation,0), dragonFv)
  dragon:SetForwardVector(newFv)
  dragon:SetAbsOrigin(dragonPos + newFv * speed + Vector(0,0,heightChange))

  if length < 50 and target:IsInvulnerable() == false then
    dragon:SetAbsOrigin(targetPos)
    dragon:RemoveModifierByName("modifier_dragon_escort_dragon_start")
    ability:ApplyDataDrivenModifier(caster, dragon, "modifier_dragon_escort_dragon_escorting", {})
    ability:ApplyDataDrivenModifier(dragon, target, "modifier_dragon_escort", {})
  end
end

function DragonEscortMove(event)
  local caster = event.caster
  local dragon = event.target
  local target = dragon.target
  local ability = event.ability
  local speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )/30

  local dragonPos = dragon:GetAbsOrigin()
  local dragonFv = dragon:GetForwardVector()

  local heightChange = 15
  local dragonHeight = dragonPos.z
  local targetHeight = 400
  local heightDiff = math.abs(dragonHeight - targetHeight)
  if heightChange > heightDiff then
    heightChange = heightDiff
  end
  if dragonHeight > targetHeight then
    heightChange = -heightChange
  end

  local destFv = target:GetForwardVector()
  local rotDiff = RotationDelta(VectorToAngles(dragonFv), VectorToAngles(destFv))
  local rotation = 6 --30 times bigger per second(rotation per frame atm)
  
  if rotDiff.y<0 then
    if rotDiff.y < rotation then
      rotation = -rotation
    else
      rotation = rotDiff.y
    end
  elseif rotDiff.y>0 then
    if rotDiff.y > rotation then
      rotation = rotation
    else
      rotation = rotDiff.y
    end
  else
    rotation = 0
  end

  local newFv = RotatePosition(destFv, QAngle(0,rotation,0), dragonFv)
  dragon:SetForwardVector(newFv)
  local newPos = dragonPos + newFv * speed
  if IsOutOfBounds(newPos) == false then
    dragon:SetAbsOrigin(newPos+ Vector(0,0,heightChange))
    if IsInPit(newPos) then
      dragon:RemoveModifierByName("modifier_dragon_escort_dragon_escorting")
    end
  else
    dragon:SetAbsOrigin(dragonPos + Vector(0,0,heightChange))
  end


  if IsValidEntity(target) and target:IsAlive() then
    target:SetAbsOrigin(dragon:GetAbsOrigin())
  end
end

function DragonEscortDrop(event)
  local dragon = event.target
  local target = dragon.target
  local ability = event.ability
  target:SetAbsOrigin(dragon:GetAbsOrigin())
  dragon:RemoveModifierByName("modifier_dragon_escort_dragon_escorting")
  ability:ApplyDataDrivenModifier(target, target, "modifier_dragon_escort_dropping", {})
  ability:ApplyDataDrivenModifier(dragon, dragon, "modifier_dragon_escort_dragon_flying_away", {})
end

function DragonEscortDroppingMove(event)
  local target = event.target
  local ability = event.ability
  local speed = 8
  local targetPos = target:GetAbsOrigin()
  local groundPos = GetGroundPosition(targetPos, target)
  local diff = math.abs(targetPos.z - groundPos.z)
  if speed > diff then
    FindClearSpaceForUnit(target, targetPos, false)
    target:RemoveModifierByName("modifier_dragon_escort_dropping")
    target:RemoveModifierByName("modifier_dragon_escort")
  else
    target:SetAbsOrigin(targetPos - Vector(0,0,speed))
  end
end

function DragonEscortFlyingAway(event)
  local dragon = event.target
  local ability = event.ability
  local speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )/30
  local dragonPos = dragon:GetAbsOrigin()
  local dragonFv = dragon:GetForwardVector()
  local heightChange = 15
  dragon:SetAbsOrigin(dragonPos + dragonFv * speed + Vector(0,0,heightChange))
end