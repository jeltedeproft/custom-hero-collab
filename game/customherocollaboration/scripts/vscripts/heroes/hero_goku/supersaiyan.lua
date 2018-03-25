function supersaiyan( keys )
	local caster = keys.caster -- Main wall dummy
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local move_speed = ability:GetLevelSpecialValueFor("move_speed", ability_level)

	local normal_blink_name = keys.blink_cd
	local no_cd_blink_name = keys.blink_no_cd
	
	caster:AddNewModifier(caster, ability, "modifier_imba_speed_limit_break", {duration = duration})

	caster:SwapAbilities(normal_blink_name, no_cd_blink_name, false, true)
end

function StopSound( keys )
	StopSoundEvent( keys.soundname, keys.caster )
end

function resetblink( keys )
	local caster = keys.caster -- Main wall dummy
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local move_speed = ability:GetLevelSpecialValueFor("move_speed", ability_level)

	local normal_blink_name = keys.blink_cd
	local no_cd_blink_name = keys.blink_no_cd

	caster:RemoveModifierByName("modifier_imba_speed_limit_break")

	caster:SwapAbilities(no_cd_blink_name,normal_blink_name, false, true)
end

