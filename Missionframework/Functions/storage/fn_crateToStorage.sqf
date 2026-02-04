/*
    File: fn_crateToStorage.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 2017-03-27
    Last Update: 2026-02-01
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Attach given crate at storage area.

    Parameter(s):
        _crate      - Crate                     [OBJECT, defaults to objNull]
        _storage    - Storage                   [OBJECT, defaults to objNull]
        _update     - Update sector resources   [BOOL, defaults to false]

    Returns:
        Function reached the end [BOOL]
*/

params [
    ["_crate", objNull, [objNull]],
    ["_storage", objNull, [objNull]],
    ["_update", false, [false]]
];

#define SUPPLY_INDEX 0
#define AMMO_INDEX 1
#define FUEL_INDEX 2

// Validate parameters
if (isNull _crate) exitWith {["Null object given"] call BIS_fnc_error; false};
if (isNull _storage) exitWith {["Null object given"] call BIS_fnc_error; false};

// Get storage values
private _resources = [_storage] call KPLIB_fnc_getStorageValues;
_resources params ["_supply", "_ammo", "_fuel"];

private _sum = _supply + _ammo + _fuel;

// Check for enough space in storage
private _storageLimit = [_storage] call KPLIB_fnc_getStorageLimit;
if (_sum >= _storageLimit) exitWith {
    if (!isDedicated) then {
        [localize "STR_BOX_CANTSTORE", true, 2] call KPLIB_fnc_hint;
    };
};

// Store value
private _crateValue = _crate getVariable ["KPLIB_crateValue", 0];

if (_sum + _crateValue > _storageLimit) then {
    private _amount = (_sum + _crateValue) - _storageLimit;
    _crateValue = _crateValue - _amount; // Only extract the necessary amount to fill storage
};

switch (typeOf _crate) do {
    case KPLIB_b_crateSupply : {
        _resources set [SUPPLY_INDEX, _supply + _crateValue];
    };
    case KPLIB_b_crateAmmo : {
        _resources set [AMMO_INDEX, _ammo + _crateValue];
    };
    case KPLIB_b_crateFuel : {
        _resources set [FUEL_INDEX, _fuel + _crateValue];
    };
    default {}
};

private _oldValue = (_crate getVariable ["KPLIB_crateValue", 0]);
private _newValue = _oldValue - _crateValue;
_crate setVariable ["KPLIB_crateValue", _newValue];

_storage setVariable ["KPLIB_storageResources", _resources, true];

// Update sector resource values, if requested
if (_update) then {
    if (_storage getVariable ["KPLIB_factoryStorage", false]) then {
        private _sector = _storage getVariable ["KPLIB_storageSector", ""];
        [_sector] call KPLIB_fnc_updateProductionValues;
    };
};

// Add mass to a transportable storage
if (typeOf _storage == KPLIB_b_transStorage) then {
    private _oldMass = getMass _storage;
    private _newMass = _oldMass + _crateValue;
    _storage setMass _newMass;
};

if (_newValue < 1) then {
    deleteVehicle _crate;
};

true