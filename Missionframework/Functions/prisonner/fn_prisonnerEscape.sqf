params["_unit"];

// Assign unit back to the enemy side
private _grp = createGroup [KPLIB_side_enemy, true];
[_unit] joinSilent _grp;
_unit setUnitPos "AUTO";
_unit setCaptive false;

// Check if units is in a vehicle
if ((vehicle _unit != _unit) && !(_unit isEqualTo (driver vehicle _unit))) then {
    moveOut _unit;
    unAssignVehicle _unit;
};

// Check for handcuffs
if (KPLIB_ace) then {
    private _isCuffed = _unit getVariable ["ace_captives_isHandcuffed", false];
    if (_isCuffed) then {
        ["ace_captives_setHandcuffed", [_unit, false], _unit] call CBA_fnc_targetEvent;
    } else {
        ["ace_captives_setSurrendered", [_unit, false], _unit] call CBA_fnc_targetEvent;
    };
} else {
    params["_unit"];
    _unit setCaptive false;
    _unit enableAI "ANIM";
    _unit enableAI "MOVE";
    _unit playmove "AmovPercMstpSsurWnonDnon_AmovPercMstpSnonWnonDnon";
    [_unit, ""] remoteExecCall ["switchMove"];
};

{deleteWaypoint _x} forEachReversed waypoints _grp;
{
    doStop _x; 
    _x doFollow (leader _grp)
} foreach (units _grp);

private _possibleSectors = (KPLIB_sectors_all - KPLIB_sectors_player);
private _movePos = [];
if (count _possibleSectors > 0) then {
    // Find the nearest enemy sector to escape
    _possibleSectors = [_possibleSectors , [getpos _unit, 5000] , {(markerPos _x) distance _input0} , 'ASCEND'] call BIS_fnc_sortBy;
    _targetSector = _possibleSectors select 0;
    _movePos = markerpos _targetSector;
} else {
    // Find the nearest FOB to run in the opposite direction
    _nearestFOB = [getPosATL _unit] call KPLIB_fnc_getNearestFOB;
    _movePos = _unit getPos [5000, (_unit getDir _nearestFOB) - 180];
};

private _waypoint = _grp addWaypoint [_movePos, 300];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointSpeed "FULL";