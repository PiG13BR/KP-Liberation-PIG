#include "..\defines.hpp"
/*
	File: fn_loadPylonManagerMenu.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 01/02/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Loads air spawner menu

	Parameter(s):
		_display - loaded display [DISPLAY, defauls to displayNull]
		_aircraft - aircraft to change pylons [OBJECT, defaults to objNull]
	
	Returns:
		-
*/
params[["_display", findDisplay 46], ["_aircraft", localNamespace getVariable ["PIG_PylonManager_aircraft", objNull]]];

if (_display == displayNull) exitWith {};

if (isNull _aircraft) exitWith {[] call KPLIB_fnc_unloadPylonManagerMenu};

localNameSpace setVariable ["PIG_PylonManager_pylonIndex", -1];

// Create lightsoruce (lifted from arsenal.sqf)
_intensity = 20;
_light = "#lightpoint" createvehicleLocal (getPosATL _placeholder);
_light setlightbrightness _intensity;
_light setlightambient [1, 1, 1];
_light setlightcolor [0, 0, 0];
_light lightattachobject [_placeholder, [0, 0, -_intensity * 7]];
_light setLightDayLight false;

localNamespace setvariable ["PIG_PylonManager_LightSource", _light];

PIG_PylonManager_airLoadout = [];

[_display, _aircraft] call KPLIB_fnc_loadPylonsLb;
[] call KPLIB_fnc_reloadPresetControls;

//--------------- Camera
[_display, _aircraft] call KPLIB_fnc_loadCameraHandle;

