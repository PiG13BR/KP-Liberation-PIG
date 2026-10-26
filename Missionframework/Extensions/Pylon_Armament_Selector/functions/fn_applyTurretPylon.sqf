/*
    File: fn_applyTurretPylon.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 13/06/2026
	Last Update: 08/10/2026
    
    Description:
        Apply designated turret to the pylon

    Parameter(s):
        _aircraft - aircraft to apply the turret configuration [OBJECT]
        _pylonIndex - pylon index [NUMBER]
        _turret - turret to apply [ARRAY, defaults to [-1]]
        _lbIndex - pylon list box selection [NUMBER, defaults to -1]
    
    Returns:
        -
*/
params["_aircraft", "_pylonIndex", ["_turret", [-1]], ["_lbIndex", -1, [0]]];

private _magazine = (getAllPylonsInfo (_aircraft) param [_pylonIndex - 1, []]) param [3, ""];
if (_magazine isEqualTo "") exitWith {};

private _oldTurret = if (_turret isEqualTo [0]) then {[-1]} else {[0]};

["PAS_setPylonArmament", [_aircraft, _pylonIndex, _magazine, _turret, _lbIndex]] call CBA_fnc_globalEvent;