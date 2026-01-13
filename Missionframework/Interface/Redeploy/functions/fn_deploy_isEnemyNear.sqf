#include "..\defines.hpp"
/*
    File: fn_deploy_isEnemyNear.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 07/11/2025
    Last Update: 17/11/20255
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Check rally point area for enemy nearby

    Parameter(s):
        _deployPos - deploy object to check for nearby enemy units [OBJECT, defaults to objNull]

    Returns:
        BOOL
*/
params[["_deployPos", [0,0,0], [[]]]];

if (_deployPos isEqualTo [0,0,0]) exitWith {false};

((ASLToAGL (ATLToASL (_deployPos)) nearEntities [["CAManBase", "LandVehicle", "Air"], MIN_DIST_CHECK_DEPLOY]) findIf {(alive _x) && {[_x] call KPLIB_fnc_ace_isAwake} && {side _x == KPLIB_side_enemy}}) >= 0