/*
    File: fn_mouseButtonDown.sqf
    Author: commy2
    Adaptation made by PiG13BR for Air Spawner Menu
    Date: 14/10/2025
    Update Date: 14/10/2025
    
    Description:
        Handles mouse button release

    Parameter(s):
        0: Not used
        1: Args <ARRAY>
            - 0: Not used
            - 1: Mouse button <NUMBER>
    
    Returns:
        -
*/

params ["", "_args"];
_args params ["", "_buttonPressed"];

PIG_PylonManager_mouseButtonState set [_buttonPressed, []];

