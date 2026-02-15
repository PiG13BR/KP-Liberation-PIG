#include "..\defines.hpp"
/*
	File: fn_createPylonManagerRsc.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 15/02/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Create display for Air Spawner Menu

	Parameter(s):
		_aircraft - aircraft to change pylons [OBJECT, defaults to objNull]
	
	Returns:
		-
*/

params[["_aircraft", objNull, [objNull]]];

if (isNull _aircraft) exitWith {};

localNamespace setVariable ["PIG_PylonManager_aircraft", _aircraft];
_aircraft setVariable ["PIG_pylonManager_isBusy", true];

private _displayToUse = findDisplay IDD_MISSION;

[{_this createDisplay "PIG_PylonManager_RscMainMenu"}, _displayToUse] call CBA_fnc_execNextFrame;