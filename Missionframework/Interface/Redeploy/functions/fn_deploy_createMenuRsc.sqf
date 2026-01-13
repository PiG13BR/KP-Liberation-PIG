#include "..\defines.hpp"
/*
    File: fn_deploy_createMenuRsc.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 04/11/2025
    Last Update: 17/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Create liberation deploy Rsc

    Parameter(s):
        -

    Returns:
        -
*/
[{
    // Conditions
    !isNil "KPLIB_sectors_fob" &&
    {!isNil "KPLIB_sectors_player"} &&
    {!isNil "KPLIB_saveLoaded"} &&
    {KPLIB_saveLoaded} &&
    {!isNil "introDone"} && 
    {introDone} &&
    {!isNil "cinematic_camera_stop" }&&
    {cinematic_camera_stop}
}, {
    // Exec
    private _displayToUse = findDisplay IDD_MISSION;

    [{_this createDisplay "LiberationDeployRsc"}, _displayToUse] call CBA_fnc_execNextFrame;
}, []] call CBA_fnc_waitUntilAndExecute;