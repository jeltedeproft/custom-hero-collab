function LightningBurst ( event )
  local hero = event.caster
  local target = hero.target
  local casterPos = hero:GetAbsOrigin()
  local targetPos = target:GetAbsOrigin()
  local ability = event.ability
  local force = ability:GetLevelSpecialValueFor( "force", ability:GetLevel() - 1 )
  local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
  local reduction = ability:GetLevelSpecialValueFor( "reduction", ability:GetLevel() - 1 )

  EmitSoundOn("Hero_Zuus.ArcLightning.Cast", hero) 
  EmitSoundOn("Hero_Zuus.ArcLightning.Target", target)

  local lightningBolt = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_WORLDORIGIN, hero)
  ParticleManager:SetParticleControl(lightningBolt,0,Vector(hero:GetAbsOrigin().x,hero:GetAbsOrigin().y,hero:GetAbsOrigin().z + hero:GetBoundingMaxs().z )) 
  ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z )) 

  ApplyDamage({ victim = target, attacker = hero, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })

  local diff = targetPos - casterPos
  local diffNormalized = diff:Normalized()
  local diffLength = diff:Length2D()
  local redu = diffLength / reduction
  if redu >= 1 then
    force = force / redu
  end
  target:AddPhysicsVelocity(diffNormalized * force)
end

function SetTarget( event )
  local hero = event.caster
  local target = event.target
  hero.target = target
end