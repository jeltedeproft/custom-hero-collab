function store_unit(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	print("linked unit = " .. target:GetName())
	
	caster.linked_unit = target
end