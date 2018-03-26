function RemoveModifierFromCaster(event)
	local target = event.caster
	local modifier = event.ModifierName
	target:RemoveModifierByName(modifier)
end

function RemoveModifierFromTarget(event)
	local target = event.target
	local modifier = event.ModifierName
	target:RemoveModifierByName(modifier)
end