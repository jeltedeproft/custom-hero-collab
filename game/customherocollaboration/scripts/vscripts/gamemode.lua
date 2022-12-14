-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode
BAREBONES_VERSION = "1.00"

-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = false 

if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
--require('libraries/attachments')
-- This library can be used to synchronize client-server data via player/client-specific nettables
require('libraries/playertables')
-- This library can be used to create container inventories or container shops
require('libraries/containers')
-- This library provides a searchable, automatically updating lua API in the tools-mode via "modmaker_api" console command
--require('libraries/modmaker')
-- This library provides an automatic graph construction of path_corner entities within the map
require('libraries/pathgraph')
-- This library (by Noya) provides player selection inspection and management from server lua
require('libraries/selection')

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')


-- This is a detailed example of many of the containers.lua possibilities, but only activates if you use the provided "playground" map
if GetMapName() == "playground" then
  require("examples/playground")
end

--require("examples/worldpanelsExample")

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

  --collect all heroes
  if hero:GetOwnerEntity() ~= nil then
    GameRules.Heroes[hero:GetPlayerID()] = hero
    hero.positions = {}

    hero:MoveToPosition( hero:GetAbsOrigin() )

    if hero:GetUnitName() == "npc_dota_hero_invoker" then
      local empty = hero:FindAbilityByName("barebones_empty1")
      if empty ~= nil then
        hero:RemoveAbility("barebones_empty1")
      end
      for k,uspell in pairs(GameRules.UNIQUE_SPELLS) do
        local spell = hero:FindAbilityByName(uspell)
        if spell ~= nil then
          hero:RemoveAbility(uspell)
        end
      end
      local random = RandomInt(1, #GameRules.UNIQUE_SPELLS) 
      local spell = hero:AddAbility(GameRules.UNIQUE_SPELLS[random])
      spell:SetLevel(1) 
    end

    if hero:GetUnitName() == "npc_dota_hero_sand_king" then
      local energy_shield = hero:FindAbilityByName("shielder_energy_shield")
      if energy_shield then energy_shield:SetLevel(1) end
    end
  end
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")

  Timers:CreateTimer(30, -- Start this timer 30 game-time seconds later
    function()
      DebugPrint("This function is called 30 seconds after the game begins, and every 30 seconds thereafter")
      return 30.0 -- Rerun this timer every 30 game-time seconds 
    end)
end



-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  if GetMapName() == "dota" then
    PRE_GAME_TIME = 75.0
  end
  if GetMapName() ~= "dota" then
    self.m_TeamColors = {}
    self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }  --    Teal
    self.m_TeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }   --    Yellow
    self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }  --      Pink
    self.m_TeamColors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }   --    Orange
    self.m_TeamColors[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }   --    Blue
    self.m_TeamColors[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }  --    Green
    self.m_TeamColors[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }   --    Brown
    self.m_TeamColors[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }  --    Cyan
    self.m_TeamColors[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }  --    Olive
    self.m_TeamColors[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }  --    Purple

    for team = 0, (DOTA_TEAM_COUNT-1) do
      color = self.m_TeamColors[ team ]
      if color then
        SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
      end
    end

    self.m_VictoryMessages = {}
    self.m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#VictoryMessage_GoodGuys"
    self.m_VictoryMessages[DOTA_TEAM_BADGUYS]  = "#VictoryMessage_BadGuys"
    self.m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1"
    self.m_VictoryMessages[DOTA_TEAM_CUSTOM_2] = "#VictoryMessage_Custom2"
    self.m_VictoryMessages[DOTA_TEAM_CUSTOM_3] = "#VictoryMessage_Custom3"
    self.m_VictoryMessages[DOTA_TEAM_CUSTOM_4] = "#VictoryMessage_Custom4"
    self.m_VictoryMessages[DOTA_TEAM_CUSTOM_5] = "#VictoryMessage_Custom5"
    self.m_VictoryMessages[DOTA_TEAM_CUSTOM_6] = "#VictoryMessage_Custom6"
    self.m_VictoryMessages[DOTA_TEAM_CUSTOM_7] = "#VictoryMessage_Custom7"
    self.m_VictoryMessages[DOTA_TEAM_CUSTOM_8] = "#VictoryMessage_Custom8"

    self.m_GatheredShuffledTeams = {}
    self.numSpawnCamps = 5
    self.specialItem = ""
    self.spawnTime = 120
    self.nNextSpawnItemNumber = 1
    self.hasWarnedSpawn = false
    self.allSpawned = false
    self.leadingTeam = -1
    self.runnerupTeam = -1
    self.leadingTeamScore = 0
    self.runnerupTeamScore = 0
    self.isGameTied = true
    self.countdownEnabled = false
    self.itemSpawnIndex = 1
    self.itemSpawnLocation = Entities:FindByName( nil, "greevil" )
    self.tier1ItemBucket = {}
    self.tier2ItemBucket = {}
    self.tier3ItemBucket = {}
    self.tier4ItemBucket = {}

    self.TEAM_KILLS_TO_WIN = 25
    self.CLOSE_TO_VICTORY_THRESHOLD = 5

    self:GatherAndRegisterValidTeams()

    -- Adding Many Players
    if GetMapName() == "desert_quintet" then
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 5 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 5 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 5 )
      self.m_GoldRadiusMin = 300
      self.m_GoldRadiusMax = 1400
      self.m_GoldDropPercent = 8
      MAX_NUMBER_OF_TEAMS = 3
    elseif GetMapName() == "temple_quartet" then
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 4 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 4 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 4 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 4 )
      self.m_GoldRadiusMin = 300
      self.m_GoldRadiusMax = 1400
      self.m_GoldDropPercent = 10
      MAX_NUMBER_OF_TEAMS = 4
    elseif GetMapName() == "mines_trio" then
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 3 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 3 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 3 )
      self.m_GoldRadiusMin = 250
      self.m_GoldRadiusMax = 550
      self.m_GoldDropPercent = 4
      MAX_NUMBER_OF_TEAMS = 3
    elseif GetMapName() == "desert_duo" then
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 2 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 2 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 2 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 2 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_3, 2 )
      self.m_GoldRadiusMin = 250
      self.m_GoldRadiusMax = 550
      self.m_GoldDropPercent = 4
      MAX_NUMBER_OF_TEAMS = 5
    elseif GetMapName() == "forest_solo" then
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 1 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 1 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 1 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 1 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_3, 1 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_4, 1 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_5, 1 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_6, 1 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_7, 1 )
      GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_8, 1 )
      self.m_GoldRadiusMin = 250
      self.m_GoldRadiusMax = 550
      self.m_GoldDropPercent = 4
      MAX_NUMBER_OF_TEAMS = 10
    end

    GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
    GameRules:GetGameModeEntity():SetTopBarTeamValuesVisible( false )
    GameRules:GetGameModeEntity():SetFountainPercentageHealthRegen( 0 )
    GameRules:GetGameModeEntity():SetFountainPercentageManaRegen( 0 )
    GameRules:GetGameModeEntity():SetFountainConstantManaRegen( 0 )
    GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap( GameMode, "BountyRunePickupFilter" ), self )
    GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( GameMode, "ExecuteOrderFilter" ), self )

    --ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( GameMode, 'OnGameRulesStateChange' ), self )
    --ListenToGameEvent( "npc_spawned", Dynamic_Wrap( GameMode, "OnNPCSpawned" ), self )
    ListenToGameEvent( "dota_team_kill_credit", Dynamic_Wrap( GameMode, 'OnTeamKillCredit' ), self )
    --ListenToGameEvent( "entity_killed", Dynamic_Wrap( GameMode, 'OnEntityKilled' ), self )
    ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( GameMode, "OnItemPickedUp"), self )
    ListenToGameEvent( "dota_npc_goal_reached", Dynamic_Wrap( GameMode, "OnNPCGoalReached" ), self )

    GameMode:SetUpFountains()
    GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 ) 

    -- Spawning monsters
    spawncamps = {}
    for i = 1, self.numSpawnCamps do
      local campname = "camp"..i.."_path_customspawn"
      spawncamps[campname] =
      {
        NumberToSpawn = RandomInt(3,5),
        WaypointName = "camp"..i.."_path_wp1"
      }
    end
  end
  --remember positions of heroes for ntropy rewind spell
  GameRules.Heroes = {}
  GameRules.Think = Timers:CreateTimer(function() Think() return .1 end)

  -- Remove TP scrolls
  GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(function(ctx, event)
      local item = EntIndexToHScript(event.item_entindex_const)
      if item:GetAbilityName() == "item_tpscroll" and item:GetPurchaser() == nil then return false end
      return true
  end, self)

  --Lua Modifiers
  LinkLuaModifier( "modifier_stun", LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "modifier_medical_tractate", LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "modifier_induel", LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "modifier_lostduel", LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "modifier_dueldelay", "modifiers/modifier_dueldelay", LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "modifier_creepbuff", "modifiers/modifier_creepbuff", LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "modifier_bvohero", "modifiers/modifier_bvohero", LUA_MODIFIER_MOTION_NONE )

  LinkLuaModifier( "bvo_rem_skill_2_modifier", "heroes/rem/modifiers/bvo_rem_skill_2_modifier", LUA_MODIFIER_MOTION_NONE )
  --Talents
  LinkLuaModifier( "bvo_special_bonus_magic_resist_25_modifier", "talents/bvo_special_bonus_magic_resist_25_modifier", LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "bvo_special_bonus_armor_15_modifier", "talents/bvo_special_bonus_armor_15_modifier", LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "bvo_special_bonus_health_650_modifier", "talents/bvo_special_bonus_health_650_modifier", LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "bvo_special_bonus_evasion_15_modifier", "talents/bvo_special_bonus_evasion_15_modifier", LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "bvo_special_bonus_attack_speed_80_modifier", "talents/bvo_special_bonus_attack_speed_80_modifier", LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "bvo_special_bonus_damage_75_modifier", "talents/bvo_special_bonus_damage_75_modifier", LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "bvo_special_bonus_lifesteal_10_modifier", "talents/bvo_special_bonus_lifesteal_10_modifier", LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "bvo_special_bonus_reduced_damage_10_modifier", "talents/bvo_special_bonus_reduced_damage_10_modifier", LUA_MODIFIER_MOTION_NONE )

  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
end

function _G:PlaySoundFile( soundName, caller )
  for _,hero in pairs(_G.tHeroesRadiant) do
    if hero.playHeroVoice == 1 then
      if (caller:GetAbsOrigin() - hero:GetAbsOrigin()):Length2D() < 3000 then
        EmitSoundOnClient(soundName, hero:GetPlayerOwner())
      end
    end
  end
  for _,hero in pairs(_G.tHeroesDire) do
    if hero.playHeroVoice == 1 then
      if (caller:GetAbsOrigin() - hero:GetAbsOrigin()):Length2D() < 3000 then
        EmitSoundOnClient(soundName, hero:GetPlayerOwner())
      end
    end
  end
end

---------------------------------------------------------------------------
-- Set up fountain regen
---------------------------------------------------------------------------
function GameMode:SetUpFountains()

  LinkLuaModifier( "modifier_fountain_aura_lua", LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "modifier_fountain_aura_effect_lua", LUA_MODIFIER_MOTION_NONE )

  local fountainEntities = Entities:FindAllByClassname( "ent_dota_fountain")
  for _,fountainEnt in pairs( fountainEntities ) do
    --print("fountain unit " .. tostring( fountainEnt ) )
    fountainEnt:AddNewModifier( fountainEnt, fountainEnt, "modifier_fountain_aura_lua", {} )
  end
end

---------------------------------------------------------------------------
-- Get the color associated with a given teamID
---------------------------------------------------------------------------
function GameMode:ColorForTeam( teamID )
  local color = self.m_TeamColors[ teamID ]
  if color == nil then
    color = { 255, 255, 255 } -- default to white
  end
  return color
end

---------------------------------------------------------------------------
---------------------------------------------------------------------------
function GameMode:EndGame( victoryTeam )
  local overBoss = Entities:FindByName( nil, "@overboss" )
  if overBoss then
    local celebrate = overBoss:FindAbilityByName( 'dota_ability_celebrate' )
    if celebrate then
      overBoss:CastAbilityNoTarget( celebrate, -1 )
    end
  end

  GameRules:SetGameWinner( victoryTeam )
end


---------------------------------------------------------------------------
-- Put a label over a player's hero so people know who is on what team
---------------------------------------------------------------------------
function GameMode:UpdatePlayerColor( nPlayerID )
  if not PlayerResource:HasSelectedHero( nPlayerID ) then
    return
  end

  local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
  if hero == nil then
    return
  end

  local teamID = PlayerResource:GetTeam( nPlayerID )
  local color = self:ColorForTeam( teamID )
  PlayerResource:SetCustomPlayerColor( nPlayerID, color[1], color[2], color[3] )
end


---------------------------------------------------------------------------
-- Simple scoreboard using debug text
---------------------------------------------------------------------------
function GameMode:UpdateScoreboard()
  local sortedTeams = {}
  for _, team in pairs( self.m_GatheredShuffledTeams ) do
    table.insert( sortedTeams, { teamID = team, teamScore = GetTeamHeroKills( team ) } )
  end

  -- reverse-sort by score
  table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

  for _, t in pairs( sortedTeams ) do
    local clr = self:ColorForTeam( t.teamID )

    -- Scaleform UI Scoreboard
    local score = 
    {
      team_id = t.teamID,
      team_score = t.teamScore
    }
    FireGameEvent( "score_board", score )
  end
  -- Leader effects (moved from OnTeamKillCredit)
  local leader = sortedTeams[1].teamID
  --print("Leader = " .. leader)
  self.leadingTeam = leader
  self.runnerupTeam = sortedTeams[2].teamID
  self.leadingTeamScore = sortedTeams[1].teamScore
  self.runnerupTeamScore = sortedTeams[2].teamScore
  if sortedTeams[1].teamScore == sortedTeams[2].teamScore then
    self.isGameTied = true
  else
    self.isGameTied = false
  end
  local allHeroes = HeroList:GetAllHeroes()
  for _,entity in pairs( allHeroes) do
    if entity:GetTeamNumber() == leader and sortedTeams[1].teamScore ~= sortedTeams[2].teamScore then
      if entity:IsAlive() == true then
        -- Attaching a particle to the leading team heroes
        local existingParticle = entity:Attribute_GetIntValue( "particleID", -1 )
            if existingParticle == -1 then
              local particleLeader = ParticleManager:CreateParticle( "particles/leader/leader_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, entity )
          ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, entity, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", entity:GetAbsOrigin(), true )
          entity:Attribute_SetIntValue( "particleID", particleLeader )
        end
      else
        local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
        if particleLeader ~= -1 then
          ParticleManager:DestroyParticle( particleLeader, true )
          entity:DeleteAttribute( "particleID" )
        end
      end
    else
      local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
      if particleLeader ~= -1 then
        ParticleManager:DestroyParticle( particleLeader, true )
        entity:DeleteAttribute( "particleID" )
      end
    end
  end
end

---------------------------------------------------------------------------
-- Update player labels and the scoreboard
---------------------------------------------------------------------------
function GameMode:OnThink()
  for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
    self:UpdatePlayerColor( nPlayerID )
  end
  
  self:UpdateScoreboard()
  -- Stop thinking if game is paused
  if GameRules:IsGamePaused() == true then
        return 1
    end

  if self.countdownEnabled == true then
    CountdownTimer()
    if nCOUNTDOWNTIMER == 30 then
      CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
    end
    if nCOUNTDOWNTIMER <= 0 then
      --Check to see if there's a tie
      if self.isGameTied == false then
        GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[self.leadingTeam] )
        GameMode:EndGame( self.leadingTeam )
        self.countdownEnabled = false
      else
        self.TEAM_KILLS_TO_WIN = self.leadingTeamScore + 1
        local broadcast_killcount = 
        {
          killcount = self.TEAM_KILLS_TO_WIN
        }
        CustomGameEventManager:Send_ServerToAllClients( "overtime_alert", broadcast_killcount )
      end
        end
  end
  
  if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    --Spawn Gold Bags
    GameMode:ThinkGoldDrop()
    GameMode:ThinkSpecialItemDrop()
  end

  return 1
end

---------------------------------------------------------------------------
-- Scan the map to see which teams have spawn points
---------------------------------------------------------------------------
function GameMode:GatherAndRegisterValidTeams()
--  print( "GatherValidTeams:" )

  local foundTeams = {}
  for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
    foundTeams[  playerStart:GetTeam() ] = true
  end

  local numTeams = TableCount(foundTeams)
  print( "GatherValidTeams - Found spawns for a total of " .. numTeams .. " teams" )
  
  local foundTeamsList = {}
  for t, _ in pairs( foundTeams ) do
    table.insert( foundTeamsList, t )
  end

  if numTeams == 0 then
    print( "GatherValidTeams - NO team spawns detected, defaulting to GOOD/BAD" )
    table.insert( foundTeamsList, DOTA_TEAM_GOODGUYS )
    table.insert( foundTeamsList, DOTA_TEAM_BADGUYS )
    numTeams = 2
  end

  local maxPlayersPerValidTeam = math.floor( 10 / numTeams )

  self.m_GatheredShuffledTeams = ShuffledList( foundTeamsList )

  print( "Final shuffled team list:" )
  for _, team in pairs( self.m_GatheredShuffledTeams ) do
    print( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
  end

  print( "Setting up teams:" )
  for team = 0, (DOTA_TEAM_COUNT-1) do
    local maxPlayers = 0
    if ( nil ~= TableFindKey( foundTeamsList, team ) ) then
      maxPlayers = maxPlayersPerValidTeam
    end
    print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(maxPlayers) )
    GameRules:SetCustomGameTeamMaxPlayers( team, maxPlayers )
  end
end

-- Spawning individual camps
function GameMode:spawncamp(campname)
  spawnunits(campname)
end

-- Simple Custom Spawn
function spawnunits(campname)
  local spawndata = spawncamps[campname]
  local NumberToSpawn = spawndata.NumberToSpawn --How many to spawn
    local SpawnLocation = Entities:FindByName( nil, campname )
    local waypointlocation = Entities:FindByName ( nil, spawndata.WaypointName )
  if SpawnLocation == nil then
    return
  end

    local randomCreature = 
      {
      "basic_zombie",
      "berserk_zombie"
      }
  local r = randomCreature[RandomInt(1,#randomCreature)]
  --print(r)
    for i = 1, NumberToSpawn do
        local creature = CreateUnitByName( "npc_dota_creature_" ..r , SpawnLocation:GetAbsOrigin() + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_NEUTRALS )
        --print ("Spawning Camps")
        creature:SetInitialGoalEntity( waypointlocation )
    end
end

--------------------------------------------------------------------------------
-- Event: Filter for inventory full
--------------------------------------------------------------------------------
function GameMode:ExecuteOrderFilter( filterTable )
  --[[
  for k, v in pairs( filterTable ) do
    print("EO: " .. k .. " " .. tostring(v) )
  end
  ]]

  local orderType = filterTable["order_type"]
  if ( orderType ~= DOTA_UNIT_ORDER_PICKUP_ITEM or filterTable["issuer_player_id_const"] == -1 ) then
    return true
  else
    local item = EntIndexToHScript( filterTable["entindex_target"] )
    if item == nil then
      return true
    end
    local pickedItem = item:GetContainedItem()
    --print(pickedItem:GetAbilityName())
    if pickedItem == nil then
      return true
    end
    if pickedItem:GetAbilityName() == "item_treasure_chest" then
      local player = PlayerResource:GetPlayer(filterTable["issuer_player_id_const"])
      local hero = player:GetAssignedHero()
      if hero:GetNumItemsInInventory() < 9 then
        --print("inventory has space")
        return true
      else
        --print("Moving to target instead")
        local position = item:GetAbsOrigin()
        filterTable["position_x"] = position.x
        filterTable["position_y"] = position.y
        filterTable["position_z"] = position.z
        filterTable["order_type"] = DOTA_UNIT_ORDER_MOVE_TO_POSITION
        return true
      end
    end
  end
  return true
end


function _G:ToggleAbilities( hero, ability_visible, ability_hidden )
  local ability_visible_handle = hero:FindAbilityByName(ability_visible)

  local ability_visible_level = ability_visible_handle:GetLevel()
  local ability_visible_cooldown = ability_visible_handle:GetCooldownTimeRemaining()
  hero:RemoveAbility(ability_visible)

  local ability_hidden_handle = hero:AddAbility(ability_hidden)
  ability_hidden_handle:SetLevel(ability_visible_level)
  ability_hidden_handle:StartCooldown(ability_visible_cooldown)
end

function _G:CreateDrop(itemName, pos, launch)
    local newItem = CreateItem(itemName, nil, nil)
    newItem:SetPurchaseTime(0)
    newItem.originalPos = pos
    local drop = CreateItemOnPositionSync( pos, newItem )
    if launch then
      local direction = Vector( RandomInt(-10, 10), RandomInt(-10, 10), 0)
      local vec = direction:Normalized() * 64
      newItem:LaunchLoot(true, 256, 0.75, pos + vec)
    end
end

function CreateGoldCoin(pos, amount)
  local gc_table = {}
  for i = 1 , amount do
    local dummy = CreateUnitByName("npc_dummy_unit", pos, false, nil, nil, DOTA_TEAM_NEUTRALS)
    FindClearSpaceForUnit(dummy, pos, false)
      dummy:AddAbility("custom_gold_coin_dummy")
      local abl = dummy:FindAbilityByName("custom_gold_coin_dummy")
      if abl ~= nil then abl:SetLevel(1) end
      table.insert(gc_table, dummy)
  end
  for _,coin in pairs(gc_table) do
    local ability = coin:FindAbilityByName("custom_gold_coin_dummy")
    ability:ApplyDataDrivenModifier(coin, coin, "custom_phased_modifier", {} )
  end
end

function InitHeroSetup(event)
  local hero = EntIndexToHScript(event.heroindex)

  if hero then
    if hero:GetTeamNumber() == DOTA_TEAM_NEUTRALS then return end --or else brewmaster would be counted aswell
    if not hero:IsRealHero() or hero:IsIllusion() then return end


      local attachPoint = "attach_head"
      local attachZ = 138
      local attachX = 8
      local attachY = 0
      local attachSize = 1.0

    --Add extra skills
    local name = hero:GetUnitName()
    if name == "npc_dota_hero_juggernaut" then
      hero:FindAbilityByName("bvo_ichigo_skill_0"):SetLevel(1)
      hero:AddAbility("bvo_ichigo_skill_4_extra")
      hero:FindAbilityByName("bvo_ichigo_skill_4_extra"):SetHidden(true)

      hero:AddAbility("bvo_ichigo_skill_4")
      hero:FindAbilityByName("bvo_ichigo_skill_4"):SetHidden(true)
      hero:AddAbility("bvo_ichigo_skill_5")
      hero:FindAbilityByName("bvo_ichigo_skill_5"):SetHidden(true)
  
      attachZ = 178
        attachX = 30
        attachSize = 1.5

    elseif name == "npc_dota_hero_zuus" then
      hero:FindAbilityByName("bvo_enel_skill_0"):SetLevel(1)

      attachZ = 178
        attachX = -14
        attachSize = 1.5

    elseif name == "npc_dota_hero_ember_spirit" then
      hero:FindAbilityByName("bvo_ace_skill_0"):SetLevel(1)

      attachZ = 156
        attachX = 0
        attachY = 4
        attachSize = 1.0

    elseif name == "npc_dota_hero_faceless_void" then
      hero:FindAbilityByName("bvo_mihawk_skill_0"):SetLevel(1)

      attachZ = 176
        attachX = 10
        attachY = 2
        attachSize = 1.5

    elseif name == "npc_dota_hero_luna" then
      hero:FindAbilityByName("bvo_orihime_skill_0"):SetLevel(1)

      attachZ = 150
        attachX = 10
        attachY = -14
        attachSize = 1.0
    elseif name == "npc_dota_hero_sniper" then
      hero:FindAbilityByName("bvo_ishida_skill_0"):SetLevel(1)

      attachZ = 162
        attachX = 6
        attachY = -2
        attachSize = 1.0
    elseif name == "npc_dota_hero_lion" then
      hero:FindAbilityByName("bvo_yamamoto_skill_0"):SetLevel(1)

      attachZ = 156
        attachX = 4
        attachY = 0
        attachSize = 1.0
    elseif name == "npc_dota_hero_morphling" then
      hero:FindAbilityByName("bvo_zaraki_skill_0"):SetLevel(1)
      hero:AddAbility("bvo_zaraki_skill_3_extra")
      hero:FindAbilityByName("bvo_zaraki_skill_3_extra"):SetLevel(1)
      hero:FindAbilityByName("bvo_zaraki_skill_3_extra"):SetHidden(true)
      hero:AddAbility("bvo_zaraki_skill_5")
      hero:FindAbilityByName("bvo_zaraki_skill_5"):SetHidden(true)

      attachZ = 160
        attachX = 22
        attachY = 0
        attachSize = 1.0
    elseif name == "npc_dota_hero_riki" then
      hero:FindAbilityByName("bvo_luffy_skill_0"):SetLevel(1)
      hero:FindAbilityByName("bvo_luffy_skill_0"):SetHidden(true)
      
      hero:FindAbilityByName("bvo_luffy_skill_4_soru"):SetLevel(1)
      hero:FindAbilityByName("bvo_luffy_skill_4_soru"):SetHidden(true)

      attachZ = 150
        attachX = -6
        attachY = -2
        attachSize = 1.5
    elseif name == "npc_dota_hero_sven" then
      hero:FindAbilityByName("bvo_zoro_skill_0"):SetLevel(1)

      attachZ = 166
        attachX = 14
        attachY = 0
        attachSize = 1.0
    elseif name == "npc_dota_hero_lycan" then
      hero:FindAbilityByName("bvo_crocodile_skill_0"):SetLevel(1)

      attachZ = 190
        attachX = 4
        attachY = 0
        attachSize = 1.0
    elseif name == "npc_dota_hero_phantom_assassin" then
      hero:FindAbilityByName("bvo_soifon_skill_0"):SetLevel(1)

      attachZ = 138
        attachX = -2
        attachY = 0
        attachSize = 1.0
    elseif name == "npc_dota_hero_kunkka" then
      hero:FindAbilityByName("bvo_byakuya_skill_0"):SetLevel(1)
      hero:AddAbility("bvo_byakuya_skill_1_off")
      hero:FindAbilityByName("bvo_byakuya_skill_1_off"):SetLevel(1)
      hero:FindAbilityByName("bvo_byakuya_skill_1_off"):SetHidden(true)
      hero:AddAbility("bvo_byakuya_skill_4_off")
      hero:FindAbilityByName("bvo_byakuya_skill_4_off"):SetLevel(1)
      hero:FindAbilityByName("bvo_byakuya_skill_4_off"):SetHidden(true)

      attachZ = 142
        attachX = 38
        attachY = 0
        attachSize = 1.0
    elseif name == "npc_dota_hero_skeleton_king" then
      hero:FindAbilityByName("bvo_toshiro_skill_0"):SetLevel(1)
      hero:AddAbility("bvo_toshiro_skill_2_bankai")
      hero:FindAbilityByName("bvo_toshiro_skill_2_bankai"):SetLevel(1)
      hero:FindAbilityByName("bvo_toshiro_skill_2_bankai"):SetHidden(true)
      hero:AddAbility("bvo_toshiro_skill_4")
      hero:FindAbilityByName("bvo_toshiro_skill_4"):SetHidden(true)

      hero:AddAbility("bvo_toshiro_skill_5")
      hero:FindAbilityByName("bvo_toshiro_skill_5"):SetHidden(true)

      attachPoint = "follow_overhead"
      attachZ = 120
        attachX = 20
        attachSize = 2.0
    elseif name == "npc_dota_hero_naga_siren" then
      hero:FindAbilityByName("bvo_rukia_skill_0"):SetLevel(1)
      hero:AddAbility("bvo_rukia_skill_5")
      hero:FindAbilityByName("bvo_rukia_skill_5"):SetHidden(true)

      attachZ = 138
        attachX = -4
        attachY = -2
        attachSize = 1.0
    elseif name == "npc_dota_hero_slark" then
      hero:FindAbilityByName("bvo_hollow_skill_0"):SetLevel(1)
      hero:AddAbility("bvo_hollow_skill_1_bankai")
      hero:FindAbilityByName("bvo_hollow_skill_1_bankai"):SetHidden(true)
      hero:AddAbility("bvo_hollow_skill_4_extra")
      hero:FindAbilityByName("bvo_hollow_skill_4_extra"):SetHidden(true)
      hero:AddAbility("bvo_hollow_skill_5")
      hero:FindAbilityByName("bvo_hollow_skill_5"):SetHidden(true)
      hero:AddAbility("bvo_hollow_skill_5_extra")
      hero:FindAbilityByName("bvo_hollow_skill_5_extra"):SetHidden(true)

      attachZ = 178
        attachX = 30
        attachSize = 1.5
    elseif name == "npc_dota_hero_night_stalker" then
      hero:FindAbilityByName("bvo_lucci_skill_0"):SetLevel(1)

      attachZ = 146
        attachX = 36
        attachY = -8
        attachSize = 1.0
    elseif name == "npc_dota_hero_leshrac" then
      hero:FindAbilityByName("bvo_moria_skill_0"):SetLevel(1)

      attachZ = 224
        attachX = 6
        attachY = -2
        attachSize = 1.0
    elseif name == "npc_dota_hero_elder_titan" then
      hero:FindAbilityByName("bvo_sanji_skill_0"):SetLevel(1)
      hero:AddAbility("bvo_sanji_skill_4")
      hero:FindAbilityByName("bvo_sanji_skill_4"):SetHidden(true)
      hero:AddAbility("bvo_sanji_skill_5")
      hero:FindAbilityByName("bvo_sanji_skill_5"):SetHidden(true)

      attachZ = 166
        attachX = 12
        attachY = 0
        attachSize = 1.0
    elseif name == "npc_dota_hero_techies" then
      hero:FindAbilityByName("bvo_usopp_skill_0"):SetLevel(1)
      hero:AddAbility("bvo_usopp_skill_0_use")
      hero:FindAbilityByName("bvo_usopp_skill_0_use"):SetLevel(1)
      hero:FindAbilityByName("bvo_usopp_skill_0_use"):SetHidden(true)

      hero:AddAbility("bvo_usopp_skill_5_extra")
      hero:FindAbilityByName("bvo_usopp_skill_5_extra"):SetHidden(true)

      hero:FindAbilityByName("bvo_usopp_skill_5"):SetLevel(0)

      attachZ = 148
        attachX = 20
        attachY = 0
        attachSize = 1.0
    elseif name == "npc_dota_hero_lina" then
      hero:FindAbilityByName("bvo_nami_skill_0"):SetLevel(1)

      attachZ = 154
        attachX = -10
        attachY = -4
        attachSize = 1.5
    elseif name == "npc_dota_hero_phantom_lancer" then
      hero:FindAbilityByName("bvo_aokiji_skill_0"):SetLevel(1)

      attachZ = 178
        attachX = -4
        attachY = 0
        attachSize = 1.0
    elseif name == "npc_dota_hero_spectre" then
      hero:FindAbilityByName("bvo_yoruichi_skill_0"):SetLevel(1)
      hero:AddAbility("bvo_yoruichi_skill_5")
      hero:FindAbilityByName("bvo_yoruichi_skill_5"):SetHidden(true)

      attachZ = 156
        attachX = 0
        attachY = 0
        attachSize = 1.0
    elseif name == "npc_dota_hero_queenofpain" then
      hero:FindAbilityByName("bvo_shinobu_skill_0"):SetLevel(1)

      attachZ = 132
        attachX = 0
        attachY = 4
        attachSize = 1.5
    elseif name == "npc_dota_hero_keeper_of_the_light" then
      hero:FindAbilityByName("bvo_kuma_skill_0"):SetLevel(1)

      attachZ = 212
        attachX = 0
        attachY = 0
        attachSize = 1.0
    elseif name == "npc_dota_hero_lich" then
      hero:FindAbilityByName("bvo_brook_skill_0"):SetLevel(1)

      attachZ = 138
        attachX = -8
        attachSize = 1.0
    elseif name == "npc_dota_hero_mirana" then
      hero:FindAbilityByName("bvo_robin_skill_0"):SetLevel(1)
      
      attachZ = 156
        attachX = -4
        attachSize = 1.5
        --
        local heroPos2 = hero:GetAbsOrigin()
        local heroForward2 = hero:GetForwardVector()

      local dummy2 = CreateUnitByName("npc_dummy_unit", heroPos2, false, nil, nil, hero:GetTeam())
      dummy2:SetForwardVector(heroForward2)
      dummy2:AddAbility("custom_point_dummy")
      local abl = dummy2:FindAbilityByName("custom_point_dummy")
      if abl ~= nil then abl:SetLevel(1) end
      dummy2:SetModel("models/heroes/omniknight/omniknightwings.vmdl")
      dummy2:SetOriginalModel("models/heroes/omniknight/omniknightwings.vmdl")
      dummy2:SetModelScale(1.0)
      local vec_up2 = Vector( heroPos2.x, heroPos2.y, heroPos2.z + 130 )
      local rotation2 = QAngle( 0, 90, 0 )
      local rot_vector2 = RotatePosition(heroPos2, rotation2, heroPos2 + heroForward2 * 100)
      local pos12 = ((rot_vector2 - heroPos2):Normalized() * 0)
      dummy2:SetAbsOrigin(vec_up2 + heroForward2 * 0 + pos12)
      dummy2:SetParent(hero, "attach_origin")
      hero.wing_dummy = dummy2
      hero.wing_dummy.parent = hero
      dummy2:AddNoDraw()
    elseif name == "npc_dota_hero_troll_warlord" then
      hero:FindAbilityByName("bvo_ikkaku_skill_0"):SetLevel(1)
      hero:AddAbility("bvo_ikkaku_skill_4")
      hero:FindAbilityByName("bvo_ikkaku_skill_4"):SetHidden(true)
      hero:AddAbility("bvo_ikkaku_skill_5")
      hero:FindAbilityByName("bvo_ikkaku_skill_5"):SetHidden(true)

      --attachZ = 138
        --attachX = -8
        --attachSize = 1.0
    elseif name == "npc_dota_hero_terrorblade" then
      hero:FindAbilityByName("bvo_tousen_skill_0"):SetLevel(1)
      hero:AddAbility("bvo_tousen_skill_1_off")
      hero:FindAbilityByName("bvo_tousen_skill_1_off"):SetHidden(true)
      hero:AddAbility("bvo_tousen_skill_4_off")
      hero:FindAbilityByName("bvo_tousen_skill_4_off"):SetHidden(true)

      --attachZ = 138
        --attachX = -8
        --attachSize = 1.0
    elseif name == "npc_dota_hero_life_stealer" then
      hero:FindAbilityByName("bvo_renji_skill_0"):SetLevel(1)
      hero:AddAbility("bvo_renji_skill_1_off")
      hero:FindAbilityByName("bvo_renji_skill_1_off"):SetHidden(true)
      hero:AddAbility("bvo_renji_skill_4_off")
      hero:FindAbilityByName("bvo_renji_skill_4_off"):SetHidden(true)
      hero:AddAbility("bvo_renji_skill_3_off")
      hero:FindAbilityByName("bvo_renji_skill_3_off"):SetHidden(true)
      hero:AddAbility("bvo_renji_skill_5")
      hero:FindAbilityByName("bvo_renji_skill_5"):SetHidden(true)

      --attachZ = 138
        --attachX = -8
        --attachSize = 1.0
    elseif name == "npc_dota_hero_slardar" then
      hero:FindAbilityByName("bvo_sado_skill_0"):SetLevel(1)
      hero:AddAbility("bvo_sado_skill_5")
      hero:FindAbilityByName("bvo_sado_skill_5"):SetHidden(true)

      --attachZ = 138
        --attachX = -8
        --attachSize = 1.0
    elseif name == "npc_dota_hero_windrunner" then
      hero:FindAbilityByName("bvo_megumin_skill_0"):SetLevel(1)

      --attachZ = 138
        --attachX = -8
        --attachSize = 1.0
    elseif name == "npc_dota_hero_furion" then
      hero:FindAbilityByName("bvo_squall_skill_0"):SetLevel(1)

      --attachZ = 138
        --attachX = -8
        --attachSize = 1.0
    elseif name == "npc_dota_hero_necrolyte" then
      hero:AddAbility("bvo_mayuri_skill_1_cast")
      hero:FindAbilityByName("bvo_mayuri_skill_1_cast"):SetLevel(1)
      hero:FindAbilityByName("bvo_mayuri_skill_1_cast"):SetHidden(true)

      hero:FindAbilityByName("bvo_mayuri_skill_0"):SetLevel(1)

      --attachZ = 138
        --attachX = -8
        --attachSize = 1.0
    elseif name == "npc_dota_hero_huskar" then
      hero:FindAbilityByName("bvo_law_skill_0"):SetLevel(1)

      --attachZ = 138
        --attachX = -8
        --attachSize = 1.0
    elseif name == "npc_dota_hero_puck" then
      hero:FindAbilityByName("bvo_whitebeard_skill_0"):SetLevel(1)

      --attachZ = 138
        --attachX = -8
        --attachSize = 1.0
    elseif name == "npc_dota_hero_centaur" then
      hero:FindAbilityByName("bvo_aizen_skill_0"):SetLevel(1)

      --attachZ = 138
        --attachX = -8
        --attachSize = 1.0
    elseif name == "npc_dota_hero_templar_assassin" then
      hero:FindAbilityByName("bvo_rory_skill_0"):SetLevel(1)

      --attachZ = 138
        --attachX = -8
        --attachSize = 1.0
    elseif name == "npc_dota_hero_enigma" then
      hero:FindAbilityByName("bvo_ulquiorra_skill_0"):SetLevel(1)

      --attachZ = 138
        --attachX = -8
        --attachSize = 1.0
    elseif name == "npc_dota_hero_pudge" then
      hero:FindAbilityByName("bvo_anzu_skill_0"):SetLevel(1)

      --attachZ = 138
        --attachX = -8
        --attachSize = 1.0
    elseif name == "npc_dota_hero_vengefulspirit" then
      hero:FindAbilityByName("bvo_rem_skill_0"):SetLevel(1)

      --attachZ = 138
        --attachX = -8
        --attachSize = 1.0
    elseif name == "npc_dota_hero_phoenix" then
      hero:FindAbilityByName("bvo_kissshot_skill_0"):SetLevel(1)

      --attachZ = 138
        --attachX = -8
        --attachSize = 1.0
    elseif name == "npc_dota_hero_ursa" then
      hero:FindAbilityByName("bvo_akainu_skill_0"):SetLevel(1)

      --attachZ = 138
        --attachX = -8
        --attachSize = 1.0
    elseif name == "npc_dota_hero_dark_willow" then
      hero:FindAbilityByName("bvo_perona_skill_0"):SetLevel(1)

      --attachZ = 138
        --attachX = -8
        --attachSize = 1.0
    end
  end
end

function attachCosmetic( keys )
  local unit = keys.unit
  local scale = keys.scale
  local pitch = keys.pitch
  local yaw = keys.yaw
  local roll = keys.roll
  local attachPoint = keys.attachPoint
  local offset = keys.offset * scale * unit:GetModelScale()

  local attach = unit:ScriptLookupAttachment(attachPoint)

  local hat = Entities:CreateByClassname("prop_dynamic")
  hat:SetModel(keys.model)
  hat:SetModelScale(scale)

  local angles = unit:GetAttachmentAngles(attach)
  angles = QAngle(angles.x, angles.y, angles.z)
  angles = RotateOrientation( angles, RotationDelta( QAngle(pitch, yaw, roll), QAngle(0,0,0) ) )
  
  local attach_pos = unit:GetAttachmentOrigin(attach)
  attach_pos = attach_pos + RotatePosition(Vector(0,0,0), angles, offset)

  hat:SetAbsOrigin(attach_pos)
  hat:SetAngles(angles.x,angles.y,angles.z)

  hat:SetParent(unit, attachPoint)
end

--recheck position if hero was out of game or something
function Recheck_position(hero)
  if hero:GetAbsOrigin() then
    hero.positions[math.floor(currTime)] = hero:GetAbsOrigin()
  else
    Timers:CreateTimer(1, 
      function()
        Recheck_position(hero) 
    end)
  end
end


--ntropy rewind think function, this is kind of ugly, sometimes heroes disapear, it can cause an error, so if a hero isnt in the game for this moment, we just wait a seocnd and try gaain
function Think()
  local currTime = GameRules:GetGameTime()

  for pID, hero in pairs(GameRules.Heroes) do
    if not hero.positions[math.floor(currTime)] then
      if not hero:IsNull() then
        if hero:GetAbsOrigin() then
          hero.positions[math.floor(currTime)] = hero:GetAbsOrigin()
        else
          Timers:CreateTimer(1, 
            function()
              Recheck_position(hero)  
          end)
        end 
      else
        Timers:CreateTimer(1, 
          function()
            Recheck_position(hero)  
        end)
      end
    end

    for t, pos in pairs(hero.positions) do
      if (currTime-t) > 10 then
        hero.positions[t] = nil
      else -- the rest of the times in the table are <= 4.
        break
      end
    end
  end
end

function split(s, delimiter)
    local result = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

function GiveGoldToTeam(team_table, gold)
  for _, x in pairs(team_table) do
    if x then
      PlayerResource:ModifyGold( x:GetPlayerID(), gold, true, 0)
    end
  end
end

function _G:GiveTeamGold(team_number, gold)
  local team_table = nil
  if team_number == DOTA_TEAM_GOODGUYS then
    team_table = tHeroesRadiant
  elseif team_number == DOTA_TEAM_BADGUYS then
    team_table = tHeroesDire
  end

  if team_table ~= nil then
    for _, x in pairs(team_table) do
      if x then
        PlayerResource:ModifyGold( x:GetPlayerID(), gold, true, 0)
      end
    end
  end
end

function _G:PopupNumbers(target, pfx, color, lifetime, number, presymbol, postsymbol, all)
    local pfxPath = string.format("particles/msg_fx/msg_%s.vpcf", pfx)

    local pidx
    if all then
    pidx = ParticleManager:CreateParticle(pfxPath, PATTACH_ABSORIGIN_FOLLOW, target)
  else
    pidx = ParticleManager:CreateParticleForPlayer(pfxPath, PATTACH_ABSORIGIN_FOLLOW, target, target:GetOwner())
  end

    local digits = 0
    if number ~= nil then
        digits = #tostring(number)
    end
    if presymbol ~= nil then
        digits = digits + 1
    end
    if postsymbol ~= nil then
        digits = digits + 1
    end

    ParticleManager:SetParticleControl(pidx, 1, Vector(tonumber(presymbol), tonumber(number), tonumber(postsymbol)))
    ParticleManager:SetParticleControl(pidx, 2, Vector(lifetime, digits, 0))
    ParticleManager:SetParticleControl(pidx, 3, color)
end

function ApplyCooldownReduction( _, event )
    local player = PlayerResource:GetPlayer(event.PlayerID)
    if player == nil then return end
    local hero = player:GetAssignedHero()

    for _,cdItem in pairs(cd_reduction_items) do
      if hero:HasItemInInventory(cdItem) then
        local ability = hero:FindAbilityByName( event.abilityname )
        --reduction
        local item = CreateItem(cdItem, hero, hero)
      local reduction = item:GetLevelSpecialValueFor("cd_reduction", 0 )
        item:RemoveSelf()
        reduction = reduction / 100
        --item cd
        if ability == nil then
          for i = 0, 5 do
            local item = hero:GetItemInSlot(i)
            if item ~= nil and item:GetName() == event.abilityname then
              ability = item
              if ability:GetCooldownTimeRemaining() > 0 then
                  local cdDefault = ability:GetCooldown( ability:GetLevel() - 1 )
                  local cdReduced = cdDefault * ( 1.0 - reduction )
                  local cdRemaining = ability:GetCooldownTimeRemaining()

                  if cdRemaining > cdReduced then
                      cdRemaining = cdRemaining - cdDefault * reduction
                      ability:StartCooldown( cdRemaining )
                  end
              end
            end
          end
        end
        --skill cd
        if ability ~= nil and ability:GetCooldownTimeRemaining() > 0 then
            local cdDefault = ability:GetCooldown( ability:GetLevel() - 1 )
            local cdReduced = cdDefault * ( 1.0 - reduction )
            local cdRemaining = ability:GetCooldownTimeRemaining()

            if cdRemaining > cdReduced then
                cdRemaining = cdRemaining - cdDefault * reduction
                ability:EndCooldown()
                ability:StartCooldown( cdRemaining )
            end
        end
      end
  end
end
