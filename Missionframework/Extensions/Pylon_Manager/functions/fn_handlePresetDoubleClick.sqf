#include "..\defines.hpp"
/*
	File: fn_handlePresetDoubleClick.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 16/10/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Handles double mouse click to load preset on the aircraft

	Parameter(s):
		Listbox passed arguments
	
	Returns:
		-
*/
params ["_control", "_lbCurSel", "_lbSelection"];

private _display = (findDisplay IDD_PYLONMANAGER_MENU);

private _ctrlPylonsListBox = _display displayCtrl IDC_PYLONS_LISTBOX;

// Load the text
private _key = _control lbText (lbCurSel _control);
if (tolowerANSI _key isEqualTo "") exitWith {["No preset selected to load", true, 5, 2] call ace_common_fnc_displayText};

private _aircraft = localNamespace getVariable ["PIG_PylonManager_aircraft", objNull];

[typeOf (_aircraft)] call KPLIB_fnc_reloadLoadout;

// Load the preset on the local aircraft
[_aircraft, _key] call KPLIB_fnc_loadAirPreset;