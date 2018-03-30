function Myst ( event )
  local caster = event.caster
  local ability = event.ability
  local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
  local mist = CreateUnitByName("dummy_myst", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeam())
  local dummy_modifier = mist:FindAbilityByName("dummy_passive")
  dummy_modifier:SetLevel(1)
  EmitSoundOn("Hero_Riki.Smoke_Screen", mist)
  ability:ApplyDataDrivenModifier(caster, mist, "modifier_myst", {duration = duration})
  Timers:CreateTimer(0,function()
    ability:ApplyDataDrivenModifier(caster, mist, "modifier_myst_ai", {duration = duration})
    mist:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY) 
  end)
  local particle = ParticleManager:CreateParticle("particles/custom_particles/abilities/myst/slark_shadow_dance_dummy.vpcf", PATTACH_ABSORIGIN_FOLLOW, mist)
  ParticleManager:SetParticleControl( particle, 0, mist:GetAbsOrigin())
  ParticleManager:SetParticleControl( particle, 1, mist:GetAbsOrigin())
  ParticleManager:SetParticleControl( particle, 2, mist:GetAbsOrigin())
  ParticleManager:SetParticleControl( particle, 3, mist:GetAbsOrigin())
  ParticleManager:SetParticleControl( particle, 4, mist:GetAbsOrigin())
  ParticleManager:SetParticleControl( particle, 5, mist:GetAbsOrigin())
  ParticleManager:SetParticleControl( particle, 6, mist:GetAbsOrigin())
  ParticleManager:SetParticleControl( particle, 7, mist:GetAbsOrigin())
  ParticleManager:SetParticleControl( particle, 8, mist:GetAbsOrigin())
  ParticleManager:SetParticleControl( particle, 9, mist:GetAbsOrigin())
  Timers:CreateTimer(0,function()
    if IsValidEntity(mist) then
      ParticleManager:SetParticleControl( particle, 0, mist:GetAbsOrigin())
      ParticleManager:SetParticleControl( particle, 1, mist:GetAbsOrigin())
      ParticleManager:SetParticleControl( particle, 2, mist:GetAbsOrigin())
      ParticleManager:SetParticleControl( particle, 3, mist:GetAbsOrigin())
      ParticleManager:SetParticleControl( particle, 4, mist:GetAbsOrigin())
      ParticleManager:SetParticleControl( particle, 5, mist:GetAbsOrigin())
      ParticleManager:SetParticleControl( particle, 6, mist:GetAbsOrigin())
      ParticleManager:SetParticleControl( particle, 7, mist:GetAbsOrigin())
      ParticleManager:SetParticleControl( particle, 8, mist:GetAbsOrigin())
      ParticleManager:SetParticleControl( particle, 9, mist:GetAbsOrigin())
      return 1/30
    end
  end)
end

function MystDrain ( event )
  local caster = event.target
  local ability = event.ability
  local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
  local mana_drain = ability:GetLevelSpecialValueFor( "mana_drain", ability:GetLevel() - 1 )
  local units = FindUnitsInRadius(caster:GetTeam() , caster:GetAbsOrigin() , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
  for k,v in pairs(units) do
    EmitSoundOn("Hero_Antimage.ManaBreak", v)
    local particle = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/am_manaburn_basher_ti_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, v)
    local mana = v:GetMana()
    if mana > mana_drain then
      v:SetMana(mana - mana_drain)
    else
      v:SetMana(0)
    end
  end
end

function MystMove ( event )
  local caster = event.target
  local units = FindUnitsInRadius(caster:GetTeam() , caster:GetAbsOrigin() , nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
  for k,v in pairs(units) do
    if v:HasModifier("modifier_invisible") == false and v:HasModifier("rock_modifier") == false then
      caster:MoveToPosition(v:GetAbsOrigin())
      return
    end
  end
  caster:MoveToPosition(caster:GetAbsOrigin() + RandomVector(400))
end