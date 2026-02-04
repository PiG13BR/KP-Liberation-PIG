KPLIB_endgame = 0;
KPLIB_respawn_marker = "respawn";

// Version of the KP Liberation framework
KPLIB_version = [0, 97, "0pig"];

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

    // OAB Start
    if (OAB_isOPFORFriendly) then {
        addMissionEventHandler ["EntityKilled", {
            params ["_unit", "_killer", "_instigator", "_useEffects"];

            if ((side (group _killer) == KPLIB_side_player) && (side (group _unit) == KPLIB_side_enemy)) then {
                KPLIB_side_player setFriend [KPLIB_side_enemy, 0];
                KPLIB_side_enemy setFriend [KPLIB_side_player, 0];
                OAB_isOPFORFriendly = false;
                publicVariable "OAB_isOPFORFriendly";
                [] call KPLIB_fnc_doSave;
                removeMissionEventHandler [_thisEvent, _thisEventHandler];
            }
        }];
    };

    // OAB
    addMissionEventHandler ["EntityCreated", {
        params ["_entity"];
        
        if !(_entity isKindOf "CAManBase") exitWith {};

        if (side (group _entity) == KPLIB_side_enemy) then {
            _entity addItem "NVGoggles";
            _entity assignItem "NVGoggles";
        };
        
        if ((typeOf _entity == KPLIB_o_squadLeader) || (typeOf _entity == KPLIB_o_officer) || (typeOf _entity == KPLIB_o_rifleman) || (typeOf _entity == KPLIB_o_grenadier) || (typeOf _entity == KPLIB_o_paratrooper)) then {
            {_entity removePrimaryWeaponItem _x}forEach (primaryWeaponItems _entity);
            {_entity addPrimaryWeaponItem _x} forEach ["CUP_optic_HensoldtZO_RDS", "CUP_acc_LLM_od"];
        };

        if (typeOf _entity == KPLIB_o_atSpecialist) then {
            
            _entity removeWeapon (secondaryWeapon _entity);
            clearAllItemsFromBackpack _entity;
            _entity addMagazine "CUP_MAAWS_HEAT_M";
            _entity addWeapon "CUP_launch_MAAWS";
            _entity addMagazines ["CUP_MAAWS_HEAT_M", 3];
            _entity addMagazines ["CUP_MAAWS_HEDP_M", 1];
            _entity addSecondaryWeaponItem "CUP_optic_MAAWS_Scope";
        };
    }];

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

    waitUntil {sleep 0.1; time > 30};

    KPLIB_initServerDone = true;
    publicVariable "KPLIB_initServerDone";

    // OAB
    0 spawn {
        while {KPLIB_endgame == 0} do {
            sleep 1;
            [
                // ["task",value]
                ["UpdateDetails","KP Liberation 0.97.0pig"],
                ["UpdateState",""],
                ["UpdateLargeImageKey","oab_-_v0_2"],
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
        sleep 1;
        endMission "END2";
        false;
    };

    if (!isDedicated && !hasInterface && isMultiplayer) then {
        execVM "Scripts\Server\offloading\hc_manager.sqf";
    };

    // Get mission version and readable world name for Discord rich presence
    [
        ["UpdateDetails", [localize "STR_MISSION_VERSION", "on", getText (configfile >> "CfgWorlds" >> worldName >> "description")] joinString " "]
    ] call (missionNamespace getVariable ["DiscordRichPresence_fnc_update", {}]);

    // Add EH for curator to add kill manager and object init recognition for zeus spawned units/vehicles
    {
        _x addEventHandler ["CuratorObjectPlaced", {[_this select 0, _this select 1] call KPLIB_fnc_handlePlacedZeusObject;}];
    } forEach allCurators;

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