/*
    File: fn_factoryBuildFacility.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 14/11/2025
    Last Update: 05/03/2026
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

#define SUPPLY_INDEX 0
#define AMMO_INDEX 1
#define FUEL_INDEX 2

// Get storage object
private _storage = KPLIB_sector_storage getOrDefault [_factory, objNull];

if (isNull _storage) exitWith {};

private _resources = _storage getVariable ["KPLIB_storageResources", [0,0,0]];
_resources params ["_suppliesAmount", "_ammoAmount", "_fuelAmount"];

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
if ((_suppliesAmount >= _priceS) && (_ammoAmount >= _priceA) && (_fuelAmount >= _priceF)) then {
    // Resoures available to build a facility
    stats_supplies_spent = stats_supplies_spent + _priceS;
    stats_ammo_spent = stats_ammo_spent + _priceA;
    stats_fuel_spent = stats_fuel_spent + _priceF;

    if (_priceS > 0) then {_resources set [SUPPLY_INDEX, _suppliesAmount - _priceS]};
    if (_priceA > 0) then {_resources set [AMMO_INDEX, _ammoAmount - _priceA]};
    if (_priceF > 0) then {_resources set [FUEL_INDEX, _fuelAmount - _priceF]};

    _storage setVariable ["KPLIB_storageResources", _resources, true];

    [_factory, [[_index, true]]] call KPLIB_fnc_updateProductionValues; // Set the "can produce" index to true if successful

    [localize "STR_PRODUCTION_FACBUILD_SUCCESS", false, 5] remoteExecCall ["KPLIB_fnc_hint", _clientOwner];

    ["KPLIB_updateProductionMarkers", [_factory]] call CBA_fnc_serverEvent; // Update factory markers

    true
} else {
    // Not enough resources to build facility
    [format [localize "STR_PRODUCTION_FACBUILD_ERROR", _priceS, _priceA, _priceF], true, 3] remoteExecCall ["KPLIB_fnc_hint", _clientOwner];
    false
};