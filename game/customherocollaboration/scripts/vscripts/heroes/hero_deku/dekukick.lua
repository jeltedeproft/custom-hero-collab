function kick(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	FindClearSpaceForUnit(caster, target:GetAbsOrigin(), true)	
end
