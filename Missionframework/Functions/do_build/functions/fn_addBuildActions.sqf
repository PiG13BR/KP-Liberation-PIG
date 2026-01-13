#include "..\defines.hpp"
/*
    File: fn_addBuildActions
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 28/08/2025
    Last update: 08/12/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
		Add build actions to the preplaced object

    Parameter(s)
		_object - object to add build actions [OBJECT, defaults to objNull]
		_player - player that is building the object [OBJECT, defaults to player]

    Returns:
        -
*/

params[["_object", objNull, [objNull]], ["_player", player, [objNull]]];

if (isNull _object) then {["Null object to add actions"] call BIS_fnc_error};

// Disable players actions with this variable
_player setVariable ["KPLIB_BUILD_isBuilding", true];

// Build action
private _objectSize = (boundingBoxReal _object # 2) * 1.05;
private _build_action = [
	_player,
	["<img size='1.5' color='#0ECD00' image='Functions\do_build\icons\check.paa'/>", " ", "<t color='#0ECD00' size='1.2' >", localize "STR_BUILD_ACTION_BUILD", "</t>"] joinString "",
	"\a3\ui_f\data\igui\cfg\actions\repair_ca.paa", 
	"\a3\ui_f\data\igui\cfg\actions\repair_ca.paa",
	// Condition to show
	toString{
		alive _this &&
		{isNull (objectParent _this)} && {!isNull (_this getVariable ["KPLIB_BUILD_preplacedObject", objNull])}
	},
	// Condition for the action to progress
	toString{
		private _object = (_arguments # 0);

		alive _caller &&
		{isNull (objectParent _caller)} && 
		{!isNull (_caller getVariable ["KPLIB_BUILD_preplacedObject", objNull])} &&
		{speed _caller == 0} &&
		{
			((typeOf _object) in KPLIB_collisionIgnoreObjects) ||
			{
				!((typeOf _object) in KPLIB_collisionIgnoreObjects) &&
				{(_object getVariable ["KPLIB_BUILD_canBuild", false])}
			}
		} &&
		{_object getVariable ["KPLIB_BUILD_isObjectInArea", true]}
	},
	{},
	// Code executed on every progress tick
	{
		private _source = localNamespace getVariable ["KPLIB_BUILD_buildingSoundSource", objNull];
		if (isNull _source) then {private _source = playSound "wrench_building"; localNamespace setVariable ["KPLIB_BUILD_buildingSoundSource", _source]}
	},
	// Code on completion
	{ 		
		params ["_player", "", "", "_arguments"];
		_arguments params ['_object', '', '_spheres'];

		// Remove spheres
		private _spheres = (localNamespace getVariable ["KPLIB_BUILD_areaSpheres", []]);
		{deleteVehicle _x}forEach _spheres;

		// Spawn builded object
		
		// Get local object attributes
		private _objectClass = (typeOf _object);
		private _objPos = getPosATL _object;
		private _objDir = getDir _object;

		// Delete local object
		detach _object;
		deleteVehicle _object;

		private _vector = localNamespace getVariable ["KPLIB_BUILD_vector", true];
		private _buildType = localNamespace getVariable ["KPLIB_BUILD_buildType", 1];
		private _withCrew = localNamespace getVariable ["KPLIB_BUILD_requireCrew", false];

		// Build object on the server side
		["KPLIB_buildObject", [_objectClass, _objPos, _objDir, _vector, _buildType, _withCrew, _player]] call CBA_fnc_serverEvent;
		
		// Reset variables
		[_player, false] call KPLIB_fnc_buildCameraAssist;
		{_player removeAction _x}forEach (_player getVariable ["KPLIB_BUILD_playerActions", []]);
		[_player] call KPLIB_fnc_deleteBuildVariables;

		if !(isNil "KPLIB_doBuild_eachFrame") then {
			removeMissionEventHandler ["EachFrame", KPLIB_doBuild_eachFrame]
		};

		_player setVariable ["KPLIB_BUILD_isBuilding", false];
		/*
			// Remove EH from player
			{
				_x params ["_event", "_handle"];
				_player removeEventHandler [_event, _handle]
			}forEach (_player getVariable ["KPLIB_BUILD_playerEH", []]);
		*/
	},
	// Code on interrupted
	{
		private _object = (_arguments # 0);
		if !((typeOf _object) in KPLIB_collisionIgnoreObjects) then {
			if (_object getVariable ["KPLIB_BUILD_isObjectInArea", false]) then {
				//private _spheres = (_object getVariable ["KPLIB_BUILD_objectSpheres", []]);
				private _areaSpheres = localNamespace getVariable ["KPLIB_BUILD_areaSpheres", []];
				_nearestObjects = (nearestObjects [_object, ["AllVehicles", "Things", "ThingX", "Building", "Ruins"], (_arguments # 1), false] - [_object, _caller] - _areaSpheres);
				if (_nearestObjects isNotEqualTo []) then {
					[format [localize "STR_PLACEMENT_IMPOSSIBLE", count _nearestObjects, (_arguments # 1) toFixed 0], true, 3] call KPLIB_fnc_hint;
				};
			}
		};
		if !(_object getVariable ["KPLIB_BUILD_isObjectInArea", false]) then {
			[format [localize "STR_BUILD_ERROR_DISTANCE", KPLIB_range_fob], true, 3] call KPLIB_fnc_hint;
		};
	},
	[_object, _objectSize], // Arguments
	KPLIB_doBuildCoef * (_objectSize), // Time to build
	-500, 
	true, 
	false
] call BIS_fnc_holdActionAdd;

// Build & Repeat
private _repeat_build_action = [
	_player,
	["<img size='1.5' color='#0ECD00' image='Functions\do_build\icons\plus.paa'/>", " ", "<t color='#0ECD00' size='1.2' >", localize "STR_BUILD_ACTION_BUILDREPEAT", "</t>"] joinString "",
	"\a3\ui_f\data\igui\cfg\actions\repair_ca.paa", 
	"\a3\ui_f\data\igui\cfg\actions\repair_ca.paa",
	// Condition to show
	toString{
		alive _this &&
		{isNull (objectParent _this)} && {!isNull (_this getVariable ["KPLIB_BUILD_preplacedObject", objNull])} && 
		{[localNamespace getVariable ["KPLIB_BUILD_itemToBuild", []]] call KPLIB_fnc_build_isItemAffordable}
	},
	// Condition to progress
	toString{
		private _object = (_arguments # 0);
		alive _caller &&
		{isNull (objectParent _caller)} && 
		{!isNull (_caller getVariable ["KPLIB_BUILD_preplacedObject", objNull])} &&
		{speed _caller == 0} &&
		{
			((typeOf _object) in KPLIB_collisionIgnoreObjects) ||
			{
				!((typeOf _object) in KPLIB_collisionIgnoreObjects) &&
				{(_object getVariable ["KPLIB_BUILD_canBuild", false])}
			}
		} &&
		{_object getVariable ["KPLIB_BUILD_isObjectInArea", true]}
	},
	{},
	// Code executed on every progress tick
	{
		private _source = localNamespace getVariable ["KPLIB_BUILD_buildingSoundSource", objNull];
		if (isNull _source) then {private _source = playSound "wrench_building"; localNamespace setVariable ["KPLIB_BUILD_buildingSoundSource", _source]}
	},
	// Code on completion
	{ 		
		params ["_player", "", "", "_arguments"];
		_arguments params ['_object', '', '_spheres'];

		// Remove spheres
		private _spheres =  (localNamespace getVariable ["KPLIB_BUILD_areaSpheres", []]);
		{deleteVehicle _x}forEach _spheres;

		// Reset variables
		_player setVariable ["KPLIB_BUILD_preplacedObject", nil];
		{_player removeAction _x}forEach (_player getVariable ["KPLIB_BUILD_playerActions", []]);

		// Spawn builded object

		// Get local object attributes
		private _objectClass = (typeOf _object);
		private _objPos = getPosATL _object;
		private _objDir = getDir _object;

		// Delete local object
		detach _object;
		deleteVehicle _object;

		private _vector = localNamespace getVariable ["KPLIB_BUILD_vector", true];
		private _buildType = localNamespace getVariable ["KPLIB_BUILD_buildType", 1];
		private _withCrew = localNamespace getVariable ["KPLIB_BUILD_requireCrew", false];

		private _repeat = true;

		// Build object on the server side
		["KPLIB_buildObject", [_objectClass, _objPos, _objDir, _vector, _buildType, _withCrew, _player, _repeat]] call CBA_fnc_serverEvent;

		/*
			// Remove EH from player
			{
				_x params ["_event", "_handle"];
				_player removeEventHandler [_event, _handle]
			}forEach (_player getVariable ["KPLIB_BUILD_playerEH", []]);
		*/
	},
	// Code on interrupted
	{
		private _object = (_arguments # 0);
		if !((typeOf _object) in KPLIB_collisionIgnoreObjects) then {
			if (_object getVariable ["KPLIB_BUILD_isObjectInArea", false]) then {
				//private _spheres = (_object getVariable ["KPLIB_BUILD_objectSpheres", []]);
				private _areaSpheres = localNamespace getVariable ["KPLIB_BUILD_areaSpheres", []];
				_nearestObjects = (nearestObjects [_object, ["AllVehicles", "Things", "ThingX", "Building", "Ruins"], (_arguments # 1), false] - [_object, _caller] - _areaSpheres);
				if (_nearestObjects isNotEqualTo []) then {
					[format [localize "STR_PLACEMENT_IMPOSSIBLE", count _nearestObjects, (_arguments # 1) toFixed 0], true, 3] call KPLIB_fnc_hint;
				};
			}
		};
		if !(_object getVariable ["KPLIB_BUILD_isObjectInArea", false]) then {
			[format [localize "STR_BUILD_ERROR_DISTANCE", KPLIB_range_fob], true, 3] call KPLIB_fnc_hint;
		};
	},
	[_object, _objectSize], // Arguments
	KPLIB_doBuildCoef * (_objectSize), // Time to build
	-501, 
	true, 
	false
] call BIS_fnc_holdActionAdd;

// Cancel action
private _cancelBuild_action = _player addAction [
	["<img size='1.5' color='#F20000' image='Functions\do_build\icons\cross.paa'/>", " ", "<t color='#F20000' size='1.2' >", localize "STR_BUILD_ACTION_CANCEL", "</t>"] joinString "",
	{
		params ["_player"];
		private _object = _player getVariable ["KPLIB_BUILD_preplacedObject", objNull];

		[_object, _player] call KPLIB_fnc_cancelBuilding;
	},
	nil,
	-502,
	true,
	false,
	"",
	toString {
		alive _this &&
		{isNull (objectParent _this)} && {!isNull (_this getVariable ["KPLIB_BUILD_preplacedObject", objNull])} &&
		{(localNamespace getVariable ["KPLIB_BUILD_buildType", 1]) isNotEqualTo BUILDTYPE_FOB}
	}
];

// Raise
private _up_action = _player addAction [
	["<img size='1.2' color='#FFFF00' image='Functions\do_build\icons\up.paa'/>", " ", "<t color='#FFFF00'>", localize "STR_BUILD_ACTION_RAISE", "</t>"] joinString "",
	{
		params ["_player"];
		private _object = _player getVariable ["KPLIB_BUILD_preplacedObject", objNull];
		private _Ycoord = localNamespace getVariable ["KPLIB_BUILD_objectYCoord", ceil(boundingBoxReal _object # 2) * 1.3];
		private _elevation = localNamespace getVariable ["KPLIB_BUILD_objectElevation", 1];
		private _newElevation = _elevation + 0.2;
		localNamespace setVariable ["KPLIB_BUILD_objectElevation", _newElevation];
		_object attachTo [_player, [0, _Ycoord, _newElevation]];

		// Adjust spheres
		/*
		private _dist = 0.6 * (boundingBoxReal _object # 2);
		if (_dist < 5) then { _dist = 5 };
		{	
			_x setPos (_object getPos [_dist, 12 * _forEachIndex]);
			_x attachTo [_object];
		}forEach (_object getVariable ["KPLIB_BUILD_objectSpheres", []]);
		*/
		
	},
	nil,
	-503,
	true,
	false,
	"",
	toString {
		alive _originalTarget &&
		_this in _this && {!isNull (_this getVariable ["KPLIB_BUILD_preplacedObject", objNull])}
	}
];

// Lower
private _down_action = _player addAction [
	["<img size='1.2' color='#FFFF00' image='Functions\do_build\icons\down.paa'/>", " ", "<t color='#FFFF00'>", localize "STR_BUILD_ACTION_LOWER", "</t>"] joinString "",
	{
		params ["_player"];
		private _object = _player getVariable ["KPLIB_BUILD_preplacedObject", objNull];
		private _Ycoord = localNamespace getVariable ["KPLIB_BUILD_objectYCoord", ceil(boundingBoxReal _object # 2) * 1.3];
		private _elevation = localNamespace getVariable ["KPLIB_BUILD_objectElevation", 1];
		private _newElevation = _elevation - 0.2;
		if (((getPosATL _object) # 2) < 0) exitWith {_object setVectorUp surfaceNormal position _object;};
		localNamespace setVariable ["KPLIB_BUILD_objectElevation", _newElevation];
		_object attachTo [_player, [0, _Ycoord, _newElevation]];

		// Adjust spheres
		/*
		private _dist = 0.6 * (boundingBoxReal _object # 2);
		if (_dist < 5) then { _dist = 5 };
		{	
			_x setPos (_object getPos [_dist, 12 * _forEachIndex]);
			_x attachTo [_object];
		}forEach (_object getVariable ["KPLIB_BUILD_objectSpheres", []]);
		*/
	},
	nil,
	-504,
	true,
	false,
	"",
	toString {
		alive _originalTarget &&
		_this in _this && {!isNull (_this getVariable ["KPLIB_BUILD_preplacedObject", objNull])}
	}
];

// Rotate right
private _rotateRight_action = _player addAction [
	["<img size='1.2' color='#FFFF00' image='Functions\do_build\icons\rotate-right.paa'/>", " ", "<t color='#FFFF00'>", localize "STR_BUILD_ACTION_ROTATE_RIGHT", "</t>"] joinString "",
	{
		params ["_player"];
		private _object = _player getVariable ["KPLIB_BUILD_preplacedObject", objNull];
		_rotation = _object getVariable ["PIG_objectRotation", 0];
		_newRotation = _rotation + 45;
		_object setVariable ["PIG_objectRotation", _newRotation];
        _object setDir _newRotation;
		_object setPosWorld getPosWorld _object;
	},
	nil,
	-505,
	true,
	false,
	"",
	toString {
		alive _originalTarget &&
		_this in _this && {!isNull (_this getVariable ["KPLIB_BUILD_preplacedObject", objNull])}
	}
];

// Rotate left
private _rotateLeft_action = _player addAction [
	["<img size='1.2' color='#FFFF00' image='Functions\do_build\icons\rotate-left.paa'/>", " ", "<t color='#FFFF00'>", localize "STR_BUILD_ACTION_ROTATE_LEFT", "</t>"] joinString "",
	{
		params ["_player"];
		private _object = _player getVariable ["KPLIB_BUILD_preplacedObject", objNull];
		_rotation = _object getVariable ["PIG_objectRotation", 0];
		_newRotation = _rotation - 45;
		_object setVariable ["PIG_objectRotation", _newRotation];
        _object setDir _newRotation;
		_object setPosWorld getPosWorld _object;
	},
	nil,
	-506,
	true,
	false,
	"",
	toString {
		alive _originalTarget &&
		_this in _this && {!isNull (_this getVariable ["KPLIB_BUILD_preplacedObject", objNull])}
	}
];

// Foward
private _foward_action = _player addAction [
	["<img size='1.2' color='#FFFF00' image='Functions\do_build\icons\chevron-double-up.paa'/>", " ", "<t color='#FFFF00'>", localize "STR_BUILD_ACTION_FOWARD", "</t>"] joinString "",
	{
		params ["_player"];
		private _object = _player getVariable ["KPLIB_BUILD_preplacedObject", objNull];
		private _elevation = localNamespace getVariable ["KPLIB_BUILD_objectElevation", 1];
		private _Ycoord = localNamespace getVariable ["KPLIB_BUILD_objectYCoord", ceil(boundingBoxReal _object # 2) * 1.3];
		private _newYCoord = _Ycoord + 0.2;
		localNamespace setVariable ["KPLIB_BUILD_objectYCoord", _newYCoord];
		_object attachTo [_player, [0, _newYCoord, _elevation]];

		// Adjust spheres
		/*
		private _dist = 0.6 * (boundingBoxReal _object # 2);
		if (_dist < 5) then { _dist = 5 };
		{	
			_x setPos (_object getPos [_dist, 12 * _forEachIndex]);
			_x attachTo [_object];
		}forEach (_object getVariable ["KPLIB_BUILD_objectSpheres", []]);
		*/

		// Adjust camera
		if !(isNull (_player getVariable ["KPLIB_BUILD_camera", objNull])) then {
			[_player] call KPLIB_fnc_buildCameraAssist;
		}
	},
	nil,
	-507,
	true,
	false,
	"",
	toString {
		alive _originalTarget &&
		_this in _this && {!isNull (_this getVariable ["KPLIB_BUILD_preplacedObject", objNull])}
	}
];

// Backward
private _backward_action = _player addAction [
	["<img size='1.2' color='#FFFF00' image='Functions\do_build\icons\chevron-double-down.paa'/>", " ", "<t color='#FFFF00'>", localize "STR_BUILD_ACTION_BACKWARD", "</t>"] joinString "",
	{
		params ["_player"];
		private _object = _player getVariable ["KPLIB_BUILD_preplacedObject", objNull];
		private _elevation = localNamespace getVariable ["KPLIB_BUILD_objectElevation", 1];
		private _Ycoord = localNamespace getVariable ["KPLIB_BUILD_objectYCoord", ceil(boundingBoxReal _object # 2) * 1.3];
		private _newYCoord = _Ycoord - 0.2;
		localNamespace setVariable ["KPLIB_BUILD_objectYCoord", _newYCoord];
		_object attachTo [_player, [0, _newYCoord, _elevation]];

		// Adjust spheres
		/*
		private _dist = 0.6 * (boundingBoxReal _object # 2);
		if (_dist < 5) then { _dist = 5 };
		{	
			_x setPos (_object getPos [_dist, 12 * _forEachIndex]);
			_x attachTo [_object];
		}forEach (_object getVariable ["KPLIB_BUILD_objectSpheres", []]);
		*/

		// Adjust camera
		if !(isNull (_player getVariable ["KPLIB_BUILD_camera", objNull])) then {
			[_player] call KPLIB_fnc_buildCameraAssist;
		}
	},
	nil,
	-508,
	true,
	false,
	"",
	toString {
		alive _originalTarget &&
		_this in _this && {!isNull (_this getVariable ["KPLIB_BUILD_preplacedObject", objNull])}
	}
];

// Vector/Alignment on terrain
private _vectorBuild_action = _player addAction [
	["<img size='1.2' color='#FFFF00' image='Functions\do_build\icons\ruler-horizontal.paa'/>", " ", "<t color='#FFFF00'>", localize "STR_BUILD_ACTION_ALIGNMENT", "</t>"] joinString "",
	{
		params ["_player"];
		private _object = _player getVariable ["KPLIB_BUILD_preplacedObject", objNull];
		private _vector = localNamespace getVariable ["KPLIB_BUILD_vector", true];

		if (_vector) then {
			_object setVectorUp [0,0,1];
		} else {
			_object setVectorUp surfaceNormal position _object;
		};

		_vector = !_vector;
		localNamespace setVariable ["KPLIB_BUILD_vector", _vector];
	},
	nil,
	-509,
	true,
	false,
	"",
	toString {
		alive _originalTarget &&
		_this in _this && {!isNull (_this getVariable ["KPLIB_BUILD_preplacedObject", objNull])}
	}
];

// Build camera assist
private _changeView_action = _player addAction [
	["<img size='1.2' color='#FF9100' image='Functions\do_build\icons\camera.paa'/>", " ", "<t color='#FF9100'>", localize "STR_BUILD_ACTION_CAMERA_ASSIST", "</t>"] joinString "",
	{
		params ["_player"];
		if (isNull (_player getVariable ["KPLIB_BUILD_camera", objNull])) then {
			[_player] call KPLIB_fnc_buildCameraAssist;
		} else {
			[_player, false] call KPLIB_fnc_buildCameraAssist;
		}
	},
	nil,
	-510,
	true,
	false,
	"",
	toString {
		alive _originalTarget &&
		_this in _this && {!isNull (_this getVariable ["KPLIB_BUILD_preplacedObject", objNull])}
	}
];

_player setVariable ["KPLIB_BUILD_playerActions", [_build_action, _repeat_build_action, _cancelBuild_action, _up_action, _down_action, _rotateRight_action, _rotateLeft_action, _foward_action, _backward_action, _vectorBuild_action, _changeView_action]];