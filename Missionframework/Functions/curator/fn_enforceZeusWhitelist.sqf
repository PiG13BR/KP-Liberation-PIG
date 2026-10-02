/*
    File: fn_enforceZeusWhitelist.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 18/02/2026
    Last Update: 30/09/2026
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

_zeus setVariable ["Addons", 3, true];

// From ACE
private _addons = ('true' configClasses (configFile >> "CfgPatches")) apply {configName _x};
activateAddons _addons;
removeAllCuratorAddons _zeus;
_zeus addCuratorAddons _addons;

_zeus setVariable ["BIS_fnc_initModules_disableAutoActivation", false];

_zeus setCuratorCoef ["Place", 0];
_zeus setCuratorCoef ["Delete", 0];

private _ownerVar = _player call BIS_fnc_objectVar;
_zeus setvariable ["owner", _ownerVar];

// Assign player
[_player, _zeus] remoteExec ["assignCurator", 2];

["KPLIB_generateLog", [format["Setting up player %1 with UID %2 as zeus (%3)", name _player, _uid, _zeus], "ZEUS WHITELIST"]] call CBA_fnc_serverEvent;

// Remove the assigned curator on player disconnect
addMissionEventHandler ["HandleDisconnect", {
    params ["", "", "_uid"];
    private _zeus = missionNamespace getVariable (format["KPLIB_zeus_%1", _uid]);
    if (!isNil "_zeus") then {
        deleteVehicle _zeus;
        missionNamespace setVariable [format["KPLIB_zeus_%1", _uid], nil];
    };
}];

_zeus addEventHandler ["CuratorObjectPlaced", {
    params ["_curator", "_entity"];
    [_curator, _entity] call KPLIB_fnc_handlePlacedZeusObject;
}];

// Thanks to Kohjin (lines from BIS_fnc_moduleCurator)
_zeus addEventHandler ["curatorFeedbackMessage",       { _this call BIS_fnc_showCuratorFeedbackMessage; }];
_zeus addEventHandler ["curatorPinged",                { _this call BIS_fnc_curatorPinged; }];
_zeus addEventHandler ["curatorObjectPlaced",          { _this call BIS_fnc_curatorObjectPlaced; }];
_zeus addEventHandler ["curatorObjectEdited",          { _this call BIS_fnc_curatorObjectEdited; }];
_zeus addEventHandler ["curatorWaypointPlaced",        { _this call BIS_fnc_curatorWaypointPlaced; }];
_zeus addEventHandler ["curatorObjectDoubleClicked",   { (_this select 1) call BIS_fnc_showCuratorAttributes; }];
_zeus addEventHandler ["curatorGroupDoubleClicked",    { (_this select 1) call BIS_fnc_showCuratorAttributes; }];
_zeus addEventHandler ["curatorWaypointDoubleClicked", { (_this select 1) call BIS_fnc_showCuratorAttributes; }];
_zeus addEventHandler ["curatorMarkerDoubleClicked",   { (_this select 1) call BIS_fnc_showCuratorAttributes; }];
_player call BIS_fnc_curatorRespawn;

true