#include "..\defines.hpp"
/*
	File: fn_handleAirMagazinesLb.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 01/02/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Handles available magazines in listbox

	Parameter(s):
		Listbox passed arguments
	
	Returns:
		-
*/
params ["_control", "_lbCurSel", "_lbSelection"];

private _display = (findDisplay IDD_PYLONMANAGER_MENU);
private _ctrlPylonsListBox = _display displayCtrl IDC_PYLONS_LISTBOX;
private _ctrlMagazinesListBox = _display displayCtrl IDC_MAGAZINES_LISTBOX;

private _selectedAmmo = _ctrlMagazinesListBox lbData _lbCurSel;
private _aircraft = localNamespace getVariable ["PIG_PylonManager_aircraft", objNull];

// Change text for pylon listbox
private _pylonIndex = localNameSpace getVariable ["PIG_PylonManager_pylonIndex", -1];

if (_lbCurSel == 0) then { 
    _defaultName = _ctrlPylonsListBox lbData _pylonIndex; // Empty was selected
    _ctrlPylonsListBox lbSetText [_pylonIndex, _defaultName + " " + "-" + " " + "empty"];
    _ctrlPylonsListBox lbSetColor [_pylonIndex, [1, 0, 0, 1]]; // RED COLOR
    PIG_PylonManager_airLoadout set [_pylonIndex, ""];
    private _realPylon = (_pylonIndex + 1);
    [_aircraft, [_realPylon, "", true]] remoteExec ["setPylonLoadout", _aircraft];
} else {
    _ctrlPylonsListBox lbSetText [_pylonIndex, _selectedAmmo];
    _ctrlPylonsListBox lbSetColor [_pylonIndex, [0, 0.7, 0, 1]]; // GREEN COLOR
    PIG_PylonManager_airLoadout set [_pylonIndex, _selectedAmmo];
    private _realPylon = (_pylonIndex + 1);
    //_aircraft setPylonLoadout [_realPylon, _selectedAmmo, true];
    [_aircraft, [_realPylon, _selectedAmmo, true]] remoteExec ["setPylonLoadout", _aircraft];
};