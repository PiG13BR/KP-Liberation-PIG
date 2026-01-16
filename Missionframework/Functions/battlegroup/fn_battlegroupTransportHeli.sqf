/*
    File: fn_battlegroupTransportHeli.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 16/10/2025
    Last Update: 08/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns an helicopter that lands and drop off troops and then despawns

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

if (!isServer) exitWith {[]};

// Get heli class if not provided
if (_heliClass isEqualTo "") then {
    _heliClass = selectRandom KPLIB_o_helicopters;
    while {!(_heliClass in KPLIB_o_troopTransports)} do {
        _heliClass = selectRandom KPLIB_o_helicopters;
    };
};
if (_heliClass isEqualTo "") exitWith {[]};

// Get target position if not provided
if (_targetPos isEqualTo [0 ,0 ,0]) then {
    _targetPos = [_targetPos] call KPLIB_fnc_getBluforObjective;
};
if (_targetPos isEqualTo []) exitWith {[]};

// Get spawn point if not provided
if (_spawnPoint isEqualTo "") then {
    _spawnPoint = [1500, 4000, false, _targetPos] call KPLIB_fnc_getOpforSpawnPoint;
};
if (_spawnPoint isEqualTo "") exitWith {[]};

// Find land area
private _landArea = [0,0];
private _tries = 0;
while {_tries < 4} do {
    _tries = _tries + 1;
    _landArea = [[[_targetPos, 1500]], [], 
    {
        (_this distance2D _targetPos > 400) && 
        (_this distance2D _targetPos < 700) && 
        {_this isFlatEmpty [10, -1, 0.3, 5, 0, false] isNotEqualTo []}
    }] call BIS_fnc_randomPos;
    if (_landArea isNotEqualTo [0,0]) exitWith {}; // Exit on pos found
};

if (_landArea isEqualTo [0,0]) exitWith {[format["No land area found in %1", _targetPos], "HELICOPTER TRANSPORT"] call KPLIB_fnc_log; []};

// Put spawn marker in a cooldown. Not going to be used for the next minutes.
if (isNil "KPLIB_usedOpforSpawnPoints") then {
    KPLIB_usedOpforSpawnPoints = [];
};
KPLIB_usedOpforSpawnPoints pushBack _spawnPoint;

private _newHeli = createVehicle [_heliClass, markerpos _spawnPoint, [], 0, "FLY"];
if (isNull _newHeli) exitWith {[format["No helicopter spawned %1", _targetPos], "HELICOPTER TRANSPORT"] call KPLIB_fnc_log; []};
private _pilot_group = [_newHeli, KPLIB_side_enemy] call KPLIB_fnc_createCrew;

_newHeli addMPEventHandler ["MPKilled", {
    params ["_unit", "_killer"];
    ["KPLIB_manageKills", [_unit,_killer]] call CBA_fnc_localEvent;
}];
{
    _x addMPEventHandler ["MPKilled", {
        params ["_unit", "_killer"];
        ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
    }];
} forEach (crew _newHeli);

{ deleteWaypoint _x } forEachReversed waypoints _pilot_group;

// Spawn inf in cargo
private _infGrp = [_newHeli] call KPLIB_fnc_spawnInfCargo;
if (isNull _infGrp) exitWith {deleteVehicle _newHeli; []};

_newHeli flyInHeight 100;

_pilot_group setBehaviour "CARELESS";
/*
_waypoint = _pilot_group addWaypoint [_targetPos, 25];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointSpeed "FULL";
_waypoint setWaypointBehaviour "CARELESS";
_waypoint setWaypointCombatMode "BLUE";
_waypoint setWaypointCompletionRadius 100;
*/

// Prepare to land
private _heliPad = "Land_HelipadEmpty_F" createVehicle [0,0,0];
_heliPad setPosATL _landArea;
_newHeli landAt [_heliPad, "GetOut", 30];

// Drop off units 
[{
    _this params ["_heli", "_infGrp"];

    isTouchingGround _heli || (((getPosATL _heli) # 2) < 2)
}, {
    _this params ["_heli", "_infGrp", "_heliPad"];

    if !(alive _heli) exitWith {deleteVehicle _heliPad;};

    [(units _infGrp)] allowGetIn false;
    [(units _infGrp)] orderGetIn false;
    {
        _x setUnitPos "MIDDLE";
        unassignVehicle _x;
        moveout _x;
    } forEach (units _infGrp);
}, [_newHeli, _infGrp, _heliPad]
] call CBA_fnc_waitUntilAndExecute;

// Heli RTB
[{
    _this params ["_heli", "_infGrp"];

    isTouchingGround _heli && ({_x in _heli} count (units _infGrp) < 1)
}, {
    _this params ["_heli", "_infGrp", "_targetPos", "_spawnPoint", "_heliPad"];

    if !(alive _heli) exitWith {deleteVehicle _heliPad;};

    [_infGrp, _targetPos] call KPLIB_fnc_battlegroupAttack; // Commit inf to attack
    [_heli, _spawnPoint, _heliPad] call KPLIB_fnc_heliRTB; // Heli RTB
}, [_newHeli, _infGrp, _targetPos, _spawnPoint, _heliPad]
] call CBA_fnc_waitUntilAndExecute;

KPLIB_fnc_heliRTB = {
    params["_heli", "_returnMarker", "_heliPad"];

    _heli landAt [_heliPad, "None", 0]; // Cancel landAt command
    deleteVehicle _heliPad;

    _waypoint = (group (driver _heli)) addWaypoint [getMarkerPos _returnMarker, 0];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointSpeed "FULL";
    _waypoint setWaypointBehaviour "CARELESS";
    _waypoint setWaypointCombatMode "BLUE";
    _waypoint setWaypointCompletionRadius 100;

    [{
        _this params ["_heli", "_despawnPos"];

        (_heli distance2D _despawnPos) < 200 || {!alive _heli}
    }, {
        _this params ["_heli"];
        
        if (!alive _heli) exitWith {};
        deleteVehicleCrew _heli;
        deleteVehicle _heli;
        
    }, [_heli, getMarkerPos _returnMarker]
    ] call CBA_fnc_waitUntilAndExecute;
};

if (_notify) then {
    ["KPLIB_reinfIncoming", [_spawnPoint, _targetPos]] call CBA_fnc_globalEvent;
};

["KPLIB_battlegroupSpawn", [_infGrp]] call CBA_fnc_serverEvent;

[_pilot_group, _infGrp]