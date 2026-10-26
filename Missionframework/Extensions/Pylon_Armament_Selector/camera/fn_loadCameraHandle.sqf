#include "..\defines.hpp"

/*
    File: fn_loadCameraHandle.sqf
    Author: Alganthe, johnb43
    Adaptation made by PiG13BR for Air Spawner Menu
    Date: 14/10/2025
    Update Date: 05/10/2026
    
    Description:
        Loads camera display

    Parameter(s):
        _display - display responsable
        _aircraft - aircraft object to be center camera [OBJECT, defaults to objNull]
    
    Returns:
        -
*/
params ["_display", ["_aircraft", objNull, [objNull]]];

//--------------- Init
PIG_PAS_mouseButtonState = [[], []];

//--------------- Camera prep
cutText ["", "PLAIN"];
showCommandingMenu "";

PIG_PAS_cameraView = cameraView;
showHUD [false, false, false, false, false, false, false, false, false, false, true];

private _mouseAreaCtrl = _display displayCtrl IDC_MOUSEAREA;
ctrlSetFocus _mouseAreaCtrl;

private _centerPos = (markerPos ["airSpawn_pos", true]);

//--------------- Init camera
if (isNil "PIG_PAS_cameraPos") then {
    private _boundingBoxReal = boundingBoxReal _aircraft;
    private _distanceMax = ((_boundingBoxReal select 0) vectorDistance (_boundingBoxReal select 1)) * 1.5;
    PIG_PAS_cameraPos = [_distanceMax, 320, 20, [0, 0, 0.85]];
};

PIG_PAS_cameraHelper = createAgent ["Logic", _centerPos, [], 0, "none"];
PIG_PAS_cameraHelper setVehiclePosition [_centerPos, [], 0, "CAN_COLLIDE"];
PIG_PAS_cameraHelper setDir (markerDir "airSpawn_pos");

PIG_PAS_center = _aircraft;

PIG_PAS_camera = "camera" camCreate _centerPos;
PIG_PAS_camera cameraEffect ["internal", "back"];
PIG_PAS_camera camPrepareFocus [-1, -1];
PIG_PAS_camera camPrepareFov 0.35;
PIG_PAS_camera camCommitPrepared 0;
cameraEffectEnableHUD true;

if (currentVisionMode player == 1) then {
    player action ["NVGogglesOff", player];
};

showCinemaBorder false;
["#(argb,8,8,3)color(0,0,0,1)", false, nil, 0, [0, 0.5]] call BIS_fnc_textTiles;

//--------------- Reset camera pos
[nil, [controlNull, 0, 0]] call KPLIB_fnc_handleMouse;
PIG_PAS_camPosUpdateHandle = addMissionEventHandler ["Draw3D", {[_thisArgs # 0] call KPLIB_fnc_updateCamPos}, [_display]];