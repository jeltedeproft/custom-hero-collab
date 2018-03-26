function ConjureRune(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	CreateItemOnPositionSync(point, CreateItem(GameRules.RANDOM_RUNES[RandomInt(1, #GameRules.RANDOM_RUNES)], nil, nil))
end