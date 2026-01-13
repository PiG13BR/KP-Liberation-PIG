/*
    File: fn_factoryProduceResource.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 14/11/2025
    Last Update: 20/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Generates resource if possible and update the production values for this factory. This functions runs independently for each sector producing a resource.

    Parameter(s):
        _factory - sector marker (factory) where the resource will be produced [STRING]

    Returns:
        [BOOL]
*/

params["_factory"];

if (!isServer) exitWith {false};
if !(_factory in KPLIB_production) exitWith {["This sector is not in the production list"] call BIS_fnc_error; false};

// Only run if there are players connected
if ((count (allPlayers - entities "HeadlessClient_F")) > 0) then {

    private _factoryProduction = KPLIB_production getOrDefault [_factory, []]; // Get updated version

    _factoryProduction params [
        "_sectorName",
        "_sectorType",
        "_storageArray",
        "_canProduceS",
        "_canProduceA",
        "_canProduceF",
        "_typeOfResource",
        "_time" // Always get the updated time
    ];

    // Get storage object
    private _storage = KPLIB_sector_storage getOrDefault [_factory, objNull];

    if (isNull _storage) exitWith {["KPLIB_removeFactoryProduction", _factory] call CBA_fnc_serverEvent;}; // No storage. Exit script.

    // Update resources values
    private _supplyValue = 0;
    private _ammoValue = 0;
    private _fuelValue = 0;

    private _start = diag_tickTime; // Get script start tick time
    if (KPLIB_production_debug > 0) then {[format ["Production interval started: %1 - Sector: %2", diag_tickTime, _sectorName], "PRODUCTION"] call KPLIB_fnc_log;};

    private _tempProduction = [];

    // Check if it's time to produce it
    if ((_time - 1) < 1) then {
        // Produce resource
        _time = KPLIB_production_interval; // Reset timer

        // Check if storage is full. If it's, it will ignore the production
        if (((count (attachedObjects _storage)) < 12) && !(_typeOfResource == 3)) then {
            private _crateType = KPLIB_b_crateSupply;

            // Type of resource to create
            switch _typeOfResource do {
                case 1: {_crateType = KPLIB_b_crateAmmo; stats_ammo_produced = stats_ammo_produced + 100;};
                case 2: {_crateType = KPLIB_b_crateFuel; stats_fuel_produced = stats_fuel_produced + 100;};
                default {_crateType = KPLIB_b_crateSupply; stats_supplies_produced = stats_supplies_produced + 100;};
            };

            // Produce resoures (create crate and attach to the storage)
            private _crate = [_crateType, 100, getPosATL _storage] call KPLIB_fnc_createCrate;
            [_crate, _storage] call KPLIB_fnc_crateToStorage;
        };
    } else {
        // Update timer.
        _time = _time - 1;
    };

    // Get resources amount
    {
        switch ((typeOf _x)) do {
            case KPLIB_b_crateSupply: {_supplyValue = _supplyValue + (_x getVariable ["KPLIB_crate_value", 0]);};
            case KPLIB_b_crateAmmo: {_ammoValue = _ammoValue + (_x getVariable ["KPLIB_crate_value", 0]);};
            case KPLIB_b_crateFuel: {_fuelValue = _fuelValue + (_x getVariable ["KPLIB_crate_value", 0]);};
            default {[format ["Invalid object (%1) at storage area", (typeOf _x)], "ERROR"] call KPLIB_fnc_log;};
        };
    } forEach (attachedObjects _storage);

    // Update hashmap
    _tempProduction = [
        _sectorName,
        _sectorType,
        _storageArray,
        _canProduceS, 
        _canProduceA,
        _canProduceF,
        _typeOfResource,
        _time,
        _supplyValue,
        _ammoValue,
        _fuelValue
    ];

    if (KPLIB_production_debug > 0) then {[format ["Production Update: %1", _tempProduction # 0], "PRODUCTION"] call KPLIB_fnc_log;};

    KPLIB_production set [_factory, _tempProduction]; // Update it
    publicVariable "KPLIB_production";

    if (KPLIB_production_debug > 0) then {[format ["Production interval finished - Time needed: %1 seconds", diag_tickTime - _start], "PRODUCTION"] call KPLIB_fnc_log;};
};

