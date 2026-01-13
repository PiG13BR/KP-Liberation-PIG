// AI
add_civ_waypoints = compile preprocessFileLineNumbers "Scripts\Server\ai\add_civ_waypoints.sqf";
add_defense_waypoints = compile preprocessFileLineNumbers "Scripts\Server\ai\add_defense_waypoints.sqf";
building_defence_ai = compile preprocessFileLineNumbers "Scripts\Server\ai\building_defence_ai.sqf";
patrol_ai = compile preprocessFileLineNumbers "Scripts\Server\ai\patrol_ai.sqf";
prisonner_ai = compile preprocessFileLineNumbers "Scripts\Server\ai\prisonner_ai.sqf";

// Game
check_victory_conditions = compile preprocessFileLineNumbers "Scripts\Server\game\check_victory_conditions.sqf";

// Patrol
manage_one_civilian_patrol = compile preprocessFileLineNumbers "Scripts\Server\patrols\manage_one_civilian_patrol.sqf";
reinforcements_manager = compile preprocessFileLineNumbers "Scripts\Server\patrols\reinforcements_manager.sqf";

// Secondary objectives
fob_hunting = compile preprocessFileLineNumbers "Scripts\Server\secondary\fob_hunting.sqf";
convoy_hijack = compile preprocessFileLineNumbers "Scripts\Server\secondary\convoy_hijack.sqf";
search_and_rescue = compile preprocessFileLineNumbers "Scripts\Server\secondary\search_and_rescue.sqf";
civ_supplies = compile preprocessFileLineNumbers "Scripts\Server\secondary\civ_supplies.sqf";
bingo_fuel = compile preprocessFileLineNumbers "Scripts\Server\secondary\bingo_fuel.sqf";
rearm_outpost = compile preprocessFileLineNumbers "Scripts\Server\secondary\rearm_outpost.sqf";

// Sector
attack_in_progress_fob = compile preprocessFileLineNumbers "Scripts\Server\sector\attack_in_progress_fob.sqf";
attack_in_progress_sector = compile preprocessFileLineNumbers "Scripts\Server\sector\attack_in_progress_sector.sqf";
ied_manager = compile preprocessFileLineNumbers "Scripts\Server\sector\ied_manager.sqf";

// Globals
KPLIB_sectors_active = []; publicVariable "KPLIB_sectors_active";

execVM "Scripts\Server\base\startgame.sqf";
execVM "Scripts\Server\base\huron_manager.sqf";
execVM "Scripts\Server\base\startvehicle_spawn.sqf";
[] call KPLIB_fnc_createSuppModules;
execVM "Scripts\Server\battlegroup\counter_battlegroup.sqf";
execVM "Scripts\Server\battlegroup\random_battlegroups.sqf";
execVM "Scripts\Server\battlegroup\readiness_increase.sqf";
execVM "Scripts\Server\game\apply_default_permissions.sqf";
execVM "Scripts\Server\game\cleanup_vehicles.sqf";
if (!KPLIB_param_vanillaFog) then {execVM "Scripts\Server\game\fucking_set_fog.sqf";};
execVM "Scripts\Server\game\manage_time.sqf";
execVM "Scripts\Server\game\manage_weather.sqf";
execVM "Scripts\Server\game\playtime.sqf";
execVM "Scripts\Server\game\spawn_radio_towers.sqf";
execVM "Scripts\Server\game\synchronise_vars.sqf";
[] call KPLIB_fnc_setFactoryFacility;
execVM "Scripts\Server\game\zeus_synchro.sqf";
execVM "Scripts\Server\offloading\show_fps.sqf";
execVM "Scripts\Server\patrols\civilian_patrols.sqf";
execVM "Scripts\Server\patrols\reinforcements_resetter.sqf";
if (KPLIB_param_logistic) then {execVM "Scripts\Server\resources\manage_logistics.sqf";};
[] call KPLIB_fnc_factoryProductionInit;
[] call KPLIB_fnc_recalculateResourcesInit;
[] call KPLIB_fnc_recalculateResourcesPFH;
execVM "Scripts\Server\resources\unit_cap.sqf";
execVM "Scripts\Server\sector\lose_sectors.sqf";

KPLIB_fsm_sectorMonitor = [] call KPLIB_fnc_sectorMonitor;
if (KPLIB_param_highCommand) then {KPLIB_fsm_highcommand = [] call KPLIB_fnc_highcommand;};

// Select FOB templates
[] call compile preprocessFileLineNumbers "Presets\Secondary\Fob_Hunting\init_templates.sqf";

// Civil Reputation
execVM "Scripts\Server\civrep\init_module.sqf";

// Civil Informant
execVM "Scripts\Server\civinformant\init_module.sqf";

// Asymmetric Threats
execVM "Scripts\Server\asymmetric\init_module.sqf";

// Groupcheck for deletion when empty
execVM "Scripts\Server\offloading\group_diag.sqf";

{
    if ((_x != player) && (_x distance (markerPos KPLIB_respawn_marker) < 200 )) then {
        if (isNull objectParent _x) then {deleteVehicle _x} else {(objectParent _x) deleteVehicleCrew _x};
    };
} forEach allUnits;

// Server Restart Script from K4s0
if (KPLIB_param_restart > 0) then {
    execVM "Scripts\Server\game\server_restart.sqf";
};

// Extensions
if (KPLIB_param_enemyArtillery) then {
    [] call KPLIB_fnc_artilleryTimerSpawn;
};

if (KPLIB_param_SAMSite > 0) then {
    [] call KPLIB_fnc_SAM_init;
};