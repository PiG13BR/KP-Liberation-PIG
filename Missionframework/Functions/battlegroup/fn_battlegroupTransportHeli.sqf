/*
    File: fn_battlegroupTransportHeli.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 16/10/2025
    Last Update: 11/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns an helicopter that lands and drop off troops and then despawns

    Parameter(s):
        _heliClass - vehicle classname [STRING, defaults to ""]
		_targetPos - position to attack [POSITION, defaults to [0 ,0 ,0]
        _spawnPoint - spawn point or sector reference [STRING, defaults to ""]
        _notify - notify players [BOOL, defaults to true]

    Returns:
        Spawned groups [ARRAY]
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
    _heliClass = selectRandom (KPLIB_o_helicopters select {_x in KPLIB_o_troopTransports});
};
if (_heliClass isEqualTo "") exitWith {[]};

// Get target position if not provided
if (_targetPos isEqualTo [0 ,0 ,0]) then {
    _targetPos = [_targetPos] call KPLIB_fnc_getBluforObjective;
};
if (_targetPos isEqualTo []) exitWith {[]};

// Get spawn point if not provided
if (_spawnPoint isEqualTo "") then {
    _spawnPoint = [1500, 2500, false, _targetPos] call KPLIB_fnc_getOpforSpawnPoint;
};
if (_spawnPoint isEqualTo "") exitWith {[]};

// Find land area
private _landArea = [_targetPos, 700] call KPLIB_fnc_findPlaceToLand;

if (_landArea isEqualTo [0,0]) exitWith {[]};

// Put spawn marker in a cooldown. Not going to be used for the next minutes.
if (isNil "KPLIB_usedOpforSpawnPoints") then {
    KPLIB_usedOpforSpawnPoints = [];
};
KPLIB_usedOpforSpawnPoints pushBack _spawnPoint;

//private _newHeli = createVehicle [_heliClass, markerpos _spawnPoint, [], 0, "FLY"];
private _newHeli = [markerpos _spawnPoint, _heliClass] call KPLIB_fnc_spawnVehicle;
if (isNull _newHeli) exitWith {[format["No helicopter spawned %1", _targetPos], "HELICOPTER TRANSPORT"] call KPLIB_fnc_log; []};
//private _pilot_group = [_newHeli, KPLIB_side_enemy] call KPLIB_fnc_createCrew;
private _pilot_group = (group (driver _newHeli));

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

// Prepare to land
private _heliPad = "Land_HelipadEmpty_F" createVehicle [0,0,0];
_heliPad setPosATL _landArea;
_newHeli landAt [_heliPad, "GetOut", 30];

[_spawnPoint, _targetPos, _newHeli, _landArea, _infGrp, _heliPad] spawn {
    params["_spawnPoint", "_targetPos", "_heli", "_landArea", "_infGrp", "_heliPad"];

    private _fnc_heliRTB = {
        params["_heli", "_returnMarker", "_heliPad"];

        _heli landAt [_heliPad, "None", 0]; // Cancel landAt command
        deleteVehicle _heliPad;

        private _waypoint = (group (driver _heli)) addWaypoint [getMarkerPos _returnMarker, 0];
        _waypoint setWaypointType "MOVE";
        _waypoint setWaypointSpeed "FULL";
        _waypoint setWaypointBehaviour "CARELESS";
        _waypoint setWaypointCombatMode "BLUE";
        _waypoint setWaypointCompletionRadius 100;

        waitUntil {sleep 1; (_heli distance2D (getMarkerPos _returnMarker)) < 200 || {!alive _heli} || {alive _x || [_x] call KPLIB_fnc_ace_isAwake} count crew _heli < 1};

		if (!alive _heli) exitWith {};
        deleteVehicleCrew _heli;
		deleteVehicle _heli;
    };

    waitUntil {sleep 1; (_heli distance2d _landArea) < 500};

    // Split pilot-turret groups and reveal ground targets for heli gunners
    private _turretGrp = createGroup [KPLIB_side_enemy, true];
    private _fullCrew = fullCrew [_heli, "", true];
    {
        private _unit = _x # 0;
        if (_unit in (units _infGrp)) then {continue}; // Skip unit from the cargo group
        private _role = _x # 1;
        if (_role == "gunner" || _role == "turret") then {
            [_unit] join _turretGrp
        };
    }forEach _fullCrew;

    _turretGrp setBehaviour "COMBAT";
    _turretGrp setCombatMode "RED";
    private _bluforEntities = [_landArea, 250, KPLIB_side_player] call KPLIB_fnc_getNearbyEntities;

    {
        if (local _turretGrp) then {
            _turretGrp reveal [_x, 4];
        } else {
            [_turretGrp, [_x, 4]] remoteExec ["reveal"]
        }
    }forEach _bluforEntities;

    if ((!alive _heli) || (({alive _x || [_x] call KPLIB_fnc_ace_isAwake} count (crew _heli)) < 1)) exitWith {deleteVehicle _heliPad;};

    // Get countermeasures
	private "_counterMeasures";
	{
		private _currentWeapons = _heli weaponsTurret _x;
		_counterMeasures = _currentWeapons select {tolower ((_x call bis_fnc_itemType) select 1) in ["countermeasureslauncher"]};
		if (_counterMeasures isNotEqualTo []) exitWith {}; // Found
	}forEach ([[-1]] + allTurrets _heli);

	[_heli, _counterMeasures, _landArea] spawn {
		params["_heli", "_counterMeasures", "_landArea"];

		private _flareType = selectRandom _counterMeasures;
		if (isNil "_flareType") exitWith {}; // Flare type not found
		private _counterModes = (getArray (configFile >> "CfgWeapons" >> _flareType >> "modes"));

		// Fire flares until exit the area
		while {((_heli distance2d _landArea) < 500) && (alive _heli) && (({alive _x || [_x] call KPLIB_fnc_ace_isAwake} count (crew _heli)) > 0)} do {
			if (((getPosATL _heli) # 2) < 10) then {continue};
            (driver _heli) forceWeaponFire [_flareType, (selectRandom _counterModes)];
			sleep (2 + (random 1));
		};
	};

    waitUntil {sleep 1; isTouchingGround _heli || (((getPosATL _heli) # 2) < 2)};

    if ((!alive _heli) || (({alive _x || [_x] call KPLIB_fnc_ace_isAwake} count (crew _heli)) < 1)) exitWith {deleteVehicle _heliPad;};

    // Drop off units 
    [(units _infGrp)] allowGetIn false;
    [(units _infGrp)] orderGetIn false;

    {
        [_x, "MIDDLE"] remoteExec ["setUnitPos", _x];
        unassignVehicle _x;
        moveout _x;
        sleep 0.5;
    } forEach (units _infGrp);

    // Heli RTB
    waitUntil {sleep 1; {_x in _heli} count (units _infGrp) < 1};

    if !(alive _heli) exitWith {deleteVehicle _heliPad;};

    [_heli, _spawnPoint, _heliPad] spawn _fnc_heliRTB; // Heli RTB
    [_infGrp, _targetPos] call KPLIB_fnc_infantryAttack; // Commit inf to attack
    _infGrp setVariable ["KPLIB_isBattleGroup", true];
};

if (_notify) then {
    ["KPLIB_reinfIncoming", [_spawnPoint, _targetPos]] call CBA_fnc_globalEvent;
};

["KPLIB_battlegroupSpawn", [_infGrp, _spawnPoint]] call CBA_fnc_serverEvent;

[_pilot_group, _infGrp]