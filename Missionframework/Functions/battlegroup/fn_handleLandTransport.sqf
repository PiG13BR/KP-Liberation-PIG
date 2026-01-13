/*
    File: fn_handleLandTransport.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 30/10/2025
    Last Update: 04/11/2025
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

if (!isServer) exitWith {};

private _infGrp = [_vehicle] call KPLIB_fnc_spawnInfCargo;

private _hasGun = false;
if (count (allTurrets [_vehicle, false]) > 0) then {
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
    _unit setVariable ["KPLIB_dropOffUnits", true];
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

    [{
        _this params ["_vehicle", "_despawnPos"];

        (_vehicle distance2D _despawnPos) < 100 || {!alive _vehicle}
    }, {
        _this params ["_vehicle"];
        
        if (!alive _vehicle) exitWith {};
        deleteVehicleCrew _vehicle;
        deleteVehicle _vehicle;
        
    }, [_vehicle, getMarkerPos _returnMarker]
    ] call CBA_fnc_waitUntilAndExecute;
};

// Try to make the vehicle follow infantry units
KPLIB_fnc_vehicleFollow = {
    params["_vehicle", "_infGrp"];

    (driver _vehicle) enableAI "MOVE";

    [{
        params["_args", "_handle"];
        _args params ["_vehicle", "_infGrp"];
        
        if (!alive _vehicle || {!alive driver _vehicle}) exitWith {[_handle] call CBA_fnc_removePerFrameHandler;};
        if ((units _infGrp) findIf {(alive _x) && {[_x] call KPLIB_fnc_ace_isAwake}} < 0) exitWith {[_handle] call CBA_fnc_removePerFrameHandler;};

        if (nearestTerrainObjects [(getPosATL (leader _infGrp)),["Tree", "Rock", "Rocks"], 25] isNotEqualTo []) exitWith {}; // Ignore if leader is near trees, rocks
        if (_vehicle distance (leader _infGrp) >= 250) exitWith {}; // Ignore if is too far away from the leader

        _vehicle doMove (getPosATL (leader _infGrp));
    }, 10, [_vehicle, _infGrp]] call CBA_fnc_addPerFrameHandler;
};

// Drop off units 
[{
    _this params ["_vehicle", "_infGrp", "_unload_distance", "_targetPos"];

    (_vehicle distance2D _targetPos < _unload_distance) || {!alive _vehicle || {!alive (driver _vehicle)}} || {_vehicle getVariable ["KPLIB_dropOffUnits", false];}
}, {
    _this params ["_vehicle", "_infGrp"];

    if !(alive _vehicle) exitWith {};
    (driver _vehicle) disableAI "MOVE";
    {deleteWaypoint _x}forEachReversed waypoints (group (driver _vehicle));
    [(units _infGrp)] allowGetIn false;
    [(units _infGrp)] orderGetIn false;
    {
        unassignVehicle _x;
    } forEach (units _infGrp);
}, [_vehicle, _infGrp, _unload_distance, _targetPos]] call CBA_fnc_waitUntilAndExecute;

// Vehicle move out
[{
    _this params ["_vehicle", "_infGrp"];

    (({_x in _vehicle} count (units _infGrp)) isEqualTo 0) || {!alive _vehicle || {!alive (driver _vehicle)}}
}, {
    _this params ["_vehicle", "_infGrp", "_spawnPoint", "_targetPos", "_hasGun"];

    if !(alive _vehicle) exitWith {};

    if !(_hasGun) then {
        // Despawn
        [{_this call KPLIB_fnc_vehicleReturn}, [_vehicle, _spawnPoint], 20] call CBA_fnc_waitAndExecute;
    } else {
        // Follow units
        [{_this call KPLIB_fnc_vehicleFollow}, [_vehicle, _infGrp], 30] call CBA_fnc_waitAndExecute;
    };
    
    [_infGrp, _targetPos] call KPLIB_fnc_battlegroupAttack;
}, [_vehicle, _infGrp, _spawnPoint, _targetPos, _hasGun]] call CBA_fnc_waitUntilAndExecute;