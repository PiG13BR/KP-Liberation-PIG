/*
    File: fn_SAM_customRadarRange.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 05/12/2025
    Last Update: 05/03/2026
    License: MIT License - http://www.opensource.org/licenses/MIT
    
    Description:
        A workaround to limit radar's range.
        Ignores targets beyond range and altitude provided by the custom configuration.
    
    Parameter(s):
        _radar - object used to center reference, in general, the radar [OBJECT, defaults to objNull]
        _samTurrets - SAM launchers linked to the SAM Site [ARRAY]
    
    Returns:
        [BOOL]
*/

params[["_radar", objNull, [objNull]], ["_samTurrets", [], [[]]]];

if (isNull _radar) exitWith {["Object is null"] call BIS_fnc_error};

[{
    params["_args", "_handle"];
    _args params ["_radar", "_turrets"];

    private _grp = group _radar;
    private _sensorTargets = getSensorTargets _radar;

    // Find valid targets
    private _validTargets = _sensorTargets select {
        _x params ["_target", "_type", "_relationShip"];
        
        (_type == "air") && {_relationShip != "friendly"} && {_target distance2D _radar <= PIG_SAMSite_Setting_maxRange} && {(getPos _target # 2 > PIG_SAMSite_Setting_minAlt)}
    };

    // Find targets to ignore
    private _ignoreTargets = _sensorTargets select {
        _x params ["_target", "_type", "_relationShip"];
        
        (_type == "air") && {_relationShip != "friendly"} && {_target distance2D _radar > PIG_SAMSite_Setting_maxRange} || {(getPos _target # 2 <= PIG_SAMSite_Setting_minAlt)}
    };

    // Valid target 
    if (count _validTargets > 0) then {
        {
            _x params ["_target"];
            _grp ignoreTarget [_target, false];
            _grp reveal [_target, 1];
        }forEach _validTargets;
        
    };

    // Ignore target
    if (count _ignoreTargets > 0) then {
        {
            _x params ["_target"];
            _grp ignoreTarget [_target, true];
        }forEach _ignoreTargets;
    };
    
}, 1, [_radar, _samTurrets]] call CBA_fnc_addPerFrameHandler;