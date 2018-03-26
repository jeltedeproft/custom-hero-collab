function QtfHaxStart(event)
	local caster = event.caster
	local ability = event.ability
	EmitGlobalSound("Hero_Wisp.TeleportIn")
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_qtf_hax", {duration = duration})
	local heroPositions = {}
	local heroSpotTaken= {}
	local number = 1
	local units = FindUnitsInRadius(0 , caster:GetAbsOrigin() , nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for k,v in pairs(units) do
		heroPositions[number] = v:GetAbsOrigin()
		heroSpotTaken[number] = false
		number = number + 1
	end

	local colorunits = FindUnitsInRadius(0 , caster:GetAbsOrigin() , nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for k,v in pairs(colorunits) do
		local color = GameRules.RGB_PLAYER_COLORS[2]
      	PlayerResource:SetCustomPlayerColor(v:GetPlayerID(), color[1],color[2],color[3]) 
      	SetTeamCustomHealthbarColor(v:GetTeam(),color[1],color[2],color[3]) 
	end

	for k,v in pairs(units) do
		local foundSpot = false
		repeat
			local spotnumber = RandomInt(1, number)
        	if heroSpotTaken[spotnumber] == false then
        	  	heroSpotTaken[spotnumber] = true
        	  	FindClearSpaceForUnit(v, heroPositions[spotnumber], false)
        	  	local particle = ParticleManager:CreateParticle("particles/custom_particles/abilities/qtf_hax/joker_qtf_hax.vpcf", PATTACH_ABSORIGIN, v)
        	  	ParticleManager:SetParticleControl( particle, 0, v:GetAbsOrigin() + Vector(0,0,30))
        	  	ability:ApplyDataDrivenModifier(caster, v, "modifier_qtf_hax_hide", {duration = duration})

        	  	PlayerResource:SetCameraTarget(v:GetPlayerID(), v) 

        	  	local player = PlayerResource:GetPlayer(v:GetPlayerID())
        	  	if player ~= nil then
        	  		ParticleManager:CreateParticleForPlayer("particles/custom_particles/abilities/qtf_hax/joker_arcane_drop.vpcf", PATTACH_EYES_FOLLOW, player, player) 
        	  	end
        	  	Timers:CreateTimer(0.2,function()
        	  		PlayerResource:SetCameraTarget(v:GetPlayerID(), nil) 
        	  	end)

        	  	foundSpot = true
        	end
		until foundSpot == true
	end

end

function QtfHaxEnd(event)
	EmitGlobalSound("Hero_Wisp.TeleportOut")
	RestoreColors()
end