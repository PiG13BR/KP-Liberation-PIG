#include "..\defines.hpp";
/*
    File: fn_deploy_loadMenu.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 04/11/2025
    Last Update: 17/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Loads liberation redeploy menu

    Parameter(s):
        _display - redeploy menu display [DISPLAY, defaults to (findDisplay DEPLOY_IDD)]

    Returns:
        -
*/
params[["_display", (findDisplay DEPLOY_IDD)]];

fullmap = 0;
_old_fullmap = 0;

KPLIB_respawnPositionsList = [];

localNamespace setVariable ["KPLIB_playerDeploying", player];

// Controls
private _loadoutsComboCtrl = _display displayCtrl DEPLOY_LOADOUTS_COMBO;
private _deployMapCtrl = _display displayCtrl DEPLOY_MAP;
private _deployButtonCtrl = _display displayCtrl DEPLOY_BUTTON;

KPLIB_respawn_time = time;
KPLIB_respawn_mobile_done = false;

// Redeploy Manager
private _backpack = backpack player;

showCinemaBorder false;
camUseNVG false;
respawn_camera = "camera" camCreate (getposATL startbase);
respawn_object = "Sign_Arrow_Blue_F" createVehicleLocal (getposATL startbase);
respawn_object hideObject true;
respawn_camera camSetTarget respawn_object;
respawn_camera cameraEffect ["internal","back"];
respawn_camera camcommit 0;

// Loadouts
private _loadouts_data = [] call KPLIB_fnc_deploy_getArsenalLoadout;

_loadoutsComboCtrl lbAdd "--";
{_loadoutsComboCtrl lbAdd (_x param [0])} forEach _loadouts_data;
_loadoutsComboCtrl lbSetCurSel 0;

localNamespace setVariable ["KPLIB_loadoustData", _loadouts_data];

// Deploy positions (update KPLIB_respawnPositionsList variable)
[_display] call KPLIB_fnc_deploy_getPositions;

// Map ctrl related (ToDo Function)
"spawn_marker" setMarkerPosLocal (getpos respawn_object);
ctrlMapAnimClear _deployMapCtrl;
private _transition_map_pos = getpos respawn_object;
private _fullscreen_map_offset = 4000;
if(fullmap % 2 == 1) then {
    _transition_map_pos = [(_transition_map_pos select 0) - _fullscreen_map_offset,  (_transition_map_pos select 1) + (_fullscreen_map_offset * 0.75), 0];
};
_deployMapCtrl ctrlMapAnimAdd [0, 0.3,_transition_map_pos];
ctrlMapAnimCommit _deployMapCtrl;

_frame_pos = _display displayCtrl DEPLOY_RECYCLEBG;
_standard_map_pos = ctrlPosition _deployMapCtrl;

if (_old_fullmap != fullmap) then {
    _old_fullmap = fullmap;
    if (fullmap % 2 == 1) then {
        _deployMapCtrl ctrlSetPosition [ (_frame_pos select 0) + (_frame_pos select 2), (_frame_pos select 1), (0.6 * safezoneW), (_frame_pos select 3)];
    } else {
        _deployMapCtrl ctrlSetPosition _standard_map_pos;
    };
    _deployMapCtrl ctrlCommit 0.2;
};