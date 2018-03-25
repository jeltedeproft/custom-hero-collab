function teleport(keys)
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local teamnumber = caster:GetTeamNumber()
	local range = ability:GetLevelSpecialValueFor("range", ability:GetLevel() - 1 ) 
	local mv_spd_bonus = ability:GetLevelSpecialValueFor("mv_spd_bonus", ability:GetLevel() - 1 )
	local mv_speed_duration = ability:GetLevelSpecialValueFor("mv_speed_duration", ability:GetLevel() - 1 )
	local modifier = keys.modifiername

	ability:ApplyDataDrivenModifier(caster, caster, modifier, {})

	--calculate random position in range
	local randompos = caster_location + RandomVector(range)

	FindClearSpaceForUnit(caster, randompos, false)
end
