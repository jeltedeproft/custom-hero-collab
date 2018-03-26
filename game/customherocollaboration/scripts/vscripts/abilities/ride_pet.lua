function RidePetCheck ( event )
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

function RidePet ( event )
  local caster = event.caster
  caster.lastposbear = caster:GetAbsOrigin()
  local bear = caster.bear
  local ability = event.ability
  EmitSoundOn("Hero_LoneDruid.SpiritBear.Cast", bear)
  local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
  ability:ApplyDataDrivenModifier(caster, caster, "modifier_hunter_ride", {duration = duration})
  ability:ApplyDataDrivenModifier(caster, bear, "modifier_bear_ride", {duration = duration})
  local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_start.vpcf", PATTACH_WORLDORIGIN, bear)
  ParticleManager:SetParticleControl( particle, 0, bear:GetAbsOrigin() )
  ParticleManager:SetParticleControlForward(particle, 0, bear:GetForwardVector()) 
  FindClearSpaceForUnit(bear, caster:GetAbsOrigin(), false)
  bear:SetForwardVector(caster:GetForwardVector())
  ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, bear)
end

function RidePetFollowCaster(event)
  local caster = event.caster
  local bear = event.target
  local ability = event.ability
  local lastpos = caster.lastposbear
  local newpos = caster:GetAbsOrigin()
  local diff = newpos - lastpos
  local diffLength = diff:Length2D()
  bear:SetAbsOrigin(newpos)
  bear:SetForwardVector(caster:GetForwardVector())
  if diffLength < 3 then
    caster:RemoveGesture(ACT_DOTA_IDLE)
    bear:RemoveGesture(ACT_DOTA_RUN) 
    bear:StartGesture(ACT_DOTA_IDLE) 
  else
    caster:StartGesture(ACT_DOTA_IDLE)
    bear:RemoveGesture(ACT_DOTA_IDLE) 
    bear:StartGesture(ACT_DOTA_RUN) 
  end
  caster.lastposbear = newpos
end

function RidePetDeath(event)
  local caster = event.caster
  local bear = event.unit
  if caster:HasModifier("modifier_hunter_ride") then
    caster:RemoveModifierByName("modifier_hunter_ride")
  end
  if bear:HasModifier("modifier_bear_ride") then
    bear:RemoveModifierByName("modifier_bear_ride")
  end
end

function RidePetStop(event)
  local caster = event.caster
  local bear = event.target
  bear:RemoveGesture(ACT_DOTA_IDLE) 
  caster:RemoveGesture(ACT_DOTA_IDLE)
  bear:RemoveGesture(ACT_DOTA_RUN) 
  caster:RemoveGesture(ACT_DOTA_RUN)  
end