/*
    File: fn_handleTurretButton.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 13/06/2026
    Update Date: 22/06/2026
    
    Description:
        Handles the turret button

    Parameter(s):
        _ctrl - turret button control [CONTROL]
        _switch - switch turret [BOOL]
        _pylon - pylon index [NUMBER]
        _turret - pylon turret [ARRAY, defaults to []]
    
    Returns:
        -
*/
params["_ctrl", "_switch", "_pylon", ["_turret", []]];

private _aircraft = localNamespace getVariable ["PIG_PAS_aircraft", objNull];

// Switch turret for the selected pylon
if (_switch) then {
    _turret = PIG_PAS_pylonsTurret getOrDefault [_pylon, [-1]];
    if (_turret isEqualTo [0]) then {_turret = [-1]} else {_turret = [0]};
};

PIG_PAS_pylonsTurret set [_pylon, _turret]; // Save turret for this pylon
private _lbIndex = localNameSpace getVariable ["PIG_PAS_pylonLbIndex", -1];
[_aircraft, _pylon + 1, _turret, _lbIndex] call KPLIB_fnc_applyTurretPylon;

if (_turret isEqualTo [-1]) then {
    _ctrl ctrlSetText "a3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_driver_ca.paa";
    _ctrl ctrlSetTooltip (localize "STR_PAS_DRIVER");
} else {
    _ctrl ctrlSetText "a3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_gunner_ca.paa";
    _ctrl ctrlSetTooltip (localize "STR_PAS_GUNNER");
};
_ctrl ctrlcommit 0;

