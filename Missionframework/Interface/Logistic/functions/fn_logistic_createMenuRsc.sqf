#include "..\defines.hpp"
/*
    File: fn_logistic_createMenuRsc.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 30/07/2026
    Last Update: 30/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Create liberation logistic Rsc

    Parameter(s):
        -

    Returns:
        -
*/

private _displayToUse = findDisplay IDD_MISSION;

[{_this createDisplay "LiberationLogisticRsc"}, _displayToUse] call CBA_fnc_execNextFrame;