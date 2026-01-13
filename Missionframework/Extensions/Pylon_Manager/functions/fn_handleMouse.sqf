/*
    File: fn_handleMouse.sqf
    Author: Karel Moricky, modified by Alganthe, johnb43
    Adaptation made by PiG13BR for Air Spawner Menu
    Date: 14/10/2025
    Update Date: 14/10/2025
    
    Description:
        Update the camera position and pitch/bank.

    Parameter(s):
        0: Not used
        1: Arguments <ARRAY>
            - 0: Mouse area control <CONTROL>
            - 1: Mouse X position <NUMBER>
            - 2: Mouse Y position <NUMBER>
    
    Returns:
        -
*/

params ["", "_args"];
_args params ["_control", "_mouseX", "_mouseY"];

PIG_PylonManager_cameraPos params ["", "_dirH", "_dirV", "_helperPos"];
PIG_PylonManager_mouseButtonState params ["_LMB", "_RMB"];

if (count _LMB > 0) then {
    _LMB params ["_LMBcursorX", "_LMBcursorY"];
    private _dX = [_mouseX - _LMBcursorX, _LMBcursorX - _mouseX] select PIG_PylonManager_camInverted;
    private _dY = [_mouseY -_LMBcursorY, _LMBcursorY - _mouseY] select PIG_PylonManager_camInverted;

    private _centerBox = boundingBoxReal PIG_PylonManager_center;
    private _centerSizeBottom = _centerBox select 0 select 2;
    private _centerSizeUp = _centerBox select 1 select 2;
    private _centerSize = sqrt ([_centerBox select 0 select 0, _centerBox select 0 select 1] distance [_centerBox select 1 select 0, _centerBox select 1 select 1]);

    _helperPos = [_helperPos, _dX * _centerSize, _dirH - 90] call BIS_fnc_relPos;

    _helperPos = [
        [0, 0, ((_helperPos select 2) - _dY * _centerSize) max _centerSizeBottom min _centerSizeUp],
        ([0, 0, 0] distance2D _helperPos) min _centerSize,
        [0, 0, 0] getDir _helperPos
    ] call BIS_fnc_relPos;

    _helperPos set [2, (_helperPos select 2) max ((_centerBox select 0 select 2) + 0.2)];

    PIG_PylonManager_cameraPos set [3, _helperPos];
    PIG_PylonManager_mouseButtonState set [0, [_mouseX, _mouseY]];
};

if (count _RMB > 0) then {
    _RMB params ["_RMBcursorX", "_RMBcursorY"];

    private _dX = (_RMBcursorX - _mouseX) * 0.75;
    private _dY = (_RMBcursorY - _mouseY) * 0.75;

    _helperPos = [
        [0, 0, _helperPos select 2],
        [0, 0, 0] distance2D _helperPos,
        ([0, 0, 0] getDir _helperPos) - _dX * 360
    ] call BIS_fnc_relPos;

    PIG_PylonManager_cameraPos set [1, _dirH - _dX * 360];
    PIG_PylonManager_cameraPos set [2, (_dirV - _dY * 100) max -89 min 89];
    PIG_PylonManager_cameraPos set [3, _helperPos];
    PIG_PylonManager_mouseButtonState set [1, [_mouseX, _mouseY]];
};

if (!alive PIG_PylonManager_center) then {
    (ctrlParent _control) closeDisplay IDC_CANCEL;
};
