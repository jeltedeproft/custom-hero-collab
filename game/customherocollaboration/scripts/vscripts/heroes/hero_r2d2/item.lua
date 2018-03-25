function giveitem(keys)
	local caster = keys.caster
	local player = caster:GetOwner()
	local playerid = player:GetPlayerID()
	local teamnumber = caster:GetTeamNumber()
	local origin = caster:GetAbsOrigin()
	local forward = caster:GetForwardVector()
	local targetdroppoint = origin + forward
	local ability = keys.ability
	local ability_level = ability:GetLevel()

	local level_one_items = {
		"item_boots_of_elves",
		"item_belt_of_strength",
		"item_blades_of_attack",
		"item_blight_stone",
		"item_boots",
		"item_bottle",
		"item_circlet",
		"item_clarity",
		"item_cloak",
		"item_dust",
		"item_enchanted_mango",
		"item_faerie_fire",
		"item_gauntlets",
		"item_gloves",
		"item_flask",
		"item_infused_raindrop",
		"item_branches",
		"item_mantle",
		"item_ward_observer",
		"item_orb_of_venom",
		"item_quelling_blade",
		"item_ring_of_protection",
		"item_ward_sentry",
		"item_slippers",
		"item_smoke_of_deceit",
		"item_stout_shield",
		"item_tango",
		"item_wind_lace"
	}

	local level_two_items = {
		"item_blade_of_alacrity",
		"item_broadsword",
		"item_chainmail",
		"item_claymore",
		"item_energy_booster",
		"item_gem",
		"item_ghost",
		"item_helm_of_iron_will",
		"item_javelin",
		"item_magic_stick",
		"item_mithril_hammer",
		"item_ogre_axe",
		"item_platemail",
		"item_point_booster",
		"item_quarterstaff",
		"item_ring_of_health",
		"item_staff_of_wizardry",
		"item_vitality_booster",
		"item_void_stone",
		"item_lifesteal"
	}

	local level_three_items = {
		"item_blink",
		"item_demon_edge",
		"item_hyperstone",
		"item_mystic_staff",
		"item_reaver",
		"item_relic",
		"item_shadow_amulet",
		"item_talisman_of_evasion",
		"item_ultimate_orb",
		"item_aether_lens",
		"item_arcane_boots",
		"item_blade_mail",
		"item_buckler",
		"item_lesser_crit",
		"item_ancient_janggo",
		"item_ring_of_health",
		"item_cyclone",
		"item_force_staff",
		"item_glimmer_cape"
	}

	local level_four_items = {
		"item_aegis",
		"item_abyssal_blade",
		"item_aeon_disk",
		"item_ultimate_scepter",
		"item_assault",
		"item_bfury",
		"item_black_king_bar",
		"item_bloodstone",
		"item_bloodthorn",
		"item_travel_boots_1",
		"item_butterfly",
		"item_greater_crit",
		"item_desolator",
		"item_diffusal_blade",
		"item_ethereal_blade",
		"item_skadi",
		"item_guardian_greaves",
		"item_hand_of_midas",
		"item_heart"
	}
	--this list contains all the items that can be given at this ability level
	local itemlist = nil

	--make the right list of items
	if ability_level == 1 then itemlist = level_one_items end
	if ability_level == 2 then itemlist = level_two_items end
	if ability_level == 3 then itemlist = level_three_items end
	if ability_level == 4 then itemlist = level_four_items end

	--get a random number in the list
	local randomnumber = RandomInt(1, TableCount(itemlist))

	local newItem = CreateItem( itemlist[randomnumber], nil, nil )
	local drop = CreateItemOnPositionForLaunch( targetdroppoint, newItem )
	newItem:LaunchLootInitialHeight( false, 0, 500, 0.75, targetdroppoint + RandomVector( 50 ) )
end




