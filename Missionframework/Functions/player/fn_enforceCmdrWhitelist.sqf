/*
    File: fn_enforceCmdrWhitelist.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: -
    Last Update: 01/03/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Enforce commander whitelist. Detects if the player in the commander role is in the whitelist.

    Parameter(s):
        _player - player to check [OBJECT, defaults to player]

    Returns:
        Function reached the end [BOOL]
*/
params[["_player", player, [objNull]]];

if (count KPLIB_whitelist_cmdrSlot < 1) exitWith {false};

waitUntil {alive player};
sleep 1;

if (player isEqualTo ([] call KPLIB_fnc_getCommander) && !(serverCommandAvailable "#kick")) then {
    if !((getPlayerUID player) in KPLIB_whitelist_cmdrSlot) then {
        sleep 1;
        endMission "END1";
    };
};

true