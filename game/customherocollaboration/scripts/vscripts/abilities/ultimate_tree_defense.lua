function UltimateTreeDefense(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local trees = ability:GetLevelSpecialValueFor( "trees", ability:GetLevel() - 1 )
	for i =1,trees do
		CreateTempTree(point + RandomVector(radius), 9999) 
	end
	local units = FindUnitsInRadius(0 , point , nil, radius+55, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for k,v in pairs(units) do
		FindClearSpaceForUnit(v, v:GetAbsOrigin(), false)
	end

	local units = FindUnitsInRadius(0 , point , nil, radius+55, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for k,v in pairs(units) do
		if v:GetUnitName() == "npc_the_referee" then
			FindClearSpaceForUnit(v, v:GetAbsOrigin(), false)
		end
	end
end