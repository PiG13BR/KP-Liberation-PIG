/*
    File: fn_addFactoryProduction.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 14/11/2025
    Last Update: 19/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Add production values to the factory sector in a form of hashmap

    Parameter(s):
        _factory - sector marker (factory) to add to the production values [STRING]

    Returns:
        [BOOL]
*/
params["_factory"];

if (!isServer) exitWith {false};
if !(_factory in KPLIB_sectors_factory) exitWith {["This sector is not a factory"] call BIS_fnc_error; false};


#define SECTOR_TYPE_FACTORY 1
#define PRODUCING_NOTHING 3

/*
    KPLIB_production is a hashmap with arrays of production status of the captured factories. The keys are the factories markers.
    When a player captures a factory sector, it will add an array with these elements below as default in the KPLIB_production
        Key: Sector marker <STRING>
        Value <ARRAY>
            0: Sector marker name <STRING>
            1: Sector type Defaults to 1. 1 = factory; 2 = city (never used) <NUMBER>
            2: Factory storage <ARRAY>
                0: Storage position <POSITION>
                1: Storage direction <NUMBER>
                2: Storage vectorUp <ARRAY>
            3: Can produce Supplies (KPLIB_production_markers) <BOOL>
            4: Can produce Ammo (KPLIB_production_markers) <BOOL>
            5: Can produce Fuel (KPLIB_production_markers) <BOOL>
            6: Type of resource producing: 0 - Supply; 1 = Ammo; 2 = Fuel; 3 = Nothing (default) <NUMBER>
            7: Time left to produce next resource <NUMBER>
            8: How much supply it has <NUMBER>
            9: How much Ammo it has <NUMBER>
            10: How much fuel it has <NUMBER>
*/

private _sectorFacilities = KPLIB_production_markers get _factory;

_sectorFacilities params ["_canProduceS", "_canProduceA", "_canProduceF"];

if (isNil "KPLIB_production") then {
    KPLIB_production = _factory createHashMapFromArray [
        [
            _factory, // Key
            [
                markerText _factory,
                SECTOR_TYPE_FACTORY,
                [],
                _canProduceS, 
                _canProduceA,
                _canProduceF,
                PRODUCING_NOTHING,
                KPLIB_production_interval,
                0,
                0,
                0
            ]
        ]
    ]
} else {
    if (_factory in KPLIB_production) then {KPLIB_production deleteAt _factory;};
    
    KPLIB_production set [
        _factory, // Key
        [
            markerText _factory,
            SECTOR_TYPE_FACTORY,
            [],
            _canProduceS, 
            _canProduceA,
            _canProduceF,
            PRODUCING_NOTHING,
            KPLIB_production_interval,
            0,
            0,
            0
        ]
    ] 
};

publicVariable "KPLIB_production";

true