/*
    File: fn_SAM_spawnManager.sqf
    Author: PiG13BR (https://github.com/PiG13BR) - original idea from Nicoman
    Date: 05/12/2025
    Last Update: 14/12/2025
    License: MIT License - http://www.opensource.org/licenses/MIT
    
    Description:
        Manages SAM sites
    
    Parameter(s):
        -
    
    Returns:
        -
*/

private _sleepTime =  (1800 + (random 1800)) / (([] call KPLIB_fnc_getOpforFactor) * KPLIB_param_aggressivity); // sleep time is 30 to 60 minutes
if (KPLIB_enemyReadiness >= 80) then {_sleepTime = _sleepTime * 0.75};  // when enemy readiness gets above 80, reduce sleep time to 0.75
if (KPLIB_enemyReadiness >= 90) then {_sleepTime = _sleepTime * 0.75};  // when enemy readiness gets above 90, reduce sleep time to 0.5625 (0.75 * 0.75)
if (KPLIB_enemyReadiness >= 100) then {_sleepTime = _sleepTime * 0.75}; // when enemy readiness gets above 100, reduce sleep time to 0.42 (0.75 * 0.75 * 0.75)    

// If SAM turrets were destroyed, add a 'punishment' time for the enemy. This extra time is meant to be a dampening of the production of SAM turrets
if (KPLIB_killedTurretsSAM > 0) then {
    _sleepTime = _sleepTime * KPLIB_killedTurretsSAM;
};

[{
    // Calculate maximum amount of SAM sites
    private _maxSAMnumber = 0.5;
    private _helislots = KPLIB_heli_slots;
    private _planeslots = KPLIB_plane_slots;
    private _difficulty = KPLIB_param_difficulty;
    if (KPLIB_param_difficulty isEqualTo 4) then {_difficulty = 1};
    if (KPLIB_param_difficulty isEqualTo 10) then {_difficulty = 2};
    _maxSAMnumber = _maxSAMnumber + (_helislots / 2) + (_planeslots);
    _maxSAMnumber = _maxSAMnumber + (KPLIB_enemyReadiness / 50);
    _maxSAMnumber = _maxSAMnumber * _difficulty;
    _maxSAMnumber = round _maxSAMnumber;
    if (_maxSAMnumber > PIG_SAMSite_Setting_MaxSites) then {_maxSAMnumber = PIG_SAMSite_Setting_MaxSites};

    // maximum amount of SAM turrets should not exceed number of opfor sectors
    if (_maxSAMnumber > (count KPLIB_sectors_all - count KPLIB_sectors_player)) then {_maxSAMnumber = count KPLIB_sectors_all - count KPLIB_sectors_player};

    // If maximum amount of SAM turrets has not been reached yet, add one to the map
    if (count KPLIB_SAM_sitePositions < _maxSAMnumber) then {
        [] call KPLIB_fnc_SAM_createSite;
    };

    // Call the management again
    [] call KPLIB_fnc_SAM_spawnManager;
}, [], _sleepTime] call CBA_fnc_waitAndExecute;