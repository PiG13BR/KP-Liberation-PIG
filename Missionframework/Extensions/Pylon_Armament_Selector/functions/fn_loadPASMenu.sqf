#include "..\defines.hpp"
/*
	File: fn_loadPASMenu.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 26/10/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Loads pylon armament selector menu

	Parameter(s):
		_display - loaded display [DISPLAY, defauls to displayNull]
		_aircraft - aircraft to change pylons [OBJECT, defaults to objNull]
	
	Returns:
		-
*/
params[["_display", findDisplay 46], ["_aircraft", localNamespace getVariable ["PIG_PAS_aircraft", objNull]]];

if (_display == displayNull) exitWith {};

if (isNull _aircraft) exitWith {[] call KPLIB_fnc_unloadPASMenu};

localNameSpace setVariable ["PIG_PAS_pylonIndex", -1];

// Create lightsoruce (lifted from arsenal.sqf)
_intensity = 20;
_light = "#lightpoint" createvehicleLocal (getPosATL _placeholder);
_light setlightbrightness _intensity;
_light setlightambient [1, 1, 1];
_light setlightcolor [0, 0, 0];
_light lightattachobject [_placeholder, [0, 0, -_intensity * 7]];
_light setLightDayLight false;

localNamespace setvariable ["PIG_PAS_LightSource", _light];

PIG_PAS_airLoadout = [];
PIG_PAS_pylonsTurret = createHashMap;
PIG_PAS_cfgPresets = createHashMap;

_aircraft call KPLIB_fnc_reloadLoadout;

[_display, _aircraft] call KPLIB_fnc_loadPylonsLb;
[_display] call KPLIB_fnc_reloadPresetControls;

//--------------- Camera
[_display, _aircraft] call KPLIB_fnc_loadCameraHandle;

