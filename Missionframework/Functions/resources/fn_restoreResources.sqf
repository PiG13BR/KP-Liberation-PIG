/*
    File: fn_restoreResources.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
    Date: 10/09/2025
    Last update: 12/11/2025

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

if ((_priceSupplies > 0) || (_priceAmmo > 0) || (_priceFuel > 0)) then {
    {
        private _space = 0;
        if (typeOf _x == KPLIB_b_largeStorage) then {
            _space = (count KPLIB_large_storage_positions) - (count (attachedObjects _x));
        };
        if (typeOf _x == KPLIB_b_smallStorage) then {
            _space = (count KPLIB_small_storage_positions) - (count (attachedObjects _x));
        };

        while {(_space > 0) && (_priceSupplies > 0)} do {
            private _amount = 100;
            if ((_priceSupplies / 100) < 1) then {
                _amount = _priceSupplies;
            };
            _priceSupplies = _priceSupplies - _amount;
            private _crate = [KPLIB_b_crateSupply, _amount, getPos _x] call KPLIB_fnc_createCrate;
            [_crate, _x] call KPLIB_fnc_crateToStorage;
            _space = _space - 1;
        };

        while {(_space > 0) && (_priceAmmo > 0)} do {
            private _amount = 100;
            if ((_priceAmmo / 100) < 1) then {
                _amount = _priceAmmo;
            };
            _priceAmmo = _priceAmmo - _amount;
            private _crate = [KPLIB_b_crateAmmo, _amount, getPos _x] call KPLIB_fnc_createCrate;
            [_crate, _x] call KPLIB_fnc_crateToStorage;
            _space = _space - 1;
        };

        while {(_space > 0) && (_priceFuel > 0)} do {
            private _amount = 100;
            if ((_priceFuel / 100) < 1) then {
                _amount = _priceFuel;
            };
            _priceFuel = _priceFuel - _amount;
            private _crate = [KPLIB_b_crateFuel, _amount, getPos _x] call KPLIB_fnc_createCrate;
            [_crate, _x] call KPLIB_fnc_crateToStorage;
            _space = _space - 1;
        };
        if ((_priceSupplies == 0) && (_priceAmmo == 0) && (_priceFuel == 0)) exitWith {};
    } forEach _storageAreas;
};
