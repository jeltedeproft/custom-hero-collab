function checktalent( keys )
	local caster = keys.caster -- Dummy
	local team = caster:GetTeamNumber()
	local caster_location = caster:GetAbsOrigin()
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifiername
	local actual_modifier = caster:FindModifierByName(modifier)

	--talent
	local talent = caster:FindAbilityByName("aura_regen_bonus")

	if talent:GetLevel() > 0 then
		actual_modifier:SetStackCount(talent:GetSpecialValueFor("value"))
	end
end