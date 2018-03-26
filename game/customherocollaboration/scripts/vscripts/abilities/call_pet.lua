function CallPet ( event )
  local caster = event.caster
  local ability = event.ability
  if caster:IsAlive() == false then
    return
  end
  local pID = caster:GetPlayerID()
  local spawnPos = caster:GetAbsOrigin() + caster:GetForwardVector() * 110
  local casterFv = caster:GetForwardVector()
  if caster.bear == nil or IsValidEntity(caster.bear) == false then
    local bear = CreateUnitByName("npc_bear", spawnPos, true, caster, caster, caster:GetTeamNumber())
    bear:SetControllableByPlayer(pID, true)
    FindClearSpaceForUnit(bear, spawnPos, true)
    ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, bear)
    EmitSoundOn("Hero_LoneDruid.SpiritBear.Cast", bear)
    bear:SetForwardVector(casterFv)
    caster.bear = bear
  elseif caster.bear:IsAlive() == false then
    local bear = CreateUnitByName("npc_bear", spawnPos, true, caster, caster, caster:GetTeamNumber())
    bear:SetControllableByPlayer(pID, true)
    FindClearSpaceForUnit(bear, spawnPos, true)
    ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, bear)
    EmitSoundOn("Hero_LoneDruid.SpiritBear.Cast", bear)
    bear:SetForwardVector(casterFv)
    caster.bear = bear
  elseif caster.bear:IsAlive() == true then
    caster.bear:Interrupt()
    caster.bear:Heal(100, caster)
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_start.vpcf", PATTACH_WORLDORIGIN, caster.bear)
    ParticleManager:SetParticleControl( particle, 0, caster.bear:GetAbsOrigin() )
    ParticleManager:SetParticleControlForward(particle, 0, caster.bear:GetForwardVector()) 
    FindClearSpaceForUnit(caster.bear, spawnPos, true)
    caster.bear:SetForwardVector(casterFv)
    EmitSoundOn("Hero_LoneDruid.SpiritBear.Cast", bear)
    ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.bear)
  end
  ability:ApplyDataDrivenModifier(caster, caster, "modifier_hunter_has_bear", {})
end

function CallPetDeath(event)
  local caster = event.caster
  if caster.bear ~= nil and IsValidEntity(caster.bear) and caster.bear:IsAlive() then
    caster.bear:ForceKill(false)
  end
end 