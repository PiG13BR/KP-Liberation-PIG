/*
    File: fn_subtractResources.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
    Date: 10/09/2025
    Last update: 02/08/2026

    Description:
        Remove resources to storage areas when building

    Parameter(s):
        _supplyValue - Supplies value to subtract [NUMBER, defaults to 0]
        _ammoValue - Ammo value to subtract [NUMBER, defaults to 0]
        _fuelValue - Fuel value to subtract [NUMBER, defaults to 0]
        _storageAreas - Base storages [ARRAY, defaults to []]
    
    Returns:
        Amount of resources subtracted [ARRAY]
*/
params [
    ["_supplyValue", 0, [0]], 
    ["_ammoValue", 0, [0]], 
    ["_fuelValue", 0, [0]], 
    ["_storageAreas", [], [[]]]
];

if (!isServer) exitWith {[]};
if (_storageAreas isEqualTo []) exitWith {[]};

// Check if storages have enough resources to subtract
private _sumStorage = 0;
{
    private _resources = [_x] call KPLIB_fnc_getStorageValues;
    _resources params ["_supply", "_ammo", "_fuel"];
    _sumStorage = _sumStorage + (_supply + _ammo + _fuel);
}forEach _storageAreas;

private _sumResources = _supplyValue + _ammoValue + _fuelValue;

if (_sumStorage < _sumResources) exitWith {[]};

#define SUPPLY_INDEX 0
#define AMMO_INDEX 1
#define FUEL_INDEX 2

private _getSupply = 0;
private _getAmmo = 0;
private _getFuel = 0;

if ((_supplyValue > 0) || (_ammoValue > 0) || (_fuelValue > 0)) then {
    {
        private _resources = [_x] call KPLIB_fnc_getStorageValues;
        _resources params ["_supply", "_ammo", "_fuel"];

        if (_supplyValue > 0 && (_supply > 0)) then {
            private _amount = _supplyValue;
            private _dif = (_supply - _amount);
            _resources set [SUPPLY_INDEX, _dif max 0];
            if (_dif >= 0) then {
                _supplyValue = _supplyValue - _amount;
                _getSupply = _getSupply + _amount;
            } else {
                _supplyValue = abs(_dif);
                _getSupply = _amount - abs(_dif);
            };
        };

        if (_ammoValue > 0 && (_ammo > 0)) then {
            private _amount = _ammoValue;
            private _dif = (_ammo - _amount);
            _resources set [AMMO_INDEX, _dif max 0];
            if (_dif >= 0) then {
                _ammoValue = _ammoValue - _amount;
                _getAmmo = _getAmmo + _amount;
            } else {
                _ammoValue = abs(_dif);
                _getAmmo = _amount - abs(_dif);
            };
        };

        if (_fuelValue > 0 && (_fuel > 0)) then {
            private _amount = _fuelValue;
            private _dif = (_fuel - _amount);
            _resources set [FUEL_INDEX, _dif max 0];
            if (_dif >= 0) then {
                _fuelValue = _fuelValue - _amount;
                _getFuel = _getFuel + _amount;
            } else {
                _fuelValue = abs(_dif);
                _getFuel = _amount - abs(_dif);
            };
        };

        _x setVariable ["KPLIB_storageResources", _resources, true];

        if ((_supplyValue == 0) && (_ammoValue == 0) && (_fuelValue == 0)) exitWith {};
    } forEach _storageAreas;

    ["KPLIB_recalculateResources", []] call CBA_fnc_serverEvent;
};

[_getSupply, _getAmmo, _getFuel]