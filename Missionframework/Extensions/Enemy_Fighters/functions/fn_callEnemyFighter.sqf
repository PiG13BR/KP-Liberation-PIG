/*
    File: fn_callEnemyFighter.sqf
    Author: PiG13BR - (https://github.com/PiG13BR)
    Date: 17/08/2025
    Last update: 01/03/2026

    Description:
        Handles enemy air fighter
    
    Parameter(s)
        _targetPos - target pos reference [POSITION, defaults to [0,0,0]]

    Returns:
        -
*/

params[["_targetPos", [0,0,0], [[]], [2,3]]];

if (_targetPos isEqualTo [0,0,0]) exitWith {["No position provided to spawn enemy fighter"] call BIS_fnc_error};

if (count KPLIB_playerAircrafts < 1) exitWith {};

if (isNil "KPLIB_enemy_jetInAir") then {
    KPLIB_enemy_jetInAir = [];
    publicVariable "KPLIB_enemy_jetInAir";
};

if (count KPLIB_enemy_jetInAir >= ((floor KPLIB_param_difficulty) min 3)) exitWith {};

// Spawning enemy jet
private _fighter = [_targetPos] call KPLIB_fnc_spawnEnemyFighter;

if (isNull _fighter) exitWith {["Enemy fighter is null", "ENEMY FIGHTER"] call KPLIB_fnc_log};

KPLIB_enemy_jetInAir pushBack _fighter;
publicVariable "KPLIB_enemy_jetInAir";

// Notify players
["lib_enemy_fighter_inbound", []] remoteExec ["BIS_fnc_showNotification"];

// Enemy Jet PFH
[{
    params ["_args", "_handle"];
    _args params ["_plane", "_despawnPos"];

    if ((alive _plane) && (canFire _plane) && (canMove _plane) && (damage _plane <= 0.5) && ({alive _x} count (crew _plane) > 0) && {((getPosATL _plane) # 2) >= 10} && {fuel _plane > 0.2} && {KPLIB_playerAircrafts isNotEqualTo []}) then {
        {
            _plane reveal [_x, 1.5];
        }forEach KPLIB_playerAircrafts; 
    } else {
        if (alive _plane && ({alive _x} count crew _plane > 0)) then {
            // Return to the spawn position 
            (group _plane) setBehaviourStrong "CARELESS";
            {
                _plane forgetTarget _x;
            }forEach KPLIB_playerAircrafts; 
            _plane doMove _despawnPos;
            [{
                params ["_plane", "_despawnPos"];

                _plane distance2D _despawnPos <= 500
            }, {
                deleteVehicleCrew (_this # 0);
                deleteVehicle (_this # 0);
            }, [_plane, _despawnPos], 180, {deleteVehicleCrew (_this # 0); deleteVehicle (_this # 0)}] call CBA_fnc_waitUntilAndExecute;
        };
        [_handle] call CBA_fnc_removePerFrameHandler;
    }
}, 30, [_fighter, getPosATL _fighter]] call CBA_fnc_addPerFrameHandler;