function roll(keys)
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local teamnumber = caster:GetTeamNumber()
	local origin = caster:GetAbsOrigin()
	local forward = caster:GetForwardVector()
	local distance = ability:GetLevelSpecialValueFor("distance", ability:GetLevel() - 1 ) 
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
	local stun_radius = ability:GetLevelSpecialValueFor("stun_radius", ability:GetLevel() - 1 )
	local target_point = caster_location + (forward * distance)
	local speed = distance / duration
	local rollingmodifier = keys.rollmodifier

	local traveled_distance = 0

	ability:ApplyDataDrivenModifier(caster, caster, rollingmodifier, {})

	-- Moving the caster
	Timers:CreateTimer(0, function()
		caster_location = caster_location + (forward * speed) * 0.03
		traveled_distance = (caster_location - origin):Length2D()
		FindClearSpaceForUnit(caster, caster_location, false)

		--not reached end of the field
		if traveled_distance < distance then
			--check if we hit someone
			local close_units = FindUnitsInRadius(caster:GetTeamNumber(), caster_location, nil, stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

			for _,unit in pairs(close_units) do
				unit:AddNewModifier(caster, ability, "modifier_stunned", {duration = duration})
			end

			return 0.03
		else
			caster:RemoveModifierByName(rollingmodifier)
		end
	end)
end
