params[["_player", player, [objNull]]];

if (count KPLIB_whitelist_Zeus < 1) exitWith {};

// Whitelist detected, deleting all existing modules
["Zeus whitelist detected", "ZEUS WHITELIST"] call KPLIB_fnc_log;
{
    [format["Deleting curator %1", _x], "ZEUS WHITELIST"] call KPLIB_fnc_log;
    deleteVehicle _x
}forEach allCurators;

if (isNull _player) exitWith {};
private _uid = getPlayerUID _player;

// Exit if the player is not in the list
if (!(serverCommandAvailable "#kick") && !(_uid in KPLIB_whitelist_Zeus)) exitWith {
    sleep 1;
    endMission "END1";
};

// Creating a new zeus module
private _group = createGroup [sideLogic, true];
private _zeus = _group createUnit ["ModuleCurator_F", [-7580, -7580, 0], [], 0, "NONE"];

missionNamespace setVariable [format["KPLIB_zeus_%1", _uid], _zeus];

// All addons available
//_zeus setVariable ["Addons", 3, true];
_addons = [];
_cfgPatches = configfile >> "cfgpatches";
for "_i" from 0 to (count _cfgPatches - 1) do {
    _class = _cfgPatches select _i;
    if (isclass _class) then {_addons set [count _addons,configname _class];};
};

activateAddons _addons;
removeallcuratoraddons _zeus;
_zeus addcuratoraddons _addons;

_zeus setVariable ["BIS_fnc_initModules_disableAutoActivation", false];

_zeus setCuratorCoef ["Place", 0];
_zeus setCuratorCoef ["Delete", 0];
//diag_log format["ZEUS DEBUG: Addons: %1", (_zeus getVariable ["Addons", 0])];

private _limited = false;
_zeus setVariable ["KPLIB_limited", _limited];

// Assign player
_player assignCurator _zeus;

[format["Setting up player %1 with UID %2 as zeus (%3)", name _player, _uid, _zeus], "ZEUS WHITELIST"] call KPLIB_fnc_log;

// Remove the assigned curator on player disconnect
addMissionEventHandler ["HandleDisconnect", {
    params ["", "", "_uid"];
    private _zeus = missionNamespace getVariable (format["KPLIB_zeus_%1", _uid]);
    if (!isNil "_zeus") then {
        deleteVehicle _zeus;
        missionNamespace setVariable [format["KPLIB_zeus_%1", _uid], nil];
    };
}];