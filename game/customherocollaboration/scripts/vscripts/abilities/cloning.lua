function Cloning(event)
	local caster = event.caster
	local casterPos = caster:GetAbsOrigin()
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor( "illusion_duration", ability:GetLevel() - 1 )
	local outgoingDamage = ability:GetLevelSpecialValueFor( "illusion_outgoing_damage", ability:GetLevel() - 1 )
	local incomingDamage = ability:GetLevelSpecialValueFor( "illusion_incoming_damage", ability:GetLevel() - 1 )
	ProjectileManager:ProjectileDodge(caster)
	local clone = SpawnIllusion( caster, ability, duration, incomingDamage, outgoingDamage )
	caster:Stop()
	clone:SetForwardVector(caster:GetForwardVector())
	local fv = RandomVector(1)
	local fv2 = RotatePosition(Vector(0,0,0), QAngle(0,180,0), fv)
	FindClearSpaceForUnit(caster, casterPos + fv * 100, false)
	FindClearSpaceForUnit(clone, casterPos + fv2 * 100, false)
	EmitSoundOnLocationWithCaster(casterPos, "Hero_Terrorblade.ConjureImage", caster)
	ParticleManager:CreateParticle("particles/custom_particles/abilities/cloning/cloning.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:CreateParticle("particles/custom_particles/abilities/cloning/cloning.vpcf", PATTACH_ABSORIGIN_FOLLOW, clone )
end