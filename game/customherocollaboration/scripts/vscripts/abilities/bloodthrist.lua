function Bloodthrist ( event )
  local hero = event.caster
  local ability = event.ability
  local day_chance = ability:GetLevelSpecialValueFor( "day_chance", ability:GetLevel() - 1 )
  local night_chance = ability:GetLevelSpecialValueFor( "night_chance", ability:GetLevel() - 1 )
  local chance = nil
  if GameRules:IsDaytime() == true then
    chance = day_chance
  else
    chance = night_chance
  end
  local random = RandomInt(1, 100)
  if random < chance then
    ability:ApplyDataDrivenModifier(hero, hero, "modifier_bloodthrist_proc", {})
  end
end

function BloodthristAttack ( event )
  local hero = event.caster
  local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_trail_ember/courier_trail_ember.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
  Timers:CreateTimer(0.7,function()
    ParticleManager:DestroyParticle(particle, false) 
  end)
  local target = event.target
  local ability = event.ability
  local fv = target:GetForwardVector()
  local offset = fv * 115
  local pos = target:GetAbsOrigin() + offset
  FindClearSpaceForUnit(hero, pos, false)
  hero:SetForwardVector(-fv)
end