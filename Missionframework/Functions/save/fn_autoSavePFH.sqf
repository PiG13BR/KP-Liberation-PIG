/*
    File: fn_autoSavePFH.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 16/11/2025
    Last Update: 16/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Auto-saving PFH (save_manager.sqf)

    Parameter(s):
        -

    Returns:
        -
*/
[{
    params["_args", "_handle"];

    if (KPLIB_endgame == 1) exitWith {
        profileNamespace setVariable [KPLIB_save_key, nil];
        saveProfileNamespace;
        ["Left saving loop", "SAVE"] call KPLIB_fnc_log;

        [_handle] call CBA_fnc_removePerFrameHandler;
    };

    [] call KPLIB_fnc_doSave;

    if (KPLIB_savegame_debug > 0) then {[format ["Campaign saved - Time needed: %1 seconds", diag_tickTime - _start], "SAVE"] call KPLIB_fnc_log;};

}, KPLIB_save_interval, []] call CBA_fnc_addPerFrameHandler;