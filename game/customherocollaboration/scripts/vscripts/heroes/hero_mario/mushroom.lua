function mushroom(keys)
	local caster = keys.caster
	local ability = keys.ability
	local modifiername = keys.mushroommodifier

	caster:EmitSound("mushroom")

	caster:SetModelScale(16.0)

	ability:ApplyDataDrivenModifier(caster, caster, modifiername, nil)
end

function reducesize(keys)
	local caster = keys.caster
	local ability = keys.ability

	caster:SetModelScale(8.0)
end