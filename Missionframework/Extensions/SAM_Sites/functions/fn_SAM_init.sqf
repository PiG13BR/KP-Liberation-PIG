/*
    File: fn_SAM_init.sqf
    Author: PiG13BR (https://github.com/PiG13BR) - original ideia from Nicoman
    Date: 05/12/2025
    Last Update: 05/03/2026
    License: MIT License - http://www.opensource.org/licenses/MIT
    
    Description:
        SAM site init
    
    Parameter(s):
        -
    
    Returns:
        -
*/

if (!isServer) exitWith {};

// No SAM turrets on easiest difficulty level (as of v0.96.8, KPLIB_param_difficulty values range from 0.5 to 10)
if (KPLIB_param_difficulty < 0.75) exitWith {[format ["difficulty is easy: %1", (str KPLIB_param_difficulty)], "SAM"] call KPLIB_fnc_log;};

[] call compile preprocessFileLineNumbers "Extensions\Sam_Sites\init_templates.sqf";

if (isNil "KPLIB_SAM_sitePositions") then {
    KPLIB_SAM_sitePositions = []; 
    publicVariable "KPLIB_SAM_sitePositions";
};

KPLIB_killedTurretsSAM = 0;
publicVariable "KPLIB_killedTurretsSAM";

[] call KPLIB_fnc_SAM_spawnManager;