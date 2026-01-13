#include "..\defines.hpp"
/*
    File: fn_production_createMenuRsc.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 15/11/2025
    Last Update: 15/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Create liberation production Rsc

    Parameter(s):
        -

    Returns:
        -
*/

private _displayToUse = findDisplay IDD_MISSION;

[{_this createDisplay "LiberationProductionsRsc"}, _displayToUse] call CBA_fnc_execNextFrame;