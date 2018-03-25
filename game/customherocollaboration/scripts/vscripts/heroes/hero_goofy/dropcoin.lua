function dropcoin(keys)
	local caster = keys.caster
	local player = caster:GetOwner()
	local playerid = player:GetPlayerID()
	local teamnumber = caster:GetTeamNumber()
	local origin = caster:GetAbsOrigin()
	local forward = caster:GetForwardVector()
	local targetdroppoint = origin + forward
	local gold_amount = keys.gold

	--talent
	local talent = caster:FindAbilityByName("goofy_gold_bonus")

	if talent:GetLevel() > 0 then
		local gold = PlayerResource:GetUnreliableGold(playerid)
		local extra_gold = gold + talent:GetSpecialValueFor("value") 
		PlayerResource:SetGold(playerid,extra_gold,false)
	end


	--local goldbag = CreateUnitByName("item_bag_of_gold", targetdroppoint, true, nil, nil, teamnumber)
	local newItem = CreateItem( "item_bag_of_gold_goofy", player, player )
	local drop = CreateItemOnPositionForLaunch( targetdroppoint, newItem )
	newItem:LaunchLootInitialHeight( false, 0, 500, 0.75, targetdroppoint + RandomVector( 50 ) )
end




