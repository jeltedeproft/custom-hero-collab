function resetcooldowns( keys )
	local caster = keys.caster -- Dummy
	local team = caster:GetTeamNumber()
	local caster_location = caster:GetAbsOrigin()
	local target = keys.target
	local ability = keys.ability
	local max_ability = 6

	for ability_id = 0, max_ability do
	    local ability = target:GetAbilityByIndex(ability_id)
	    if ability then 
	        ability:EndCooldown()
	    end
	end
end