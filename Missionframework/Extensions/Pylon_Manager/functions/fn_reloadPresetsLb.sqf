/*
	File: fn_reloadPresetsLb.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 14/10/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Reloads the listbox presets

	Parameter(s):
		_aircraftClass - classname of the aircraft [STRING, defauls to ""]
		_control - listbox control to add the presets [CONTROL, defaults to controlNull]
	
	Returns:
		-
*/

params[["_aircraftClass", "", [""]], ["_control", controlNull, [controlNull]]];

if (_aircraftClass isEqualTo "") exitWith {};
if (_control == controlNull) exitWith {};

lbClear _control; // Clear the list box

// Get cfg preset for this aircraft
private _presetCfgPaths = configProperties [configFile >> "CfgVehicles" >> _aircraftClass >> "Components" >> "TransportPylonsComponent" >> "Presets", "isClass _x"];
if (isNil "PIG_PylonManager_cfgPresets") then {PIG_PylonManager_cfgPresets = createHashMap};
{
    _presetName = (getText(_x >> "displayName"));
    _control lbAdd _presetName;
    // Put the attachaments in a hashmap
    _attachs = (getArray(_x >> "attachment"));
    PIG_PylonManager_cfgPresets set [tolowerANSI _presetName, _attachs];
}forEach _presetCfgPaths;

// Get pylon profile preset for this aircraft
private _profilePresets = profileNamespace getVariable ["PIG_PylonManager_profilePresets", []];

{
    // Ignore preset from another aircraft class
    private _hashClass = (_y # 0);
    if (_hashClass == _aircraftClass) then {
        _control lbAdd _x;
    };
}forEach _profilePresets;

_control lbSetCurSel 0;