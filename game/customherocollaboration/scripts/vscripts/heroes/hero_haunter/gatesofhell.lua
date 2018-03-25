function createghost(keys)
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local playerid = player:GetPlayerID()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifiername
	local ghost_location = nil

	--find fountain location
	local fountainEntities = Entities:FindAllByClassname( "info_player_start_dota")
	for _,fountainEnt in pairs( fountainEntities ) do
		if fountainEnt:GetTeamNumber() == caster:GetTeamNumber() then
			ghost_location = fountainEnt:GetAbsOrigin()
		end
	end

	--make ghost
	local ghost = CreateUnitByName("dementor", ghost_location, true, caster, caster, caster:GetTeamNumber())
	ghost:SetControllableByPlayer(playerid, true)
    ability:ApplyDataDrivenModifier(caster, ghost, modifier, nil)
    local gateability = ghost:FindAbilityByName("opengate")
    gateability:SetLevel(ability:GetLevel())

    --store this unit for later reference
    ghost.myhaunter = caster
end


function removeghostmaybe(keys)
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local playerid = player:GetPlayerID()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifiername
	local ghost_location = nil
	local modelname = "models/dementortwo/dementor.vmdl"

	--find ghost and remove
	local ghost = Entities:FindByModelWithin(nil, modelname, caster:GetAbsOrigin(), 25000)

	if ghost == nil then
		return
	else
	    ghost:RemoveModifierByName(modifier)
        ghost:Kill(ability, caster)
    end
end

function letghostkill( keys )
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local playerid = player:GetPlayerID()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ghost_location = nil
	local modelname = "models/dementortwo/dementor.vmdl"
	local ghost_ability_name = keys.ghostabilityname

	local target = keys.target_points[1]
	

	--find ghost and remove
	local ghost = Entities:FindByModelWithin(nil, modelname, caster:GetAbsOrigin(), 25000)

	local ghost_ability = ghost:FindAbilityByName(ghost_ability_name)

	--if caster is alive, kill
	if caster:IsAlive() then
		caster:ForceKill(false)
	end

	--let ghost cast his ability
	ghost:CastAbilityOnPosition(target, ghost_ability, playerid)	
end

function letghostrevive( keys )
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local playerid = player:GetPlayerID()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifiername
	local ghost_ability_name = keys.ghostabilityname
	local haunter_ultimate_name = keys.haunterultimatename

	local target = keys.target_points[1]
	local haunter = caster.myhaunter

	--get the current respawn timer left
	local respawn_time_left = haunter:GetTimeUntilRespawn()
	local currTime = GameRules:GetGameTime() 
	haunter.revive_start_time = currTime
	haunter.respawn_time = respawn_time_left

	--play global sound
	EmitGlobalSound("hauntergatesofhell")

	--revive haunter with modifier
	local haunter_ultimate = haunter:FindAbilityByName(haunter_ultimate_name)

	haunter:RespawnHero(false, false)

	FindClearSpaceForUnit(haunter, target, false)

	ability:ApplyDataDrivenModifier(caster, haunter, modifier, nil)

	--put haunter ultimate on cooldown
	local time = haunter_ultimate:GetCooldown(ability_level)
	haunter_ultimate:StartCooldown(time)
end

function extendduration( keys )
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local playerid = player:GetPlayerID()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifiername

	local extra_duration_per_kill = ability:GetLevelSpecialValueFor("extra_duration_per_kill", ability_level)

	local target = keys.target_points[1]

	local haunter = caster.myhaunter

	local back_to_life_modifier = haunter:FindModifierByName(modifier)
	local remaining_time = back_to_life_modifier:GetRemainingTime()

	back_to_life_modifier:SetDuration(remaining_time + extra_duration_per_kill)
end

function killhaunter( keys )
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local playerid = player:GetPlayerID()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifiername

	local haunter = caster.myhaunter

	--first check if we still have respawn time left
	local start_time = haunter.revive_start_time
	local currTime = GameRules:GetGameTime()
	local difference = math.floor(currTime-start_time)

	local respawn_time_left = haunter.respawn_time
	local new_respawn_time = respawn_time_left - difference

	if respawn_time_left < difference then
		if not haunter:IsAlive() then
			haunter:RespawnHero(false, false)
		else
			--remove modifier
			haunter:RemoveModifierByName(modifier)
		end
	else
		if haunter:IsAlive() then
			--play global sound
			caster:EmitSound("haunterdie")

			--remove modifier
			haunter:RemoveModifierByName(modifier)

			--kill haunter
			local haunter = caster.myhaunter
			haunter:ForceKill(false)

			--continue respawn time
			haunter:SetTimeUntilRespawn(new_respawn_time)
		else
			haunter:SetTimeUntilRespawn(new_respawn_time)
		end
	end
end