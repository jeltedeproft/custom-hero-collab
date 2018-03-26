--[[
Usage:

You firstly need to include the module like so:

local statCollection = require('lib.statcollection')

You need to call:

statCollection:init({
    modIdentifier = 'XXXXXXXXXXXXXXXXXXX'
})

In the Activate() function of your gamemode in order for stat tracking to take place.

Everything else will be automatically handled by the module.

If you'd like to store flags, for example, the amount of kills to win, it can be done like so:

statCollection:setFlags({FlagName = 'FlagValue'})

Customising the stats beyond this will require talking to the GetDotaStats staff so a custom schema can be built for you.
Extended functionality will be added as it is needed.

Come bug us in our IRC channel or get in contact via the site chatbox. http://getdotastats.com/#contact
]]

-- Require libs
local libpath = (...):match('(.-)[^%.]+$')
local md5 = require(libpath .. 'md5')

-- Where stuff is posted to
local postLocation = 'http://getdotastats.com/s2/api/'

-- The schema version we are currently using
local schemaVersion = 1

-- Constants used for pretty formatting, as well as strings
local printPrefix = 'Stat Collection: '

local errorFailedToContactServer = 'Failed to contact the master server! Bad status code, or no body!'
local errorMissingOrIncorrectModIdentifier = 'Please ensure you call statCollection:init with a valid modIdentifier!'
local errorInitCalledTwice = 'Please ensure you only make a single call to statCollection:init, only the first call actually works.'
local errorJsonDecode = 'There was an issue decoding the JSON returned from the server, see below:'
local errorSomethingWentWrong = 'The server said something went wrong, see below:'
local errorRunInit = 'You need to call the init function before you can send stats!'
local errorFlags = 'Flags needs to be a table!'
local errorBadSchema = 'This schema doesn\'t exist!!'

local messageStarting = 'GetDotaStats module is trying to init...'
local messagePhase1Starting = 'Attempting to reqisted the match with GetDotaStats...'
local messagePhase2Starting = 'Attempting to send pregame stats...'
local messagePhase3Starting = 'Attempting to send final stats...'
local messageCustomStarting = 'Attempting to send custom stats...'
local messagePhase1Complete = 'Match was successfully registered with GetDotaStats!'
local messagePhase2Complete = 'Match pregame settings have been recorded!'
local messagePhase3Complete = 'Match stats were successfully recorded!'
local messageCustomComplete = 'Match custom stats were successfully recorded!'

-- Store the first detected steamID
local firstConnectedSteamID = -1
ListenToGameEvent('player_connect', function(keys)
-- Grab their steamID
    local steamID64 = tostring(keys.xuid)
    local steamIDPart = tonumber(steamID64:sub(4))
    if not steamIDPart then return end
    local steamID = tostring(steamIDPart - 61197960265728)

    -- Store it
    firstConnectedSteamID = steamID
end, nil)

-- Create the stat collection class
local statCollection = class({})

-- Function that will setup stat collection
function statCollection:init(options)
    -- Only allow init to be run once
    if self.doneInit then
        print(printPrefix .. errorInitCalledTwice)
        return
    end
    self.doneInit = true

    -- Print the intro message
    print(printPrefix .. messageStarting)

    -- Check for a modIdentifier
    if not options or not options.modIdentifier or options.modIdentifier == 'XXXXXXXXXXXXXXXXXXX' then
        -- Tell the user they have done it all wrong!
        print(printPrefix .. errorMissingOrIncorrectModIdentifier)
        self.doneInit = false
        return
    end
    if options.customSchema then
        local status, err = pcall(function()
            -- Load the module
            self.custom = require("statcollection." .. options.customSchema)
            self.custom:init({statCollection = self})
        end)

        if not status then
            -- Tell the user about it
            print(printPrefix .. errorBadSchema)
            print(err)
            self.doneInit = false --Make sure this wont work
            return 
        end
    else
        print(printPrefix .. errorBadSchema)
        self.doneInit = false --Make sure this wont work
        return
    end
    -- Store the modIdentifier
    self.modIdentifier = options.modIdentifier

    -- Reset our flags store
    self.flags = {}

    -- Set the default winner to -1 (no winner)
    self.winner = -1
    
    --Store roundID globally
    self.roundID = 0
    
    -- Hook requred functions to operate correctly
    self:hookFunctions()

    -- Send stage1 stuff
    self:sendStage1()
end
--Utility function to prevent code repitition
function statCollection:calcWinnersByTeam()
    output = {}
    for i = 1, (PlayerResource:GetPlayerCount() or 1) do
        output[PlayerResource:GetSteamAccountID(i - 1)] = (function() if PlayerResource:GetTeam(i - i) == self.winner then return '1' else return '0' end end)()
    end
    return output
end
-- Hooks functions to make things actually work
function statCollection:hookFunctions()
    local this = self

    -- Hook winner function
    if self.custom.GAME_WINNER then
        local oldSetGameWinner = GameRules.SetGameWinner
        GameRules.SetGameWinner = function(gameRules, team)
        -- Store the stats
            this.winner = team

            -- Run the rael setGameWinner function
            oldSetGameWinner(gameRules, team)

            -- Attempt to send stage 3, since the match is over
            this:sendStage3(this:calcWinnersByTeam(), true)
        end
    end

    -- Listen for changes in the current state
    ListenToGameEvent('game_rules_state_change', function(keys)
    -- Grab the current state
        local state = GameRules:State_Get()

        if state >= DOTA_GAMERULES_STATE_PRE_GAME then
            -- Send pregame stats
            this:sendStage2()
        end
        if self.custom.ANCIENT_EXPLOSION then
            if state >= DOTA_GAMERULES_STATE_POST_GAME then
                -- Send postgame stats
                self:findWinnerUsingForts()
                this:sendStage3(this:calcWinnersByTeam(), true)
            end
        end
        
    end, nil)
end

-- This function will attempt to detect the winner using forts, if winner is currently -1
function statCollection:findWinnerUsingForts()
    -- Check if we have found no winner yet
    if self.winner == -1 then
        local winners = 0

        local forts = Entities:FindAllByClassname('npc_dota_fort')
        for k, v in pairs(forts) do
            -- Check it's HP level
            if v:GetHealth() > 0 then
                local team = v:GetTeam()

                if winners == 0 then
                    winners = team
                else
                    winners = -1
                end
            end
        end

        if winners == 0 then
            winners = -1
        end

        -- Return our estimate
        self.winner = winners
    end
end

-- Sets a flag
function statCollection:setFlags(flags)
    if type(flags) == "table" then
        -- Store the new flags
        self.flags = flags
    else
        -- Yell at the developer
        print(printPrefix .. errorFlags)
    end
end

-- Sends stage1
function statCollection:sendStage1()
    -- If we are missing required parameters, then don't send
    if not self.doneInit then
        print(printPrefix .. errorRunInit)
        return
    end

    -- Ensure we can only send it once, and everything is good to go
    if self.sentStage1 then return end
    self.sentStage1 = true

    -- Print the intro message
    print(printPrefix .. messagePhase1Starting)

    -- Grab a reference to self
    local this = self

    -- Workout the player count
    local playerCount = PlayerResource:GetPlayerCount()
    if playerCount <= 0 then playerCount = 1 end

    -- Workout who is hosting
    local hostSteamID = PlayerResource:GetSteamAccountID(0)
    if hostSteamID == 0 then
        if firstConnectedSteamID ~= -1 then
            hostSteamID = firstConnectedSteamID
        else
            hostSteamID = -1
        end
    end

    -- Workout if the server is dedicated or not
    local isDedicated = (IsDedicatedServer() and 1) or 0

    -- Grab the mapname
    local mapName = GetMapName()

    -- Build the payload
    local payload = {
        modIdentifier = self.modIdentifier,
        hostSteamID32 = tostring(hostSteamID),
        isDedicated = isDedicated,
        mapName = mapName,
        numPlayers = playerCount,
        schemaVersion = schemaVersion
    }

    -- Begin the initial request
    self:sendStage('s2_phase_1.php', payload, function(err, res)
    -- Check if we got an error
        if err then
            print(printPrefix .. errorJsonDecode)
            print(printPrefix .. err)
            return
        end

        -- Check for an error
        if res.error then
            print(printPrefix .. errorSomethingWentWrong)
            print(res.error)
            return
        end

        -- Woot, store our vars
        this.authKey = res.authKey
        this.matchID = res.matchID

        -- Tell the user
        print(printPrefix .. messagePhase1Complete)
    end)
end

-- Sends stage2
function statCollection:sendStage2()
    -- If we are missing required parameters, then don't send
    if not self.doneInit or not self.authKey or not self.matchID then
        print(printPrefix .. errorRunInit)
        return
    end

    -- Ensure we can only send it once, and everything is good to go
    if self.sentStage2 then return end
    self.sentStage2 = true

    -- Print the intro message
    print(printPrefix .. messagePhase2Starting)

    -- Build players array
    local players = {}
    for i = 1, (PlayerResource:GetPlayerCount() or 1) do
        table.insert(players, {
            playerName = PlayerResource:GetPlayerName(i - 1),
            steamID32 = PlayerResource:GetSteamAccountID(i - 1),
            connectionState = PlayerResource:GetConnectionState(i - 1)
        })
    end

    local payload = {
        authKey = self.authKey,
        matchID = self.matchID,
        modIdentifier = self.modIdentifier,
        flags = self.flags,
        schemaVersion = schemaVersion,
        players = players
    }

    -- Send stage2
    self:sendStage('s2_phase_2.php', payload, function(err, res)
    -- Check if we got an error
        if err then
            print(printPrefix .. errorJsonDecode)
            print(printPrefix .. err)
            return
        end

        -- Check for an error
        if res.error then
            print(printPrefix .. errorSomethingWentWrong)
            print(res.error)
            return
        end

        -- Tell the user
        print(printPrefix .. messagePhase2Complete)
    end)
end

-- Sends stage3 (TODO: Redo this for round support)
function statCollection:sendStage3(winners, lastRound)
    -- If we are missing required parameters, then don't send
    if not self.doneInit or not self.authKey or not self.matchID then
        print(printPrefix .. errorRunInit)
        return
    end

    -- Ensure we can only send it once, and everything is good to go
    if self.custom.HAS_ROUNDS  == false then
        if self.sentStage3 then return end
        self.sentStage3 = true
    end

    -- Print the intro message
    print(printPrefix .. messagePhase3Starting)

    -- Build players array
    local players = {}
    for i = 1, (PlayerResource:GetPlayerCount() or 1) do
        table.insert(players, {
            steamID32 = PlayerResource:GetSteamAccountID(i - 1),
            connectionState = PlayerResource:GetConnectionState(i - 1),
            isWinner = winners[PlayerResource:GetSteamAccountID(i - 1)]
        })
    end

    -- Build rounds table
    rounds = {}
    rounds[tostring(self.roundID)] = {
        players=players
    }
    self.roundID = self.roundID + 1
    local payload = {
        authKey = self.authKey,
        matchID = self.matchID,
        modIdentifier = self.modIdentifier,
        schemaVersion = schemaVersion,
        rounds = rounds,
        gameDuration = GameRules:GetGameTime()
    }
    if lastRound == false then
        payload.gameFinished = 0
    end

    -- Send stage3
    self:sendStage('s2_phase_3.php', payload, function(err, res)
    -- Check if we got an error
        if err then
            print(printPrefix .. errorJsonDecode)
            print(printPrefix .. err)
            return
        end

        -- Check for an error
        if res.error then
            print(printPrefix .. errorSomethingWentWrong)
            print(res.error)
            return
        end

        -- Tell the user
        print(printPrefix .. messagePhase3Complete)
    end)
end
function statCollection:submitRound(args)
    --We receive the winners from the custom schema, lets tell phase 3 about it!
    returnArgs = self.custom:submitRound(args)
    self:sendStage3(returnArgs.winners, returnArgs.lastRound) 
end
-- Sends custom
function statCollection:sendCustom(args)
    local game = args.game or {} --Some custom gamemodes might not want this (ie, use player info only)
    local players = args.players or {} --Some custom gamemodes might not want this (ie, use game info only)
    if game == {} and players == {} then
        return --We have no info to actually send, truck it!
    end
    -- If we are missing required parameters, then don't send
    if not self.doneInit or not self.authKey or not self.matchID or not self.custom.SCHEMA_KEY then
        print(printPrefix .. errorRunInit)
        return
    end

    -- Ensure we can only send it once, and everything is good to go
    if self.custom.HAS_ROUNDS  == false then
        if self.sentCustom then return end
        self.sentCustom = true
    end
    
    -- Print the intro message
    print(printPrefix .. messageCustomStarting)

    -- Build rounds table
    -- Build rounds table
    rounds = {}
    rounds[tostring(self.roundID)] = {
        game = game,
        players=players
    }

    local payload = {
        authKey = self.authKey,
        matchID = self.matchID,
        modIdentifier = self.modIdentifier,
        schemaAuthKey = self.custom.SCHEMA_KEY,
        schemaVersion = schemaVersion,
        rounds = rounds
    }

    -- Send custom
    self:sendStage('s2_custom.php', payload, function(err, res)
    -- Check if we got an error
        if err then
            print(printPrefix .. errorJsonDecode)
            print(printPrefix .. err)
            return
        end

        -- Check for an error
        if res.error then
            print(printPrefix .. errorSomethingWentWrong)
            print(res.error)
            return
        end

        -- Tell the user
        print(printPrefix .. messageCustomComplete)
    end)
end

-- Sends the payload data for the given stage, and return the result
function statCollection:sendStage(stageName, payload, callback)
    -- Create the request
    local req = CreateHTTPRequestScriptVM('POST', postLocation .. stageName)
    -- Add the data
    req:SetHTTPRequestGetOrPostParameter('payload', json.encode(payload))

    -- Send the request
    req:Send(function(res)
        if res.StatusCode ~= 200 or not res.Body then
            print(printPrefix .. errorFailedToContactServer)
            return
        end

        -- Try to decode the result
        local obj, pos, err = json.decode(res.Body, 1, nil)

        -- Feed the result into our callback
        callback(err, obj)
    end)
end

-- Return our export
return statCollection