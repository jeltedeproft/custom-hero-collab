function TankMode ( event )
  local caster = event.caster
  local ability = event.ability
  caster.lastpostank = caster:GetAbsOrigin()
  ability.caster = caster
  if caster:HasModifier("modifier_tank_mode") == true then
    ParticleManager:CreateParticle("particles/econ/items/tinker/boots_of_travel/teleport_end_bots_ground_flash.vpcf", PATTACH_ABSORIGIN, caster )
    EmitSoundOn("Hero_Wisp.TeleportIn", caster)
    ability.tank:RemoveSelf()
    caster:RemoveModifierByName("modifier_tank_mode")
    caster:RemoveGesture(ACT_DOTA_IDLE)
    event.caster:RemoveNoDraw()
  else
    ParticleManager:CreateParticle("particles/econ/items/tinker/boots_of_travel/teleport_end_bots_ground_flash.vpcf", PATTACH_ABSORIGIN, caster )
    EmitSoundOn("Hero_Wisp.TeleportOut", caster)
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_tank_mode", {})
    ability.tank = CreateUnitByName("tank_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeam())
    local dummy_modifier = ability.tank:FindAbilityByName("dummy_passive")
    dummy_modifier:SetLevel(1)
    ability.tank:SetAbsOrigin(caster:GetAbsOrigin())
    ability.tank:SetForwardVector(caster:GetForwardVector())
    ability.tank:SetModelScale(1.5)
    ability:ApplyDataDrivenModifier(ability.tank, ability.tank, "modifier_tank_visual", {})
    event.caster:AddNoDraw()
  end
end

function TankModeFollowCaster(event)
  local tank = event.caster
  local ability = event.ability
  local caster = ability.caster
  local lastpos = caster.lastpostank
  local newpos = caster:GetAbsOrigin()
  local diff = newpos - lastpos
  local diffLength = diff:Length2D()
  tank:SetAbsOrigin(caster:GetAbsOrigin())
  tank:SetForwardVector(caster:GetForwardVector())
  if diffLength < 3 then
    caster:RemoveGesture(ACT_DOTA_IDLE)
    tank:RemoveGesture(ACT_DOTA_RUN) 
    tank:StartGesture(ACT_DOTA_IDLE) 
  else
    caster:StartGesture(ACT_DOTA_IDLE)
    tank:RemoveGesture(ACT_DOTA_IDLE) 
    tank:StartGesture(ACT_DOTA_RUN) 
  end
  caster.lastpostank = newpos
end
