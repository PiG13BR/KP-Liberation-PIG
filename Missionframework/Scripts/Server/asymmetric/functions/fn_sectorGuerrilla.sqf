params ["_sector"];

if (KPLIB_asymmetric_debug > 0) then {[format ["Sector %1 (%2) - guerrilla spawned on: %3", (markerText _sector), _sector, KPLIB_debugSource], "ASYMMETRIC"] remoteExecCall ["KPLIB_fnc_log", 2];};

private _startpos = (markerPos _sector) getPos [(1200 + (round (random 400))), (random 360)];

while {(([_startpos, 500, KPLIB_side_player] call KPLIB_fnc_getUnitsCount) > 0) || (surfaceIsWater _startpos)} do {
    _startpos = (markerPos _sector) getPos [(600 + (round (random 200))), (random 360)];
};

private _incDir = (markerPos _sector) getDir _startpos;
private _incString = "unknown";

switch (true) do {
    case (_incDir < 23) : {_incString = "N"};
    case (_incDir < 68) : {incString = "NE";};
    case (_incDir < 113) : {_incString = "E";};
    case (_incDir < 158) : {_incString = "SE";};
    case (_incDir < 203) : {_incString = "S";};
    case (_incDir < 248) : {_incString = "SW";};
    case (_incDir < 293) : {_incString = "W";};
    case (_incDir < 338) : {_incString = "NW";};
    case (_incDir > 338) : {_incString = "N";};
};

[5, [(markerText _sector), _incString]] remoteExec ["KPLIB_fnc_crGlobalMsg"];

private _spawnedGroups = [];
private _grp = [_startpos] call KPLIB_fnc_spawnGuerillaGroup;

{ deleteWaypoint _x } forEachReversed waypoints _grp;
{doStop _x; _x doFollow leader _grp} foreach units _grp;

private _waypoint = _grp addWaypoint [markerpos _sector, 100];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointSpeed "FULL";
_waypoint setWaypointBehaviour "AWARE";
_waypoint setWaypointCombatMode "YELLOW";
_waypoint setWaypointCompletionRadius 30;
_waypoint = _grp addWaypoint [markerpos _sector, 200];
_waypoint setWaypointSpeed "NORMAL";
_waypoint setWaypointType "SAD";
_waypoint = _grp addWaypoint [markerpos _sector, 200];
_waypoint setWaypointSpeed "NORMAL";
_waypoint setWaypointType "SAD";
_waypoint = _grp addWaypoint [markerpos _sector, 200];
_waypoint setWaypointSpeed "NORMAL";
_waypoint setWaypointType "SAD";
_waypoint = _grp addWaypoint [markerpos _sector, 200];
_waypoint setWaypointSpeed "NORMAL";
_waypoint setWaypointType "CYCLE";

_spawnedGroups pushBack _grp;

sleep 30;

if (((random 100) <= 25) && !(KPLIB_r_vehicles isEqualTo [])) then {
    private _vehicle = (selectRandom KPLIB_r_vehicles) createVehicle _startpos;
    [_vehicle] call KPLIB_fnc_allowCrewInImmobile;

    private _grp = [_startpos, 2] call KPLIB_fnc_spawnGuerillaGroup;
    ((units _grp) select 0) moveInDriver _vehicle;
    ((units _grp) select 1) moveInGunner _vehicle;

    _waypoint = _grp addWaypoint [markerpos _sector, 100];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointSpeed "LIMITED";
    _waypoint setWaypointBehaviour "AWARE";
    _waypoint setWaypointCombatMode "YELLOW";
    _waypoint setWaypointCompletionRadius 30;
    _waypoint = _grp addWaypoint [markerpos _sector, 300];
    _waypoint setWaypointSpeed "LIMITED";
    _waypoint setWaypointType "SAD";
    _waypoint = _grp addWaypoint [markerpos _sector, 300];
    _waypoint setWaypointSpeed "LIMITED";
    _waypoint setWaypointType "SAD";
    _waypoint = _grp addWaypoint [markerpos _sector, 300];
    _waypoint setWaypointSpeed "LIMITED";
    _waypoint setWaypointType "SAD";
    _waypoint = _grp addWaypoint [markerpos _sector, 300];
    _waypoint setWaypointSpeed "LIMITED";
    _waypoint setWaypointType "CYCLE";

    _spawnedGroups pushBack _grp;
};

waitUntil {sleep 60; !(_sector in KPLIB_sectors_active)};

sleep 60;

private _strengthChanged = false;

{
    if (!isNull _x) then {
        {
            if (alive _x) then {
                if (isNull objectParent _x) then {deleteVehicle _x} else {(objectParent _x) deleteVehicleCrew _x};
                KPLIB_guerilla_strength = KPLIB_guerilla_strength + 2;
                _strengthChanged = true;
            };
        } forEach (units _x);
    };
} forEach _spawnedGroups;

if (!isServer && _strengthChanged) then {
    publicVariableServer "KPLIB_guerilla_strength";
};

if (KPLIB_asymmetric_debug > 0) then {[format ["Sector %1 (%2) - guerrilla dropped on: %3", (markerText _sector), _sector, KPLIB_debugSource], "ASYMMETRIC"] remoteExecCall ["KPLIB_fnc_log", 2];};
