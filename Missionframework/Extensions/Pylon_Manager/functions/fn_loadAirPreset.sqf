#include "..\defines.hpp"
/*
	File: fn_loadAirPreset.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 01/02/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Visualy loads the selected preset on the spawned aircraft

	Parameter(s):
		_vehicleLocal - locally spawned aircraft [OBJECT]
		_preset - name of the preset to load in [STRING]
	
	Returns:
		-
*/

params["_vehicleLocal", "_preset"];

private _display = (findDisplay IDD_PYLONMANAGER_MENU);

private _ctrlPylonsListBox = _display displayCtrl IDC_PYLONS_LISTBOX;
private _ctrlMagazinesListBox = _display displayCtrl IDC_MAGAZINES_LISTBOX;
private _ctlrPresetsListBox = _display displayCtrl IDC_PRESETS_LISTBOX;

// Cfg Preset
if (toLowerANSI(_preset) in PIG_PylonManager_cfgPresets) then {
	private _pylonsCfg = PIG_PylonManager_cfgPresets get (tolowerANSI _preset);
	if (_pylonsCfg isEqualTo []) then {
		// Reset to default
		lbClear _ctrlPylonsListBox;
		_pylonPaths = configProperties [configFile >> "CfgVehicles" >> (typeOf _vehicleLocal) >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"];

		{
			_pylonName = configName _x;
			_ctrlPylonsListBox lbAdd (_pylonName + " " + "-" + " " + "empty");
			_ctrlPylonsListBox lbSetData [_forEachIndex, _pylonName]; // Save the default names
			_ctrlPylonsListBox lbSetColor [_forEachIndex, [1, 0, 0, 1]]; // RED COLOR
			PIG_PylonManager_airLoadout set [_forEachIndex, ""];
			private _realPylon = (_forEachIndex + 1);
			[_vehicleLocal, [_realPylon, "", true]] remoteExec ["setPylonLoadout", _vehicleLocal];
		} forEach _pylonPaths;
	};

	{
		if (_x isEqualTo "") then {
			_defaultName = _ctrlPylonsListBox lbData _forEachIndex;
			_ctrlPylonsListBox lbSetText [_forEachIndex, _defaultName + " " + "-" + " " + "empty"];
			_ctrlPylonsListBox lbSetColor [_forEachIndex, [1, 0, 0, 1]]; // RED COLOR
			PIG_PylonManager_airLoadout set [_forEachIndex, ""];
			private _realPylon = (_forEachIndex + 1);
			[_vehicleLocal, [_realPylon, "", true]] remoteExec ["setPylonLoadout", _vehicleLocal];
		} else {
			_ctrlPylonsListBox lbSetText [_forEachIndex, _x];
			_ctrlPylonsListBox lbSetColor [_forEachIndex, [0, 0.7, 0, 1]]; // GREEN COLOR
			PIG_PylonManager_airLoadout set [_forEachIndex, _x];
			private _realPylon = (_forEachIndex + 1);
			[_vehicleLocal, [_realPylon, _x, true]] remoteExec ["setPylonLoadout", _vehicleLocal];
		}
	}forEach _pylonsCfg;
};

// Profile presets
private _profilePresets = profileNamespace getVariable ["PIG_PylonManager_profilePresets", []];
if (_preset in _profilePresets) then {
	private _pylonsProfile = ((_profilePresets get _preset) # 1); // # 1 = array that cointains the magazines and pylons in order

	{
		if (_x isEqualTo "") then {
			_defaultName = _ctrlPylonsListBox lbData _forEachIndex;
			_ctrlPylonsListBox lbSetText [_forEachIndex, _defaultName + " " + "-" + " " + "empty"];
			_ctrlPylonsListBox lbSetColor [_forEachIndex, [1, 0, 0, 1]]; // RED COLOR
			PIG_PylonManager_airLoadout set [_forEachIndex, ""];
			private _realPylon = (_forEachIndex + 1);
			[_vehicleLocal, [_realPylon, "", true]] remoteExec ["setPylonLoadout", _vehicleLocal];
		} else {
			_ctrlPylonsListBox lbSetText [_forEachIndex, _x];
			_ctrlPylonsListBox lbSetColor [_forEachIndex, [0, 0.7, 0, 1]]; // GREEN COLOR
			PIG_PylonManager_airLoadout set [_forEachIndex, _x];
			private _realPylon = (_forEachIndex + 1);
			[_vehicleLocal, [_realPylon, _x, true]] remoteExec ["setPylonLoadout", _vehicleLocal];
		}
	}forEach _pylonsProfile;
};