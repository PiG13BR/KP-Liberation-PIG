/*
    File: fn_changeFactoryProduction.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 14/11/2025
    Last Update: 23/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Change the resource production of a factory. Reset counter.

    Parameter(s):
        _factory - sector marker (factory) to change production [STRING]
        _newProduction - producing index [NUMBER, 0 for supplies; 1 for ammo; 2 for fuel]
        _clientOwner - client ID used to hint if changing production failed [NUMBER]

    Returns:
        [BOOL]
*/
params ["_factory", "_newProduction", "_clientOwner"];

if (!isServer) exitWith {false};
if !(_factory in KPLIB_production) exitWith {["This sector is not in the production list"] call BIS_fnc_error; false};

#define PRODUCING_SUPPLY 0
#define PRODUCING_AMMO 1
#define PRODUCING_FUEL 2

private _tempProduction = KPLIB_production get _factory;

_tempProduction params [
    "",
    "",
    "_storageArray",
    "_canProduceS",
    "_canProduceA",
    "_canProduceF"
];

// Check if can produce it
if (_storageArray isEqualTo []) exitWith {}; // No storage found

private _producing = "";
private _canProduce = false; 
switch (_newProduction) do {
    case PRODUCING_SUPPLY : {_canProduce = _canProduceS; _producing = "SUPPLIES"};
    case PRODUCING_AMMO: {_canProduce = _canProduceA; _producing = "AMMO"};
    case PRODUCING_FUEL: {_canProduce = _canProduceF; _producing = "FUEL"};
    default {_producing = "NOTHING"};
};

if (!_canProduce) exitWith {
    [localize "STR_PRODUCTION_FACFALSE", true, 3] remoteExec ["KPLIB_fnc_hint", _clientOwner];
    false
};

// 6 is the index for type of resources that the factory is producing, 7 is the timer to reset
[_factory, [
    [6, _newProduction],
    [7, KPLIB_production_interval] // Reset timer
]] call KPLIB_fnc_updateProductionValues;

private _isProducing = [_factory] call KPLIB_fnc_factoryProductionPFH;

if (_isProducing) then {
    [format["Changing production in %1 to %2", markerText _factory, _producing], "PRODUCTION"] call KPLIB_fnc_log;
    true
} else {
    [format["Changing production in %1 to %2 FAILED", markerText _factory, _producing], "PRODUCTION"] call KPLIB_fnc_log;
    false
};