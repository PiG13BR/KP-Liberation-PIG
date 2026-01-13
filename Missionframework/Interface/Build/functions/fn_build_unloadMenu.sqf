#include "..\defines.hpp"
/*
    File: fn_build_unloadMenu.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 10/11/2025
    Last Update: 12/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Unload build menu

    Parameter(s):
        _display - build menu display [DISPLAY, defaults to findDisplay IDD_BUILD_MENU]

    Returns:
        -
*/
params[["_display", findDisplay IDD_BUILD_MENU]];

if (!isNil "KPLIB_BUILD_labelPfhandle") then {[KPLIB_BUILD_labelPfhandle] call CBA_fnc_removePerFrameHandler;}; // Delete previous PFH

localNamespace setVariable ["KPLIB_Build_type", nil];

