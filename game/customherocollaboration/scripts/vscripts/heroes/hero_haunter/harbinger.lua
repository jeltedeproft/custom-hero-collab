function upgradeother( keys )
	local caster = keys.caster -- Main wall dummy
	local this_ability = keys.ability
	local this_abilityName = this_ability:GetAbilityName()
	local this_abilityLevel = this_ability:GetLevel()

	local other_ability_name = keys.otherability
	local other_ability = caster:FindAbilityByName(other_ability_name)
	local other_ability_level = other_ability:GetLevel()

	-- Check to not enter a level up loop
	if other_ability_level ~= this_abilityLevel then
		other_ability:SetLevel(this_abilityLevel)
	end
end

function switchabilities( keys )
	local caster = keys.caster -- Main wall dummy
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifiername

	local ability_name = ability:GetName()
	local beckoning_ability_name = keys.new_ability

	local target = keys.target
	local args = nil

	local Duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )

	caster.teleporttarget = target

	caster:SwapAbilities(ability_name, beckoning_ability_name, false, true)

	--talent
	local talent = caster:FindAbilityByName("haunter_harbinger_duration_bonus")

	if talent:GetLevel() > 0 then
		local new_duration = Duration + talent:GetSpecialValueFor("value")
		args = {duration = new_duration}
	end

	ability:ApplyDataDrivenModifier(caster, target, string modifier, args)
end


function removeall( keys )
	local caster = keys.caster -- Main wall dummy
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifiername

	local current_ability_name = keys.currentability
	local other_ability_name = keys.otherability

	local current_ability = caster:FindAbilityByName(current_ability_name)
	local other_ability = caster:FindAbilityByName(other_ability_name)

	local target = keys.target

	if not target:IsAlive() then
		ability:EndCooldown()
	end
	caster:SwapAbilities(current_ability_name, other_ability_name, false, true)
end