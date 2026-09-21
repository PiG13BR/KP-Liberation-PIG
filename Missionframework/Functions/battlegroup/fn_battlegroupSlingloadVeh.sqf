/*
    File: fn_battlegroupSlingLoadVeh.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 06/06/2026
    Last Update: 20/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns an helicopter that lands and drop off troops and then despawns

    Parameter(s):
        _heliClass - vehicle classname [STRING, defaults to ""]
		_targetPos - position to attack [POSITION, defaults to [0 ,0 ,0]
        _spawnPoint - spawn point or sector reference [STRING, defaults to ""]
        _notify - notify players [BOOL, defaults to true]

    Returns:
        Spanwed groups [ARRAY]
*/

params [
	["_heliClass", "", [""]],
	["_targetPos", [0 ,0 ,0], [[]]],
	["_spawnPoint", "", [""]],
    ["_notify", true, [false]]
];

private _hc = [] call KPLIB_fnc_getLessLoadedHC;
if (!isNull _hc) exitWith {
    _this remoteExecCall ["KPLIB_fnc_battlegroupSlingloadVeh", _hc]
};

// Get heli class if not provided
if (_heliClass isEqualTo "") then {
	_heliClass = selectRandom KPLIB_o_slingHelicopters;
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

// Select vehicles in pool that can be slingloaded
private _vehClass = selectRandom KPLIB_o_slingVehicles;

// Create vehicle to sling
private _veh = [markerPos _spawnPoint, _vehClass, 10] call KPLIB_fnc_spawnVehicle;
private _grpVeh = (group (driver _veh));
_veh allowCrewInImmobile true;

// Disable some features while beign carried
if (local _veh) then {
	_veh disableAI "AUTOTARGET";
	_veh disableAI "TARGET";
	_veh disableAI "FIREWEAPON";
} else {
	[_veh, "AUTOTARGET"] remoteExec ["disableAI", _veh];
	[_veh, "TARGET"] remoteExec ["disableAI", _veh];
	[_veh, "FIREWEAPON"] remoteExec ["disableAI", _veh];
};

// Create helicopter
private _heli = [markerPos _spawnPoint, _heliClass, 50] call KPLIB_fnc_spawnVehicle;
private _grpHeli = (group (driver _heli));
// private _wp = _grpHeli addWaypoint [getMarkerPos "unloadPoint", 0];
// _wp setWaypointType "UNHOOK"; // It fails, nothing in arma is easy

// Helicopter attributes
_grpHeli setBehaviour "CARELESS";
_heli flyInHeightASL [100,100,100];

// Make hooked vehicle explode once it touches ground if the helicopter get shows down
_heli addEventHandler ["Killed", {
	params["_helicopter"];
	private _cargo = getSlingLoad _helicopter;
	if ((!isNull _cargo) && {((getPosATL _cargo) # 2) >= 10}) then {
		[
			{isTouchingGround _this || ((getPosATL _this) # 2) < 1}, 
			{_this setDamage 1}, 
			_cargo,
			15, // Timeout
			{_this setDamage 1}
		] call CBA_fnc_waitUntilAndExecute;
	};
}];

// Mass
_veh setVariable ["KPLIB_OriginalMass", (getMass _veh)];
private _vehMass = getNumber(configFile >> "CfgVehicles" >> _heliClass >> "slingLoadMaxCargoMass");
if (getMass _veh > _vehMass) then {
	if (local _veh) then {
		_veh setMass (_vehMass - 100);
	} else {
		[_veh, (_vehMass - 100)] remoteExec ["setMass", _veh];
	};
};

[_spawnPoint, _targetPos, _landArea, _heli, _veh, _grpVeh] spawn {
	params["_spawnPoint", "_targetPos", "_landArea", "_heli", "_veh", "_grpVeh"];

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

		waitUntil {sleep 1; (_heli distance2D (getMarkerPos _returnMarker)) < 200 || {!alive _heli} || {alive _x || [_x] call KPLIB_fnc_ace_isAwake} count crew _heli < 1};

		if (!alive _heli) exitWith {};
		deleteVehicleCrew _heli;
		deleteVehicle _heli;
		private _vehLoaded = getSlingLoad _heli;
		if !(isNull _vehLoaded) then {deleteVehicleCrew _vehLoaded; deleteVehicle _vehLoaded};
	};

	// Sling load vehicle
	_heli setSlingLoad _veh;
	if (isNull (getSlingLoad _heli)) exitWith {
		[_heli] call KPLIB_fnc_cleanOpforVehicle; 
		[_veh] call KPLIB_fnc_cleanOpforVehicle
	};

	// Return slingloaded vehicle to its normal mass
	_heli addEventHandler ["RopeBreak", {
		params ["_object1", "_rope", "_object2"];

		private _vehMass = _object2 getVariable ["KPLIB_OriginalMass", -1];
		if (_vehMass == -1) exitWith {};

		if (local _object2) then {
			_object2 setMass _vehMass;
		} else {
			[_object2, _vehMass] remoteExec ["setMass", _object2];
		};
	}];

	private _heliPad = createVehicle ["Land_HelipadEmpty_F", _landArea];

	// Force land to touch the cargo on the ground
	_heli landAt [_heliPad, "Land", -1];

	waitUntil {sleep 1; (_heli distance2d _landArea) < 500};

	if ((!alive _heli) || (({alive _x || [_x] call KPLIB_fnc_ace_isAwake} count (crew _heli)) < 1)) exitWith {deleteVehicle _heliPad};

	if ((!alive _veh) || (({alive _x || [_x] call KPLIB_fnc_ace_isAwake} count (crew _veh)) < 1) || {isNull (getSlingLoad _heli)}) exitWith {
		// Force chopper RTB
		[_heli, _spawnPoint, _heliPad] spawn KPLIB_fnc_heliRTB; // Heli RTB
	};

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

	waitUntil {sleep 1; (((getPos _heli) # 2) < 13) || isTouchingGround(getSlingLoad _heli)};

	if ((!alive _heli) || (({alive _x || [_x] call KPLIB_fnc_ace_isAwake} count (crew _heli)) < 1)) exitWith {deleteVehicle _heliPad};

	// Unhook cargo
	_heli setSlingLoad objNull; 
	_veh setVectorUp surfaceNormal (position _veh); // Unflip vehicle
	[_veh] call KPLIB_fnc_allowCrewInImmobile;
	_heli flyInHeightASL [75,75,75];

	// Enable features back
	if (local _veh) then {
		_veh enableAI "AUTOTARGET";
		_veh enableAI "TARGET";
		_veh enableAI "FIREWEAPON";
	} else {
		[_veh, "AUTOTARGET"] remoteExec ["enableAI", _veh];
		[_veh, "TARGET"] remoteExec ["enableAI", _veh];
		[_veh, "FIREWEAPON"] remoteExec ["enableAI", _veh];
	};

	[_heli, _spawnPoint, _heliPad] spawn KPLIB_fnc_heliRTB; // Heli RTB

	[_veh, _targetPos] call KPLIB_fnc_vehicleAttack;
	_grpVeh setVariable ["KPLIB_isBattleGroup", true];
};

if (_notify) then {
    ["KPLIB_reinfIncoming", [_spawnPoint, _targetPos]] call CBA_fnc_globalEvent;
};

["KPLIB_battlegroupSpawn", [_grpVeh, _spawnPoint]] call CBA_fnc_serverEvent;

[_grpHeli, _grpVeh]