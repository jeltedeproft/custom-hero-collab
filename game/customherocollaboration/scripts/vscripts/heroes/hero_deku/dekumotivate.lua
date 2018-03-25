function motivatetalent(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifiername = keys.modifier

	local bonus_physical_dmg_block = ability:GetLevelSpecialValueFor("bonus_physical_dmg_block", ability:GetLevel() - 1 )

	--talent
	local talent = caster:FindAbilityByName("aura_damage_bonus")

	if talent:GetLevel() > 0 then
		local bonus_physical_dmg_block = bonus_physical_dmg_block + talent:GetSpecialValueFor("value")
		local modifier = ability:ApplyDataDrivenModifier(caster, target, modifiername, {duration = ability:GetSpecialValueFor("duration")})
		modifier:SetStackCount(talent:GetSpecialValueFor("value")) 
	end
end
