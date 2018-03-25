-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')
require('precache')
require('constants')
require('lib/teleport')

function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]

  DebugPrint("[BAREBONES] Performing pre-load precache")
  PrecacheModel("models/goofygood6/goofygood6.vmdl", context)
  PrecacheItemByNameSync( "item_bag_of_gold", context )
  PrecacheItemByNameSync( "item_bag_of_gold_goofy", context )

  PrecacheResource("soundfile", "soundevents/game_sounds_custom.vsndevts", context)

  PrecacheResource( "particle", "particles/newplayer_fx/npx_landslide_debris.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_base_attack.vpcf", context )
  PrecacheResource( "particle", "particles/econ/items/puck/puck_alliance_set/puck_base_attack_aproset.vpcf", context )
  PrecacheResource( "particle", "particles/units/heroes/hero_skywrath_mage/skywrath_mage_base_attack.vpcf", context )
  PrecacheResource( "particle", "particles/custom_particles/goku/goku_spiritbomb.vpcf", context )
  PrecacheResource( "particle", "particles/custom_particles/goku/goku_kamehameha_cast.vpcf", context )
  PrecacheModel( "npc_dota_hero_pugna", context )
  PrecacheModel( "npc_dota_hero_omniknight", context )
  PrecacheModel( "npc_dota_hero_rattletrap", context )
  PrecacheModel( "npc_dota_hero_razor", context )
  PrecacheModel( "npc_dota_hero_sand_king", context )
  PrecacheModel( "npc_dota_hero_shadow_shaman", context )
  PrecacheModel( "npc_dota_hero_storm_spirit", context )

  --BLEACH VS ONCE PIECE STUFF
  for k, v in pairs( model_lookup ) do
    PrecacheModel( v, context )
    PrecacheUnitByNameSync(k, context)
  end
  for k, v in pairs( particle_precache ) do
    PrecacheResource( "particle", v, context )
  end
  for k, v in pairs( soundfile_precache ) do
    PrecacheResource( "soundfile", v, context )
  end
  for k, v in pairs( model_precache ) do
    PrecacheResource( "model", v, context )
  end
end

-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:_InitGameMode()
end