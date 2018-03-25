function swap( keys )
	local caster = keys.caster
	local caster_pos = caster:GetOrigin()
	local swaphero = keys.target
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("duration")
	local bonus = ability:GetSpecialValueFor("bonus")

	--talent
	local talent = caster:FindAbilityByName("equivalent_exchange_bonus_stats")

	if talent:GetLevel() > 0 then
		bonus = bonus + talent:GetSpecialValueFor("value")
	end

	
	local hero_strength = swaphero:GetStrength()
	local hero_agility = swaphero:GetAgility()
	local hero_int = swaphero:GetIntellect()

	--save old values
	caster.old_strength = hero_strength
	caster.old_agility = hero_agility
	caster.old_int = hero_int

	if swaphero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
		swaphero:SetBaseStrength(hero_strength + bonus)
		swaphero:SetBaseIntellect(hero_int - bonus)
		swaphero:SetBaseAgility(hero_agility - bonus)
	elseif swaphero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY then
		swaphero:SetBaseStrength(hero_strength - bonus)
		swaphero:SetBaseIntellect(hero_int - bonus)
		swaphero:SetBaseAgility(hero_agility + bonus)
	elseif swaphero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT then
		swaphero:SetBaseStrength(hero_strength - bonus)
		swaphero:SetBaseAgility(hero_agility - bonus)
		swaphero:SetBaseIntellect(hero_int + bonus)
	end
end

function resetstats( keys )
	local caster = keys.caster
	local caster_pos = caster:GetOrigin()
	local swaphero = keys.target

	swaphero:SetBaseAgility(caster.old_agility)
	swaphero:SetBaseStrength(caster.old_strength)
	swaphero:SetBaseIntellect(caster.old_int)

end