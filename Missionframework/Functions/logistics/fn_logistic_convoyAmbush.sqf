#include "script_components.hpp"
/*
    File: fn_logistic_convoyAmbush.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 02/08/2026
    Last Update: 26/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Create logistic convoy ambush

    Parameter(s):
        _logiID - logistic group ID [STRING, defaults to ""]

    Returns:
        Function reached the end [BOOL]
*/
params [["_logiID", "", [""]]];

private _convoy = KPLIB_logistics getOrDefault [_logiID, []];

if (_convoy isEqualTo []) exitWith {false};

_convoy params [
    "_truckCount",
    "_posDestA",
    "_posDestB",
    "_transResourcesA",
    "_transResourcesB",
    "_currentLoaded",
    "_status",
    "_timeLeft",
    "_specialFlag"
];

if (KPLIB_asymmetric_debug > 0) then {[format ["Logistic convoy %1: spawning ambush", _logiID], "ASYMMETRIC"] call KPLIB_fnc_log;};

// Find position to spawn the ambushed convoy
private _pos = [0,0,0];
switch _status do {
    case LOGI_STATUS_TO_B: {
        _pos = _posDestB getPos [_timeLeft * 400, _posDestB getDir _posDestA]
    };
    case LOGI_STATUS_TO_A: {
        _pos = _posDestA getPos [_timeLeft * 400, _posDestA getDir _posDestB]
    };
    default {[format ["Logistic convoy %1 ambush: convoy is not travelling", _logiID], "ERROR"] call KPLIB_fnc_log;};
};

if (_pos isEqualTo [0,0,0]) exitWith {
    [format ["Logistic convoy %1 ambush: no position", _logiID], "ERROR"] call KPLIB_fnc_log; 
    false
};

// Find road
private _roadObj = [_pos, 400, []] call BIS_fnc_nearestRoad;
if (isNull _roadObj) exitWith {
    if (KPLIB_asymmetric_debug > 0) then {[format ["Logistic convoy %1 ambush: no road near current convoy position", _logiID], "ASYMMETRIC"] call KPLIB_fnc_log;};
    false
};

KPLIB_convoy_ambush_inProgress = true;
[0, getPosATL _roadObj] remoteExec ["asymm_notifications"];

private _vehicleArray = [];
for "_i" from 1 to _truckCount do {
    private _veh = createVehicle [KPLIB_b_logiTruck # 0, getPosATL _roadObj, [], 50, "NONE"];
    _veh setDir (getDir _roadObj);
    {
        private _damage = random 0.6;
        if ((_x find "Wheel") != -1) then {
            _damage = _damage + 0.6;
        } else {
            _damage = _damage + 0.3;
        };
        if (_damage > 1) then {_damage = 1.0};
        _veh setHitPointDamage [_x, _damage];
    } forEach ((getAllHitPointsDamage _veh) # 0);
    _vehicleArray pushBack _veh;

    private _driver = createVehicle [KPLIB_b_crewUnit, getPosATL _veh, [], 12, "NONE"];
    _driver setDamage 1;
};
if (KPLIB_asymmetric_debug > 0) then {[format ["Logistic convoy %1 ambush: truck spawning done", _logiID], "ASYMMETRIC"] call KPLIB_fnc_log;};

private _supplies = _currentLoaded # 0;
private _ammo = _currentLoaded # 1;
private _fuel = _currentLoaded # 2;
private _crateArray = [];

while {_supplies > 0} do {
    private _amount = 100;
    if ((_supplies / 100) < 1) then {
        _amount = _supplies;
    };
    _supplies = _supplies - _amount;
    private _crate = [KPLIB_b_crateSupply, _amount, getPosATL _roadObj] call KPLIB_fnc_createCrate;
    _crate setPosATL (_crate getPos [random 60, random 360]);
    _crateArray pushBack [_crate];
};

while {_ammo > 0} do {
    private _amount = 100;
    if ((_ammo / 100) < 1) then {
        _amount = _ammo;
    };
    _ammo = _ammo - _amount;
    private _crate = [KPLIB_b_crateAmmo, _amount, getPos _roadObj] call KPLIB_fnc_createCrate;
    _crate setPosATL (_crate getPos [random 60, random 360]);
    _crateArray pushBack [_crate];
};

while {_fuel > 0} do {
    private _amount = 100;
    if ((_fuel / 100) < 1) then {
        _amount = _fuel;
    };
    _fuel = _fuel - _amount;
    private _crate = [KPLIB_b_crateFuel, _amount, getPos _roadObj] call KPLIB_fnc_createCrate;
    _crate setPos (_crate getPos [random 60, random 360]);
    _crateArray pushBack [_crate];
};
if (KPLIB_asymmetric_debug > 0) then {[format ["Logistic convoy %1 ambush: resource spawning done", _logiID], "ASYMMETRIC"] call KPLIB_fnc_log;};

private _grp = [getPosATL _roadObj] call KPLIB_fnc_spawnGuerillaGroup;

private _waypoint = _grp addWaypoint [getPosATL _roadObj, 150];
_waypoint setWaypointType "SAD";
_waypoint setWaypointCompletionRadius 10;
_waypoint = _grp addWaypoint [getPosATL _roadObj, 150];
_waypoint setWaypointType "SAD";
_waypoint setWaypointCompletionRadius 10;
_waypoint = _grp addWaypoint [getPosATL _roadObj, 150];
_waypoint setWaypointType "SAD";
_waypoint setWaypointCompletionRadius 10;
_waypoint = _grp addWaypoint [getPosATL _roadObj, 150];
_waypoint setWaypointType "CYCLE";
_waypoint setWaypointCompletionRadius 10;
if (KPLIB_asymmetric_debug > 0) then {[format ["Logistic convoy %1 ambush: guerillas spawning done", _logiID], "ASYMMETRIC"] call KPLIB_fnc_log;};

[_grp, _roadObj, _crateArray] spawn {
    params["_grp", "_roadObj", "_crateArray"];

    private _waitingTime = KPLIB_convoy_ambush_duration;
    while {(({alive _x} count (units _grp)) > 0) && (_waitingTime > 0)} do {
        uiSleep 1;
        private _player_near = false;
        {
            if (((_x distance _roadObj) < 250) && (alive _x)) exitWith {_player_near = true};
        } foreach allPlayers;

        if !(_player_near) then {
            _waitingTime = _waitingTime - 1;
        };
    };
    if (KPLIB_asymmetric_debug > 0) then {[format ["Logistic convoy %1 ambush: ambush finished", _logiID], "ASYMMETRIC"] call KPLIB_fnc_log;};

    KPLIB_convoy_ambush_inProgress = false;

    if ((_waitingTime <= 0) && (({alive _x} count (units _grp)) > 0)) then {
        [2] remoteExec ["asymm_notifications"];
        private _gain = 0;
        {
            if (alive _x) then {
                if (isNull objectParent _x) then {deleteVehicle _x} else {(objectParent _x) deleteVehicleCrew _x};
                _gain = _gain + 2;
            };
        } forEach (units _grp);
        {
            if ((typeOf (_x # 0)) == KPLIB_b_crateAmmo) then {
                _gain = _gain + 3;
            } else {
                _gain = _gain + 2;
            };
            deleteVehicle (_x # 0);
        } forEach _crateArray;
        KPLIB_guerilla_strength = KPLIB_guerilla_strength + _gain;
        if (KPLIB_asymmetric_debug > 0) then {[format ["Logistic convoy %1 ambush: guerillas escaped", _logiID], "ASYMMETRIC"] call KPLIB_fnc_log;};
    } else {
        [1] remoteExec ["asymm_notifications"];
        if (KPLIB_asymmetric_debug > 0) then {[format ["Logistic convoy %1 ambush: guerillas defeated", _logiID], "ASYMMETRIC"] call KPLIB_fnc_log;};
    };
};

true