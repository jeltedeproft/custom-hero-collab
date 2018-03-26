function BlazingTrailsCreate ( event )
  local caster = event.caster
  local ability = event.ability
  local flame_duration = ability:GetLevelSpecialValueFor( "flame_duration", ability:GetLevel() - 1 )
  local casterPos = caster:GetAbsOrigin()
  local trail = CreateUnitByName("dummy_unit", casterPos, true, caster, caster, caster:GetTeamNumber())
  trail:SetAbsOrigin(casterPos)
  ability:ApplyDataDrivenModifier(caster, trail, "modifier_blazing_trails_thinker", {duration = flame_duration})
  local particle = ParticleManager:CreateParticle("particles/custom_particles/abilities/blazing_trails/blazing_trails_path_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, trail)
  ParticleManager:SetParticleControl( particle, 0, casterPos)
end

function BlazingTrailsSoundStart(event)
  local caster = event.caster
  EmitSoundOn("Hero_Batrider.Firefly.loop", caster)
end

function BlazingTrailsSoundStop(event)
  local caster = event.caster
  StopSoundOn("Hero_Batrider.Firefly.loop", caster)
end