-- In this file you can set up all the properties and settings for your game mode.


ENABLE_HERO_RESPAWN = true              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = true             -- Should the main shop contain Secret Shop items as well as regular items
ALLOW_SAME_HERO_SELECTION = true        -- Should we let people select the same hero as each other

HERO_SELECTION_TIME = 70.0              -- How long should we let people select their hero?
PRE_GAME_TIME = 10.0                    -- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60.0                   -- How long should we let people look at the scoreboard before closing the server automatically?
TREE_REGROW_TIME = 60.0                 -- How long should it take individual trees to respawn after being cut down/destroyed?

GOLD_PER_TICK = 1.5                     -- How much gold should players get per tick?
GOLD_TICK_TIME = 0.66                      -- How long should we wait in seconds between gold ticks?

RECOMMENDED_BUILDS_DISABLED = true     -- Should we disable the recommened builds for heroes
CAMERA_DISTANCE_OVERRIDE = -1           -- How far out should we allow the camera to go?  Use -1 for the default (1134) while still allowing for panorama camera distance changes

MINIMAP_ICON_SIZE = 1                   -- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1             -- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1              -- What icon size should we use for runes?

RUNE_SPAWN_TIME = 120                   -- How long in seconds should we wait between rune spawns?
CUSTOM_BUYBACK_COST_ENABLED = false      -- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = false  -- Should we use a custom buyback time?
BUYBACK_ENABLED = true                 -- Should we allow people to buyback when they die?

DISABLE_FOG_OF_WAR_ENTIRELY = false     -- Should we disable fog of war entirely for both teams?
USE_UNSEEN_FOG_OF_WAR = false           -- Should we make unseen and fogged areas of the map completely black until uncovered by each team? 
                                            -- Note: DISABLE_FOG_OF_WAR_ENTIRELY must be false for USE_UNSEEN_FOG_OF_WAR to work
USE_STANDARD_DOTA_BOT_THINKING = false  -- Should we have bots act like they would in Dota? (This requires 3 lanes, normal items, etc)
USE_STANDARD_HERO_GOLD_BOUNTY = true    -- Should we give gold for hero kills the same as in Dota, or allow those values to be changed?

USE_CUSTOM_TOP_BAR_VALUES = true        -- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true                  -- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = true             -- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = false-- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = false       -- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false             -- Should we disable the gold sound when players get gold?

END_GAME_ON_KILLS = true                -- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = 50         -- How many kills for a team should signify an end of game?

USE_CUSTOM_HERO_LEVELS = true           -- Should we allow heroes to have custom levels?
MAX_LEVEL = 50                          -- What level should we let heroes get to?
USE_CUSTOM_XP_VALUES = true             -- Should we use custom XP values to level up heroes, or the default Dota numbers?

-- Fill this table up with the required XP per level if you want to change it
XP_PER_LEVEL_TABLE = {
	0,
	240,
	600,
	1080,
	1680,
	2300,
	2940,
	3600,
	4280,
	5080,
	5900,
	6740,
	7640,
	8865,
	10115,
	11390,
	12690,
	14015,
	15415,
	16905,
	18405,
	20155,
	22155,
	24405,
	26905
}

ENABLE_FIRST_BLOOD = true               -- Should we enable first blood for the first kill in this game?
HIDE_KILL_BANNERS = false               -- Should we hide the kill banners that show when a player is killed?
LOSE_GOLD_ON_DEATH = true               -- Should we have players lose the normal amount of dota gold on death?
SHOW_ONLY_PLAYER_INVENTORY = false      -- Should we only allow players to see their own inventory even when selecting other units?
DISABLE_STASH_PURCHASING = false        -- Should we prevent players from being able to buy items into their stash when not at a shop?
DISABLE_ANNOUNCER = false               -- Should we disable the announcer from working in the game?
FORCE_PICKED_HERO = nil                 -- What hero should we force all players to spawn as? (e.g. "npc_dota_hero_axe").  Use nil to allow players to pick their own hero.

FIXED_RESPAWN_TIME = -1                 -- What time should we use for a fixed respawn timer?  Use -1 to keep the default dota behavior.
FOUNTAIN_CONSTANT_MANA_REGEN = -1       -- What should we use for the constant fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_MANA_REGEN = -1     -- What should we use for the percentage fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_HEALTH_REGEN = -1   -- What should we use for the percentage fountain health regen?  Use -1 to keep the default dota behavior.
MAXIMUM_ATTACK_SPEED = 600              -- What should we use for the maximum attack speed?
MINIMUM_ATTACK_SPEED = 20               -- What should we use for the minimum attack speed?

GAME_END_DELAY = -1                     -- How long should we wait after the game winner is set to display the victory banner and End Screen?  Use -1 to keep the default (about 10 seconds)
VICTORY_MESSAGE_DURATION = 3            -- How long should we wait after the victory message displays to show the End Screen?  Use 
STARTING_GOLD = 500                     -- How much starting gold should we give to each player?
DISABLE_DAY_NIGHT_CYCLE = false         -- Should we disable the day night cycle from naturally occurring? (Manual adjustment still possible)
DISABLE_KILLING_SPREE_ANNOUNCER = false -- Shuold we disable the killing spree announcer?
DISABLE_STICKY_ITEM = false             -- Should we disable the sticky item button in the quick buy area?
SKIP_TEAM_SETUP = false                 -- Should we skip the team setup entirely?
ENABLE_AUTO_LAUNCH = true               -- Should we automatically have the game complete team setup after AUTO_LAUNCH_DELAY seconds?
AUTO_LAUNCH_DELAY = 30                  -- How long should the default team selection launch timer be?  The default for custom games is 30.  Setting to 0 will skip team selection.
LOCK_TEAM_SETUP = false                 -- Should we lock the teams initially?  Note that the host can still unlock the teams 


-- NOTE: You always need at least 2 non-bounty type runes to be able to spawn or your game will crash!
ENABLED_RUNES = {}                      -- Which runes should be enabled to spawn in our game mode?
ENABLED_RUNES[DOTA_RUNE_DOUBLEDAMAGE] = true
ENABLED_RUNES[DOTA_RUNE_HASTE] = true
ENABLED_RUNES[DOTA_RUNE_ILLUSION] = true
ENABLED_RUNES[DOTA_RUNE_INVISIBILITY] = true
ENABLED_RUNES[DOTA_RUNE_REGENERATION] = true
ENABLED_RUNES[DOTA_RUNE_BOUNTY] = true
ENABLED_RUNES[DOTA_RUNE_ARCANE] = true


USE_CUSTOM_TEAM_COLORS = true           -- Should we use custom team colors?
USE_CUSTOM_TEAM_COLORS_FOR_PLAYERS = true          -- Should we use custom team colors to color the players/minimap?

TEAM_COLORS = {}                        -- If USE_CUSTOM_TEAM_COLORS is set, use these colors.
TEAM_COLORS[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }  --    Teal
TEAM_COLORS[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }   --    Yellow
TEAM_COLORS[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }  --    Pink
TEAM_COLORS[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }   --    Orange
TEAM_COLORS[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }   --    Blue
TEAM_COLORS[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }  --    Green
TEAM_COLORS[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }   --    Brown
TEAM_COLORS[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }  --    Cyan
TEAM_COLORS[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }  --    Olive
TEAM_COLORS[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }  --    Purple


USE_AUTOMATIC_PLAYERS_PER_TEAM = true   -- Should we set the number of players to 10 / MAX_NUMBER_OF_TEAMS?
MAX_NUMBER_OF_TEAMS = 2

CUSTOM_TEAM_PLAYER_COUNT = {}           -- If we're not automatically setting the number of players per team, use this table
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_1] = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_2] = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_3] = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_4] = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_5] = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_6] = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_7] = 1
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_8] = 1

GameRules.PREDATOR_COLOURED_NAMES = {}
GameRules.PREDATOR_COLOURED_NAMES["npc_dota_hero_viper"] = "<font color='#FF8C00'>Hunter</font>"
GameRules.PREDATOR_COLOURED_NAMES["npc_dota_hero_oracle"] = "<font color='#3CB371'>Sage</font>"
GameRules.PREDATOR_COLOURED_NAMES["npc_dota_hero_tinker"] = "<font color='#C0C0C0'>Machinist</font>"
GameRules.PREDATOR_COLOURED_NAMES["npc_dota_hero_tiny"] = "<font color='#5000DC'>Vampire</font>"
GameRules.PREDATOR_COLOURED_NAMES["npc_dota_hero_venomancer"] = "<font color='#1E90FF'>Lich</font>"
GameRules.PREDATOR_COLOURED_NAMES["npc_dota_hero_tidehunter"] = "<font color='#FF4500'>Berserker</font>"
GameRules.PREDATOR_COLOURED_NAMES["npc_dota_hero_weaver"] = "<font color='#B22222'>Demon</font>"
GameRules.PREDATOR_COLOURED_NAMES["npc_dota_hero_witch_doctor"] = "<font color='#DAB24D'>Assassin</font>"
GameRules.PREDATOR_COLOURED_NAMES["npc_dota_hero_brewmaster"] = "<font color='#DEB887'>Brawler</font>"
GameRules.PREDATOR_COLOURED_NAMES["npc_dota_hero_medusa"] = "<font color='#98FB98'>Gorgon</font>"
GameRules.PREDATOR_COLOURED_NAMES["npc_dota_hero_rubick"] = "<font color='#DCDCDC'>J</font><font color='#C0C0C0'>o</font><font color='#A9A9A9'>k</font><font color='#808080'>e</font><font color='#696969'>r</font>"

GameRules.COLOURED_NAMES = {}

GameRules.CURRENT_PLAYERS = {}

GameRules.PLAYER_ID_TO_HERO = {}

GameRules.PLAYER_ID_TO_TEAM = {}

GameRules.PLAYER_COLOR_BY_ID = {
        [0] = "#3375FF",
        [1] = "#66FFBF",
        [2] = "#BF00BF",
        [3] = "#F3F00B",
        [4] = "#FF6B00",
        [5] = "#FE86C2",
        [6] = "#A1B447",
        [7] = "#65D9F7",
        [8] = "#008321",
        [9] = "#A46900"
}

GameRules.RGB_PLAYER_COLORS = {}
GameRules.RGB_PLAYER_COLORS[0] = { 51, 117, 255 }  
GameRules.RGB_PLAYER_COLORS[1]  = { 102, 255, 191 }    
GameRules.RGB_PLAYER_COLORS[2] = { 191, 0, 191 }   
GameRules.RGB_PLAYER_COLORS[3] = { 243, 240, 11 }      
GameRules.RGB_PLAYER_COLORS[4] = { 255, 107, 0 }    
GameRules.RGB_PLAYER_COLORS[5] = { 254, 134, 194 }    
GameRules.RGB_PLAYER_COLORS[6] = { 161, 180, 71 }  
GameRules.RGB_PLAYER_COLORS[7] = { 101, 217, 247 }
GameRules.RGB_PLAYER_COLORS[8] = { 0, 131, 33 }
GameRules.RGB_PLAYER_COLORS[9] = { 164, 105, 0 } 


GameRules.UNIQUE_SPELLS = {
	[1] = "wind_walk",
	[2] = "mana_burn",
	[3] = "healing_wave",
	[4] = "jump",
	[5] = "spirit_swap",
	[6] = "war_stomp",
	[7] = "ultimate_tree_defense",
	[8] = "lightning_burst",
	[9] = "blessing_of_nature",
	[10] = "refresh",
	[11] = "cloning",
	[12] = "dragon_escort"
}