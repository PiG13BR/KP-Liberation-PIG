#include "..\defines.hpp"
/*
    File: fn_logistic_unloadMenu.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 31/07/2026
    Last Update: 30/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Unload virtual logistic menu

    Parameter(s):
        _display - virtual logistic menu display [DISPLAY, defaults to findDisplay IDD_LOGISTIC_MENU]

    Returns:
        -
*/
params[["_display", findDisplay IDD_LOGISTIC_MENU]];

[_display, true] call KPLIB_fnc_logistic_drawArrow;
deleteMarkerLocal "start_marker"; 
deleteMarkerLocal "destination_marker";
localNamespace setVariable ["KPLIB_logistic_nearFob", nil];
localNamespace setVariable ["KPLIB_logistic_destinations", nil];
uiNamespace setVariable ["KPLIB_logistic_display", nil];
[KPLIB_LOGISTIC_MENU_PFH] call CBA_fnc_removePerFrameHandler;

// Renable user actions
inGameUISetEventHandler ["PrevAction", "false"];
inGameUISetEventHandler ["NextAction", "false"];
inGameUISetEventHandler ["Action", "false"];