/*
    File: fn_handlePlacedZeusObject.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 18/02/2026
    Last Update: 19/02/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Creates zeus modules for each player in the zeus whitelist

    Parameter(s):
        _player - player to assign zeus module [OBJECT, defaults to player]

    Returns:
        Function reached the end [BOOL]
*/
params[["_player", player, [objNull]]];

if (count KPLIB_whitelist_Zeus < 1) exitWith {false};

if (isNull _player) exitWith {};
private _uid = getPlayerUID _player;

// Exit if the player is not in the list
if !(_uid in KPLIB_whitelist_Zeus) exitWith {false};

// Creating a new zeus module
private _group = createGroup [sideLogic, true];
private _zeus = _group createUnit ["ModuleCurator_F", [-7580, -7580, 0], [], 0, "NONE"];

missionNamespace setVariable [format["KPLIB_zeus_%1", _uid], _zeus];

/*
    // All addons
    _zeus setVariable ["Addons", 3, true];
    diag_log format["ZEUS DEBUG: Addons: %1", (_zeus getVariable ["Addons", 0])];
    private _addons = [];

    _cfgPatches = configfile >> "cfgpatches";
    for "_i" from 0 to (count _cfgPatches - 1) do {
        _class = _cfgPatches select _i;
        if (isclass _class) then {_addons set [count _addons,configname _class];};
    };
*/

removeallcuratoraddons _zeus;
_zeus addcuratoraddons (activatedAddons);

_zeus setVariable ["BIS_fnc_initModules_disableAutoActivation", false];

_zeus setCuratorCoef ["Place", 0];
_zeus setCuratorCoef ["Delete", 0];

private _ownerVar = _player call BIS_fnc_objectVar;
_zeus setvariable ["owner", _ownerVar];

// Assign player
[_player, _zeus] remoteExec ["assignCurator", 2];

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

true