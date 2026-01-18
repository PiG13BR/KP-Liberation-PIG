/*
    Create a zeus interface for the player to access
*/
params["_player"];

if !((getPlayerUID _player) in KPLIB_whitelist_Zeus) exitWith {};

private _grp = createGroup sideLogic;
private _zeus =  _grp createUnit ["ModuleCurator_F", [0,0,0], [], 0, "NONE"];

_zeus setVariable ["Addons", 3, true];
_zeus setVariable ["BIS_fnc_initModules_disableAutoActivation", false];
_zeus setCuratorCoef ["Place", 0];
_zeus setCuratorCoef ["Delete", 0];

private _ownerVar = _player call BIS_fnc_objectVar;
_zeus setvariable ["owner", _ownerVar];

_player assignCurator _zeus;