#include "..\defines.hpp"
/*
	File: fn_handlePylonsLb.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 20/10/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Handles pylons list box

	Parameter(s):
		List box passed arguments
	
	Returns:
		-
*/
params ["_control", "_lbCurSel", "_lbSelection"];

private _display = (findDisplay IDD_PYLONMANAGER_MENU);
private _ctrlMagazinesListBox = _display displayCtrl IDC_MAGAZINES_LISTBOX;

lbClear _ctrlMagazinesListBox;

// Get pylon name
private _pylonName = _control lbData _lbCurSel;
// Get aircraft selected
private _aircraft = localNameSpace getVariable ["PIG_PylonManager_aircraft", objNull];

// Get compatible magazines for this aircraft class
private _compatibleMagazines = ((typeOf _aircraft) getCompatiblePylonMagazines _pylonName);
localNameSpace setVariable ["PIG_PylonManager_pylonIndex", _lbCurSel]; // Save the index selection for the list box
localNameSpace setVariable ["PIG_PylonManager_pylonName", _pylonName]; 

// For magazine listbox
// Top option: "none"
_ctrlMagazinesListBox lbAdd "NONE";
_ctrlMagazinesListBox lbSetTooltip [0, "Empty"];
_ctrlMagazinesListBox lbSetData [0, "NONE"];

// Ammo options
{
    private _magazine = _x;
    if (_x isEqualType []) then {
        {
            _name = getText(configFile >> "cfgMagazines" >> _x >> "displayName");
            _ctrlMagazinesListBox lbAdd _name;
            _ctrlMagazinesListBox lbSetTooltip [(_forEachIndex + 1), getText(configFile >> "CfgMagazines" >> _x >> "descriptionShort")];
            _ctrlMagazinesListBox lbSetData [(_forEachIndex + 1), _x]; // Store default list box data
        }forEach _magazine;
    } else {
            _name = getText(configFile >> "cfgMagazines" >> _magazine >> "displayName");
            _ctrlMagazinesListBox lbAdd _name;
            _ctrlMagazinesListBox lbSetTooltip [(_forEachIndex + 1), getText(configFile >> "CfgMagazines" >> _x >> "descriptionShort")];
            _ctrlMagazinesListBox lbSetData [(_forEachIndex + 1), _magazine]; // Store default list box data
    }
}forEach _compatibleMagazines;
