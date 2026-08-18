/*
    File: fn_battlegroupParatroopers.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 29/10/2025
    Last Update: 16/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns an airplane and paradrop units to designated location
        Once the infantry is on the ground, they will regroup first and then attack the target position

    Parameter(s):
        _planeClass - vehicle classname [STRING, defaults to ""]
		_targetPos - position to attack [POSITION, defaults to [0 ,0 ,0]
        _spawnPoint - spawn point or sector reference [STRING, defaults to ""]
        _notify - notify players [BOOL, defaults to true]

    Returns:
        Group spawned [GROUP]
*/

params [
    ["_planeClass", "", [""]],
    ["_targetPos", [0 ,0 ,0], [[]]],
    ["_spawnPoint", "", [""]],
    ["_notify", true, [false]]
];

if (!isServer) exitWith {[]};

// Get heli class if not provided
if (_planeClass isEqualTo "") then {
    _planeClass = selectRandom KPLIB_o_paradropPlanes;
    while {!(_planeClass in KPLIB_o_troopTransports)} do {
        _planeClass = selectRandom KPLIB_o_paradropPlanes;
    };
};
if (_planeClass isEqualTo "") exitWith {[]};

// Get target position if not provided
if (_targetPos isEqualTo [0 ,0 ,0]) then {
    _targetPos = [_targetPos] call KPLIB_fnc_getBluforObjective;
};
if (_targetPos isEqualTo []) exitWith {[]};

// Get spawn point if not provided
if (_spawnPoint isEqualTo "") then {
    // Avoid getting air spawns close by
    _airSpawns = KPLIB_sectors_airSpawn select {(markerPos _x) distance _targetPos > 3000};
    _spawnPoint = ([_airSpawns, [_targetPos], {(markerPos _x) distance _input0}, "ASCEND"] call BIS_fnc_sortBy) select 0;
};
if (_spawnPoint isEqualTo "") exitWith {grpNull};

private _paradropArea = [_targetPos, 800] call KPLIB_fnc_findPlaceToParadrop;

if (_paradropArea isEqualTo [0,0]) exitWith {[]};
private _newPlane = createVehicle [_planeClass, markerpos _spawnPoint, [], 100, "FLY"];
//_newPlane setPosASL [markerpos _spawnPoint # 0, markerpos _spawnPoint # 1, (getTerrainHeightASL (markerpos _spawnPoint)) + 300];
private _pilot_group = [_newPlane, KPLIB_side_enemy] call KPLIB_fnc_createCrew;
_newPlane setDir (getDir _newPlane + (_newPlane getRelDir _targetPos));
_newPlane setVelocityModelSpace [0,100,0];

_newPlane addMPEventHandler ["MPKilled", {
    params ["_unit", "_killer"];
    ["KPLIB_manageKills", [_unit,_killer]] call CBA_fnc_localEvent;
}];
{
    _x addMPEventHandler ["MPKilled", {
        params ["_unit", "_killer"];
        ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
    }];
} forEach (crew _newPlane);

{ deleteWaypoint _x } forEachReversed waypoints _pilot_group;

private _infGrp = [_newPlane] call KPLIB_fnc_spawnInfCargo;
if (isNull _infGrp) exitWith {deleteVehicle _newPlane; []};

_newPlane flyInHeightASL [300, 300, 300];

_pilot_group setBehaviour "CARELESS";

// Paradrop wp
private _pathPos1 = _paradropArea getPos [1500, (_newPlane getDir _paradropArea) - 180];
private _wp1 = _pilot_group addWaypoint [_pathPos1, 0];
_wp1 setWaypointType "MOVE";
_wp1 setWaypointSpeed "NORMAL";
_wp1 setWaypointBehaviour "CARELESS";
_wp1 setWaypointCombatMode "BLUE";
_wp1 setWaypointCompletionRadius 400;

private _wp2 = _pilot_group addWaypoint [_paradropArea, 25];
_wp2 setWaypointType "MOVE";
_wp2 setWaypointSpeed "LIMITED"; // Slow down
_wp2 setWaypointCompletionRadius 400;
_pilot_group setVariable ["KPLIB_paradropWp", _wp2];

private _wp1Inf = _infGrp addWaypoint [_paradropArea, 0];
_wp1Inf setWaypointType "MOVE";
_wp1Inf setWaypointSpeed "FULL";
_infGrp setVariable ["KPLIB_infparadropWp", _wp1Inf];

_infGrp setSpeedMode "FULL";

// Drop off units
[_newPlane, _paradropArea, _pilot_group, _infGrp, _spawnPoint, _targetPos] spawn {
    params ["_newPlane", "_paradropArea", "_pilot_group", "_infGrp", "_spawnPoint", "_targetPos"];

    waitUntil {sleep 1; (_newPlane distance2D _paradropArea < 400) || (!alive _newPlane) || ({alive _x} count (units _infGrp) < 1)};

    if ((!alive _newPlane) || ({alive _x} count (units _infGrp) < 1)) exitWith {};

    _fnc_planeRTB = {
        params["_newPlane", "_returnMarker"];

        _newPlane flyInHeightASL [500, 500, 500];

        _waypoint = (group (driver _newPlane)) addWaypoint [getMarkerPos _returnMarker, 1000];
        _waypoint setWaypointType "MOVE";
        _waypoint setWaypointSpeed "FULL";
        _waypoint setWaypointBehaviour "CARELESS";
        _waypoint setWaypointCombatMode "BLUE";
        _waypoint setWaypointCompletionRadius 400;

        waitUntil {sleep 1; _newPlane distance2D getMarkerPos _returnMarker < 300};

        if (!alive _newPlane) exitWith {};
        deleteVehicleCrew _newPlane;
        deleteVehicle _newPlane;
    };

    // Add a waypoint to maintain path
    private _wp3 = _pilot_group addWaypoint [_newPlane getPos [1000, (getDir _newPlane)], 0];
    _wp3 setWaypointType "MOVE";
    _wp3 setWaypointCompletionRadius 400;

    {deleteWaypoint _x}forEachReversed waypoints _infGrp;
    [(units _infGrp)] allowGetIn false;
    [(units _infGrp)] orderGetIn false;
    {_x allowDamage false}forEach (units _infGrp);

    // Paradrop infantry
    {
        _x setVariable ["KPLIB_paratrooper_backpack", [backpack _x, backpackItems _x]];
        removeBackpack _x; 
        _x addBackPack KPLIB_o_parachuteType;
        sleep 0.5;
        unassignVehicle _x;
        moveout _x;
    } forEach (units _infGrp);

    {_x allowDamage true}forEach (units _infGrp);

    // Plane RTB
    [_newPlane, _spawnPoint] spawn _fnc_planeRTB;

    _fnc_checkLanding = {
        params ["_infGrp", "_paradropArea", "_targetPos"];

        if (({alive _x && [_x] call KPLIB_fnc_ace_isAwake} count (units _infGrp)) < 1) exitWith {true};

        // Detect units that landed on water or uncounsionus, delete them
        private _unableUnits = (units _infGrp) select {(isTouchingGround _x || ((getPosATL _x # 2) < 2)) && {surfaceIsWater (getPosATL _x) || !([_x] call KPLIB_fnc_ace_isAwake)} };

        {
            if !([_x] call KPLIB_fnc_ace_isAwake) then {_x setDamage 1} else {deleteVehicle _x};
        }forEach _unableUnits;

        {isTouchingGround _x || ((getPosATL _x # 2) < 2)} count (units _infGrp) >= count (units _infGrp)
    };

    // Check landing
    waitUntil {sleep 1; [_infGrp, _paradropArea, _targetPos] call _fnc_checkLanding};

    if (({alive _x && [_x] call KPLIB_fnc_ace_isAwake} count (units _infGrp)) < 1) exitWith {};

    // Spawns an orange smoke in the paradrop assembling area
    private _moduleGroup = createGroup [sideLogic, true];
    "ModuleSmokeOrange_F" createUnit [
        _paradropArea,
        _moduleGroup,
        "this setVariable ['BIS_fnc_initModules_disableAutoActivation', false, true];"
    ];

    // Return the backpack contents for each unit
    {
        private _unit = _x;
        private _backpackContents = _unit getVariable ["KPLIB_paratrooper_backpack", []];
        if (count _backpackContents < 1) then {continue};
        _unit addBackpack (_backpackContents # 0);
        {_unit addItemToBackpack _x} foreach (_backpackContents # 1);
    }forEach (units _infGrp);

    // Units arriving at regroup locations
    waitUntil {
        sleep 5;
        // Keep IA units moving to reach assembling area
        {
            if (_x distance _paradropArea > 100) then {_x doMove _paradropArea;};
        }forEach units (_infGrp);

        {(_x distance (leader _infGrp) < 125) && {alive _x} && {[_x] call KPLIB_fnc_ace_isAwake}} count (units _infGrp) >= (count units _infGrp)
    };

    if (({alive _x && [_x] call KPLIB_fnc_ace_isAwake} count (units _infGrp)) < 1) exitWith {};


    [_infGrp, _targetPos] call KPLIB_fnc_infantryAttack; // Commit inf to attack
    _infGrp setVariable ["KPLIB_isBattleGroup", true];
    [_infGrp] call KPLIB_fnc_LAMBS_enableReinforcements;
};

if (_notify) then {
    ["KPLIB_reinfIncoming", [_spawnPoint, _targetPos]] call CBA_fnc_globalEvent;
};

["KPLIB_battlegroupSpawn", [_infGrp, _spawnPoint]] call CBA_fnc_serverEvent; // Pass only inf group to HC

[_pilot_group, _infGrp]