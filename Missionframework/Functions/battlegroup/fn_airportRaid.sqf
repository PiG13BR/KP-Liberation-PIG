/*
    File: fn_airportRaid.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 30/10/2025 
    Last Update: 01/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns battlegroups to attack an airport sector

    Parameter(s):
		_targetPos - airport position to attack [POSITION, defaults to [0 ,0 ,0]

    Returns:
        -
*/
params[["_targetPos", [0, 0, 0], [[]], [2,3]]];

if (_targetPos isEqualTo [0, 0, 0]) exitWith {};

if !(canSuspend) exitWith {_this spawn KPLIB_fnc_airportRaid};

// Paradrop or heli transport + slingload vehicles
if (random 100 <= 50) then {
    ["", _targetPos, ""] call KPLIB_fnc_battlegroupParatroopers;
    sleep 3;
    if (KPLIB_param_unitCap >= 1) then {
        ["", _targetPos, ""] call KPLIB_fnc_battlegroupParatroopers;
    };
    sleep 3;
    if (KPLIB_enemyReadiness >= 75) then {
        ["", _targetPos, ""] call KPLIB_fnc_battlegroupParatroopers;
    };
} else {
    ["", _targetPos, "", false] call KPLIB_fnc_battlegroupTransportHeli;
    sleep 3;
    if (KPLIB_param_unitCap >= 1) then {
        ["", _targetPos, "", false] call KPLIB_fnc_battlegroupTransportHeli;
    };
    sleep 3;
    if (KPLIB_enemyReadiness >= 75) then {
        ["", _targetPos, ""] call KPLIB_fnc_battlegroupAttackHeli;
    };
    ["", _targetPos, "", false] call KPLIB_fnc_battlegroupSlingLoadVeh;
    sleep 3;
    if (KPLIB_param_unitCap >= 1) then {
        ["", _targetPos, "", false] call KPLIB_fnc_battlegroupSlingLoadVeh;
    };
};
KPLIB_last_battlegroup_time = diag_tickTime;
["KPLIB_reinfIncoming", ["", _targetPos]] call CBA_fnc_globalEvent;