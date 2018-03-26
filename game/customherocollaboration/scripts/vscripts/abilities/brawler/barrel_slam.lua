function BarrelSlam(event)
  local caster = event.caster
  local point = event.target_points[1]
  local ability = event.ability
  local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
  local knockback_force = ability:GetLevelSpecialValueFor( "knockback_force", ability:GetLevel() - 1 )
  local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
  local delay = ability:GetLevelSpecialValueFor( "delay", ability:GetLevel() - 1 )

  EmitSoundOn("Hero_Brewmaster.PreAttack" , caster)

  local casterPos = caster:GetAbsOrigin()

  local diffLength = (point-casterPos):Length2D()

  local p = 0.9 *(diffLength/2)
  local z = math.sqrt(p^2+(diffLength/2)^2)

  local projSpeed = diffLength/delay

  local particleSpeed = projSpeed * ((2*z)/diffLength)

  local particle = ParticleManager:CreateParticle("particles/custom_particles/abilities/brawler/brawler_spell_storm_bolt.vpcf", PATTACH_WORLDORIGIN, target)
  ParticleManager:SetParticleControl(particle,0,casterPos) --origin
  ParticleManager:SetParticleControl(particle,1,point) --destination
  ParticleManager:SetParticleControl(particle,2,Vector(particleSpeed,0,0)) --speed

  --EmitSoundOnLocationWithCaster(point,"Hero_Sven.StormBolt",caster)

  Timers:CreateTimer(delay,function()
    EmitSoundOnLocationWithCaster(point,"Hero_Tidehunter.AnchorSmash",caster)
    local units = FindUnitsInRadius(caster:GetTeam() , point , nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for k,v in pairs(units) do
      local targetPos = v:GetAbsOrigin()
  	  local vdiff = targetPos - point
  	  vdiffNormalized = vdiff:Normalized()
  	  v:AddPhysicsVelocity(vdiffNormalized * knockback_force)
      ApplyDamage({ victim = v, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
    end
  end)

end