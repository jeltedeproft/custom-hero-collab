function teleport( keys )
	local caster = keys.caster -- Main wall dummy
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifiername

	local target = caster.teleporttarget
	local teleport_point = target:GetAbsOrigin()

	local particle = keys.particlename

	local particle_radius = ability:GetLevelSpecialValueFor("particle_radius", ability:GetLevel() - 1 )
	local particle_delay = ability:GetLevelSpecialValueFor("particle_delay", ability:GetLevel() - 1 )

	--particle at start
	local pfx_start = ParticleManager:CreateParticle(particle, PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(pfx_start, 0, caster_location)
	ParticleManager:SetParticleControl(pfx_start, 1, Vector(particle_radius, particle_radius, particle_radius))

	--remove particle
	Timers:CreateTimer(particle_delay, function()
		ParticleManager:DestroyParticle(pfx_start, false)
	end)

	FindClearSpaceForUnit(caster, teleport_point, false)

	--particle at end
	local pfx_end = ParticleManager:CreateParticle(particle, PATTACH_POINT, caster)
	ParticleManager:SetParticleControl(pfx_end, 0, teleport_point)
	ParticleManager:SetParticleControl(pfx_end, 1, Vector(particle_radius, particle_radius, particle_radius))

	--remove particle
	Timers:CreateTimer(particle_delay, function()
		ParticleManager:DestroyParticle(pfx_end, false)
	end)
end

