/*
    File: fn_battlegroupAttackHeli.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 30/10/2025 
    Last Update: 08/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns an attack helicopter

    Parameter(s):
        _heliClass - vehicle classname [STRING, defaults to ""]
        _sector - spawn point or sector reference [STRING, defaults to ""]
        _targetPos - position to attack [POSITION, defaults to []]

    Returns:
        Group spawned [GROUP]
*/

params [
    ["_heliClass", "", [""]],
    ["_targetPos", [0 ,0 ,0], [[]]],
    ["_spawnPoint", "", [""]],
    ["_notify", true, [false]]
];

if (!isServer) exitWith {grpNull};

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
    _spawnPoint = [2000, 4000, false, _targetPos] call KPLIB_fnc_getOpforSpawnPoint;
};
if (_spawnPoint isEqualTo "") exitWith {grpNull};

private _attackHeli = createVehicle [_heliClass, markerpos _spawnPoint, [], 0, "FLY"];
private _pilot_group = [_attackHeli, KPLIB_side_enemy] call KPLIB_fnc_createCrew;

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

_wp1 = _pilot_group addWaypoint [_targetPos, 25];
_wp1 setWaypointType "SAD";
_wp1 setWaypointSpeed "NORMAL";
_wp1 setWaypointBehaviour "COMBAT";
_wp1 setWaypointCompletionRadius 100;

_pilot_group setCombatMode "RED";

KPLIB_fnc_findTargetsInSector = {
    params["_targets", "_heliGrp"];
    // Reveal targets inside the sector
    {
        if ((_heliGrp knowsAbout _x) >= 2.5) then {continue};
        _heliGrp reveal [_x, 2.5];
    }forEach _targets;
};

[{
    params["_args", "_handle"];
    _args params ["_targetPos", "_helicopter"];

    if (!alive _helicopter || {!alive (driver _helicopter)}) exitWith {[_handle] call CBA_fnc_removePerFrameHandler;};

    private _bluforEntities = ([_targetPos, 150, 150, 0, false] nearEntities [["CAManBase", "Landvehicle", "Helicopter"], false, true, true]) select {(side _x) == KPLIB_side_player};
    
    private _heliGroup = (group (driver _helicopter));

    [_bluforEntities, _heliGroup] remoteExecCall ["KPLIB_fnc_findTargetsInSector", groupOwner _heliGroup];

}, 60, [_targetPos, _attackHeli]] call CBA_fnc_addPerFrameHandler;

if (_notify) then {
    ["KPLIB_reinfIncoming", [_spawnPoint, _targetPos]] call CBA_fnc_globalEvent;
};

["KPLIB_battlegroupSpawn", [_pilot_group]] call CBA_fnc_serverEvent;

_pilot_group