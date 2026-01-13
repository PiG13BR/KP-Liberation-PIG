#include "..\defines.hpp"
/*
	File: fn_renameAirPreset.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 16/10/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Rename preset. Only possible for profile presets.

	Parameter(s):
		-
	
	Returns:
		-
*/

private _display = (findDisplay IDD_PYLONMANAGER_MENU);

private _ctlrPresetsListBox = _display displayCtrl IDC_PRESETS_LISTBOX;
private _ctrlRenameEdit = _display displayCtrl IDC_RENAME_EDIT;

private _aircraft = localNameSpace getVariable ["PIG_PylonManager_aircraft", objNull];

if ((lbCurSel _ctlrPresetsListBox ) isEqualTo -1) exitWith {["No preset selected to rename", true, 5, 2] call ace_common_fnc_displayText};
private _key = _ctlrPresetsListBox  lbText (lbCurSel _ctlrPresetsListBox ); // The text that shows in the lb is the key name in the hashmaps
if (toLowerANSI(_key) in PIG_PylonManager_cfgPresets) exitWith {["You can't rename a cfg presets", true, 5, 2] call ace_common_fnc_displayText};

private _profilePresets = profileNamespace getVariable ["PIG_PylonManager_profilePresets", []];

if ((ctrlText _ctrlRenameEdit) isEqualTo "") exitWith {["Enter a name for you preset", true, 5, 2] call ace_common_fnc_displayText};

// The renamed key
private _renamedText = (ctrlText _ctrlRenameEdit);
if (_renamedText in _profilePresets) exitWith {[["This name %1 already exist in your saved presets", str _renamedText], 1.5, ACE_player] call ace_common_fnc_displayTextStructured};

// Save original value
private _value = _profilePresets get _key; 
    // Delete key
_deleted = _profilePresets deleteAt _key;
// Save new key and get original value from the deleted key
_profilePresets set [(_renamedText), _value];
// Update lb text
_ctlrPresetsListBox lbSetText [(lbCurSel _ctlrPresetsListBox), _renamedText];
[typeOf (_aircraft)] call KPLIB_fnc_reloadPresetsLb; 