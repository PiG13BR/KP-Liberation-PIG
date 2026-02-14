/*
    File: fn_updateCamPos.sqf
    Author: Karel Moricky, modified by Alganthe.
    Adaptation made by PiG13BR for Air Spawner Menu
    Date: 14/10/2025
    Update Date: 13/02/2026
    
    Description:
        Updates the camera pos each frame (called from a draw3D MEH)
        Draw a pylon icon to show to the player what pylon is selected

    Parameter(s):
        -
    
    Returns:
        -
*/
PIG_PylonManager_cameraPos params ["_distance", "_dirH", "_dirV"];

[PIG_PylonManager_cameraHelper, [_dirH + 180, - _dirV, 0]] call BIS_fnc_setObjectRotation;
PIG_PylonManager_cameraHelper attachTo [PIG_PylonManager_center, PIG_PylonManager_cameraPos select 3, ""]; // Reattach for smooth movement

PIG_PylonManager_camera setPos (PIG_PylonManager_cameraHelper modelToWorld [0, -_distance, 0]);
PIG_PylonManager_camera setVectorDirAndUp [vectorDir PIG_PylonManager_cameraHelper, vectorUp PIG_PylonManager_cameraHelper];

private _aircraft = localNamespace getVariable ["PIG_PylonManager_aircraft", objNull];

if (isNull _aircraft) exitWith {};

// Pylon draw3d
if (!(_aircraft isKindOf "Air") || {(localNameSpace getVariable ["PIG_PylonManager_pylonName", ""]) isEqualTo ""}) exitWith {};

// Get pylon relative pos
private _selectedPylon = localNameSpace getVariable ["PIG_PylonManager_pylonName", ""];
private _pylonRelPos = PIG_PylonManager_pylonsPosHash get _selectedPylon;
if (isNil "_pylonRelPos") exitWith {}; // Avoid error on changing aircraft

private _role = _pylonRelPos # 1;
_pylonRelPos = _pylonRelPos # 0;

drawIcon3D
[
    "z\ace\addons\interact_menu\ui\selector1.paa",
    [1,1,1,1],
    _aircraft modelToWorld _pylonRelPos,
    1.5,
    1.5,
    0,
    _selectedPylon,
    2,
    0.04,
    "RobotoCondensed",
    "right",
    true
];

switch (true) do {
    case (_role isEqualTo [0]) : {
        drawIcon3D
        [
            "a3\ui_f\data\igui\rscingameui\rscunitinfo\role_gunner_ca.paa",
            [1,1,1,1],
            _aircraft modelToWorld _pylonRelPos,
            1.2,
            1.2,
            0,
            "",
            2,
            0.04,
            "RobotoCondensed",
            "right",
            true
        ];
    };
    case (_role isEqualTo [-1]) : {
        drawIcon3D
        [
            "a3\ui_f\data\igui\rscingameui\rscunitinfo\role_driver_ca.paa",
            [1,1,1,1],
            _aircraft modelToWorld _pylonRelPos,
            1.2,
            1.2,
            0,
            "",
            2,
            0.04,
            "RobotoCondensed",
            "right",
            true
        ];
    };
    default {        
        drawIcon3D
        [
            "a3\ui_f\data\igui\rscingameui\rscunitinfo\role_driver_ca.paa",
            [1,1,1,1],
            _aircraft modelToWorld _pylonRelPos,
            1,
            1,
            0,
            "",
            2,
            0.04,
            "RobotoCondensed",
            "right",
            true
        ];
    };
};
