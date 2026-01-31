/*
    File: fn_subtractResources.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
    Date: 10/09/2025
    Last update: 28/01/2026

    Description:
        Remove resources to storage areas when building

    Parameter(s):
        _priceSupplies - Supplies value to return [NUMBER]
        _priceAmmo - Ammo value to return [NUMBER]
        _priceFuel - Fuel value to return [NUMBER]
        _typeName - classname of the item to build [STRING]
        _localType - build type [NUMBER]
        _storageAreas - Fob storages [ARRAY]
    
    Returns:
        -
*/
params ["_priceSupplies", "_priceAmmo", "_priceFuel", "_typeName", "_localType", "_storageAreas"];

if (!isServer) exitWith {};

#define SUPPLY_INDEX 0
#define AMMO_INDEX 1
#define FUEL_INDEX 2

if ((_priceSupplies > 0) || (_priceAmmo > 0) || (_priceFuel > 0)) then {

    stats_supplies_spent = stats_supplies_spent + _priceSupplies;
    stats_ammo_spent = stats_ammo_spent + _priceAmmo;
    stats_fuel_spent = stats_fuel_spent + _priceFuel;

    {
        private _resources = [_x] call KPLIB_fnc_getStorageValues;
        _resources params ["_supply", "_ammo", "_fuel"];

        if ((_priceSupplies > 0) && (_supply >= _priceSupplies)) then {
            private _amount = _priceSupplies;
            _resources set [SUPPLY_INDEX, _supply - _amount];
            _priceSupplies = _priceSupplies - _amount
        };

        if ((_priceAmmo > 0) && (_ammo >= _priceAmmo)) then {
            private _amount = _priceAmmo;
            _resources set [AMMO_INDEX, _ammo - _amount];
            _priceAmmo = _priceAmmo - _amount
        };

        if ((_priceFuel > 0) && (_fuel >= _priceFuel)) then {
            private _amount = _priceFuel;
            _resources set [FUEL_INDEX, _fuel - _amount];
            _priceFuel = _priceFuel - _amount
        };

        _x setVariable ["KPLIB_storageResources", _resources, true];

        if ((_priceSupplies == 0) && (_priceAmmo == 0) && (_priceFuel == 0)) exitWith {};
    } forEach _storageAreas;

    if (_localType == 8) then {
        stats_blufor_soldiers_recruited = stats_blufor_soldiers_recruited + 10;
    } else {
        if (_typeName isKindOf "CAManBase") then {
            stats_blufor_soldiers_recruited = stats_blufor_soldiers_recruited + 1;
        } else {
            if (!(_typeName isKindOf "Building")) then {
                stats_blufor_vehicles_built = stats_blufor_vehicles_built + 1;
            };
        };
    };

    ["KPLIB_recalculateResources", []] call CBA_fnc_serverEvent;
};
