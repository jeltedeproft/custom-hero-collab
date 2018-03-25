function roarenemies(keys)
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local teamnumber = caster:GetTeamNumber()
	local modifier = keys.modifiername

	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )
	local durationenemy = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )

	--talent
	local talent = caster:FindAbilityByName("chimera_roar_enemy_duration_bonus")

	if talent:GetLevel() > 0 then
		durationenemy = durationenemy + talent:GetSpecialValueFor("value")
	end

	local enemies = FindUnitsInRadius(teamnumber, caster_location, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE , FIND_ANY_ORDER, false)

	for _,unit in pairs(enemies) do
		if not unit:HasModifier(modifier) then
			ability:ApplyDataDrivenModifier(caster, unit, modifier, {duration = durationenemy})
		end
	end	
end