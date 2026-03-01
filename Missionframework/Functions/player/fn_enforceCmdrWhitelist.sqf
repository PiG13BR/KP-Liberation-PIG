/*
    File: fn_handlePlacedZeusObject.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: -
    Last Update: 19/02/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Enforce commander whitelist. Detects if the player in the commander role is in the whitelist.

    Parameter(s):
        _player - player to assign zeus module [OBJECT, defaults to player]

    Returns:
        Function reached the end [BOOL]
*/
params[["_player", player, [objNull]]];

if (count KPLIB_whitelist_cmdrSlot < 1) exitWith {};

waitUntil {alive player};
sleep 1;

if (player isEqualTo ([] call KPLIB_fnc_getCommander) && !(serverCommandAvailable "#kick")) then {
    if !((getPlayerUID player) in KPLIB_whitelist_cmdrSlot) then {
        sleep 1;
        endMission "END1";
    };
};