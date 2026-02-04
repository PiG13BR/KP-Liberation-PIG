/*
    File: fn_SAM_createSite.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 05/12/2025
    Last Update: 27/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT
    
    Description:
        Crates SAM Site based on templates
    
    Parameter(s):
        -
    
    Returns:
        -
*/

// Create site
private _spawnMarker = [] call KPLIB_fnc_SAM_getOpforSpawnPoint;
if (_spawnMarker isEqualTo "") exitWith {false};

KPLIB_SAM_sitePositions pushBack _spawnMarker;
publicVariable "KPLIB_SAM_sitePositions";

private _samSitePos = markerpos _spawnMarker;
private _samSiteObjects = [];
private _samSiteTurrets = [];
private _samShorads = [];
private _infPatrols = [];
private _infGarrison = [];
private _staticGroup = [];

// Select template
private _samTemplate = [] call compile preprocessFileLineNumbers (selectRandom KPLIB_SAM_templates);

_samTemplate params ["_radarCenter", "_turrets", "_shorads",  "_statics", "_garrisons", "_objects"];

[_samSitePos, 75] call KPLIB_fnc_createClearance;

// Get nearest fob position 
private _fobPos = [_samSitePos] call KPLIB_fnc_getNearestFob;
private _relDir = _samSitePos getDir _fobPos;

// Spawn radar (used as a reference for the other objects to spawn in)
_radarCenter params ["_classRadar", "_posRadar", "_dirRadar"];
if (_dirRadar > 0 && _dirRadar < 360) then {_dirRadar = 0};
//private _objPos = [((_samSitePos select 0) + (_posRadar select 0)), ((_samSitePos select 1) + (_posRadar select 1)), 0];
private _radar = [_samSitePos, (selectRandom _classRadar), true] call KPLIB_fnc_spawnVehicle;

// Find driver and delete it
if (!isNull (driver _radar)) then {_radar deleteVehicleCrew (driver _radar)};

// Create SAM Site group
private _group = createGroup [KPLIB_side_enemy, true];
private _crewRadar = units _radar;
[_crewRadar, _group] remoteExecCall ["joinSilent"];
_radar allowDamage false;
_radar setVectorUp [0, 0, 1];
_radar setDir (_relDir - _dirRadar);
[_radar] call KPLIB_fnc_clearCargo;
//_radar setPosATL _objPos;
[{_this allowDamage true}, _radar, 3] call CBA_fnc_waitAndExecute;

_radar setAutonomous true;
_radar setVehicleReceiveRemoteTargets true;
_radar setVehicleReportRemoteTargets true;

_radar setVariable ["KPLIB_samSiteGroup", _group]; // Save to avoid grpNull

// Skills
{
	_x setSkill ["spotDistance", 1];
	_x setSkill ["aimingAccuracy", 0.8];
	_x setSkill ["aimingSpeed", 0.8];
	_x setSkill ["spotTime", 1];
}forEach _crewRadar;

// SAM launchers
private _samCount = 1; // Default: spawn one
if (KPLIB_enemyReadiness >= 50) then {_samCount = _samCount + 1};
if (KPLIB_enemyReadiness >= 75) then {_samCount = _samCount + 1};
if (KPLIB_enemyReadiness >= 100) then {_samCount = _samCount + 1};

{
	if (_forEachIndex > _samCount) exitWith {};
	_x params ["_classes", "_pos", "_dir"];
	
	private _samClass = selectRandom _classes;

	private _samPos = (_radar modelToWorld _pos);
	private _sam = [_samPos, _samClass] call KPLIB_fnc_spawnVehicle;
	private _crew = units _sam;
    [_crew, _group] remoteExecCall ["joinSilent"];

	// Find driver and delete it
	if (!isNull (driver _sam)) then {_sam deleteVehicleCrew (driver _sam)};

	_sam allowDamage false;
	_sam setVectorUp [0, 0, 1];
	_sam setDir (_dir + _relDir);
	_sam setPosATL _samPos;
	[_sam] call KPLIB_fnc_clearCargo;
	[{_this allowDamage true}, _sam, 3] call CBA_fnc_waitAndExecute;
    _sam setAutonomous true;

	_sam setVehicleReceiveRemoteTargets true;
	_sam setVehicleReportRemoteTargets true;

	// Skills
	{
		_x setSkill ["spotDistance", 1];
		_x setSkill ["aimingAccuracy", 1];
		_x setSkill ["aimingSpeed", 1];
		_x setSkill ["spotTime", 1];
	}forEach _crew;

	_samSiteTurrets pushBack _sam;
} forEach _turrets;

// SHORAD
{
	_x params ["_classes", "_pos", "_dir"];
	
	private _shoradClass = selectRandom _classes;

	private _shoradPos = (_radar modelToWorld _pos);
	private _shorad = [_shoradPos, _shoradClass] call KPLIB_fnc_spawnVehicle;
	private _crew = units _shorad;
    [_crew, _group] remoteExecCall ["joinSilent"];

	// Find driver and delete it
	if (!isNull (driver _shorad)) then {_shorad deleteVehicleCrew (driver _shorad)};

	_shorad allowDamage false;
	_shorad setVectorUp [0, 0, 1];
	_shorad setDir (_dir + _relDir);
	_shorad setPosATL _shoradPos;
	[_shorad] call KPLIB_fnc_clearCargo;
	[{_this allowDamage true}, _shorad, 3] call CBA_fnc_waitAndExecute;
    _shorad setAutonomous true;

	_shorad setVehicleReceiveRemoteTargets true;
	_shorad setVehicleReportRemoteTargets true;

	// Skills
	{
		_x setSkill ["spotDistance", 1];
		_x setSkill ["aimingAccuracy", 0.8];
		_x setSkill ["aimingSpeed", 0.8];
		_x setSkill ["spotTime", 1];
	}forEach _crew;

	_samShorads pushBack _shorad;
} forEach _shorads;

if (_samShorads isNotEqualTo []) then {
	// Incoming missile EH >> try to defeat harm missiles
	[_radar, _samShorads] call KPLIB_fnc_SAM_incomingMissile;	
};

// SAM placement objects
{
	_x params ["_class", "_pos", "_dir"];

	private _objPos = (_radar modelToWorld _pos);
	private _object = _class createVehicle _objPos;
	_object allowDamage false;
	_object setVectorUp [0, 0, 1];
	_object setDir (_dir + _relDir); 
	_object setPosATL _objPos;
	[_object] call KPLIB_fnc_clearCargo;
	// Fix for floating objects
	_object setPosATL [getPos _object # 0, getPos _object # 1, 0];
	// Rotation vector fix
	_object setVectorUp surfaceNormal position _object;

	if (_object isKindOf "landVehicle") then {_object setVehicleLock "LOCKED"};

	[{_this allowDamage true}, _object, 3] call CBA_fnc_waitAndExecute;
 
	_samSiteObjects pushBack _object;
} forEach _objects;

// Garrison buildings
{
	_x params ["_class", "_pos", "_dir"];

	private _objPos = (_radar modelToWorld _pos);
	private _garrison = _class createVehicle _objPos;

	_garrison setVectorUp [0, 0, 1];
	_garrison setDir (_dir + _relDir); 
	_garrison setPosATL _objPos;

	// Fix for floating objects
	_garrison setPosATL [getPos _garrison # 0, getPos _garrison # 1, 0];
	// Rotation vector fix
	_garrison setVectorUp surfaceNormal position _garrison;

	[{_this allowDamage true}, _garrison, 3] call CBA_fnc_waitAndExecute;

	private _squadGrp = [_garrison] call KPLIB_fnc_spawnBuildingGarrison;
	
	_samSiteObjects pushBack _garrison;
	_infGarrison pushBack _squadGrp;
}forEach _garrisons;

// Static weapons
private _groupStatic = createGroup [KPLIB_side_enemy, true];
{
	_x params ["_classes", "_pos", "_dir"];

	private _staticClass = selectRandom _classes;

	private _staticPos = (_radar modelToWorld _pos);
	_staticPos = +_staticPos;
	_staticPos set [2, (_pos # 2)];
	//private _static = [_staticPos, _staticClass, true] call KPLIB_fnc_spawnVehicle;
	private _static = createVehicle [_staticClass, _staticPos, [], 0, "CAN_COLLIDE"];
	_static allowDamage false;

	[_static, KPLIB_side_enemy, _groupStatic] call KPLIB_fnc_createCrew;

	private _crew = units _static;
    [_crew, _groupStatic] remoteExecCall ["joinSilent"];
	
	//_static setVectorUp [0, 0, 1];
	_static setDir (_dir + _relDir);
	//_static setPosATL _staticPos;
	[_static] call KPLIB_fnc_clearCargo;
	[{_this allowDamage true}, _static, 3] call CBA_fnc_waitAndExecute;

	[{_this doWatch (_this getPos [300, (getDir _this)]);}, _static, 10] call CBA_fnc_waitAndExecute;

	_staticGroup pushBack _groupStatic;
	_samSiteObjects pushBack _static;
}forEach _statics;

// Infantry patrol
private _squad1 = ["army"] call KPLIB_fnc_getSquadComp;
private _squad2 = [];
if (KPLIB_enemyReadiness >= 50) then {_squad2 = ["army"] call KPLIB_fnc_getSquadComp;};

// Spawn squads
{
    if (count _x < 1) then {continue};
	
    private _grp = [_spawnMarker, _x] call KPLIB_fnc_spawnRegularSquad;
    if (KPLIB_LAMBS) then {
        [_grp, _samSitePos, 150, 4 + ceil(random 4), [], true] call lambs_wp_fnc_taskPatrol;
    } else {
        [_grp, _samSitePos, 150, 3, 1] call CBA_fnc_taskDefend;
    };

    _infPatrols pushBack _grp;
}forEach [_squad1, _squad2];

// Spawn ammunition crate
private _amount = (ceil (random 2)) * KPLIB_param_resourcesMulti;
for "_i" from 1 to _amount do {
	private _spawnPos = (_samSitePos getPos [random 50, random 50]) findEmptyPosition [10, 40, KPLIB_b_crateAmmo];
	[selectRandom [KPLIB_b_crateAmmo, KPLIB_b_crateSupply, KPLIB_b_crateFuel], 100, _spawnPos] call KPLIB_fnc_createCrate;
};

// If custom config is enabled, monitor the area
if (KPLIB_param_SAMSite == 2) then {
    [_radar, _samSiteTurrets] call KPLIB_fnc_SAM_customRadarRange;
};

// Silly loop to keep AI radar watch all directions.
[{
	params["_radar", "_handle"];

	if (!alive _radar || {!alive (gunner _radar)}) exitWith {[_handle] call CBA_fnc_removePerFrameHandler};

	private _watchDir = (_radar getVariable ["KPLIB_radarWatchDir", getDir _radar]) + 30;
	_radar doWatch (_radar getPos [300, _watchDir]);
	_radar setVariable ["KPLIB_radarWatchDir", _watchDir];
}, 10, _radar] call CBA_fnc_addPerFrameHandler;

[_spawnMarker, _radar, _samSiteTurrets, _samSiteObjects, _samShorads, _staticGroup, _infGarrison, _infPatrols] call KPLIB_fnc_SAM_monitorSitePFH;

[format["Enemy SAM Site created in position %1", _samSitePos], "SAM SITE"] call KPLIB_fnc_log;

true


