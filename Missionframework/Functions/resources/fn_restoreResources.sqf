/*
    File: fn_restoreResources.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
    Date: 10/09/2025
    Last update: 04/08/2026

    Description:
        Restore resources to storage areas

    Parameter(s):
        _supplyValue - Supplies value to restore [NUMBER, defaults 0]
        _ammoValue - Ammo value to restore [NUMBER, defaults 0]
        _fuelValue - Fuel value to restore [NUMBER, defaults 0]
        _storages - Base storages [ARRAY, defaults []]
    
    Returns:
        Function reached the end [BOOL]
*/
params [
    ["_supplyValue", 0, [0]], 
    ["_ammoValue", 0, [0]], 
    ["_fuelValue", 0, [0]], 
    ["_storages", [], [[]]]
];

if (!isServer) exitWith {false};
if (_storages isEqualTo []) exitWith {false};

#define SUPPLY_INDEX 0
#define AMMO_INDEX 1
#define FUEL_INDEX 2

if ((_supplyValue > 0) || (_ammoValue > 0) || (_fuelValue > 0)) then {
    {
        private _resources = [_x] call KPLIB_fnc_getStorageValues;
        _resources params ["_supply", "_ammo", "_fuel"];
        private _sum = _supply + _ammo + _fuel;
        private _amountSum = _sum;

        private _storageLimit = [_x] call KPLIB_fnc_getStorageLimit;

        if (_supplyValue > 0) then {
            private _amount = _supplyValue;
            _amountSum = _amountSum + _amount;
            
            if (_amountSum > _storageLimit) then {
                private _adjust = (_sum + _amount) - _storageLimit;
                _amount = _amount - _adjust; // Only the necessary amount to fill storage
                if (_adjust < 0) then {_amount = 0;};
            };
            if (_amount < 0) exitWith {};
            
            _resources set [SUPPLY_INDEX, _supply + _amount];

            _supplyValue = _supplyValue - _amount
        };

        if (_ammoValue > 0) then {
            private _amount = _ammoValue;
            _amountSum = _amountSum + _amount;
            
            if (_amountSum > _storageLimit) then {
                private _adjust = (_sum + _amount) - _storageLimit;
                _amount = _amount - _adjust; // Only the necessary amount to fill storage
                if (_adjust < 0) then {_amount = 0;};
            };
            _resources set [AMMO_INDEX, _ammo + _amount];

            _ammoValue = _ammoValue - _amount
        };

        if (_fuelValue > 0) then {
            private _amount = _fuelValue;
            _amountSum = _amountSum + _amount;
            
            if (_amountSum > _storageLimit) then {
                private _adjust = (_sum + _amount) - _storageLimit;
                _amount = _amount - _adjust; // Only the necessary amount to fill storage
                if (_adjust < 0) then {_amount = 0;};
            };

            _resources set [FUEL_INDEX, _fuel + _amount];

            _fuelValue = _fuelValue - _amount
        };

        _x setVariable ["KPLIB_storageResources", _resources, true];
    } forEach _storages;

    ["KPLIB_recalculateResources", []] call CBA_fnc_serverEvent;

    // Spawn crates if there are resources left to restore
    private _storage = _storages # ((count _storages) - 1);
    while {(_supplyValue > 0) || (_ammoValue > 0) || (_fuelValue > 0)} do {
        if (_supplyValue > 0) then {
            private _price = _supplyValue min 100;
            [KPLIB_b_crateSupply, _price, getPosATL _storage] call KPLIB_fnc_createCrate;
            _supplyValue = _supplyValue - _price;
        };

        if (_ammoValue > 0) then {
            private _price = _ammoValue min 100;
            [KPLIB_b_crateAmmo, _price, getPosATL _storage] call KPLIB_fnc_createCrate;
            _ammoValue = _ammoValue - _price;
        };

        if (_fuelValue > 0) then {
            private _price = _fuelValue min 100;
            [KPLIB_b_crateFuel, _price, getPosATL _storage] call KPLIB_fnc_createCrate;
            _fuelValue = _fuelValue - _price;
        };
    };
};

true