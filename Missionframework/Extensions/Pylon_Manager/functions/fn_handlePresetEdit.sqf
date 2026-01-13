#include "..\defines.hpp"
/*
	File: fn_handlePresetEdit.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 16/10/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Handles preset edit box

	Parameter(s):
		Edit box passed arguments
	
	Returns:
		-
*/
params ["_control", "_newText"];

private _display = (findDisplay IDD_PYLONMANAGER_MENU);

private _ctrlRenameButton = _display displayCtrl IDC_RENAME_BUTTON;
private _ctrlSaveNewButton = _display displayCtrl IDC_SAVENEW_BUTTON;

private _profilePresets = profileNamespace getVariable ["PIG_PylonManager_profilePresets", []];
if ((_newText in _profilePresets) || {toLowerANSI(_newText) in PIG_PylonManager_cfgPresets} || {toLowerANSI(_newText) in PIG_PylonManager_cfgPresets} || {toUpperANSI _newText in PIG_PylonManager_cfgPresets}) then {
    // Disable save new preset
    _ctrlSaveNewButton ctrlEnable false;
    _ctrlSaveNewButton ctrlSetTooltip "Invalid Name/Already Exists";
    // Disable rename preset
    _ctrlRenameButton ctrlEnable false;
    _ctrlRenameButton ctrlSetTooltip "Invalid Name/Already Exists";
} else {
    _ctrlSaveNewButton ctrlEnable true;
    _ctrlSaveNewButton ctrlSetTooltip "Save this as a new preset";
    _ctrlRenameButton ctrlEnable true;
    _ctrlRenameButton ctrlSetTooltip "Rename the selected preset";
};