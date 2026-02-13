#include "..\defines.hpp"
/*
	File: fn_saveAirPreset.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 13/02/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Overwrite preset. Only possible for profile presets.

	Parameter(s):
		-
	
	Returns:
		-
*/
private _display = (findDisplay IDD_PYLONMANAGER_MENU);

private _ctlrPresetsListBox = _display displayCtrl IDC_PRESETS_LISTBOX;

if (lbCurSel _ctlrPresetsListBox == -1) exitWith {["No preset selected to save", true, 5, 2] call ace_common_fnc_displayText};

private _profilePresets = (profileNamespace getVariable "PIG_PylonManager_profilePresets");
private _key = _ctlrPresetsListBox lbText (lbCurSel _ctlrPresetsListBox);
private _aircraftSel = localNameSpace getVariable "PIG_PylonManager_aircraftSelected";

private _loadout = PIG_PylonManager_airLoadout;
_profilePresets set [(_key), [_aircraftSel, _loadout]];

[_aircraftSel] call KPLIB_fnc_reloadPresetsLb;