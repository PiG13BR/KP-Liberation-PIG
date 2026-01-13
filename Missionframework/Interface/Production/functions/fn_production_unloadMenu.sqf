#include "..\defines.hpp"
/*
    File: fn_production_unloadMenu.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 10/11/2025
    Last Update: 12/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Unload production menu

    Parameter(s):
        _display - production menu display [DISPLAY, defaults to findDisplay IDD_PRODUCTION_MENU]

    Returns:
        -
*/
params[["_display", findDisplay IDD_PRODUCTION_MENU]];

if (!isNil "KPLIB_production_MenuPFH") then {[KPLIB_production_MenuPFH] call CBA_fnc_removePerFrameHandler};

//"spawn_marker" setMarkerPosLocal markers_reset; // ???
localNameSpace setVariable ["KPLIB_production_new", nil];
localNamespace getVariable ["KPLIB_production_SectorSelected", nil]