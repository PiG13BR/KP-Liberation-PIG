#include "..\defines.hpp"
/*
	File: fn_saveNewAirPreset.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 16/10/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Save new preset

	Parameter(s):
		-
	
	Returns:
		-
*/

private _display = (findDisplay IDD_PYLONMANAGER_MENU);

private _ctrlRenameEdit = _display displayCtrl IDC_RENAME_EDIT;
private _ctlrPresetsListBox = _display displayCtrl IDC_PRESETS_LISTBOX;

if ((ctrlText _ctrlRenameEdit) isEqualTo "") exitWith {["Enter a name for you preset", true, 5, 2] call ace_common_fnc_displayText};

// Get new key name
private _key = (ctrlText _ctrlRenameEdit);
// Get profile hashmap
private _profilePresets = profileNamespace getVariable ["PIG_PylonManager_profilePresets", []];
// Check for similar names/key in presets
if ((_key in _profilePresets) || {toLowerANSI(_key) in PIG_PylonManager_cfgPresets}) exitWith {systemChat format ["[ERROR] This name %1 already exist in the preset", str _key]};

private _aircraft = localNameSpace getVariable ["PIG_PylonManager_aircraft", objNull];
private _loadout = PIG_PylonManager_airLoadout;

_profilePresets set [(_key), [typeOf (_aircraft), _loadout], true]; // Set a new key

// Get cfg preset for this aircraft
lbClear _ctlrPresetsListBox;
private _presetCfgPaths = configProperties [configFile >> "CfgVehicles" >> typeOf (_aircraft) >> "Components" >> "TransportPylonsComponent" >> "Presets", "isClass _x"];

{
    _presetName = (getText(_x >> "displayName"));
    _ctlrPresetsListBox lbAdd _presetName;
    // Put the attachaments in a hashmap
    _attachs = (getArray(_x >> "attachment"));
    PIG_PylonManager_cfgPresets set [_presetName, _attachs];
}forEach _presetCfgPaths;

{
    // Ignore preset from another aircraft class
    private _hashClass = (_y # 0);
    if (_hashClass == typeOf (_aircraft)) then {
        _ctlrPresetsListBox lbAdd _x;
    };
}forEach _profilePresets;