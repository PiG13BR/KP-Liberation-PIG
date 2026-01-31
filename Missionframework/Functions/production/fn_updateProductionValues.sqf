/*
    File: fn_updateProductionValues.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 14/11/2025
    Last Update: 28/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Update the KPLIB_production hashmap if requested.

    Parameter(s):
        _sector - sector marker (factory) [STRING]
        _updateValues - array of arrays of indexes and values to update [ARRAY, defaults to []]
            0: Index. These can be: 
                0: Sector marker name <STRING>
                1: Sector type Defaults to 1. 1 = factory; 2 = city (never used) <NUMBER>
                2: Factory storage <ARRAY>
                    0: Storage position <POSITION>
                    1: Storage direction <NUMBER>
                    2: Storage vectorUp <ARRAY>
                3: Can produce Supplies <BOOL>
                4: Can produce Ammo <BOOL>
                5: Can produce Fuel <BOOL>
                6: Type of resource producing: 0 - Supply; 1 = Ammo; 2 = Fuel; 3 = Nothing (default) <NUMBER>
                7: Time left to produce next resource <NUMBER>
                8: How much supply it has <NUMBER>
                9: How much Ammo it has <NUMBER>
                10: How much fuel it has <NUMBER>
            1: Value <ANY>
    Returns:
        -
*/

params["_sector", ["_updateValues", [], [[]]]];

if (_sector isEqualTo "") exitWith {};

private _tempProduction = KPLIB_production get _sector;

if (_updateValues isNotEqualTo []) then {
    // Update provided indexes
    {
        _index = _x # 0;
        _valueToUpdate = _x # 1;

        _tempProduction set [_index, _valueToUpdate]
    }forEach _updateValues;
} else {
    // Update resources
    _tempProduction params [
        "_sectorName",
        "_sectorType",
        "_storageArray",
        "_canProduceS",
        "_canProduceA",
        "_canProduceF",
        "_producingType",
        "_time",
        "_suppliesAmount",
        "_suppliesAmount",
        "_suppliesAmount"
    ];

    if ((count _storageArray) > 0) then {

        // Get storage object
        private _storage = KPLIB_sector_storage getOrDefault [_sector, objNull];

        if (isNull _storage) exitWith {["KPLIB_removeFactoryProduction", _sector] call CBA_fnc_serverEvent;}; // No storage. Exit script.

        // Update resources values
        private _supplyValue = 0;
        private _ammoValue = 0;
        private _fuelValue = 0;

        // Get resources amount
        (_storage getVariable ["KPLIB_storageResources", [0,0,0]]) params ["_supplyValue", "_ammoValue", "_fuelValue"];

        private _updatedProduction = [
            _sectorName,
            _sectorType,
            _storageArray,
            _canProduceS,
            _canProduceA,
            _canProduceF,
            _producingType,
            _time,
            _supplyValue,
            _ammoValue,
            _fuelValue
        ];

        KPLIB_production set [_sector, _updatedProduction];
    };
};

publicVariable "KPLIB_production"; // Update