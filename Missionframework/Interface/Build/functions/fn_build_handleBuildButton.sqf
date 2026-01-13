#include "..\defines.hpp"
/*
    File: fn_build_handleBuildButton.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 10/11/2025
    Last Update: 02/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handles build buttons pressed and start building process, also closes the build menu display

    Parameter(s):
        _button - button control [CONTROL]
        _manned - spawn with crew [BOOL, defaults to false]

    Returns:
        -
*/
params["_button", ["_manned", false, [false]]];

// Controls
private _display = (ctrlParent _button);
private _lnbControl = _display displayCtrl IDC_BUILD_LISTBOX;

// Get element
private _lbCurSel = lnbCurSelRow _lnbControl;
if (_lbCurSel == -1) exitWith {}; // Failsafe
private _buildType = (localNamespace getVariable ["KPLIB_Build_type", 1]); // Get build type selected (label)
private _buildList = KPLIB_buildList # _buildType; // Get actual list
private _selectedItem = _buildList # _lbCurSel; // Get actual selected element

[_buildType, _selectedItem, _manned] call KPLIB_fnc_buildItem; // Do Build!

// Close dialog
_display closeDisplay 1;