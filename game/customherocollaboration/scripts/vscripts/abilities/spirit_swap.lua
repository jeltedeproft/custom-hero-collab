function SpiritSwapCheck(event)
  local caster = event.caster
  local target = event.target
  if caster == target then
    caster:Interrupt()
  end
end

function SpiritSwap ( event )
  local caster = event.caster
  local target = event.target
  local casterPos = caster:GetAbsOrigin()
  local targetPos = target:GetAbsOrigin()

  local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN, caster)
  ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin() + Vector(0,0,15)) --origin
  ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin() + Vector(0,0,15)) --destination

  ProjectileManager:ProjectileDodge(caster)
  ProjectileManager:ProjectileDodge(target)
  FindClearSpaceForUnit(caster, targetPos, true)
  FindClearSpaceForUnit(target, casterPos, true)
end