function trooper(keys)
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local playerid = player:GetPlayerID()
	local ability = keys.ability
	local target = keys.target_points[1]
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
	local number_of_troopers = ability:GetLevelSpecialValueFor("amount_of_troopers", ability:GetLevel() - 1 )
	local modifier = keys.modifiername

	local troopertable = {}

	for i = 1,number_of_troopers do

		--make trooper
		troopertable[i] = CreateUnitByName("stormtrooper", target, true, caster, caster, caster:GetTeamNumber())
		troopertable[i]:SetControllableByPlayer(playerid, true)
	    ability:ApplyDataDrivenModifier(caster, troopertable[i], modifier, nil)
	    local auraability = troopertable[i]:FindAbilityByName("r2d2_trooper_aura")
	    auraability:SetLevel(ability:GetLevel())

	    --destroy pipes after time runs out
		Timers:CreateTimer(duration, function ()
			    troopertable[i]:RemoveModifierByName(modifier)
		        troopertable[i]:ForceKill(true)
		end)
	end
end