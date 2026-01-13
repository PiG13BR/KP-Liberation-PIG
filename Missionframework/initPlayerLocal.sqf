params["_player"];

waitUntil {!isNil "KPLIB_postInit" && !isNil "KPLIB_initServerDone"};

KPLIB_debugSource = name _player;
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

waitUntil {sleep 1; alive _player};

// Client init
[] call compile preprocessFileLineNumbers "Scripts\Client\init_client.sqf";

if !(KPLIB_param_playerMenu) then {
    // Dynamic groups
   ["InitializePlayer", [_player]] call BIS_fnc_dynamicGroups;	
};

// Execute fnc_reviveInit again (by default it executes in postInit)
if ((isNil {_player getVariable "bis_revive_ehHandleHeal"} || isDedicated) && !(bis_reviveParam_mode == 0)) then {
    [] call bis_fnc_reviveInit;
};