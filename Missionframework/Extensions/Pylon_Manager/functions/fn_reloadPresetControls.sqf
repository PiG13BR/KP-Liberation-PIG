#include "..\defines.hpp"
/*
	File: fn_reloadPresetControls.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 16/10/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Resets presets buttons and creates a profile variable if not existent

	Parameter(s):
		-
	
	Returns:
		-
*/

// Create variable in profilenamespace
if (isNil {(profileNamespace getVariable "PIG_PylonManager_profilePresets")}) then {[] call KPLIB_fnc_resetAirProfileLoadout};

private _display = (findDisplay IDD_PYLONMANAGER_MENU);

// Disable all preset buttons (default)
(_display displayCtrl IDC_SAVE_BUTTON) ctrlEnable false;	// Save
(_display displayCtrl IDC_LOAD_BUTTON) ctrlEnable false;	// Load
(_display displayCtrl IDC_DELETE_BUTTON) ctrlEnable false;	// Delete
(_display displayCtrl IDC_RENAME_BUTTON) ctrlEnable false;	// Rename
(_display displayCtrl IDC_SAVENEW_BUTTON) ctrlEnable false;	// Save new preset