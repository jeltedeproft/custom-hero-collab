LinkLuaModifier( "modifier_yagami_eyes_lua","heroes/hero_yagami/modifier_yagami_eyes_lua", LUA_MODIFIER_MOTION_NONE )

function eyes(keys)
	local caster = keys.caster
	local caster_position = caster:GetAbsOrigin()
	local myteam = caster:GetTeamNumber()
	local player = caster:GetPlayerOwner()
	local playerid = player:GetPlayerID()
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
	local sight_radius = ability:GetLevelSpecialValueFor("sight_radius", ability:GetLevel() - 1 )

	--give the team vision of the enemy team
	local enemy_team = FindUnitsInRadius(myteam, caster_position, nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY,
	 DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	for _,enemy in pairs(enemy_team) do
		AddFOWViewer(myteam,enemy:GetAbsOrigin(),sight_radius,duration,true)

		--apply modifier that shows gold, hp and mp
		enemy:AddNewModifier(caster, ability, "modifier_yagami_eyes_lua", {duration = duration})
	end

	--talent
	local talent = caster:FindAbilityByName("yagami_eyes_no_mana")

	if talent:GetLevel() > 0 then
		local mana_refund = talent:GetSpecialValueFor("value")
		caster:SetMana(caster:GetMana() + mana_refund)
	end
end