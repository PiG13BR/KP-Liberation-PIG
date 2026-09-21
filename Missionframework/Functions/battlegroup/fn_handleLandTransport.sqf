/*
    File: fn_handleLandTransport.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 30/10/2025
    Last Update: 20/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handles land transportation of troops

    Parameter(s):
        _vehClass - vehicle classname [STRING, defaults to objNull]
        _spawnPoint - vehicle despawn point [STRING, defaults to ""]
        _targetPos - infantry attack position [POSITION, defaults to []]

    Returns:
        Group spawned [GROUP]
*/
params[["_vehicle", objNull, [objNull]], ["_spawnPoint", "", [""]], ["_targetPos", [], [[]]]];

if (!canSuspend) exitWith {_this spawn KPLIB_fnc_handleLandTransport};

private _infGrp = [_vehicle] call KPLIB_fnc_spawnInfCargo;

private _hasGun = false;
if (count ((typeOf _vehicle) call BIS_fnc_allTurrets) > 0) then {
    // Transport vehicle with guns
    _hasGun = true;
} else {
    _hasGun = false;
};

private _unload_distance = 500;

// Event handlers
_vehicle addEventHandler ["Hit", {
	params ["_unit", "_source", "_damage", "_instigator"];
    _unit setVariable ["KPLIB_dropOffUnits", true];
}];

_vehicle addEventHandler ["IncomingMissile", {
	params ["_target", "_ammo", "_vehicle", "_instigator", "_missile"];
    _target setVariable ["KPLIB_dropOffUnits", true];
}];

// Internal functions
KPLIB_fnc_vehicleReturn = {
    params["_vehicle", "_returnMarker"];

    (driver _vehicle) enableAI "MOVE";

    {deleteWaypoint _x}forEachReversed waypoints (group (driver _vehicle));

    _waypoint = (group (driver _vehicle)) addWaypoint [getMarkerPos _returnMarker, 0];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointSpeed "FULL";
    _waypoint setWaypointBehaviour "CARELESS";
    _waypoint setWaypointCombatMode "BLUE";
    _waypoint setWaypointCompletionRadius 100;

    waitUntil {sleep 1; (_vehicle distance2D (getMarkerPos _returnMarker)) < 100 || {!alive _vehicle}};

    if (!alive _vehicle) exitWith {};
    deleteVehicleCrew _vehicle;
    deleteVehicle _vehicle;
};

// Try to make the vehicle follow infantry units
KPLIB_fnc_vehicleFollow = {
    params["_vehicle", "_infGrp"];

    (driver _vehicle) enableAI "MOVE";

    while {alive _vehicle && {alive driver _vehicle}} do {
        if ((units _infGrp) findIf {(alive _x) && {[_x] call KPLIB_fnc_ace_isAwake}} < 0) exitWith {};

        if (nearestTerrainObjects [(getPosATL (leader _infGrp)),["Tree", "Rock", "Rocks"], 25] isNotEqualTo []) then {continue}; // Ignore if leader is near trees, rocks
        if (_vehicle distance (leader _infGrp) >= 250) then {continue}; // Ignore if is too far away from the leader
        
        _vehicle doMove (getPosATL (leader _infGrp));

        sleep 10;
    };
};

// Drop off units
waitUntil {sleep 1; (_vehicle distance2D _targetPos < _unload_distance) || {!alive _vehicle || {!alive (driver _vehicle)}} || {_vehicle getVariable ["KPLIB_dropOffUnits", false];}};

if !(alive _vehicle) exitWith {};
(driver _vehicle) disableAI "MOVE";
{deleteWaypoint _x}forEachReversed waypoints (group (driver _vehicle));
[(units _infGrp)] allowGetIn false;
[(units _infGrp)] orderGetIn false;
{
    unassignVehicle _x;
} forEach (units _infGrp);

_infGrp setVariable ["KPLIB_isBattleGroup", true];
[_infGrp] call KPLIB_fnc_LAMBS_enableReinforcements;

// Vehicle move out
waitUntil {sleep 1; (({_x in _vehicle} count (units _infGrp)) isEqualTo 0) || {!alive _vehicle || {!alive (driver _vehicle)}}};

if !(alive _vehicle) exitWith {};

if !(_hasGun) then {
    // Despawn
    [{_this spawn KPLIB_fnc_vehicleReturn}, [_vehicle, _spawnPoint], 20] call CBA_fnc_waitAndExecute;
} else {
    // Follow units
    group(driver _vehicle) setVariable ["KPLIB_isBattleGroup", true];
    [{_this spawn KPLIB_fnc_vehicleFollow}, [_vehicle, _infGrp], 30] call CBA_fnc_waitAndExecute;
};

[_infGrp, _targetPos] call KPLIB_fnc_infantryAttack;