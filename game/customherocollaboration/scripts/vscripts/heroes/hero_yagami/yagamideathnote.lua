function deathnote(keys)
	local caster = keys.caster
	local ability = keys.ability
	local Target = keys.target
	
	-- Initialize the timer
	ability.relocate_timer = keys.return_time

	local pfx = ParticleManager:CreateParticle( keys.timer_particle, PATTACH_OVERHEAD_FOLLOW, Target )

	local timerCP1_x = math.floor(keys.return_time / 10)
	local timerCP1_y = keys.return_time % 10
	print("return time = " .. keys.return_time .. " timer x = " .. timerCP1_x .. " and y = " .. timerCP1_y)
	ParticleManager:SetParticleControl( pfx, 1, Vector( timerCP1_x, timerCP1_y, 0 ) )

	ability.relocate_timerPfx = pfx
end


function UpdateTimer( keys )
	local ability = keys.ability
	local Target = keys.target
	ability.relocate_timer = ability.relocate_timer - 1
	local respawn_time_early_death = ability:GetLevelSpecialValueFor("respawn_time_early_death", (ability:GetLevel() - 1))

	local pfx = ability.relocate_timerPfx

	local timerCP1_x = math.floor(ability.relocate_timer / 10)
	local timerCP1_y = ability.relocate_timer % 10
	print("return time = " .. ability.relocate_timer .. " timer x = " .. timerCP1_x .. " and y = " .. timerCP1_y)
	ParticleManager:SetParticleControl( pfx, 1, Vector( timerCP1_x, timerCP1_y, 0 ) )

	-- Checking if target is alive to decide if it needs to increase respawn time
	if not Target:IsAlive() then
		Target:SetTimeUntilRespawn(Target:GetRespawnTime() * respawn_time_early_death)

		-- Destroy particle FXs
		ParticleManager:DestroyParticle( ability.relocate_timerPfx, false )

		Target:RemoveModifierByName(modifier)
	end
end

function cleanup( keys)
	local caster	= keys.caster
	local ability	= keys.ability
	local Target = keys.target
	local respawn_time_full_timer_pct = ability:GetLevelSpecialValueFor("respawn_time_full_timer_pct", (ability:GetLevel() - 1))

	Target:SetTimeUntilRespawn(Target:GetRespawnTime() * respawn_time_full_timer_pct)

	-- Destroy particle FXs
	ParticleManager:DestroyParticle( ability.relocate_timerPfx, false )

	Target:Kill(ability, caster)
end

function removeModifier( keys)
	local caster	= keys.caster
	local ability	= keys.ability
	local Target = keys.target
	local modifier = keys.modifiername

	if Target:HasModifier(modifier) then
		Target:RemoveModifierByName(modifier)
	end
end