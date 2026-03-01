/*
    File: fn_enemyFighterPFH.sqf
    Author: PiG13BR - (https://github.com/PiG13BR)
    Date: 04/02/2026
    Last update: 01/03/2026

    Description:
        Runs a CBA PFH to check some conditions to spawn an enemy fighter
    
    Parameter(s)
        _vehicle - player's air asset [OBJECT]

    Returns:
        -
*/
params["_vehicle"];

_vehicle setVariable ["KPLIB_playerInAircraft", true];
[{
    params ["_air", "_handle"];

    if (!alive _air || (count (crew _air) < 1) || (driver _air == objNull)) then {[_handle] call CBA_fnc_removePerFrameHandler;};

    if (KPLIB_enemyReadiness >= (65 - (5 * KPLIB_param_difficulty))) then {
        private _tower = [getPosATL _air, KPLIB_side_enemy, KPLIB_range_radioTowerScan * 1.4] call KPLIB_fnc_getNearestTower;
        if (!(isNil "_tower") && ({alive _x} count (crew _air) > 0) && {((getPosATL _air) # 2) >= 150}) then {    
            [
                {
                    //[getPosASL _this] call KPLIB_fnc_callEnemyFighter
                    ["KPLIB_callEnemyFighter", getPosASL _this] call CBA_fnc_serverEvent;
                }, _air, (30 + random 30)
            ] call CBA_fnc_waitAndExecute;
            
            [_handle] call CBA_fnc_removePerFrameHandler;
        }
    }
}, 10, _vehicle] call CBA_fnc_addPerFrameHandler;