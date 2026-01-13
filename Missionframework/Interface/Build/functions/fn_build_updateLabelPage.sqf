#include "..\defines.hpp"
/*
    File: fn_build_updateLabelPage.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 10/11/2025
    Last Update: 12/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Update label page from build menu

    Parameter(s):
        _build_list - build list to update [ARRAY, defaults to []]
        _controls - all label controls to update [ARRAY, defaults to []]

    Returns:
        -
*/
params[["_build_list", [], [[]]], ["_controls", [], [[]]]];

if (_build_list isEqualTo []) exitWith {};
if (_controls isEqualTo []) exitWith {};

_controls params ["_lnbControl", "_suppliesTextCtrl", "_ammoTextCtrl", "_fuelTextCtrl", "_labelCapTextCtrl"];

// Update affordable items
{[_x, _lnbControl] call KPLIB_fnc_build_updateAffordableItems;}forEach _build_list;

// Update Air slots
[_labelCapTextCtrl] call KPLIB_fnc_build_updateAirSlots;

// Update resources values
[_suppliesTextCtrl, _ammoTextCtrl, _fuelTextCtrl] call KPLIB_fnc_build_updateResourcesCtrl;

// Update selected element
[_lnbControl] call KPLIB_fnc_build_updateBuildCtrl;
