#include "..\defines.hpp"
/*
	File: fn_handleAirPresetsLb.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 16/10/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Handles presets in listbox

	Parameter(s):
		Listbox passed arguments
	
	Returns:
		-
*/
params ["_control", "_lbCurSel", "_lbSelection"];

if (_lbCurSel == -1) exitWith {};

private _display = (findDisplay IDD_PYLONMANAGER_MENU);

private _ctlrPresetsListBox = _display displayCtrl IDC_PRESETS_LISTBOX;
private _ctrlSaveButton = _display displayCtrl IDC_SAVE_BUTTON;
private _ctrlLoadButton = _display displayCtrl IDC_LOAD_BUTTON;
private _ctrlDeleteButton = _display displayCtrl IDC_DELETE_BUTTON;
private _ctrlRenameButton = _display displayCtrl IDC_RENAME_BUTTON;
private _ctrlRenameEdit = _display displayCtrl IDC_RENAME_EDIT;

_ctrlLoadButton ctrlEnable true; // Enable Load button

// Get the actual text in the listbox
private _getText = _ctlrPresetsListBox lbText _lbCurSel;

// Get aircraft classname selected
private _aircraft = localNameSpace getVariable ["PIG_PylonManager_aircraft", objNull];

// Check if it's a cfg preset
private _presets = configProperties [configFile >> "CfgVehicles" >> typeOf _aircraft >> "Components" >> "TransportPylonsComponent" >> "Presets", "isClass _x"];
private _is_preset = false;

{
    if (getText(_x >> "displayName") == _getText) exitWith {_is_preset = true};
}forEach _presets;

// If it's a cfg preset, disable save/delete/rename button
if (_is_preset) then {
    _ctrlSaveButton ctrlEnable false;
    _ctrlSaveButton ctrlSetTooltip "You can't modify cfg preset";
    _ctrlDeleteButton ctrlEnable false;
    _ctrlDeleteButton ctrlSetTooltip "You can't modify cfg preset";
    _ctrlRenameButton ctrlEnable false;
    _ctrlRenameButton ctrlSetTooltip "You can't modify cfg preset";
} else {
    _ctrlSaveButton ctrlEnable true;
    _ctrlSaveButton ctrlSetTooltip "Overwrite preset";
    _ctrlDeleteButton ctrlEnable true;
    _ctrlDeleteButton ctrlSetTooltip "Delete preset (this can't be undone)";
    _ctrlRenameButton ctrlEnable true;
    _ctrlRenameButton ctrlSetTooltip "Rename the selected preset";
};

_ctrlRenameEdit ctrlSetText _getText;