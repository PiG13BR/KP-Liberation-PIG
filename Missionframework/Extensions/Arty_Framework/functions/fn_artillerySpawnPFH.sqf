/*
    File: fn_artillerySpawnPFH.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 23/11/2024 
    Last Update: 23/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Artillery spawn CBA PFH. Tries to spawn an artillery position each execution.

    Parameter(s):
        _delay - amount of time (in seconds) between executions [NUMBER]

    Returns:
        -
*/

params["_delay"];

[{
    params ["_args", "_handler"];
    if ((!isNil "KPLIB_sectors_fob") && {KPLIB_sectors_fob isNotEqualTo []}) then {
        // Spawns the artillery position
        if ((KPLIB_o_artilleryUnits isEqualTo []) && {KPLIB_enemyReadiness >= 15}) then {
            if ((count (allPlayers - entities "HeadlessClient_F") >= (1 / KPLIB_param_aggressivity))) then {
                private _artySpawned = [""] call KPLIB_fnc_artillerySpawnPosition;
                if (_artySpawned) then {
                    [_handler] call CBA_fnc_removePerFrameHandler;
                }
            }
        }
    }
}, _delay, []] call CBA_fnc_addPerFrameHandler;