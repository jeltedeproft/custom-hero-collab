function checktime( keys )
	local caster = keys.caster -- Dummy
	local team = caster:GetTeamNumber()
	local caster_location = caster:GetAbsOrigin()
	local target = keys.target
	local ability = keys.ability
	local modifier_even = keys.modifier_even
	local modifier_uneven = keys.modifier_uneven

	local time = GameRules:GetDOTATime(false,false)
	local even = (math.floor(time / 60)) % 2 == 0
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )

	local allies = FindUnitsInRadius(team, caster_location, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE , FIND_ANY_ORDER, false)

	--talent
	local talent = caster:FindAbilityByName("aura_damage_bonus")

	if even then
		for _,ally in pairs(allies) do
			if ally:HasModifier(modifier_uneven) then
				ally:RemoveModifierByName(modifier_uneven)
			end
			if not ally:HasModifier(modifier_even) then
				caster:EmitSound("ntropybell")
				ability:ApplyDataDrivenModifier(caster, ally, modifier_even, nil)
			end
		end
	else
		for _,ally in pairs(allies) do
			if ally:HasModifier(modifier_even) then
				ally:RemoveModifierByName(modifier_even)
			end
			if not ally:HasModifier(modifier_uneven) then
				caster:EmitSound("ntropybell")
				local modifier = ability:ApplyDataDrivenModifier(caster, ally, modifier_uneven, nil)
				if talent:GetLevel() > 0 then
					modifier:SetStackCount(talent:GetSpecialValueFor("value"))
				end
			end
		end
	end
end