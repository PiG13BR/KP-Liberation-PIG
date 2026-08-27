/*
    File: fn_addDefenseWaypoints.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: -
    Last Update: 26/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Add defense waypoints for a group in a sector position

    Parameter(s):
        _grp - group to add defense waypoints [GROUP]
        _sectorPos - sector position [POSITION]

    Returns:
        -
*/
params["_grp", "_sectorPos"];

private _basepos = getPosATL (leader _grp);
private _is_infantry = false;
private _wpPositions = [];
private _waypoint = [];

if (isNull _grp) exitWith {};

if (vehicle (leader _grp) == (leader _grp)) then {_is_infantry = true;};

sleep 5;
{ deleteWaypoint _x } forEachReversed waypoints _grp;
sleep 1;
{doStop _x; _x doFollow leader _grp} foreach units _grp;
sleep 1;

if (_is_infantry) then {
    _wpPositions = [
        _sectorPos getPos [random [50, 100, 150], random [0, 36, 72]],
        _sectorPos getPos [random [50, 100, 150], random [72, 108, 144]],
        _sectorPos getPos [random [50, 100, 150], random [144, 180, 216]],
        _sectorPos getPos [random [50, 100, 150], random [216, 252, 288]],
        _sectorPos getPos [random [50, 100, 150], random [288, 324, 360]]
    ];
    _waypoint = _grp addWaypoint [_wpPositions select 0, 10];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointBehaviour "SAFE";
    _waypoint setWaypointCombatMode "YELLOW";
    _waypoint setWaypointSpeed "LIMITED";
    _waypoint setWaypointCompletionRadius 10;
    _waypoint setWaypointTimeout [3, 6, 9];

    _waypoint = _grp addWaypoint [_wpPositions select 1, 10];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointTimeout [3, 6, 9];
    _waypoint = _grp addWaypoint [_wpPositions select 2, 10];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointTimeout [3, 6, 9];
    _waypoint = _grp addWaypoint [_wpPositions select 3, 10];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointTimeout [3, 6, 9];

    _waypoint = _grp addWaypoint [_wpPositions select 4, 10];
    _waypoint setWaypointType "CYCLE";
    _waypoint setWaypointTimeout [3, 6, 9];
} else {
    _waypoint = _grp addWaypoint [_basepos, 1];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointBehaviour "SAFE";
    _waypoint setWaypointCombatMode "YELLOW";
    _waypoint setWaypointSpeed "LIMITED";
    _waypoint setWaypointCompletionRadius 30;
};

_grp setCurrentWaypoint [_grp, 0];

waitUntil {
    sleep 10;
    ({alive _x} count (units _grp) == 0) || !(isNull ((leader _grp) findNearestEnemy (leader _grp)))
};

if (((units _grp) findIf {alive _x}) != -1) then {
    { deleteWaypoint _x } forEachReversed waypoints _grp;
    sleep 1;
    {doStop _x; _x doFollow leader _grp} foreach units _grp;
    sleep 1;
    _wpPositions = [
        _basepos getPos [random [50, 100, 150], random [0, 36, 72]],
        _basepos getPos [random [50, 100, 150], random [72, 108, 144]],
        _basepos getPos [random [50, 100, 150], random [144, 180, 216]],
        _basepos getPos [random [50, 100, 150], random [216, 252, 288]],
        _basepos getPos [random [50, 100, 150], random [288, 324, 360]]
    ];
    _waypoint = _grp addWaypoint [_wpPositions select 0, 10];
    _waypoint setWaypointType "SAD";
    _waypoint setWaypointBehaviour "COMBAT";
    _waypoint setWaypointCombatMode "YELLOW";
    if (_is_infantry) then {
        _waypoint setWaypointSpeed "NORMAL";
    } else {
        _waypoint setWaypointSpeed "LIMITED";
    };
    _waypoint = _grp addWaypoint [_wpPositions select 1, 10];
    _waypoint setWaypointType "SAD";
    _waypoint = _grp addWaypoint [_wpPositions select 2, 10];
    _waypoint setWaypointType "SAD";
    _waypoint = _grp addWaypoint [_wpPositions select 3, 10];
    _waypoint setWaypointType "SAD";
    _waypoint = _grp addWaypoint [_wpPositions select 4, 10];
    _waypoint setWaypointType "CYCLE";
    _grp setCurrentWaypoint [_grp, 0];
};
