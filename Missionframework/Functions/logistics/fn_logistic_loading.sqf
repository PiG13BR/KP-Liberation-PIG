#include "script_components.hpp"
/*
    File: fn_logistic_loading.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 02/08/2026
    Last Update: 30/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Logistic loading process

    Parameter(s):
        _args - PFH passed arguments [ARRAY]
        _handler - PFH handler ID [NUMBER, defaults to -1]

    Returns:
        -
*/
params["_args", ["_handler", -1]];
_args params["_logiID", ["_logiData", []]];

if (_logiData isEqualTo []) then {
    _logiData = KPLIB_logistics getOrDefault [_logiID, []];
};

if (_logiData isEqualTo []) exitWith {
    [_handler] call CBA_fnc_removePerFrameHandler
};

_logiData params [
    "_truckCount", 
    "_posDestA",
    "_posDestB", 
    "_transpResourcesA", 
    "_transpResourcesB",
    "_currentLoaded",
    "_status",
    "_timeLeft",
    "_specialFlag"
];

private _pointPos = [0,0,0]; // Get position point information
private _transpRes = [0,0,0]; // Get resources transport count information
private _transpResIndex = -1;

// Check status
switch _status do {
    case LOGI_STATUS_AT_A_LOADING: {
        _pointPos = _posDestA;
        _transpRes = _transpResourcesA;
        _transpResIndex = RES_TRANS_A_INDEX;
    };
    case LOGI_STATUS_AT_B_LOADING: {
        _pointPos = _posDestB; 
        _transpRes = _transpResourcesB;
        _transpResIndex = RES_TRANS_B_INDEX;
    };
};

// Check if the destination is a player's objective, otherwise destroy the convoy from this group
#define BURN_CONVOY 0
#define ABORT_CONVOY 1
private _checkDest = -1; 
if !((([_pointPos] call KPLIB_fnc_getNearestBluforObjective) distance2D _pointPos) < 100) then {
    private _nearestSector = [100, _pointPos] call KPLIB_fnc_getNearestSector;
    if (_nearestSector in (KPLIB_sectors_all - KPLIB_sectors_player)) then {
        // Enemy sector, destroy the convoy
        _checkDest = BURN_CONVOY
    } else {
        if !((([_pointPos] call KPLIB_fnc_getNearestFob) distance2D _pointPos) < 100) then {
            // Missing FOB, abort mission
            _checkDest = ABORT_CONVOY
        } else {
            _checkDest = -1
        }
    };
};

// Abort mission or destroy convoy
if (_checkDest >= 0) exitWith {
    switch _checkDest do {
        case BURN_CONVOY : {
        // Reset logi ID
            _logiData params [
                0,
                [0,0,0],
                [0,0,0],
                [0,0,0],
                [0,0,0],
                [0,0,0],
                -1,
                -1,
                -1
            ];
            if (KPLIB_logistic_debug > 0) then {[format ["Convoy from logistic group (%1) was destroyed on loading process. No friendly sector nearby.", _logiID], "VIRTUAL LOGISTIC"] call KPLIB_fnc_log;};
        };
        case ABORT_CONVOY : {
            // Abort
            _nextState = switch _status do {
                case LOGI_STATUS_AT_A_UNLOADING: {LOGI_STATUS_ABORTING_TO_B};
                case LOGI_STATUS_AT_B_UNLOADING: {LOGI_STATUS_ABORTING_TO_A};
            };

            _logiData set [STATUS_INDEX, _nextState];
            if (KPLIB_logistic_debug > 0) then {[format ["Convoy from logistic group (%1) is aborting current mission. No fobs found in the destination.", _logiID], "VIRTUAL LOGISTIC"] call KPLIB_fnc_log;};
        };
        default {}
    };

    [_logiID, _handler] call KPLIB_fnc_logistic_manager;
};

// Get resources from the position point
private _storageAreas = [_pointPos] call KPLIB_fnc_getAllStorages;

// Get _maxGet[Resource] by finding the logistic vehicle in the KPLIB_transportConfig    
private _index = KPLIB_transport_classes find toLowerANSI(KPLIB_b_logiTruck # 0);
private _maxOffsets = if (_index != -1) then {count((KPLIB_transportConfigs # _index) select {_x isEqualType []})} else {3}; // Default is 3
private _maxCargo = _maxOffsets * 100;
_maxCargo = _maxCargo * _truckCount; // Multiply by the number of trucks in the convoy
if (KPLIB_logistic_debug > 0) then {[format ["Max. cargo capacity for logistic group (%1): %2", _logiID, _maxCargo], "VIRTUAL LOGISTIC"] call KPLIB_fnc_log;};

_transpRes params ["_supply", "_ammo", "_fuel"];

private _maxGetSupply = _supply;
if (_maxGetSupply > _maxCargo) then {_maxGetSupply = _maxCargo;};
private _maxGetAmmo = _ammo;
if (_maxGetAmmo > _maxCargo) then {_maxGetAmmo = _maxCargo;};
private _maxGetFuel = _fuel;
if (_maxGetFuel > _maxCargo) then {_maxGetFuel = _maxCargo;};

// Get resources from storages (reserve these resources for transportation)
private _processed = [];
if (_currentLoaded isEqualTo [0,0,0]) then {
    _processed = [_maxGetSupply, _maxGetAmmo, _maxGetFuel, _storageAreas] call KPLIB_fnc_subtractResources;
};

// Loading failed
if ((_processed isEqualTo []) && (_currentLoaded isEqualTo [0,0,0])) exitWith {
    // Abort loading
    _nextState = switch _status do {
        case LOGI_STATUS_AT_A_LOADING: {LOGI_STATUS_STANDBY};
        case LOGI_STATUS_AT_B_LOADING: {LOGI_STATUS_STANDBY};
    };

    _logiData set [STATUS_INDEX, _nextState];
    _logiData set [TIME_LEFT_INDEX, -1];
    _logiData set [SPECIAL_FLAG_INDEX, LOGI_NO_FLAG];

    [_logiID, _handler] call KPLIB_fnc_logistic_manager;
};

// Process resources only if not there is nothing loaded on cargo
if (_currentLoaded isEqualTo [0,0,0]) then {
    
    _processed params ["_supplyLoading", "_ammoLoading", "_fuelLoading"];

    // Set loaded total cargo
    _currentLoaded params ["_supplyLoaded", "_ammoLoaded", "_fuelLoaded"];
    _logiData set [CURRENT_LOADED_INDEX, [(_supplyLoaded + _supplyLoading), (_ammoLoaded + _ammoLoading), (_fuelLoaded + _fuelLoading)]];

    // Rest resources left to collect
    private _supplyLeft = _supply - _supplyLoading;
    private _ammoLeft = _ammo - _ammoLoading;
    private _fuelLeft = _fuel - _fuelLoading;

    _logiData set [_transpResIndex, [_supplyLeft, _ammoLeft, _fuelLeft]];

    if (KPLIB_logistic_debug > 0) then {[format ["Resources processed for logistic group (%1): %2", _logiID, _processed], "VIRTUAL LOGISTIC"] call KPLIB_fnc_log;};
};

// Check time left
if (_timeLeft > 1) then {

    _logiData set [TIME_LEFT_INDEX , _timeLeft - 1];

    if (KPLIB_logistic_debug > 0) then {[format ["Logistic Group (%1) is on loading process. Time left: %2", _logiID, _timeLeft], "VIRTUAL LOGISTIC"] call KPLIB_fnc_log;};
} else {
    // Check for the next state
    private _nextState = 0;
    private _time = 0;

    // Check for resources to transport and resources left on the cargo
    if ((_transpResourcesA isEqualTo [0,0,0]) && (_transpResourcesB isEqualTo [0,0,0]) && (_currentLoaded isEqualTo [0,0,0])) then {
        _logiData set [POINT_A_POS_INDEX, [0,0,0]];
        _logiData set [POINT_B_POS_INDEX, [0,0,0]];
    } else {
        // Loading finished
        _nextState = switch _status do {
            case LOGI_STATUS_AT_A_LOADING: {LOGI_STATUS_TO_B};
            case LOGI_STATUS_AT_B_LOADING: {LOGI_STATUS_TO_A};
        };
        _time = ceil ((_posDestA distance2D _posDestB) / 400);
        _time = _time + 2;
    };

    _logiData set [STATUS_INDEX, _nextState];
    _logiData set [TIME_LEFT_INDEX, _time];
    _logiData set [SPECIAL_FLAG_INDEX, LOGI_NO_FLAG];

    if (KPLIB_logistic_debug > 0) then {[format ["Logistic group (%1) status updated (next status: %2) after loading.", _logiID, _nextState], "VIRTUAL LOGISTIC"] call KPLIB_fnc_log;};

    [_logiID, _handler] call KPLIB_fnc_logistic_manager;
};

publicVariable "KPLIB_logistics";