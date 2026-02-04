/*
    File: fn_SAM_deleteSite.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 05/12/2025
    Last Update: 02/02/2026
    License: MIT License - http://www.opensource.org/licenses/MIT
    
    Description:
        Delete SAM site
    
    Parameter(s):
        All elements from the spawned template
    
    Returns:
        -
*/

params[   
    "_spawnMarker", 
    "_radar", 
    "_samTurrets", 
    ["_samObjects", []], 
    ["_samShorads", []], 
    ["_staticGroup", []], 
    ["_infGarrison", []], 
    ["_infPatrols", []]
];

// Wait some minutes to start despawn process
[{
    params["_radar", "_samTurrets", ["_samObjects", []], ["_samShorads", []], ["_staticGroup", []], ["_infGarrison", []], ["_infPatrols", []]];
    
    private _group = _radar getVariable ["KPLIB_samSiteGroup", grpNull];

    {moveOut _x}forEach (units _group);

    [_group] call KPLIB_fnc_despawnGroup;
    {[_x] call KPLIB_fnc_despawnGroup}forEach (_infPatrols + _staticGroup + _infGarrison);

    {
        [_x] call KPLIB_fnc_despawnObject;
    } forEach (_samObjects + _samTurrets + [_radar] + _samShorads);

}, [_radar, _samTurrets, _samObjects, _samShorads, _staticGroup, _infGarrison, _infPatrols], 30] call CBA_fnc_waitAndExecute;

KPLIB_SAM_sitePositions deleteAt (KPLIB_SAM_sitePositions find _spawnMarker);
publicVariable "KPLIB_SAM_sitePositions";


KPLIB_killedTurretsSAM = KPLIB_killedTurretsSAM + 1;
publicVariable "KPLIB_killedTurretsSAM";