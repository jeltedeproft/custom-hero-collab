function escape( keys )
	local caster = keys.caster -- Main wall dummy
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local move_speed = ability:GetLevelSpecialValueFor("move_speed", ability_level)
	
	caster:AddNewModifier(caster, ability, "modifier_imba_speed_limit_break", {duration = duration})
end