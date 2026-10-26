#include "..\defines.hpp"
/*
	File: fn_handleAirMagazinesLb.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 08/10/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Handles available magazines in listbox

	Parameter(s):
		Listbox passed arguments
	
	Returns:
		-
*/
params ["_control", "_lbCurSel", "_lbSelection"];

private _display = ctrlParent _control;
private _ctrlPylonsListBox = _display displayCtrl IDC_PYLONS_LISTBOX;
private _ctrlMagazinesListBox = _display displayCtrl IDC_MAGAZINES_LISTBOX;

private _selectedMag = _ctrlMagazinesListBox lbData _lbCurSel;
private _aircraft = localNamespace getVariable ["PIG_PAS_aircraft", objNull];

localNameSpace setVariable ["PIG_PAS_magazine", _selectedMag];

// Change text for pylon listbox
private _pylonIndex = localNameSpace getVariable ["PIG_PAS_pylonIndex", -1];

//private _turret = PIG_PAS_pylonsTurret getOrDefault [_pylon, [-1]];
private _turret = [_aircraft, _pylonIndex] call KPLIB_fnc_getPylonTurret;

private _pylonLbSel = localNameSpace getVariable ["PIG_PAS_pylonLbIndex", -1];

if (_selectedMag == "") then {
    private _defaultName = _ctrlPylonsListBox lbData _pylonLbSel; // Empty
    _ctrlPylonsListBox lbSetText [_pylonLbSel, _defaultName + " " + "-" + " " + "empty"];
    _ctrlPylonsListBox lbSetColor [_pylonLbSel, [1, 0, 0, 1]]; // RED COLOR
} else {
    private _magName = getText(configFile >> "cfgMagazines" >> _selectedMag >> "displayName");
    _ctrlPylonsListBox lbSetText [_pylonLbSel, _magName];
    _ctrlPylonsListBox lbSetColor [_pylonLbSel, [0, 0.7, 0, 1]]; // GREEN COLOR
};

["PAS_setPylonArmament", [_aircraft, _pylonIndex, _selectedMag, _turret, _pylonLbSel]] call CBA_fnc_globalEvent;