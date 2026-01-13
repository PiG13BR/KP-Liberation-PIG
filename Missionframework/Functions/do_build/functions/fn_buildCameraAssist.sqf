/*
    File: fn_buildCameraAssist.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 28/08/2025
    Last update: 12/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Creates the build camera assist

    Parameter(s)
        _player - player that is moving the preplaced object [OBJECT, defaults to player]
        _cameraOn - true for showing off the pip camera; false, for destroying the created camera [BOOL, defaults to true]

    Returns:
        -
*/

params[["_player", player, [objNull]], ["_cameraOn", true, [FALSE]]];

private _camera = _player getVariable ["KPLIB_BUILD_camera", objNull];
private _object = _player getVariable ["KPLIB_BUILD_preplacedObject", objNull];
private _logic = _player getVariable ["KPLIB_BUILD_cameraLogic", objNull];

if (_cameraOn) then {
    cutRsc ["KPLIB_BUILD_RscBuildPiP","PLAIN", 0, false]; // Call the resources
    if (isNull _camera) then {
        _camera = "camera" camCreate (getPosASL _object); // Create camera
        _player setVariable ["KPLIB_BUILD_camera", _camera]; // Save camera
    } else {
        _camera setPosASL (getPos _object);
        {detach _x}forEach attachedObjects _camera;
    };
    // Create logic
    if (isNull _logic) then {
        private _logicSide = createGroup sideLogic;
        _logic = _logicSide createUnit ["logic", getPosATL _object, [], 0, "CAN_COLLIDE"];
        _player setVariable ["KPLIB_BUILD_cameraLogic", _logic];
    };

    _logic attachTo [_player, _player worldToModel (ASLToAGL (getPosWorld _object))];
    _logic setPosATL (getPosATL _object);
    _logic setDir ((getDir _player) - (_logic getDir _player)); // Relative direction

    // Check boundingbox
    _objectBoundSphere = ceil(boundingBox _object # 2);

    _camera attachTo [_logic, [0, 0.1, _objectBoundSphere * 3]]; // Attach camera. Adjust height (z) accordingly to the boundingsphere of the object (size)
    _camera camPrepareTarget _logic;
    _camera camSetTarget _logic;
    _camera cameraEffect ["Internal", "Back", "rttbuild"];
    //if (sunOrMoon < 1) then {"rttbuild" setPiPEffect [1]} else {"rttbuild" setPiPEffect [0]};
    _camera camCommitPrepared 0; 
    cameraEffectEnableHUD true;
    showCinemaBorder false;
    showHUD true;
} else {
    // Destroy camera
    _camera cameraEffect ["terminate", "back"];
    camDestroy _camera;
    cutRsc ["RemoveRsc", "PLAIN"]; // Remove resource
    if (isNull _camera) exitWith {};
    _camera cameraEffect ["terminate", "back"];
    camDestroy _camera;
    _player setVariable ["KPLIB_BUILD_camera", nil];
    deleteVehicle _logic;
    _player setVariable ["KPLIB_BUILD_cameraLogic", objNull];
};
