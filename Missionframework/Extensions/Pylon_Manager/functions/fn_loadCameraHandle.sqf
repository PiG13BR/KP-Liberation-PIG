#include "..\defines.hpp"

/*
    File: fn_loadCameraHandle.sqf
    Author: Alganthe, johnb43
    Adaptation made by PiG13BR for Air Spawner Menu
    Date: 14/10/2025
    Update Date: 16/10/2025
    
    Description:
        Loads camera display

    Parameter(s):
        _display - display responsable
        _aircraft - aircraft object to be center camera [OBJECT]
    
    Returns:
        -
*/
params ["_display", "_aircraft"];

//--------------- Init
PIG_PylonManager_mouseButtonState = [[], []];

//--------------- Camera prep
cutText ["", "PLAIN"];
showCommandingMenu "";

PIG_PylonManager_cameraView = cameraView;
//["hideHud", [false, true, true, true, true, true, true, false, true, true]] call ace_common_fnc_showHud;

private _mouseAreaCtrl = _display displayCtrl IDC_MOUSEAREA;
ctrlSetFocus _mouseAreaCtrl;

private _centerPos = (markerPos ["airSpawn_pos", true]);

//--------------- Init camera
if (isNil "PIG_PylonManager_cameraPos") then {
    PIG_PylonManager_cameraPos = [CAM_MAX_DIST, 320, 20, [0, 0, 0.85]];
};

PIG_PylonManager_cameraHelper = createAgent ["Logic", _centerPos, [], 0, "none"];
PIG_PylonManager_cameraHelper setVehiclePosition [_centerPos, [], 0, "CAN_COLLIDE"];
PIG_PylonManager_cameraHelper setDir (markerDir "airSpawn_pos");

PIG_PylonManager_center = _aircraft;

PIG_PylonManager_camera = "camera" camCreate _centerPos;
PIG_PylonManager_camera cameraEffect ["internal", "back"];
PIG_PylonManager_camera camPrepareFocus [-1, -1];
PIG_PylonManager_camera camPrepareFov 0.35;
PIG_PylonManager_camera camCommitPrepared 0;
cameraEffectEnableHUD true;

showCinemaBorder false;
["#(argb,8,8,3)color(0,0,0,1)", false, nil, 0, [0, 0.5]] call BIS_fnc_textTiles;

//--------------- Reset camera pos
[nil, [controlNull, 0, 0]] call KPLIB_fnc_handleMouse;
PIG_PylonManager_camPosUpdateHandle = addMissionEventHandler ["Draw3D", {call KPLIB_fnc_updateCamPos}];
