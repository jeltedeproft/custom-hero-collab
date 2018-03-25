function pipe(keys)
	local caster = keys.caster
	local player = caster:GetPlayerOwner()
	local playerid = player:GetPlayerID()
	local ability = keys.ability
	local target = keys.target_points[1]
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
	local modifier = keys.modifiername
	local fountainpipelocation = nil

	--sound
	caster:EmitSound("pipe")

	--pipe at mouse location
	local mousepipe = CreateUnitByName("mario_pipe", target, true, caster, caster, caster:GetTeamNumber())
	mousepipe:SetControllableByPlayer(playerid, true)
    ability:ApplyDataDrivenModifier(caster, mousepipe, modifier, nil)
    local suckinability = mousepipe:FindAbilityByName("suck_in")
    suckinability:SetLevel(1)

    --pipe in fountain
    local fountainEntities = Entities:FindAllByClassname( "info_player_start_dota")
    for _,fountainEnt in pairs( fountainEntities ) do
    	if fountainEnt:GetTeamNumber() == caster:GetTeamNumber() then
    		fountainpipelocation = fountainEnt:GetAbsOrigin()
    	end
    end

    local fountainpipe = CreateUnitByName("mario_pipe", fountainpipelocation, true, caster, caster, caster:GetTeamNumber())
    fountainpipe:SetControllableByPlayer(playerid, true)
    ability:ApplyDataDrivenModifier(caster, fountainpipe, modifier, nil)
    local suckinabilityfountain = fountainpipe:FindAbilityByName("suck_in")
    suckinabilityfountain:SetLevel(1)
    fountainpipe.otherpipelocation = target
    mousepipe.otherpipelocation = fountainpipelocation

    --we save the pipes in the ability, for later retrieval
    player.fountain = fountainpipe
    player.mouse = mousepipe

    --destroy pipes after time runs out
	Timers:CreateTimer(duration, function ()
	        mousepipe:ForceKill(true)
	        fountainpipe:ForceKill(true)
	end)
end


function suckin(keys)
	local caster = keys.caster
	local hero = caster:GetOwner()
	local player = hero:GetPlayerOwner()
	local pos = caster:GetAbsOrigin()
	local team = caster:GetTeamNumber()
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )
	local fountainpipe = player.fountain
	local mousepipe = player.mouse

	local pipes = Entities:FindAllByClassname("npc_dota_creature")

	for _,pipe in pairs(pipes) do
		--pipe is not the one we used the spell on (starting point)
		if pipe:GetAbsOrigin() ~= caster:GetAbsOrigin() then
			--pipe is the fountain one, go there
			if pipe:GetAbsOrigin() == fountainpipe:GetAbsOrigin() then
				otherpipepos = pipe:GetAbsOrigin()
			elseif pipe:GetAbsOrigin() == mousepipe:GetAbsOrigin() then
				otherpipepos = pipe:GetAbsOrigin()
			end
		end
	end

	local friends = FindUnitsInRadius(team, pos, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

	for _,friend in pairs(friends) do
		FindClearSpaceForUnit(friend, otherpipepos, true)
	end
end