/*
    File: fn_subtractResources.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
    Date: 10/09/2025
    Last update: 12/11/2025

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

if ((_priceSupplies > 0) || (_priceAmmo > 0) || (_priceFuel > 0)) then {

    stats_supplies_spent = stats_supplies_spent + _priceSupplies;
    stats_ammo_spent = stats_ammo_spent + _priceAmmo;
    stats_fuel_spent = stats_fuel_spent + _priceFuel;

    {
        private _storage_positions = [];
        private _storedCrates = (attachedObjects _x);
        reverse _storedCrates;

        {
            _crateValue = _x getVariable ["KPLIB_crateValue",0];

            switch ((typeOf _x)) do {
                case KPLIB_b_crateSupply: {
                    if (_priceSupplies > 0) then {
                        if (_crateValue > _priceSupplies) then {
                            _crateValue = _crateValue - _priceSupplies;
                            _x setVariable ["KPLIB_crateValue", _crateValue, true];
                            _priceSupplies = 0;
                        } else {
                            detach _x;
                            deleteVehicle _x;
                            _priceSupplies = _priceSupplies - _crateValue;
                        };
                    };
                };
                case KPLIB_b_crateAmmo: {
                    if (_priceAmmo > 0) then {
                        if (_crateValue > _priceAmmo) then {
                            _crateValue = _crateValue - _priceAmmo;
                            _x setVariable ["KPLIB_crateValue", _crateValue, true];
                            _priceAmmo = 0;
                        } else {
                            detach _x;
                            deleteVehicle _x;
                            _priceAmmo = _priceAmmo - _crateValue;
                        };
                    };
                };
                case KPLIB_b_crateFuel: {
                    if (_priceFuel > 0) then {
                        if (_crateValue > _priceFuel) then {
                            _crateValue = _crateValue - _priceFuel;
                            _x setVariable ["KPLIB_crateValue", _crateValue, true];
                            _priceFuel = 0;
                        } else {
                            detach _x;
                            deleteVehicle _x;
                            _priceFuel = _priceFuel - _crateValue;
                        };
                    };
                };
                default {[format ["Invalid object (%1) at storage area", (typeOf _x)], "ERROR"] call KPLIB_fnc_log;};
            };
        } forEach _storedCrates;

        ([_x] call KPLIB_fnc_getStoragePositions) params ["_storage_positions"];

        private _area = _x;
        _i = 0;
        {
            _height = [typeOf _x] call KPLIB_fnc_getCrateHeight;
            detach _x;
            _x attachTo [_area, [(_storage_positions select _i) select 0, (_storage_positions select _i) select 1, _height]];
            _i = _i + 1;
        } forEach attachedObjects (_x);

        if ((_priceSupplies == 0) && (_priceAmmo == 0) && (_priceFuel == 0)) exitWith {};

    } forEach _storageAreas;

    if ( _localType == 8 ) then {
        stats_blufor_soldiers_recruited = stats_blufor_soldiers_recruited + 10;
    } else {
        if ( _typeName isKindOf "CAManBase" ) then {
            stats_blufor_soldiers_recruited = stats_blufor_soldiers_recruited + 1;
        } else {
            if ( ! ( _typeName isKindOf "Building" ) ) then {
                stats_blufor_vehicles_built = stats_blufor_vehicles_built + 1;
            };
        };
    };

    ["KPLIB_recalculateResources", []] call CBA_fnc_serverEvent;
};
