/*
    File: fn_unloadCameraHandle.sqf
    Author: Alganthe
    Adaptation made by PiG13BR for Air Spawner Menu
    Date: 14/10/2025
    Update Date: 14/10/2025
    
    Description:
        Unloads EH and deletes variables from the camera handle

    Parameter(s):
        -
    
    Returns:
        -
*/

removeMissionEventHandler ["Draw3D", PIG_PylonManager_camPosUpdateHandle];

if (!isNull curatorCamera && {ACE_player == player}) then {
    curatorCamera cameraEffect ["Internal", "BACK"];
} else {
    PIG_PylonManager_camera cameraEffect ["Terminate", "BACK"];
};

deleteVehicle PIG_PylonManager_cameraHelper;
camDestroy PIG_PylonManager_camera;

ACE_player switchCamera PIG_PylonManager_cameraView;

PIG_PylonManager_camera = nil;
PIG_PylonManager_cameraHelper = nil;
PIG_PylonManager_mouseButtonState = nil;
PIG_PylonManager_center = nil;

["hideHud", []] call ace_common_fnc_showHud;
