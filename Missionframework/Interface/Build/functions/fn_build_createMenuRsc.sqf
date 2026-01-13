#include "..\defines.hpp"
/*
    File: fn_build_createMenuRsc.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 09/11/2025
    Last Update: 12/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Create liberation build Rsc

    Parameter(s):
        -

    Returns:
        -
*/

// Check for nearby enemies
if (([getpos player, 300, KPLIB_side_enemy] call KPLIB_fnc_getUnitsCount) > 4) exitWith {[localize "STR_BUILD_ENEMIES_NEARBY", true, 2] call KPLIB_fnc_hint;};

private _displayToUse = findDisplay IDD_MISSION;

[{_this createDisplay "LiberationBuildRsc"}, _displayToUse] call CBA_fnc_execNextFrame;