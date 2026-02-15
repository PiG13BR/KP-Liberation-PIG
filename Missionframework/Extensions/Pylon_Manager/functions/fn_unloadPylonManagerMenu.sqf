#include "..\defines.hpp"
/*
	File: fn_unloadPylonManagerMenu.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 15/02/2026
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

// Remove remnant weapons from the setPylonLoadout command
private _aircraft = localNamespace getVariable ["PIG_PylonManager_aircraft", objNull];
private _turret = _aircraft unitTurret player;
private _weapons = _aircraft weaponsTurret _turret;
{

    private _weaponState = weaponState [_aircraft, _turret, _x];
    if ((_weaponState # 3 == "") && (_x find "mastersafe" < 0)) then {
        _aircraft removeWeaponTurret [_x, _turret];
    };

}forEach _weapons;

_aircraft setVariable ["PIG_pylonManager_isBusy", false];
localNamespace getVariable ["PIG_PylonManager_aircraft", nil];