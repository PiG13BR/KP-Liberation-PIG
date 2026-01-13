/*
    File: fn_handleScrollWheel.sqf
    Author: Alganthe
    Adaptation made by PiG13BR for Air Spawner Menu
    Date: 14/10/2025
    Update Date: 16/10/2025
    
    Description:
        Handle the mouse wheel.

    Parameter(s):
        0: Not used
        1: onMouseZChanged EH return <ARRAY>
            - 0: Not used
            - 1: Mousewheel Z position <NUMBER>
    
    Returns:
        -
*/
params ["", "_args"];
_args params ["", "_zPos"];

if !(PIG_PylonManager_center isKindOf "Air") exitWith {}; // Don't zoom in or out if it's a placeholder

private _boundingBoxReal = boundingBoxReal PIG_PylonManager_center;
private _distanceMax = ((_boundingBoxReal select 0) vectorDistance (_boundingBoxReal select 1)) * 1.5;
private _distanceMin = _distanceMax * 0.15;
private _distance = PIG_PylonManager_cameraPos select 0;

_distance = (_distance - (_zPos * 5 / 10)) max _distanceMin min _distanceMax;
PIG_PylonManager_cameraPos set [0, _distance];
