#include "..\defines.hpp"
/*
	File: fn_handleLoadPresetButton.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 05/10/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Handles available magazines in listbox

	Parameter(s):
		_control - load preset button [CONTROL]
	
	Returns:
		-
*/
params["_control"];

private _display = ctrlParent _control;

private _ctlrPresetsListBox = _display displayCtrl IDC_PRESETS_LISTBOX;

// Load the text
private _key = _ctlrPresetsListBox lbText (lbCurSel _ctlrPresetsListBox);

if (_key isEqualTo "") exitWith {[localize "STR_PAS_LOAD_WARN", true, 5, 2] call ace_common_fnc_displayText};

private _aircraft = localNamespace getVariable ["PIG_PAS_aircraft", objNull];

_aircraft call KPLIB_fnc_reloadLoadout;

// Load the preset on the local aircraft
[_aircraft, _key, _display] call KPLIB_fnc_loadAirPreset;