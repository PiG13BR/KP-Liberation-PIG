/*
	File: fn_reloadPresetsLb.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 05/10/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Reloads the listbox presets

	Parameter(s):
		_aircraft - aircraft [OBJECT, defauls to objNull]
		_control - listbox control to add the presets [CONTROL, defaults to controlNull]
	
	Returns:
		-
*/

params[["_aircraft", objNull, [objNull]], ["_control", controlNull, [controlNull]]];

if (isNull _aircraft) exitWith {};
if (_control == controlNull) exitWith {};

lbClear _control; // Clear the list box

// Get cfg preset for this aircraft
private _presetCfgPaths = configProperties [ConfigOf _aircraft >> "Components" >> "TransportPylonsComponent" >> "Presets", "isClass _x"];
if (isNil "PIG_PAS_cfgPresets") then {PIG_PAS_cfgPresets = createHashMap};
private _count = count (getAllPylonsInfo _aircraft); // Get a pylon count

{
	private _preset = [];
    private _presetName = (getText(_x >> "displayName"));
    _control lbAdd _presetName;
    // Put the attachaments in a hashmap
    private _attachs = (getArray(_x >> "attachment"));
	if (count _attachs < 1) then {
		// Empty preset
		for "_i" from 1 to _count do {
			_preset pushBack ["", [-1]];
		};
	} else {
		{
			private _turret = [_aircraft, _forEachIndex] call KPLIB_fnc_getPylonTurret;
			_preset pushBack [_x, _turret]
		}forEach _attachs;
	};

	PIG_PAS_cfgPresets set [tolowerANSI _presetName, _preset];
}forEach _presetCfgPaths;

// Get pylon profile preset for this aircraft
private _profilePresets = profileNamespace getVariable ["PIG_PAS_profilePresets", createHashMap];

{
    // Ignore preset from another aircraft class
    private _hashClass = (_y # 0);
    if (_hashClass == (typeOf _aircraft)) then {
        _control lbAdd _x;
    };
}forEach _profilePresets;

_control lbSetCurSel 0;