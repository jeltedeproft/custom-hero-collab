function Phoenix ( event )
  local caster = event.caster
  local ability = event.ability
  local hatch_time = ability:GetLevelSpecialValueFor( "hatch_time", ability:GetLevel() - 1 )
  local egg = CreateUnitByName("npc_egg", caster:GetAbsOrigin() + caster:GetForwardVector() * 115, false, nil, nil, caster:GetTeam())
  egg:SetModelScale(0.8)
  EmitSoundOn("Hero_Phoenix.SuperNova.Begin", egg)
  ability:ApplyDataDrivenModifier(caster, egg, "modifier_phoenix_hatching", {duration = hatch_time})
  StartAnimation(egg, {duration=hatch_time, activity=ACT_DOTA_IDLE, rate=0.90})
end

function PhoenixDeath(event)
  local egg = event.unit
  local ability = event.ability
  local eggPos = egg:GetAbsOrigin()
  local eggTeam = egg:GetTeam() 
  if egg:HasModifier("modifier_phoenix_hatching") then
    local pdummy = CreateUnitByName("particle_dummy_unit", eggPos, false, nil, nil, eggTeam)
    local dummy_modifier = pdummy:FindAbilityByName("particle_dummy_passive")
    dummy_modifier:SetLevel(1)
    EmitSoundOn("Hero_Phoenix.SuperNova.Death", pdummy)
    pdummy:SetAbsOrigin(eggPos)
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, pdummy)
    ParticleManager:SetParticleControl( particle, 0, eggPos + Vector(0,0,60) )
    ParticleManager:SetParticleControl( particle, 1, eggPos + Vector(0,0,60) )
    ParticleManager:SetParticleControl( particle, 2, eggPos + Vector(0,0,60) )
    Timers:CreateTimer(0,function()
      egg:RemoveSelf() 
    end)
  end
end

function PhoenixHatch(event)
  local egg = event.target
  local ability = event.ability
  local eggPos = egg:GetAbsOrigin()
  local eggTeam = egg:GetTeam()
  egg:RemoveSelf()
end