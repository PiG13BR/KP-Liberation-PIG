#include "..\defines.hpp"
/*
	File: fn_deleteAirPreset.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 16/10/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Delete loadout air preset

	Parameter(s):
		-
	
	Returns:
		-
*/

private _display = (findDisplay IDD_PYLONMANAGER_MENU);
private _ctlrPresetsListBox = _display displayCtrl IDC_PRESETS_LISTBOX;

if ((lbCurSel _ctlrPresetsListBox) isEqualTo -1) exitWith {["No preset selected to delete", true, 5, 2] call ace_common_fnc_displayText};
private _key = _ctlrPresetsListBox lbText (lbCurSel _ctlrPresetsListBox);
private _profilePresets = (profileNamespace getVariable ["PIG_PylonManager_profilePresets", ""]);
if (_key in _profilePresets) then {
    _profilePresets deleteAt _key;
    _ctlrPresetsListBox lbDelete (lbCurSel _ctlrPresetsListBox);
};

// Select last cursel
_ctlrPresetsListBox lbSetCurSel (lbCurSel _ctlrPresetsListBox);
private _aircraftSel = localNameSpace getVariable "PIG_PylonManager_aircraftSelected";
[_aircraftSel] call KPLIB_fnc_reloadPresetsLb;