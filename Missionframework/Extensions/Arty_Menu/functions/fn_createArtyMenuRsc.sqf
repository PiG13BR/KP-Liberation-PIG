#include "..\defines.hpp"
/*
	File: fn_createArtyMenuRsc.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 03/11/2025
	Last Update: 03/11/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Create display for Arty Menu

	Parameter(s):
		-
	
	Returns:
		-
*/

private _displayToUse = findDisplay IDD_MISSION;

[{_this createDisplay "PIG_RscArtyMenu"}, _displayToUse] call CBA_fnc_execNextFrame;