function FindClearSpaceFor(event)
	local caster = event.target
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
end