#include "..\defines.hpp"
/*
	File: fn_unloadPylonManagerMenu.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 20/10/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Unloads air spawner menu

	Parameter(s):
		_display - display to unload [DISPLAY, defauls to displayNull]
	
	Returns:
		-
*/
params["_display"];

// Clear variables
PIG_PylonManager_airLoadout = nil; 

deleteVehicle (localNamespace getVariable 'PIG_PylonManager_LightSource');
localNamespace setvariable ["PIG_PylonManager_LightSource", nil];
PIG_PylonManager_pylonsPosHash = nil;

localNameSpace setVariable ["PIG_PylonManager_pylonName", nil];

// Unload camera
[] call KPLIB_fnc_unloadCameraHandle;