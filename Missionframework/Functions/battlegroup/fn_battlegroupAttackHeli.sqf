/*
    File: fn_battlegroupAttackHeli.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 30/10/2025 
    Last Update: 20/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns an attack helicopter

    Parameter(s):
        _heliClass - vehicle classname [STRING, defaults to ""]
		_targetPos - position to attack [POSITION, defaults to [0 ,0 ,0]
        _spawnPoint - spawn point or sector reference [STRING, defaults to ""]
        _notify - notify players [BOOL, defaults to true]

    Returns:
        Group spawned [GROUP]
*/

params [
    ["_heliClass", "", [""]],
    ["_targetPos", [0 ,0 ,0], [[]]],
    ["_spawnPoint", "", [""]],
    ["_notify", true, [false]]
];

private _hc = [] call KPLIB_fnc_getLessLoadedHC;
if (!isNull _hc) exitWith {
    _this remoteExecCall ["KPLIB_fnc_battlegroupAttackHeli", _hc]
};

if (_heliClass isEqualTo "") then {
    _heliClass = selectRandom KPLIB_o_attackHelicopters;
};

if (_heliClass isEqualTo "") exitWith {grpNull};

// Get target position if not provided
if (_targetPos isEqualTo [0 ,0 ,0]) then {
    _targetPos = [_targetPos] call KPLIB_fnc_getBluforObjective;
};
if (_targetPos isEqualTo []) exitWith {[]};

// Get spawn point if not provided
if (_spawnPoint isEqualTo "") then {
    _spawnPoint = [1200, 2500, false, _targetPos] call KPLIB_fnc_getOpforSpawnPoint;
};
if (_spawnPoint isEqualTo "") exitWith {grpNull};

private _attackHeli = createVehicle [_heliClass, markerpos _spawnPoint, [], 0, "FLY"];
private _pilot_group = [_attackHeli, KPLIB_side_enemy] call KPLIB_fnc_createCrew;
_pilot_group setVariable ["KPLIB_isBattleGroup", true];

_attackHeli addMPEventHandler ["MPKilled", {
    params ["_unit", "_killer"];
    ["KPLIB_manageKills", [_unit,_killer]] call CBA_fnc_localEvent;
}];
{
    _x addMPEventHandler ["MPKilled", {
        params ["_unit", "_killer"];
        ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
    }];
} forEach (crew _attackHeli);

{ deleteWaypoint _x } forEachReversed waypoints _pilot_group;

// Get countermeasures
private "_counterMeasures";
{
    private _currentWeapons = _attackHeli weaponsTurret _x;
    _counterMeasures = _currentWeapons select {tolower ((_x call bis_fnc_itemType) select 1) in ["countermeasureslauncher"]};
    if (_counterMeasures isNotEqualTo []) exitWith {}; // Found
}forEach ([[-1]] + allTurrets _attackHeli);
_attackHeli setVariable ["KPLIB_heli_counterMeasures", _counterMeasures];

_attackHeli addEventHandler ["IncomingMissile", {
	params ["_target", "_ammo", "_vehicle", "_instigator", "_missile"];

    [_target] spawn {
        params["_target"];
        private _counterMeasures = _target getVariable ["KPLIB_heli_counterMeasures", []];
        private _flareType = selectRandom _counterMeasures;
		if (isNil "_flareType") exitWith {}; // Flare type not found
        for "_i" from 1 to (random 4) do {
            (driver _target) forceWeaponFire [_flareType, "Burst"];
            sleep 0.2;
        };
    };
}];

// Commit to attack
[_attackHeli, _targetPos] call KPLIB_fnc_vehicleAttack;

if (_notify) then {
    ["KPLIB_reinfIncoming", [_spawnPoint, _targetPos]] call CBA_fnc_globalEvent;
};

["KPLIB_battlegroupSpawn", [_pilot_group, _spawnPoint]] call CBA_fnc_serverEvent;

_pilot_group