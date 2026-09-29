/*
    File: fn_loadSavedGame.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 16/11/2025
    Last Update: 03/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Loads saved game at start (save_manager.sqf)
        0.97.1pig is compatible to 0.96.8apr

    Parameter(s):
        -

    Returns:
        -
*/

private _start = diag_tickTime;
["----- Loading save data", "SAVE"] call KPLIB_fnc_log;

// Handle possible enabled "wipe save" mission parameters
if (KPLIB_param_wipe_savegame_1 == 1 && KPLIB_param_wipe_savegame_2 == 1) then {
    profileNamespace setVariable [KPLIB_save_key,nil];
    saveProfileNamespace;
    ["Save wiped via mission parameters", "SAVE"] call KPLIB_fnc_log;
} else {
    ["No save wipe", "SAVE"] call KPLIB_fnc_log;
};

// Auto save when last player exits
if (hasInterface) then {
    [
        {
            !isNull (findDisplay 46)
        }, 
        {
            (findDisplay 46) displayAddEventHandler ["Unload", {
                if (!isServer) exitWith {};
                ["Player server exit. Saving mission data.", "SAVE"] call KPLIB_fnc_log;
                [] call KPLIB_fnc_doSave;
            }];
    }, [], 0, {}] call CBA_fnc_waitUntilAndExecute;
} else {
    addMissionEventHandler ["HandleDisconnect", {
        if !(allPlayers isEqualTo []) exitWith {false};
        params ["_unit"];
        deleteVehicle _unit;
        ["Last player disconnected. Saving mission data.", "SAVE"] call KPLIB_fnc_log;
        [] call KPLIB_fnc_doSave;
    }];
};

// All classnames of objects which should be saved
KPLIB_classnamesToSave = [toLowerANSI KPLIB_b_fobBuilding, toLowerANSI KPLIB_b_outpostBuilding, toLowerANSI KPLIB_b_potato01];

/*
    --- Locals ---
    Variables which are only used inside the save_manager.sqf
*/
// All AI squads
private _aiGroups = [];
// Current campaign date and time
private _dateTime = [];
// Vehicles which shouldn't be handled in the kill manager
private _noKillHandler = [toLowerANSI KPLIB_b_fobBuilding, toLowerANSI KPLIB_b_outpostBuilding, toLowerANSI KPLIB_b_potato01];
// All objects which should be loaded/saved
private _objectsToSave = [];
// All storages which are handled for resource persistence
private _resourceStorages = [];
// Collection array for the statistic values
private _stats = [];
// Collection array for the enemy weights
private _weights = [];
// All mines around FOBs
private _allMines = [];
// All unclaimed crates from crate spawning sectors
private _allCrates = [];

/*
    --- Globals ---
    Initializes global variables which are used at several places in the framework
*/

// Enemy weight for anti air
KPLIB_airWeight = 33;
// Enemy weight for anti armor
KPLIB_armorWeight = 33;
// Blufor sectors
KPLIB_sectors_player = [];
// Enemy combat readiness (0-100)
KPLIB_enemyReadiness = 0;
// All FOBs
KPLIB_player_fobs = [];
// All Outposts
KPLIB_player_outposts = [];
// Create variables for cosmutizable FOB/outposts names. Use military alphabet as default.
KPLIB_fobNames = [];
KPLIB_outpostNames = [];
// Player general permissions data
KPLIB_general_permissions = [];
// Player build permissions data
KPLIB_build_permissions = [];
// Vehicle unlock links
KPLIB_sector_vehicleLinks = [];
// Enemy weight for anti infantry
KPLIB_infantryWeight = 33;
// Civilian reputation value (-100 - +100)
KPLIB_civ_rep = 0;
// Clearances
KPLIB_clearances = [];
// Strength value of the resistance forces
KPLIB_guerilla_strength = 0;
// Logistic handling data
KPLIB_logistics = [];
// Production handling data
KPLIB_production = createHashMapFromArray [];
// Factory markers to display the current available facilities
KPLIB_production_markers = createHashMapFromArray [];
// For Storing sector storage object
KPLIB_sector_storage = createHashMapFromArray [];
// Radio tower classnames per radio tower sector
KPLIB_sectorTowers = [];
// Sectors that were already liberated once
KPLIB_sectorLiberated = [];
// Arsenal unlock links
KPLIB_sector_arsenalLink = [];
// Sectors under attack
KPLIB_sectorsUnderAttack = [];
// Global Intel resource
resources_intel = 0;
// State if the save is fully loaded
KPLIB_saveLoaded = false;
// Blocked factory by resistance
KPLIB_blockedFactories = [];
// Sector mines positions
KPLIB_sectorMinesPositionsHash = [];

// Add all buildings for saving and kill manager ignore
_noKillHandler append KPLIB_b_deco_classes;
KPLIB_classnamesToSave append KPLIB_b_deco_classes;
KPLIB_classnamesToSave append KPLIB_b_allVeh_classes;

// Add opfor and civilian vehicles for saving
KPLIB_classnamesToSave append KPLIB_o_allVeh_classes;
KPLIB_classnamesToSave append KPLIB_c_vehicles;

// Remove duplicates
KPLIB_classnamesToSave = KPLIB_classnamesToSave arrayIntersect KPLIB_classnamesToSave;

/*
    --- Statistic Variables ---
*/

stats_ammo_produced = 0;
stats_ammo_spent = 0;
stats_blufor_soldiers_killed = 0;
stats_blufor_soldiers_recruited = 0;
stats_blufor_teamkills = 0;
stats_blufor_vehicles_built = 0;
stats_blufor_vehicles_killed = 0;
stats_civilian_buildings_destroyed = 0;
stats_civilian_vehicles_killed = 0;
stats_civilian_vehicles_killed_by_players = 0;
stats_civilian_vehicles_seized = 0;
stats_civilians_healed = 0;
stats_civilians_killed = 0;
stats_civilians_killed_by_players = 0;
stats_fobs_built = 0;
stats_outposts_built = 0;
stats_fobs_lost = 0;
stats_fuel_produced = 0;
stats_fuel_spent = 0;
stats_hostile_battlegroups = 0;
stats_ieds_detonated = 0;
stats_opfor_killed_by_players = 0;
stats_opfor_soldiers_killed = 0;
stats_opfor_vehicles_killed = 0;
stats_opfor_vehicles_killed_by_players = 0;
stats_player_deaths = 0;
stats_playtime = 0;
stats_prisoners_captured = 0;
stats_readiness_earned = 0;
stats_reinforcements_called = 0;
stats_resistance_killed = 0;
stats_resistance_teamkills = 0;
stats_resistance_teamkills_by_players = 0;
stats_secondary_objectives = 0;
stats_sectors_liberated = 0;
stats_sectors_lost = 0;
stats_potato_respawns = 0;
stats_supplies_produced = 0;
stats_supplies_spent = 0;
stats_vehicles_recycled = 0;

// Prevent saving/duplication of objects placed in Eden
{
    _x setVariable ["KPLIB_edenObject", true];
} forEach (allMissionObjects "");

// Get possible save data
private _saveData = profileNamespace getVariable KPLIB_save_key;

// Load save data, when retrieved
if (!isNil "_saveData") then {

    // Convert from string to array
    if (_saveData isEqualType "") then {
        _saveData = parseSimpleArray _saveData;
    };

    if (((_saveData select 0) select 0) isEqualType 0) then {
        [format ["Save data from version: %1", (_saveData select 0) joinstring "."], "SAVE"] call KPLIB_fnc_log;

        _dateTime                                   = _saveData select  1;
        _objectsToSave                              = _saveData select  2;
        _resourceStorages                           = _saveData select  3;
        _stats                                      = _saveData select  4;
        _weights                                    = _saveData select  5;
        _aiGroups                                   = _saveData select  6;
        KPLIB_sectors_player                        = _saveData select  7;
        KPLIB_enemyReadiness                        = _saveData select  8;
        KPLIB_player_fobs                           = _saveData select  9;
        KPLIB_general_permissions                   = _saveData param [10, []];
        KPLIB_sector_vehicleLinks                   = _saveData param [11, []];
        KPLIB_civ_rep                               = _saveData select 12;
        KPLIB_clearances                            = _saveData select 13;
        KPLIB_guerilla_strength                     = _saveData select 14;
        KPLIB_logistics                             = _saveData select 15;
        KPLIB_production                            = _saveData select 16;
        KPLIB_production_markers                    = _saveData select 17;
        resources_intel                             = _saveData select 18;
        _allMines                                   = _saveData param [19, []];
        _allCrates                                  = _saveData param [20, []];
        KPLIB_sectorTowers                          = _saveData param [21, []];
        KPLIB_sectorLiberated                       = _saveData param [22, []];
        KPLIB_sector_arsenalLink                    = _saveData param [23, []];
        KPLIB_blockedFactories                      = _saveData param [24, []];
        KPLIB_player_outposts                       = _saveData param [25, []];
        KPLIB_fobNames                              = _saveData param [26, KPLIB_militaryAlphabet];
        KPLIB_outpostNames                          = _saveData param [27, KPLIB_militaryAlphabet];
        KPLIB_sectorMinesPositionsHash              = _saveData param [28, []];
        KPLIB_build_permissions                     = _saveData param [29, []];


        stats_ammo_produced                         = _stats select  0;
        stats_ammo_spent                            = _stats select  1;
        stats_blufor_soldiers_killed                = _stats select  2;
        stats_blufor_soldiers_recruited             = _stats select  3;
        stats_blufor_teamkills                      = _stats select  4;
        stats_blufor_vehicles_built                 = _stats select  5;
        stats_blufor_vehicles_killed                = _stats select  6;
        stats_civilian_buildings_destroyed          = _stats select  7;
        stats_civilian_vehicles_killed              = _stats select  8;
        stats_civilian_vehicles_killed_by_players   = _stats select  9;
        stats_civilian_vehicles_seized              = _stats select 10;
        stats_civilians_healed                      = _stats select 11;
        stats_civilians_killed                      = _stats select 12;
        stats_civilians_killed_by_players           = _stats select 13;
        stats_fobs_built                            = _stats select 14;
        stats_fobs_lost                             = _stats select 15;
        stats_fuel_produced                         = _stats select 16;
        stats_fuel_spent                            = _stats select 17;
        stats_hostile_battlegroups                  = _stats select 18;
        stats_ieds_detonated                        = _stats select 19;
        stats_opfor_killed_by_players               = _stats select 20;
        stats_opfor_soldiers_killed                 = _stats select 21;
        stats_opfor_vehicles_killed                 = _stats select 22;
        stats_opfor_vehicles_killed_by_players      = _stats select 23;
        stats_player_deaths                         = _stats select 24;
        stats_playtime                              = _stats select 25;
        stats_prisoners_captured                    = _stats select 26;
        stats_readiness_earned                      = _stats select 27;
        stats_reinforcements_called                 = _stats select 28;
        stats_resistance_killed                     = _stats select 29;
        stats_resistance_teamkills                  = _stats select 30;
        stats_resistance_teamkills_by_players       = _stats select 31;
        stats_secondary_objectives                  = _stats select 32;
        stats_sectors_liberated                     = _stats select 33;
        stats_sectors_lost                          = _stats select 34;
        stats_potato_respawns                      = _stats select 35;
        stats_supplies_produced                     = _stats select 36;
        stats_supplies_spent                        = _stats select 37;
        stats_vehicles_recycled                     = _stats select 38;
    } else {
        // --- Compatibility for older save data ---
        ["Save data from version: pre 0.96.5", "SAVE"] call KPLIB_fnc_log;

        KPLIB_sectors_player                        = _saveData select  0;
        KPLIB_player_fobs                           = _saveData select  1;
        _objectsToSave                              = _saveData select  2;
        _dateTime                                   = _saveData select  3;
        KPLIB_enemyReadiness                        = _saveData select  4;
        _resourceStorages                           = _saveData select  5;
        KPLIB_production                            = _saveData select  6;
        KPLIB_logistics                             = _saveData select  7;
        _stats                                      = _saveData select  8;
        _weights                                    = _saveData select  9;
        KPLIB_sector_vehicleLinks                   = _saveData select 10;
        KPLIB_general_permissions                   = _saveData select 11;
        _aiGroups                                   = _saveData select 12;
        resources_intel                             = _saveData select 13;
        KPLIB_civ_rep                               = _saveData select 15;
        KPLIB_production_markers                    = _saveData select 16;
        KPLIB_guerilla_strength                     = _saveData select 17;

        stats_opfor_soldiers_killed                 = _stats select  0;
        stats_opfor_killed_by_players               = _stats select  1;
        stats_blufor_soldiers_killed                = _stats select  2;
        stats_player_deaths                         = _stats select  3;
        stats_opfor_vehicles_killed                 = _stats select  4;
        stats_opfor_vehicles_killed_by_players      = _stats select  5;
        stats_blufor_vehicles_killed                = _stats select  6;
        stats_blufor_soldiers_recruited             = _stats select  7;
        stats_blufor_vehicles_built                 = _stats select  8;
        stats_civilians_killed                      = _stats select  9;
        stats_civilians_killed_by_players           = _stats select 10;
        stats_sectors_liberated                     = _stats select 11;
        stats_playtime                              = _stats select 12;
        stats_potato_respawns                      = _stats select 13;
        stats_secondary_objectives                  = _stats select 14;
        stats_hostile_battlegroups                  = _stats select 15;
        stats_ieds_detonated                        = _stats select 16;
        stats_reinforcements_called                 = _stats select 19;
        stats_prisoners_captured                    = _stats select 20;
        stats_blufor_teamkills                      = _stats select 21;
        stats_vehicles_recycled                     = _stats select 22;
        stats_ammo_spent                            = _stats select 23;
        stats_sectors_lost                          = _stats select 24;
        stats_fobs_built                            = _stats select 25;
        stats_fobs_lost                             = _stats select 26;
        stats_readiness_earned                      = _stats select 27;
    };

    // Extract weigths from collection array
    KPLIB_infantryWeight = _weights select 0;
    KPLIB_armorWeight = _weights select 1;
    KPLIB_airWeight = _weights select 2;

    // Set correct resistance standing
    private _resistanceEnemy = [0, 1] select (KPLIB_civ_rep < 25);
    private _resistanceFriendly = [0, 1] select (KPLIB_civ_rep >= -25);

    KPLIB_side_resistance setFriend [KPLIB_side_enemy, _resistanceEnemy];
    KPLIB_side_enemy setFriend [KPLIB_side_resistance, _resistanceEnemy];
    KPLIB_side_resistance setFriend [KPLIB_side_player, _resistanceFriendly];
    KPLIB_side_player setFriend [KPLIB_side_resistance, _resistanceFriendly];

    if (KPLIB_civrep_debug > 0) then {[format ["%1 getFriend %2: %3 - %1 getFriend %4: %5", KPLIB_side_resistance, KPLIB_side_enemy, (KPLIB_side_resistance getFriend KPLIB_side_enemy), KPLIB_side_player, (KPLIB_side_resistance getFriend KPLIB_side_player)], "CIVREP"] call KPLIB_fnc_log;};

    // Apply current date and time
    if (_dateTime isEqualType []) then {
        setDate _dateTime;
    } else {
        setDate [2045, 6, 6, _dateTime, 0]; // Compatibility for older save data
    };

    // Create clearances
    {
        [_x select 0, _x select 1] call KPLIB_fnc_createClearance;
    } forEach KPLIB_clearances;

    // Collection array for all objects which are loaded
    private _spawnedObjects = [];

    // Spawn all saved objects
    {
        // Fetch data of saved object
        private _object = _x call KPLIB_fnc_spawnSavedObject;
        // Add object to spawned objects collection
        if (!isNull _object) then {
            _spawnedObjects pushBack _object;
        };
    } forEach _objectsToSave;

    // Re-enable physics on the spawned objects
    {
        _x enableSimulation true;
    } forEach _spawnedObjects;

    // Check for missing fobs/outposts buildings
    {
        if (_x isEqualTo [0,0,0]) then {continue};
        private _fobObject = (nearestObject [_x, KPLIB_b_fobBuilding]);
        
        if (isNull _fobObject) then {
            // Fob object not found, spawn it
            _object = createVehicle [KPLIB_b_fobBuilding, _x, [], 0, "CAN_COLLIDE"];
            _object setPosATL _x;
            [_object] call KPLIB_fnc_addObjectInit;
        };
    }forEach KPLIB_player_fobs;

    {
        if (_x isEqualTo [0,0,0]) then {continue};
        private _outpostObject = (nearestObject [_x, KPLIB_b_outpostBuilding]);
        
        if (isNull _outpostObject) then {
            // Outpost object not found, spawn it
            _object = createVehicle [KPLIB_b_outpostBuilding, _x, [], 0, "CAN_COLLIDE"];
            _object setPosWorld _x;
            [_object] call KPLIB_fnc_addObjectInit;
        };
    }forEach KPLIB_player_outposts;
    ["Saved buildings and vehicles placed", "SAVE"] call KPLIB_fnc_log;

    // Spawn all saved mines
    private _mine = objNull;
    {
        _x params ["_minePos", "_dirAndUp", "_class", "_known"];

        _mine = createVehicle [_class, _minePos, [], 0];
        _mine setPosWorld _minePos;
        _mine setVectorDirAndUp _dirAndUp;

        // reveal mine to player side if it was detected
        if (_known) then {
            KPLIB_side_player revealMine _mine;
        };

    } forEach _allMines;
    ["Saved mines placed", "SAVE"] call KPLIB_fnc_log;

    // Spawn saved resource storages and their content
    {
        _x call KPLIB_fnc_spawnSavedStorage;
    } forEach _resourceStorages;
    ["Saved storages placed and filled", "SAVE"] call KPLIB_fnc_log;

    // Sector production. The saved data returns as an array. Transform into a hashmap.
    private _productionHashmap = createHashMapFromArray [];

    if (count KPLIB_production > 0) then {
        {
            private _key = _x # 0;
            private _array = _x # 1;
            
            _productionHashmap set [
                _key,
                [ 
                    _array # 0,
                    _array # 1,
                    _array # 2,
                    _array # 3,
                    _array # 4,
                    _array # 5,
                    _array # 6,
                    _array # 7,
                    _array # 8,
                    _array # 9,
                    _array # 10
                ]
            ]
        } forEach KPLIB_production;
    };

    KPLIB_production = _productionHashmap; // It's now a hashmap

    {
        private _sector = _x;
        private _storage = _y # 2;

        [_sector, _storage] call KPLIB_fnc_spawnSavedFactoryStorage
    }forEach KPLIB_production;
    ["Saved sector storages placed and filled", "SAVE"] call KPLIB_fnc_log;

    if (count KPLIB_blockedFactories > 0) then {
        {
            // Spawns guerilla in factory
            private _guerUnits = [_x] call KPLIB_fnc_spawnGuerInFactory;

            // Create a marker on the top of the sector
            private _mk = createMarker [format["%1_blocked", _x], markerPos _x];
            _mk setMarkerType "mil_destroy";
            _mk setMarkerSize [1.2, 1.2];
            _mk setMarkerDir 45;
            _mk setMarkerColor "ColorRED";

            // Manage blocked factory
            [_x, _guerUnits] call KPLIB_fnc_factoryBlockedPFH;
        }forEach KPLIB_blockedFactories;
    };

    // Sector production markers. Transform into a hashmap.
    private _productionMarkersHashmap = createHashMapFromArray [];

    if (count KPLIB_production_markers > 0) then {
        //KPLIB_production_markers pushBack [_x, _facility # 0, _facility # 1, _facility # 2, markerText _x];
        {
            private _key = _x # 0;
            private _value = _x # 1;
            if (_value isEqualType []) then {
                // Loaded version
                _productionMarkersHashmap set [
                        _key,
                        [ 
                            _value # 0,
                            _value # 1,
                            _value # 2,
                            _value # 3
                        ]
                    ]
            } else {
                // Old version
                _productionMarkersHashmap set [
                        _key,
                        [ 
                            _x # 1,
                            _x # 2,
                            _x # 3,
                            _x # 4
                        ]
                    ]
                
            }
        } forEach KPLIB_production_markers;
    };
 
    KPLIB_production_markers = _productionMarkersHashmap; // It's now a hashmap
    
    // Check for captured outposts that can be replenished (mission closed before replenishment happened)
    {
        if !(_x in KPLIB_fillers_patrol) then {continue};
        [_x] call KPLIB_fnc_replenishFiller
    }forEach KPLIB_sectors_player;


    // Spawn BLUFOR AI groups
    // This will be removed if we reach a 0.96.7 due to more released Arma 3 DLCs until we finish 0.97.0
    private _grp = grpNull;
    if (((_saveData select 0) select 0) isEqualType 0) then {
        {
            _x params ["_spawnPos", "_units"];
            _grp = createGroup [KPLIB_side_player, true];
            {
                [_x, [_spawnPos, _grp] select (_forEachIndex > 0), _grp] call KPLIB_fnc_createManagedUnit;
            } forEach _units;
        } forEach _aiGroups;
    } else {
        // Pre 0.96.5 compatibility
        private _pos = [];
        private _dir = 0;
        private _unit = objNull;
        {
            _grp = createGroup [KPLIB_side_player, true];
            {
                _pos = [(_x select 1) select 0, (_x select 1) select 1, ((_x select 1) select 2) + 0.2];
                _dir = _x select 2;
                _unit = [(_x select 0), _pos, _grp] call KPLIB_fnc_createManagedUnit;
                _unit setDir _dir;
                _unit setPosATL _pos;
            } forEach _x;
        } forEach _aiGroups;
    };
    ["Saved AI units placed", "SAVE"] call KPLIB_fnc_log;

    // Spawn all saved sector crates
    {
        _x call KPLIB_fnc_createCrate;
    } forEach _allCrates;
    ["Saved crates placed", "SAVE"] call KPLIB_fnc_log;
} else {
    ["Save nil", "SAVE"] call KPLIB_fnc_log;
};

// Get total area of the map with the created trigger to be used as whitelist to avoid bad positions off map for units
private _axis = worldSize / 2;
private _center = [_axis, _axis , 0];
KPLIB_centerArea = createTrigger ["EmptyDetector", _center];
KPLIB_centerArea setTriggerArea [_axis, _axis, 0, true, -1];
publicVariable "KPLIB_centerArea"; 

if (KPLIB_fobNames isEqualTo []) then {KPLIB_fobNames = KPLIB_militaryAlphabet};
if (KPLIB_outpostNames isEqualTo []) then {KPLIB_outpostNames = KPLIB_militaryAlphabet};

// Sector mines positions. The saved data returns as an array. Transform into a hashmap.
private _sectorMinesPositionsHash = createHashMapFromArray [];

if (count KPLIB_sectorMinesPositionsHash > 0) then {
	{
		private _key = _x # 0;
		private _array = _x # 1;
		
		_sectorMinesPositionsHash set [
			_key,
			[ 
				_array # 0,
				_array # 1
			]
		]
	} forEach KPLIB_sectorMinesPositionsHash;
};

KPLIB_sectorMinesPositionsHash = _sectorMinesPositionsHash; // It's now a hashmap

// Look for mines position for each sector in the game start. These positions are going to be fixed and saved.
if (KPLIB_param_enemyMines) then {
    // Find sectors without mine positions
    {
        [_x] call KPLIB_fnc_registerMinePositions
    }forEach KPLIB_sectors_all;
};

// Update logistic array into hashmap
private _logisticHashMap = createHashMapFromArray [];
if (count KPLIB_logistics > 0) then {
    {
        private _key = _x # 0;
        private _value = _x # 1;
        if (_value isEqualType []) then {
            // Loaded version
            _logisticHashMap set [
                _key,
                    [ 
                        _value # 0,
                        _value # 1,
                        _value # 2,
                        _value # 3,
                        _value # 4,
                        _value # 5,
                        _value # 6,
                        _value # 7,
                        _value # 8,
                        _value param [9, [0,0,0]], // If [0,0,0], the logistic will be deleted
                        -1
                    ]
                ]
        } else {
            // Old version
            _logisticHashMap set [
                _key,
                [ 
                    _x # 1,
                    _x # 2,
                    _x # 3,
                    _x # 4,
                    _x # 5,
                    _x # 6,
                    _x # 7,
                    _x # 8,
                    _x # 9
                ]
            ]
            
        }
    }forEach KPLIB_logistics;
};

// It's now a hashmap
KPLIB_logistics = _logisticHashMap;

publicVariable "stats_civilian_vehicles_seized";
publicVariable "stats_ieds_detonated";
publicVariable "KPLIB_sectors_player";
publicVariable "KPLIB_player_fobs";
publicVariable "KPLIB_sectorsUnderAttack";
publicVariable "KPLIB_clearances";
publicVariable "KPLIB_logistics";
publicVariable "KPLIB_production";
publicVariable "KPLIB_production_markers";
publicVariable "KPLIB_sector_storage";
publicVariable "KPLIB_blockedFactories";
publicVariable "KPLIB_player_outposts";
publicVariable "KPLIB_fobNames";
publicVariable "KPLIB_outpostNames";
publicVariable "KPLIB_sectorMinesPositionsHash";

// Check for deleted military sectors or deleted classnames in the locked vehicles array
[] call KPLIB_fnc_linkVehToUnlock;
publicVariable "KPLIB_sector_vehicleLinks";

if (KPLIB_param_lockArsenal > 0 && !isNil "KPLIB_b_lockedArsenal") then {
    [] call KPLIB_fnc_linkItemsToUnlock
};

if (KPLIB_sector_arsenalLink isEqualType []) then {KPLIB_sector_arsenalLink = createHashMapFromArray []};
publicVariable "KPLIB_sector_arsenalLink";

[] call KPLIB_fnc_setSavedPermissions;

KPLIB_saveLoaded = true; publicVariable "KPLIB_saveLoaded";

[format ["----- Saved data loaded - Time needed: %1 seconds", diag_tickTime - _start], "SAVE"] call KPLIB_fnc_log;

// Start save loop after 3 minutes
[{[] call KPLIB_fnc_autoSavePFH;}, [], 180] call CBA_fnc_waitAndExecute;
