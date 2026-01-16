/*
    File: KPLIB_config.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2017-10-16
    Last Update: 2023-03-24
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Contains all settings which are meant to be adjustable by players.
*/


/*
------------------------------------------------------------
    --- SIDE SETTINGS ---
    Sides of each faction. In basically any cases this
    doesn't need to be tweaked, even if using e.g. the
    CSAT preset for the players.
------------------------------------------------------------
*/

// Player side.
KPLIB_side_player = WEST;

// Enemy side.
KPLIB_side_enemy = EAST;

// Resistance side.
KPLIB_side_resistance = RESISTANCE;

// Civilian side.
KPLIB_side_civilian = CIVILIAN;

// Player owned sector marker color.
KPLIB_color_player = "ColorBLUFOR";

// Enemy sector marker color.
KPLIB_color_enemy = "ColorOPFOR";

// Enemy sector marker color. (activated)
KPLIB_color_enemyActive = "ColorRED";


/*
------------------------------------------------------------
    --- SAVE SETTINGS ---
    Settings concerning the internal save system.
------------------------------------------------------------
*/

// Name of the save data variable inside of the [ServerProfileName].vars.Arma3Profile file.
KPLIB_save_key = "KP_LIBERATION_" + (toUpperANSI worldName) + "_SAVEGAME";

// Name of the parameter save data variable inside of the [ServerProfileName].vars.Arma3Profile file.
KPLIB_save_paramKey = "KP_LIBERATION_" + (toUpperANSI worldName) + "_SAVE_PARAMS";

// Interval in seconds for automatic save.
KPLIB_save_interval = 60;


/*
------------------------------------------------------------
    --- RANGES AND HEIGHTS ---
    All values in meters.
------------------------------------------------------------
*/

// Build range around the main FOB building.
KPLIB_range_fob = 125;

// Maximum terrain steepness allowed for FOB deployment (0 to 1).
KPLIB_terrainGradient_fob = 0.2; 

// Altitude in metres for the HALO jump.
KPLIB_height_halo = 2500;

// Range to activate a sector.
KPLIB_range_sectorActivation   = 1000;
KPLIB_range_capitalActivation  = 1250;
KPLIB_range_cityActivation     = 1000;
KPLIB_range_factoryActivation  = 750;
KPLIB_range_militaryActivation = 1500;
KPLIB_range_towerActivation    = 500;
KPLIB_range_airSpawnActivation = 1500;
KPLIB_range_pointActivation    = 1000;

// Range to capture a sector.
KPLIB_range_sectorCapture = 175;

// Radio Tower scanning range.
KPLIB_range_radioTowerScan = 2500;

// Military base replenish outposts range.
KPLIB_range_replenishRadius = 2500;

// Minimum distance to next FOB.
KPLIB_distance_fob = 1000;

// Minimum distance to next sector.
KPLIB_distance_sector = KPLIB_range_sectorCapture + KPLIB_range_fob;


/*
------------------------------------------------------------
    --- CAP SETTINGS ---
    Maximum amounts/values for different mechanics.
------------------------------------------------------------
*/

// Cap for BLUFOR.
KPLIB_cap_playerSide = 100;

// Cap for enemy units.
KPLIB_cap_enemySide = 180;

// Cap for enemy battlegroups.
KPLIB_cap_battlegroup = 150;

// Cap for enemy patrols.
KPLIB_cap_patrol = 150;

// Size of enemy battlegroups.
KPLIB_battlegroup_size = 6;

// Cap for civilian vehicles traveling between sectors.
KPLIB_civilians_amount = 10;


/*
------------------------------------------------------------
    --- CIVIL REPUTATION SETTINGS ---
    Values connected to the civil reputation system.
------------------------------------------------------------
*/

// Civil Reputation penalty for killing a civilian.
KPLIB_cr_kill_penalty = 5;

// Civil Reputation penalty for destroying/damaging a building.
KPLIB_cr_building_penalty = 3;

// Civil Reputation penalty for stealing a civilian vehicle.
KPLIB_cr_vehicle_penalty = 2;

// Civil Reputation penalty for killing a friendly resistance soldier.
KPLIB_cr_resistance_penalty = 3;

// Civil Reputation gain for liberate a sector.
KPLIB_cr_sector_gain = 5;

// Chance (0-100) that there are wounded civilians right after capturing a sector.
KPLIB_cr_wounded_chance = 35;

// Civil Reputation gain for providing medical assistance for wounded civilians.
KPLIB_cr_wounded_gain = 2;


/*
------------------------------------------------------------
    --- SECONDARY MISSION SETTINGS ---
    Settings which are connected to the available
    secondary missions which can be started by players
    via the secondary mission dialog or happen
    randomly.
------------------------------------------------------------
*/

// Intel price for the secondary missions. [FOB hunting, Convoy ambush, SAR, CIV, FUEL, REARM]
KPLIB_secondary_missions_costs = [15, 10, 8, 8, 8, 8];

// Proportionate reduction of the actual (!) enemy combat readiness for a successful FOB hunt. (e.g. 0.4 -> reduction of 24 by an actual value of 60)
KPLIB_secondary_objective_impact = 0.4;

// The percentage increase received when completing a Humanitarian Aid secondary objective
KPLIB_secondary_objective_civ_supplies_impact = 10;

// Minimum time until a civil Informant can spawn. (seconds, default 30 min)
KPLIB_civinfo_min = 1800;

// Maximum time until a civil Informant spawns. (seconds, default 60 min)
KPLIB_civinfo_max = 3600;

// Civil Informant spawn chance. (0-100)
KPLIB_civinfo_chance = 75;

// Intel gain for talking to a civil informant.
KPLIB_civinfo_intel = 10;

// Time until a civil informant will despawn after spawning. (seconds, default 30 min)
KPLIB_civinfo_duration = 1800;

// Chance (0-100) that the delivered informant will spawn a time critical task
KPLIB_civinfo_task_chance = 35;

// Time until the task will despawn if no player is near. (seconds, default 30 min)
KPLIB_civinfo_task_duration = 1800;


/*
------------------------------------------------------------
    --- FUEL CONSUMPTION SETTINGS ---
    Values for the KP Fuel Consumption Script.
------------------------------------------------------------
*/

// Time in minutes till a full tank depletes whilst the vehicle is standing still with a running engine.
KPLIB_fuel_neutral = 180;

// Time in minutes till a full tank depletes whilst the vehicle is driving below max speed.
KPLIB_fuel_normal = 90;

// Time in minutes till a full tank depletes whilst the vehicle is driving at max speed.
KPLIB_fuel_max = 45;


/*
------------------------------------------------------------
    --- RESISTANCE SETTINGS ---
    Values connected to the resistance faction.
------------------------------------------------------------
*/

// Chance (0-100) that a logistic convoy will be ambushed, when civil reputation is low. (Checked every minute)
KPLIB_convoy_ambush_chance = 2;

// Duration of the convoy ambush event until nothing can be retrieved. (seconds)
KPLIB_convoy_ambush_duration = 1200;

// Resistance strength (0-100) needed for tier 2 equipment.
KPLIB_resistance_tier2 = 30;

// Resistance strength (0-100) needed for tier 3 equipment.
KPLIB_resistance_tier3 = 70;

// Chance (0-100) that a resistance unit has a RPG. (tier 2 and 3)
KPLIB_resistance_at_chance = 20;

// Chance (0-100) that a resistance squad will join an ongoing sector attack.
KPLIB_resistance_sector_chance = 35;

// Chance that some resistance units will spawn in blufor sectors for an ambush, if reputation is low.
KPLIB_resistance_ambush_chance = 25;


/*
------------------------------------------------------------
    --- MISC SETTINGS ---
    Values or arrays of misc mechanics.
------------------------------------------------------------
*/

// Time in minutes until a resource crate is produced, when resources multiplier is set to 1.
KPLIB_production_interval = 60;

// Percentage of resources you get back from recycling.
KPLIB_recycling_percentage = 0.5;

// Multiplier for defenders in buildings.
KPLIB_defended_buildingpos_part = 0.4;

// Time in seconds how long a captured sector is vulnerable to enemy troops.
KPLIB_vulnerability_timer = 1200;

// Chance that enemy infantry will surrender after heavy losses are encountered.
KPLIB_surrender_chance = 80;

// When playing on this map, it'll create a clearance (remove terrain objects) in a 15m radius around the battlegroup/reinforcements spawnpoint.
KPLIB_battlegroup_clearance = [
    "song_bin_tanh",
    "khe_sanh",
    "lingor3",
    "Cam_Lao_Nam"
];

// Delay after death for wrecks and corpses to be deleted
KPLIB_cleanup_delay = 1200;

// Automatic refill magazines on redeploy and load arsenal. true means fill.
KPLIB_fill_mags = false;

// Radius from object to find the nearest sector (Ideally keep this value below 400)
KPLIB_sectorObject_radius = 350;

// Building time coeficient (building size dependent)
KPLIB_doBuildCoef = 1.1;

// Potato respawn delay
KPLIB_potatoRespawnDelay = 300;

// Start base vehicles (boats and little bird)
KPLIB_startVehRespawnDelay = 300;