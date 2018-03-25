--[[Author: Pizzalol
	Date: 12.02.2015.
	Acts as an aura which applies a debuff on the target
	the debuff does the NightmareBreak function calls]]
function NightmareAura( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifier

	local aura_radius = ability:GetLevelSpecialValueFor("aura_radius", ability:GetLevel() - 1)

	local units = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, aura_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType(), 0, 0, false)

	for _,v in pairs(units) do
		if v ~= target then
			ability:ApplyDataDrivenModifier(caster, v, modifier, {duration = 0.5})
		end
	end
end

--[[Author: Pizzalol
	Date: 12.02.2015.
	Stops the sound from playing]]
function NightmareStopSound( keys )
	local target = keys.target
	local sound = keys.sound

	StopSoundEvent(sound, target)
end

--[[Author: Pizzalol
	Date: 12.02.2015.
	Checks if the target that we applied the Nightmare debuff on is the caster
	if it is the caster then we give him the ability to break the Nightmare and on calls
	where the Nightmare ends then it reverts the abilities]]
function NightmareCasterCheck( keys )
	local target = keys.target
	local caster = keys.caster
	local check_ability = keys.check_ability

	-- If it is the caster then swap abilities
	if target == caster then
		-- Swap sub_ability
		local sub_ability_name = keys.sub_ability_name
		local main_ability_name = keys.main_ability_name

		caster:SwapAbilities(main_ability_name, sub_ability_name, false, true)

		-- Sets the level of the ability that we swapped 
		if main_ability_name == check_ability then
			local level_ability = caster:FindAbilityByName(sub_ability_name)
			level_ability:SetLevel(1)
		end
	end
end

--[[Author: Pizzalol
	Date: 12.02.2015.
	Turns of the toggle of the ability]]
function NightmareCasterEnd( keys )
	local caster = keys.caster
	local ability = keys.ability

	ability:ToggleAbility()
end