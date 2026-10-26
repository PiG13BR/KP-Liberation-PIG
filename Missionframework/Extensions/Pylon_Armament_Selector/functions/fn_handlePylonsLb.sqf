#include "..\defines.hpp"
/*
	File: fn_handlePylonsLb.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 07/10/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Handles pylons list box

	Parameter(s):
		List box passed arguments
	
	Returns:
		-
*/
params ["_control", "_lbCurSel"];

// Get pylon true index
private _pylonIndex = _control lbValue _lbCurSel;
localNameSpace setVariable ["PIG_PAS_pylonIndex", _pylonIndex]; // Save the index selection for the list box
localNameSpace setVariable ["PIG_PAS_pylonLbIndex", _lbCurSel]; // Save pylon lb selection

// Get pylon name
private _pylonName = _control lbData _lbCurSel;
localNameSpace setVariable ["PIG_PAS_pylonName", _pylonName];

private _display = ctrlParent _control;
private _ctrlMagazinesCombo = _display displayCtrl IDC_MAGAZINES_COMBO;

lbClear _ctrlMagazinesCombo;

// Add options in combo box
{
    _ctrlMagazinesCombo lbAdd _x;
	if (_forEachIndex == 1) then {_ctrlMagazinesCombo lbSetTooltip [_forEachIndex, localize "STR_PAS_ADD_FAVORITE_TOOLTIP"]};
}forEach [localize "STR_PAS_COMPAT_MAGAZINES", localize "STR_PAS_FAVORITES"];

// All Compatible Magazines. It will trigger the handle combo magazine function to fill the magazines listbox
private _selectionIndex = _ctrlMagazinesCombo getVariable ["PIG_PAS_comboBoxCurSel", 0];
_ctrlMagazinesCombo lbSetCurSel _selectionIndex;