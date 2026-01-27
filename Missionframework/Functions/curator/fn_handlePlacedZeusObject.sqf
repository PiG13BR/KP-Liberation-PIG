/*
    File: fn_handlePlacedZeusObject.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2020-04-11
    Last Update: 2025-11-25
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Applies all KP Liberation values and functionalities for crates, units and vehicles.

    Parameter(s):
        _obj - Object to add the functionalities and values to [OBJECT, defaults to objNull]

    Returns:
        Function reached the end [BOOL]
*/
params [
    ["_curator", objNull, [objNull]],
    ["_obj", objNull, [objNull]]
];

if (isNull _obj) exitWith {false};

// Identify kind of placed object once
private _unit = _obj in allUnits;
private _vehicle = _obj in vehicles;
private _crate = (toLowerANSI (typeOf _obj)) in KPLIB_crates;

// Exit if building and no resource crate
if !(_unit || _vehicle || _crate) exitWith {false};

// For a vehicle apply clear cargo
if (_vehicle) then {
    [_obj] call KPLIB_fnc_clearCargo;

    // Add kill manager and object init to possible crew units
    {
        _x addMPEventHandler ["MPKilled", {
            params ["_unit", "_killer"];
            ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
        }];
        [_x] call KPLIB_fnc_addObjectInit;
    } forEach (crew _obj);
};

// Apply kill manager, if it's not a crate
if !(_crate) then {
    _obj addMPEventHandler ["MPKilled", {
        params ["_unit", "_killer"];
        ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
    }];

    // Log
    ["KPLIB_generateLog", 
        [
            format["Curator: %1, placed an object/entity (%2) in position %3", _curator, typeOf _obj, getPosATL _obj],
            "ZEUS PLACED OBJECT"
        ]
    ] call CBA_fnc_serverEvent;
} else {
    // Otherwise apply all needed values/functionalities
    _obj setMass 500;
    _obj setVariable ["KPLIB_crateValue", 100, true];
    [_obj, true] call KPLIB_fnc_clearCargo;

    // Log
    ["KPLIB_generateLog", 
        [
            format["Curator: %1, placed a resource crate (%2) in position %2", _curator, typeOf _obj, getPosATL _obj],
            "ZEUS PLACED OBJECT"
        ]
    ] call CBA_fnc_serverEvent;
};

// Add object init codes
[_obj] call KPLIB_fnc_addObjectInit;

true
