KPLIB_endgame = 0;
KPLIB_respawn_marker = "respawn";

// Version of the KP Liberation framework
KPLIB_version = [0, 97, "1pig"];

enableSaving [false, false];

if (isDedicated) then {KPLIB_debugSource = "Server";} else {KPLIB_debugSource = name player;};

// Init sector variables
[] call KPLIB_fnc_initSectors;

if (!isServer) then {waitUntil {!isNil "KPLIB_initServerDone"};};

// Read configuration
[] call compile preprocessFileLineNumbers 'Configurations\KPLIB_config.sqf';

// Read whitelist
[] call compile preprocessFileLineNumbers 'Configurations\KPLIB_whitelists.sqf';

// Read transport configuration (to carry crate resources)
[] call compile preprocessFileLineNumbers 'Configurations\KPLIB_transportConfigs.sqf';

// Read misc classname list
[] call compile preprocessFileLineNumbers 'Configurations\KPLIB_classnameLists.sqf';

// Get mission parameters and transform them into usable variables
[] call compile preprocessFileLineNumbers 'Scripts\Shared\fetch_params.sqf';

// Read presets
[] call compile preprocessFileLineNumbers 'Presets\init_presets.sqf';

// Read objects inits
[] call compile preprocessFileLineNumbers 'Configurations\KPLIB_objectInits.sqf';

// Call init shared (scripts shared between client and server)
[] call compile preprocessFileLineNumbers 'Scripts\Shared\init_shared.sqf';

// Static weapons configuration
[] call compile preprocessFileLineNumbers 'Extensions\Sector_Objects\KPLIB_staticsConfigs.sqf';

// Lock arsenal items by sector
if (KPLIB_param_lockArsenal > 0) then {
    [] call compile preprocessFileLineNumbers 'Extensions\Lock_Arsenal\init_presets.sqf';
};

// Sector events
if (KPLIB_param_sectorEvents > 0) then {
    [] call compile preprocessFileLineNumbers 'Extensions\Sector_Events\init_events.sqf';
};

// Set up CBA event handlers
[] call compile preprocessFileLineNumbers 'CBA_addEventHandler.sqf';

// Set up CBA settings
[] call compile preprocessFileLineNumbers 'CBA_initSettings.sqf';

// Pylon Armament Selector custom preset
if (KPLIB_param_PAS && KPLIB_ace) then {
    [] call compile preprocessFileLineNumbers "Extensions\Pylon_Armament_Selector\init_presets.sqf";
};

if (KPLIB_param_playerMenu) then {
    // KP player menu
    [] call KPPLM_fnc_postInit;
};

// Load saved game and initiate server scripts
if (isServer) then {
    [] call KPLIB_fnc_loadSavedGame; 
    [] call compile preprocessFileLineNumbers "Scripts\Server\init_server.sqf";

    if (isDedicated) then {KPLIB_debugSource = "Server";} else {KPLIB_debugSource = name player;};

    setViewDistance 1600;

    // Execute fnc_reviveInit again (by default it executes in postInit)
    if ((isNil {player getVariable "bis_revive_ehHandleHeal"} || isDedicated) && !(bis_reviveParam_mode == 0)) then {
        [] call bis_fnc_reviveInit;
    };

    if !(KPLIB_param_playerMenu) then {
        // Dynamic groups
        ["Initialize"] call BIS_fnc_dynamicGroups;	
    };

    addMissionEventHandler ["GroupCreated", {
        params ["_group"];

        if (side _group != KPLIB_side_enemy) exitWith {};

        _group addEventHandler ["CombatModeChanged", {
            params ["_group", "_newMode"];

            if (_newMode == "COMBAT") then {
                _group enableIRLasers true
            } else {
                _group enableIRLasers false
            };
        }];
    }];

    // Create bases markers
    ["KPLIB_updateBaseMarkers", []] call CBA_fnc_serverEvent;

    waitUntil {sleep 0.1; time > 30};
    
    KPLIB_initServerDone = true;
    publicVariable "KPLIB_initServerDone";

    spawn {
        while {KPLIB_endgame == 0} do {
            sleep 1;
            [
                // ["task",value]
                ["UpdateDetails","KP Liberation 0.97.0pig"],
                ["UpdateState",""],
                ["UpdateLargeImageKey",""],
                ["UpdateSmallImageKey",""],
                ["UpdatePartySize",count playableUnits],
                ["UpdatePartyMax",getNumber(missionConfigFile >> "Header" >> "maxPlayers")]
            ] call (missionNameSpace getVariable ["DiscordRichPresence_fnc_update",{}]);
        };
    };
};

// Supply dump preset
[] call compile preprocessFileLineNumbers 'Extensions\Supply_Menu\init_presets.sqf';

if (!isDedicated && hasInterface) then {

    KPLIB_debugSource = name player;
    enableSaving [false, false];

    // Check if CBA is running
    if (!KPLIB_CBA) exitWith {
        ["CBA_A3 not loaded. Aborting Mission! KP LIBERATION PIG requires CBA!!!"] call BIS_fnc_error;
        ["CBA_A3 not loaded. This mission requires CBA to run properly.", true, 5] remoteExec ["KPLIB_fnc_hint", 0, true];
        sleep 5;
        endMission "End2";
        false;
    };

    // Check if Advanced Sling Loading and/or Advanced Towing are running
    if (isClass(configFile >> "CfgPatches" >> "SA_AdvancedSlingLoading")) exitWith {
        ["Advanced Sling Loading loaded. Aborting Mission! This mod breaks AI!!"] call BIS_fnc_error;
        ["Advanced Sling Loading loaded. Remove this mod!!!", true, 5] remoteExec ["KPLIB_fnc_hint", 0, true];
        sleep 5;
        endMission "End3";
    };
    if (isClass(configFile >> "CfgPatches" >> "SA_AdvancedTowing")) exitWith {
        ["Advanced Towing loaded. Aborting Mission! This mod breaks AI!!"] call BIS_fnc_error;
        ["Advanced Towing loaded. Remove this mod!!!", true, 5] remoteExec ["KPLIB_fnc_hint", 0, true];
        sleep 5;
        endMission "End4";
    };

    if (!isDedicated && !hasInterface && isMultiplayer) then {
        execVM "Scripts\Server\offloading\hc_manager.sqf";
    };

    // Get mission version and readable world name for Discord rich presence
    [
        ["UpdateDetails", [localize "STR_MISSION_VERSION", "on", getText (configfile >> "CfgWorlds" >> worldName >> "description")] joinString " "]
    ] call (missionNamespace getVariable ["DiscordRichPresence_fnc_update", {}]);

    // Add EH for curator to add kill manager and object init recognition for zeus spawned units/vehicles
    if (count KPLIB_whitelist_Zeus < 1) then {
        {
            _x addEventHandler ["CuratorObjectPlaced", {[_this select 0, _this select 1] call KPLIB_fnc_handlePlacedZeusObject;}];
        } forEach allCurators;
    };

    waitUntil {sleep 1; alive player};

    // Client init
    [] call compile preprocessFileLineNumbers "Scripts\Client\init_client.sqf";

    if !(KPLIB_param_playerMenu) then {
        // Dynamic groups
        ["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;	
    };

    // Execute fnc_reviveInit again (by default it executes in postInit)
    if ((isNil {player getVariable "bis_revive_ehHandleHeal"} || isDedicated) && !(bis_reviveParam_mode == 0)) then {
        [] call bis_fnc_reviveInit;
    };
};

["INIT DONE", "INIT"] call KPLIB_fnc_log;
KPLIB_init = true;