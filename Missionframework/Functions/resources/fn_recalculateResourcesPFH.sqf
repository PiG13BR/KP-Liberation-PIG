/*
    File: fn_recalculateResourcesPFH.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 10/09/2025
    Last update: 12/11/2025

    Description:
        Update resources PFH

    Parameter(s):
        -
    
    Returns:
        -
*/
[{
    !isNil "KPLIB_saveLoaded" && KPLIB_saveLoaded
}, {
    [{
        ["KPLIB_recalculateResources", []] call CBA_fnc_serverEvent;
    }, 3] call CBA_fnc_addPerFrameHandler;
}] call CBA_fnc_waitUntilAndExecute;

