/*
    File: fn_deploy_playerCanRedeploy.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 17/11/2025
    Last Update: 08/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Check if the FOB has enough resources to able the player to respawn

    Parameter(s):
        _respawnPos - respawn position used as reference to get the nearest FOB [POSITION, defaults to [0,0,0]] 

    Returns:
        Bool and Fob name [ARRAY]
*/
params[["_respawnPos", [0,0,0], [[]]]];

private _canRespawn = [true, ""];

if (_respawnPos isEqualTo [0,0,0]) exitWith {_canRespawn};
if (KPLIB_sectors_FOB isEqualTo []) exitWith {_canRespawn};
if (KPLIB_param_respawnCost < 1) exitWith {_canRespawn};

private _player = localNamespace getVariable ["KPLIB_playerDeploying", player];

// Check range from the nearest fob
private _closestFobPos = [_respawnPos] call KPLIB_fnc_getNearestFob;

// Players and respawn pos is inside the fob, ignore cost
if ((_respawnPos distance2D _closestFobPos < KPLIB_range_fob) && {_player distance2D _closestFobPos < KPLIB_range_fob}) exitWith {_canRespawn};

// Respawn pos is outside of fob minimal cost range, ignore cost
if ((_respawnPos distance2D _closestFobPos) > (KPLIB_range_fob * 2)) exitWith {_canRespawn};

// Respawn pos is inside of fob minimal cost range, return fob name to warn players
if (_respawnPos distance2D _closestFobPos < (KPLIB_range_fob * 2)) then {_canRespawn set [1, [_closestFobPos] call KPLIB_fnc_getFobName];};

// Respawn cost
private _supplies = KPLIB_param_respawnCost;
private _ammo = KPLIB_param_respawnCost;
private _fuel = KPLIB_param_respawnCost;

// Check fob available supplies
private _fobData = KPLIB_fob_resources select {((_x select 0) distance _closestFobPos) < KPLIB_range_fob};

(_fobData # 0) params ["", "_fobSupplies", "_fobAmmo", "_fobFuel"];

if (
    ((_supplies > 0) && (_supplies > _fobSupplies)) ||
    ((_ammo > 0) && (_ammo > _fobAmmo)) ||
    ((_fuel > 0) && (_fuel > _fobFuel))
) then {
    _canRespawn set [0, false];
};

_canRespawn