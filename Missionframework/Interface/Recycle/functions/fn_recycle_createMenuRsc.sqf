#include "..\defines.hpp"
/*
    File: fn_recycle_createMenuRsc.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 22/11/2025
    Last Update: 22/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Create liberation recycle Rsc

    Parameter(s):
        _vehicle - vehicle to recycle

    Returns:
        -
*/
params["_vehicle"];

private _displayToUse = findDisplay IDD_MISSION;

localNamespace setVariable ["KPLIB_vehToRecycle", _vehicle];

// Create dialog
[{_this createDisplay "LiberationRecycleRsc"}, _displayToUse] call CBA_fnc_execNextFrame;