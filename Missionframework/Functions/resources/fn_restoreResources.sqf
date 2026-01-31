/*
    File: fn_restoreResources.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
    Date: 10/09/2025
    Last update: 28/01/2026

    Description:
        Return resources to storage areas when building is cancelled

    Parameter(s):
        _priceSupplies - Supplies value to return [NUMBER]
        _priceAmmo - Ammo value to return [NUMBER]
        _priceFuel - Fuel value to return [NUMBER]
        _storageAreas - Fob storages [ARRAY]
    
    Returns:
        -
*/
params ["_priceSupplies", "_priceAmmo", "_priceFuel", "_storageAreas"];

if (!isServer) exitWith {};

#define SUPPLY_INDEX 0
#define AMMO_INDEX 1
#define FUEL_INDEX 2

if ((_priceSupplies > 0) || (_priceAmmo > 0) || (_priceFuel > 0)) then {
    {
        private _resources = [_x] call KPLIB_fnc_getStorageValues;
        _resources params ["_supply", "_ammo", "_fuel"];
        private _sum = _supply + _ammo + _fuel;

        private _storageLimit = [_x] call KPLIB_fnc_getStorageLimit;

        if (_priceSupplies > 0) then {
            private _amount = _priceSupplies;
            if (_sum + _amount > _storageLimit) then {
                private _adjust = (_sum + _amount) - _storageLimit;
                _amount = _amount - _adjust; // Only the necessary amount to fill storage
            };
            _resources set [SUPPLY_INDEX, _supply + _amount];

            _priceSupplies = _priceSupplies - _amount
        };

        if (_priceAmmo > 0) then {
            private _amount = _priceAmmo;
            if (_sum + _amount > _storageLimit) then {
                private _adjust = (_sum + _amount) - _storageLimit;
                _amount = _amount - _adjust; // Only the necessary amount to fill storage
            };
            _resources set [AMMO_INDEX, _supply + _amount];

            _priceAmmo = _priceAmmo - _amount
        };

        if (_priceFuel > 0) then {
            private _amount = _priceFuel;
            if (_sum + _amount > _storageLimit) then {
                private _adjust = (_sum + _amount) - _storageLimit;
                _amount = _amount - _adjust; // Only the necessary amount to fill storage
            };
            _resources set [FUEL_INDEX, _supply + _amount];

            _priceFuel = _priceFuel - _amount
        };

        _x setVariable ["KPLIB_storageResources", _resources, true];

        if ((_priceSupplies == 0) && (_priceAmmo == 0) && (_priceFuel == 0)) exitWith {};
    } forEach _storageAreas;

    ["KPLIB_recalculateResources", []] call CBA_fnc_serverEvent;
};


