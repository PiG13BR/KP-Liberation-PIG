/*
    File: fn_battlegroupIncoming.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
    Date: 11/11/2025
    Last Update: 13/10/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Notify players that an enemy battlegroup is going to attack an objective

    Parameter(s):
        _spawnPoint - battlegroup spawn point [STRING, defaults to ""]
        _attackDestionation - blufor objective [POSITION, defaults to [0,0,0]]

    Returns:
        -
*/
if (isDedicated) exitWith {};

params [["_spawnPoint", "", [""]], ["_attackDestination", [0,0,0], [[]]]];

if (_spawnPoint isNotEqualTo "") then {
    // Put spawn marker in a cooldown. Not going to be used for the next minutes.
    if (isNil "KPLIB_usedOpforSpawnPoints") then {
        KPLIB_usedOpforSpawnPoints = [];
    };
    KPLIB_usedOpforSpawnPoints pushBack _spawnPoint;

    [{
        _this params ["_spawnPoint"];

        KPLIB_usedOpforSpawnPoints deleteAt (KPLIB_usedOpforSpawnPoints find _spawnPoint); // Remove marker from variable

    }, [_spawnPoint], 180] call CBA_fnc_waitAndExecute;
};

if (missionNamespace getVariable ["KPLIB_enemy_AttackingObjective", []] isEqualTo _attackDestination) exitWith {};
missionNamespace setVariable ["KPLIB_enemy_AttackingObjective", _attackDestination, true];

if ( isNil "KPLIB_last_incoming_notif_time" ) then { KPLIB_last_incoming_notif_time = -9999 };

if ( time > KPLIB_last_incoming_notif_time + 60 ) then {

    KPLIB_last_incoming_notif_time = time;

    private _attackLocationName = [_attackDestination] call KPLIB_fnc_getLocationName;

    ["lib_incoming", [_attackLocationName]] call BIS_fnc_showNotification;

    private _mrk = createMarkerLocal ["opfor_incoming_marker", _attackDestination];
    "opfor_incoming_marker" setMarkerTypeLocal "selector_selectedMission";
    "opfor_incoming_marker" setMarkerColorLocal KPLIB_color_enemyActive;

    [{deleteMarkerLocal _this;}, _mrk, 250] call CBA_fnc_waitAndExecute;
};
