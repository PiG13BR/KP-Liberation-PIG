/*
    File: fn_deploy_createMenuRsc.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 04/11/2025
    Last Update: 05/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Create liberation deploy Rsc

    Parameter(s):
        -

    Returns:
        -
*/
params["_display"];

private _player = localNamespace getVariable ["KPLIB_playerDeploying", player];

respawn_camera cameraEffect ["Terminate","back"];
camDestroy respawn_camera;
deleteVehicle respawn_object;
camUseNVG false;
"spawn_marker" setMarkerPosLocal markers_reset;

if (KPLIB_respawn_mobile_done) then {
    KPLIB_respawn_time = time + KPLIB_param_mobileRespawnCooldown;
    KPLIB_respawn_mobile_done = false;
};

if (KPLIB_param_useArsenalPreset > 0) then {
    [_backpack] call KPLIB_fnc_checkGear;
};

if (KPLIB_param_mobileRespawn && (KPLIB_respawn_time > time)) then {
    [format [localize "STR_RESPAWN_COOLDOWN_HINT", ceil ((KPLIB_respawn_time - time) / 60)], true, 2] call KPLIB_fnc_hint;
};

[KPLIB_REDEPLOY_pfhandle] call CBA_fnc_removePerFrameHandler;

localNamespace setVariable ["KPLIB_loadoustData", nil];
localNamespace getVariable ["KPLIB_playerDeploying", nil];

if (_player distance2D (markerPos "respawn") < 100) then {
    // If player is still near respawn point, reload GUI
    [] call KPLIB_fnc_deploy_createMenuRsc;
};

