/*
    File: fn_prisonnerCheckPFH.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 24/11/2025
    Last Update: 13/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Runs a PFH to check if there are blufor units nearby

    Parameter(s):
        _prisonner - Unit prisonner

    Returns:
        -
*/
params["_prisonner"];

[{
    params["_unit", "_handler"];

    // Dead unit exit
    if (!alive _unit) exitWith {[_handler] call CBA_fnc_removePerFrameHandler;};

    // Pow delivered exit
    if (_unit getVariable ["KPLIB_powDelivered", false]) exitWith {[_handler] call CBA_fnc_removePerFrameHandler;};
    
    private _nearUnits = [ASLToAGL (getPosASL _unit), 50, 50, 0, false, -1] nearEntities [["CAManBase", "Car", "Air"], false, true, true];
    private _isNearBlufor = (_nearUnits findIf {(side _x == KPLIB_side_player) && (_unit distance _x < 100)}) >= 0;

    // No blufor units nearby exit
    if (!_isNearBlufor) exitWith {
        [_unit] call KPLIB_fnc_prisonnerEscape;
        [group _unit] call KPLIB_fnc_despawnGroup;
        [_handler] call CBA_fnc_removePerFrameHandler
    };
}, 10, _prisonner] call CBA_fnc_addPerFrameHandler;