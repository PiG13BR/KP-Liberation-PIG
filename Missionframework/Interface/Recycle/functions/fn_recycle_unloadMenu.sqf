#include "..\defines.hpp"
/*
    File: fn_production_unloadMenu.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 22/11/2025
    Last Update: 22/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Unload production menu

    Parameter(s):
        _display - production menu display [DISPLAY, defaults to findDisplay IDD_PRODUCTION_MENU]

    Returns:
        -
*/
params[["_display", findDisplay IDD_PRODUCTION_MENU]];

// Wait 1 sec just to make sure to not interfere with do recycle function
[{
    localNamespace setVariable ["KPLIB_recycleGain", nil];
    localNamespace setVariable ["KPLIB_vehToRecycle", nil];
}, 1] call CBA_fnc_waitAndExecute;
