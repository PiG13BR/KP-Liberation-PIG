/*
    File: fn_deploy_barracksNearby.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 08/01/2026
    Last Update: 08/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Check if the FOB has barracks

    Parameter(s):
        _respawnPos - respawn position used as reference to get the nearest FOB [POSITION, defaults to [0,0,0]] 

    Returns:
        Bool and Fob name [ARRAY]
*/
params[["_respawnPos", [0,0,0], [[]]]];

private _canRespawn = true;

if (_respawnPos isEqualTo [0,0,0]) exitWith {_canRespawn};
if (KPLIB_sectors_FOB isEqualTo []) exitWith {_canRespawn};

// Check range from the nearest fob
private _closestFobPos = [_respawnPos] call KPLIB_fnc_getNearestFob;

// Players and respawn pos is inside the fob
if (_respawnPos distance2D _closestFobPos > KPLIB_range_fob) exitWith {_canRespawn};

// Check for neaby barracks
if (count (_closestFobPos nearObjects [KPLIB_b_barrack, KPLIB_range_fob]) < 2) then {
    _canRespawn = false
};

_canRespawn

