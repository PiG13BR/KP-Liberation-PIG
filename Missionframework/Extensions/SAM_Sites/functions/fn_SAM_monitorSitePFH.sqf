/*
    File: fn_SAM_monitorSitePFH.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 05/12/2025
    Last Update: 02/02/2026
    License: MIT License - http://www.opensource.org/licenses/MIT
    
    Description:
        Monitor SAM site independently with PFH
        Each execution check for dead assets and rearm alive ones
    
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

[{
    params["_args", "_handle"];
    _args params["_spawnMarker", "_radar", "_samTurrets", ["_samObjects", []], ["_samShorads", []], ["_staticGroup", []], ["_infGarrison", []], ["_infPatrols", []]];

    // Check values
    private _launchersCount = 0;
    private _launchersDown = 0;
    private _siteDown = false;

    // Check radar 
    if (!alive _radar || {!alive (gunner _radar)}) then {
        _siteDown = true;
    };

    // Iterate each turret
    {
        private _sam = _x;

        if (_siteDown) then {
            // Deactivate launchers for this site if radars are down
            _sam setVehicleReceiveRemoteTargets false;
            _sam setVehicleReportRemoteTargets false;
            _sam setVehicleAmmo 0;
        } else {
            _launchersCount = _launchersCount + 1;
            // Check if launcher is alive
            if (!alive _sam || {!alive (gunner _sam)}) then {
                _launchersDown = _launchersDown + 1;
            } else {
                // Restore ammo and fuel
                _sam setVehicleAmmo 1;
                _sam setFuel 1;
            };

            // Check if all launchers are down
            if (_launchersDown >= _launchersCount) then {
                _siteDown = true;
            };
        }
    } forEach _samTurrets;

    if (_siteDown) then {
        // Delete site
        ["lib_enemy_sam_destroyed", []] remoteExec ["BIS_fnc_showNotification"];
        [_spawnMarker, _radar, _samTurrets, _samObjects, _samShorads, _staticGroup, _infGarrison, _infPatrols] call KPLIB_fnc_SAM_deleteSite;
        [_handle] call CBA_fnc_removePerFrameHandler;
    };
},  2, [_spawnMarker, _radar, _samTurrets, _samObjects, _samShorads, _staticGroup, _infGarrison, _infPatrols]] call CBA_fnc_addPerFrameHandler;