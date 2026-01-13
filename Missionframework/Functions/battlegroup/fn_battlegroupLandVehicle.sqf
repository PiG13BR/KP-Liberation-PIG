/*
    File: fn_battlegroupParatroopers.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 30/10/2025
    Last Update: 04/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns a vehicle battlegroup

    Parameter(s):
        _vehClass - vehicle classname [STRING, defaults to ""]
        _sector - spawn point or sector reference [STRING, defaults to ""]
        _targetPos - position to attack [POSITION, defaults to []]

    Returns:
        Group spawned [GROUP]
*/

params[
    ["_vehClass", "", [""]],
    ["_targetPos", [0 ,0 ,0], [[]]],
    ["_spawnPoint", "", [""]],
    ["_notify", true, [false]]
];

if (!isServer) exitWith {grpNull};

// Get vehicle class if not provided
if (_vehClass isEqualTo "") then {
    private _vehiclePool = [KPLIB_o_battleGrpVehicles, KPLIB_o_battleGrpVehiclesLight] select (KPLIB_enemyReadiness < 50);
    _vehiclePool = _vehiclePool select {_x iskindOf "LandVehicle"}; // Land vehicles only
    _vehClass = selectRandom _vehiclePool;
};
if (_vehClass isEqualTo "") exitWith {grpNull};

// Get target position if not provided
if (_targetPos isEqualTo [0 ,0 ,0]) then {
    _targetPos = [_targetPos] call KPLIB_fnc_getBluforObjective;
};
if (_targetPos isEqualTo []) exitWith {[]};

// Get spawn point if not provided
if (_spawnPoint isEqualTo "") then {
    _spawnPoint = [1000, 2000, false, _targetPos] call KPLIB_fnc_getOpforRoadSpawnPoint;
};
if (_spawnPoint isEqualTo "") exitWith {grpNull};

private _vehicle = [markerpos _spawnPoint, _vehClass] call KPLIB_fnc_spawnVehicle;
private _grp = (group (driver _vehicle));
// Find road
private _roadPos = [[[getPosATL _vehicle, 100]], [], {isOnRoad _this}] call BIS_fnc_randomPos;
if (_roadPos isNotEqualTo [0,0]) then {_vehicle setVehiclePosition [_roadPos, [], 2, "NONE"];};

_grp setVariable ["KPLIB_isBattleGroup", true];

_vehicle limitSpeed 50;

if ((_vehClass in KPLIB_o_troopTransports) && ([] call KPLIB_fnc_getOpforCap < KPLIB_cap_battlegroup)) then {
    // Transport vehicle
    [_vehicle, _spawnPoint, _targetPos] call KPLIB_fnc_handleLandTransport;
};

[{[_this # 0, _this # 1] call KPLIB_fnc_battlegroupAttack;}, [_grp, _targetPos]] call CBA_fnc_execNextFrame; // Commit attack

if (_notify) then {
    ["KPLIB_reinfIncoming", [_spawnPoint, _targetPos]] call CBA_fnc_globalEvent;
};

["KPLIB_battlegroupSpawn", [_grp]] call CBA_fnc_serverEvent;

_grp