function mushroom(keys)
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local playerid = player:GetPlayerID()
	local ability = keys.ability
	local target = keys.target_points[1]
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
	local modifier = keys.modifiername


	--make mushroom
	local mushroom = CreateUnitByName("mario_mushroom", target, true, caster, caster, caster:GetTeamNumber())
	mushroom:SetControllableByPlayer(playerid, true)
    ability:ApplyDataDrivenModifier(caster, mushroom, modifier, nil)
    local healability = mushroom:FindAbilityByName("mario_mushroom_heal")
    healability:SetLevel(ability:GetLevel())

    --destroy pipes after time runs out
	Timers:CreateTimer(duration, function ()
		    mushroom:RemoveModifierByName(modifier)
	        mushroom:ForceKill(true)
	end)
end