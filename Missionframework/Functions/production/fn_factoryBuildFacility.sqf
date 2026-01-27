/*
    File: fn_factoryBuildFacility.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 14/11/2025
    Last Update: 20/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Build a new production facility for the factory

    Parameter(s):
        _factory - sector marker (factory) to build new facility in [STRING]
        _facility - producing index [STRING, defaults to "SUPPLY", can also be "AMMO"; "FUEL"]
        _clientOwner - client ID used to call hints [NUMBER]

    Returns:
        [BOOL]
*/
params ["_factory", ["_facility", "SUPPLY", [""]], "_clientOwner"];

if (!isServer) exitWith {false};
if !(_factory in KPLIB_production) exitWith {["This sector is not in the production list"] call BIS_fnc_error; false};

// Get production elements
private _factoryProduction = KPLIB_production getOrDefault [_factory, []];

if (_factoryProduction isEqualTo []) exitWith {};

// Fetch production params
_factoryProduction params [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "_suppliesCount",
    "_ammoCount",
    "_fuelCount"
];

// Default prices
private _priceS = 100;
private _priceA = 100;
private _priceF = 100;

private _index = 0; // KPLIB_production index to change "can produce" bool
switch (_facility) do {
    case "SUPPLY": {_index = 3; _priceS = 50}; // Supply "can produce" index and price update
    case "AMMO": {_index = 4; _priceA = 50;}; // Ammo "can produce" index and price update
    case "FUEL": {_index = 5 ;_priceF = 50;}; // Fuel "can produce" index and price update
};

// Check for available resources
if ((_suppliesCount >= _priceS) && (_ammoCount >= _priceA) && (_fuelCount >= _priceF)) then {
    // Resoures available to build a facility
    stats_supplies_spent = stats_supplies_spent + _priceS;
    stats_ammo_spent = stats_ammo_spent + _priceA;
    stats_fuel_spent = stats_fuel_spent + _priceF;

    // Get storage object
    private _storage = KPLIB_sector_storage getOrDefault [_factory, objNull];

    if (isNull _storage) exitWith {};

    //private _storage = (_storages # 0);
    private _storedCrates = (attachedObjects _storage);
    reverse _storedCrates;

    // Iterate stored crates and remove values from them
    {
        private _crateValue = _x getVariable ["KPLIB_crateValue", 0];

        switch ((typeOf _x)) do {
            case KPLIB_b_crateSupply: {
                if (_priceS > 0) then {
                    if (_crateValue > _priceS) then {
                        _crateValue = _crateValue - _priceS;
                        _x setVariable ["KPLIB_crateValue", _crateValue, true];
                        _priceS = 0;
                    } else {
                        detach _x;
                        deleteVehicle _x;
                        _priceS = _priceS - _crateValue;
                    };
                };
            };
            case KPLIB_b_crateAmmo: {
                if (_priceA > 0) then {
                    if (_crateValue > _priceA) then {
                        _crateValue = _crateValue - _priceA;
                        _x setVariable ["KPLIB_crateValue", _crateValue, true];
                        _priceA = 0;
                    } else {
                        detach _x;
                        deleteVehicle _x;
                        _priceA = _priceA - _crateValue;
                    };
                };
            };
            case KPLIB_b_crateFuel: {
                if (_priceF > 0) then {
                    if (_crateValue > _priceF) then {
                        _crateValue = _crateValue - _priceF;
                        _x setVariable ["KPLIB_crateValue", _crateValue, true];
                        _priceF = 0;
                    } else {
                        detach _x;
                        deleteVehicle _x;
                        _priceF = _priceF - _crateValue;
                    };
                };
            };
            default {[format ["Invalid object (%1) at storage area", (typeOf _x)], "ERROR"] call KPLIB_fnc_log;};
        };
    } forEach _storedCrates;

    private _i = 0;
    {
        private _height = [typeOf _x] call KPLIB_fnc_getCrateHeight;
        detach _x;
        _x attachTo [_storage, [(KPLIB_small_storage_positions select _i) select 0, (KPLIB_small_storage_positions select _i) select 1, _height]];
        _i = _i + 1;
    } forEach (attachedObjects _storage);

    [_factory, [[_index, true]]] call KPLIB_fnc_updateProductionValues; // Set the "can produce" index to true if successful

    [localize "STR_PRODUCTION_FACBUILD_SUCCESS", false, 5] remoteExecCall ["KPLIB_fnc_hint", _clientOwner];

    ["KPLIB_updateProductionMarkers", [_factory]] call CBA_fnc_serverEvent; // Update factory markers

    true
} else {
    // Not enough resources to build facility
    [format [localize "STR_PRODUCTION_FACBUILD_ERROR", _priceS, _priceA, _priceF], true, 3] remoteExecCall ["KPLIB_fnc_hint", _clientOwner];
    false
};