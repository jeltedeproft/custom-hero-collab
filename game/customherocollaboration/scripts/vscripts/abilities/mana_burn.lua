function CheckMana ( event )
  local hero = event.caster
  local target = event.target
  if target:GetMaxMana() == 0 then
    hero:Interrupt()
  end
end

function ManaBurn ( event )
  local hero = event.caster
  local target = event.target
  local ability = event.ability
  local delay = ability:GetLevelSpecialValueFor( "delay", ability:GetLevel() - 1 )
  local mana_burn = ability:GetLevelSpecialValueFor( "mana_burn", ability:GetLevel() - 1 )
  local actualmanaburn = 0

  local particle = ParticleManager:CreateParticle("particles/custom_particles/abilities/mana_burn/mana_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
  ParticleManager:SetParticleControl(particle, 0, hero:GetAbsOrigin()) --origin
  ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) --destination

  local particle = ParticleManager:CreateParticle("particles/custom_particles/abilities/mana_burn/mana_burn_copy.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
  ParticleManager:SetParticleControl(particle, 0, hero:GetAbsOrigin()) --origin
  ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) --destination

  Timers:CreateTimer(delay,
    function()
      ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
      EmitSoundOn("Hero_NyxAssassin.ManaBurn.Target",target)
      local targetMana = target:GetMana()
      if targetMana < mana_burn then
        actualmanaburn = targetMana
      else
        actualmanaburn = mana_burn
      end
      local newmana = targetMana - actualmanaburn
      target:SetMana(newmana)
      ApplyDamage({ victim = target, attacker = hero, damage = actualmanaburn, damage_type = DAMAGE_TYPE_MAGICAL })
  end)
end