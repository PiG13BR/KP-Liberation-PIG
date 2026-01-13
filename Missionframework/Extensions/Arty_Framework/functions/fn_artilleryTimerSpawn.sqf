/*
    File: fn_artilleryTimerSpawn.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 22/09/2024 
    Last Update: 09/12/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Sets a delay to spawns the enemy artillery position in the map (About 15-30 min)

    Parameter(s):
        -  

    Returns:
        -
*/

if (!isServer) exitWith {};

KPLIB_o_artilleryUnits = [];

private _sleeptime =  (900 + (random 900)) / (([] call KPLIB_fnc_getOpforFactor) * KPLIB_param_aggressivity);

if (KPLIB_enemyReadiness >= 40) then {_sleeptime = _sleeptime * 0.75;};
if (KPLIB_enemyReadiness >= 60) then {_sleeptime = _sleeptime * 0.75;};
if (KPLIB_enemyReadiness >= 80) then {_sleeptime = _sleeptime * 0.75;};

if (!isNil "KPLIB_artilleryPosition_Down") then {
    if (KPLIB_artilleryPosition_Down > 0) then {
            // Punish enemies with more delay
        if (KPLIB_artilleryPosition_Down == 1) then {KPLIB_artilleryPosition_Down = 1.5};
        _sleeptime = _sleeptime * KPLIB_artilleryPosition_Down;
    };
};

[{
    params["_sleeptime"];
    [_sleeptime] call KPLIB_fnc_artillerySpawnPFH;
}, _sleeptime, _sleeptime] call CBA_fnc_waitAndExecute;
