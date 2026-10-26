#include "..\defines.hpp"
/*
	File: fn_loadAirPreset.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 08/10/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Visualy loads the selected preset on the aircraft

	Parameter(s):
		_aircraft - aircraft to load the preset [OBJECT]
		_preset - name of the preset to load in [STRING]
	
	Returns:
		-
*/

params["_aircraft", "_preset", ["_display", (findDisplay IDD_PAS_MENU)]];

private _ctrlPylonsListBox = _display displayCtrl IDC_PYLONS_LISTBOX;
private _ctrlMagazinesListBox = _display displayCtrl IDC_MAGAZINES_LISTBOX;
private _ctlrPresetsListBox = _display displayCtrl IDC_PRESETS_LISTBOX;
private _ctrlTurretButton = _display displayCtrl IDC_TURRET_BUTTON;

private _pylonsInfo = getAllPylonsInfo _aircraft;

// Cfg Preset
if (toLowerANSI(_preset) in PIG_PAS_cfgPresets) then {
	private _pylonsCfg = PIG_PAS_cfgPresets get (tolowerANSI _preset);
	if (_pylonsCfg isEqualTo []) then {
		// Reset to default
		lbClear _ctrlPylonsListBox;
		private _pylonsInfo = _pylonsInfo select {(toLowerANSI (_x # 1)) find "dummy" <= 0}; // Ignore dummy pylons

		{
			_x params ["_index", "_pylonName", "_turret", "_magazine"];

			_ctrlPylonsListBox lbAdd (_pylonName + " " + "-" + " " + "empty");
			_ctrlPylonsListBox lbSetData [_forEachIndex, _pylonName]; // Save the default names
			_ctrlPylonsListBox lbSetValue [_forEachIndex, _index]; // Save pylon index
			_ctrlPylonsListBox lbSetColor [_forEachIndex, [1, 0, 0, 1]]; // RED COLOR

			["PAS_setPylonArmament", [_aircraft, _index, _magazine, _turret, _forEachIndex]] call CBA_fnc_globalEvent;
		}forEach _pylonsInfo;
	};

	private _trueIndex = 0;
	{
		if (_forEachIndex > count _pylonsInfo) exitWith {};

		// Compare to the pylons info
		private _pylonName = (_pylonsInfo # _forEachIndex) # 1;
		if ((toLowerANSI _pylonName) find "dummy" >= 0) then {continue}; // Ignore dummy pylons

		private _magazine = _x # 0;
		private _turret = _x # 1;
		private _pylonIndex = _ctrlPylonsListBox lbValue _trueIndex;

		if (_magazine isEqualTo "") then {
			_defaultName = _ctrlPylonsListBox lbData _trueIndex;
			_ctrlPylonsListBox lbSetText [_trueIndex, _defaultName + " " + "-" + " " + "empty"];
			_ctrlPylonsListBox lbSetColor [_trueIndex, [1, 0, 0, 1]]; // RED COLOR
		} else {
			private _magName = getText(configFile >> "cfgMagazines" >> _magazine >> "displayName");
			_ctrlPylonsListBox lbSetText [_trueIndex, _magName];
			_ctrlPylonsListBox lbSetColor [_trueIndex, [0, 0.7, 0, 1]]; // GREEN COLOR
		};

		["PAS_setPylonArmament", [_aircraft, _pylonIndex, _magazine, _turret, _trueIndex]] call CBA_fnc_globalEvent;

		_trueIndex = _trueIndex + 1;
	}forEach _pylonsCfg;
};

// Profile presets
private _profilePresets = profileNamespace getVariable ["PIG_PAS_profilePresets", createHashMap];
if (_preset in _profilePresets) then {
	private _pylonsProfile = ((_profilePresets get _preset) # 1); // # 1 = array that cointains the magazines and pylons in order
	private _trueIndex = 0;
	{
		if (_forEachIndex > count _pylonsInfo) exitWith {};

		// Compare to the pylons info
		private _pylonName = (_pylonsInfo # _forEachIndex) # 1;
		if ((toLowerANSI _pylonName) find "dummy" >= 0) then {continue}; // Ignore dummy pylons

		private _magazine = _x # 0;
		private _turret = _x # 1;
		private _pylonIndex = _ctrlPylonsListBox lbValue _trueIndex;

		if (_magazine isEqualTo "") then {
			_defaultName = _ctrlPylonsListBox lbData _trueIndex;
			_ctrlPylonsListBox lbSetText [_trueIndex, _defaultName + " " + "-" + " " + "empty"];
			_ctrlPylonsListBox lbSetColor [_trueIndex, [1, 0, 0, 1]]; // RED COLOR
		} else {
			private _magName = getText(configFile >> "cfgMagazines" >> _magazine >> "displayName");
			_ctrlPylonsListBox lbSetText [_trueIndex, _magName];
			_ctrlPylonsListBox lbSetColor [_trueIndex, [0, 0.7, 0, 1]]; // GREEN COLOR
		};

		["PAS_setPylonArmament", [_aircraft, _pylonIndex, _magazine, _turret, _trueIndex]] call CBA_fnc_globalEvent;

		_trueIndex = _trueIndex + 1;
	}forEach _pylonsProfile;

	// Change turret icon if necessary
	if !(isNull _ctrlTurretButton) then {
		private _pylonSelected = (localNameSpace getVariable ["PIG_PAS_pylonIndex", 0]);
		private _turret = [_aircraft, _pylonSelected] call KPLIB_fnc_getPylonTurret;
		[_ctrlTurretButton, false, _pylonSelected, _turret] call KPLIB_fnc_handleTurretButton;
	};
};