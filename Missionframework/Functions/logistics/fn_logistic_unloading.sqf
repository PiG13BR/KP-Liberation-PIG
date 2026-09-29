#include "script_components.hpp"
/*
    File: fn_logistic_unloading.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 02/08/2026
    Last Update: 26/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Logistic unloading process

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
    "", 
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

// Check status
switch _status do {
    case LOGI_STATUS_AT_A_UNLOADING: {
        _pointPos = _posDestA;
        _transpRes = _transpResourcesA;
    }; 
    case LOGI_STATUS_AT_B_UNLOADING: {
        _pointPos = _posDestB; 
        _transpRes = _transpResourcesB;
    };
};

if (_timeLeft > 1 && (_currentLoaded isNotEqualTo [0,0,0])) then {
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
            };
            case ABORT_CONVOY : {
                // Abort
                _nextState = switch _status do {
                    case LOGI_STATUS_AT_A_UNLOADING: {LOGI_STATUS_ABORTING_TO_B};
                    case LOGI_STATUS_AT_B_UNLOADING: {LOGI_STATUS_ABORTING_TO_A};
                };

                _logiData set [STATUS_INDEX, _nextState];
            };
            default {}
        };

        [_logiID, _handler] call KPLIB_fnc_logistic_manager;
    };

    // Get resources from the position point
    private _storageAreas = [_pointPos] call KPLIB_fnc_getAllStorages;
    private _storages = [];

    // Exit on no storages in the area
    if ((count (_storageAreas)) == 0) exitWith {
        _logiData set [SPECIAL_FLAG_INDEX, LOGI_FLAG_NO_STORAGE];
        
        // Abort
        _nextState = switch _status do {
            case LOGI_STATUS_AT_A_UNLOADING: {LOGI_STATUS_ABORTING_TO_B};
            case LOGI_STATUS_AT_B_UNLOADING: {LOGI_STATUS_ABORTING_TO_A};
        };

        _logiData set [STATUS_INDEX, _nextState];

        [_logiID, _handler] call KPLIB_fnc_logistic_manager;
    };

    _logiData set [TIME_LEFT_INDEX, _timeLeft - 1];

    if (KPLIB_logistic_debug > 0) then {[format ["Logistic group (%1) is on unloading process. Time left: %2", _logiID, _timeLeft], "VIRTUAL LOGISTIC"] call KPLIB_fnc_log;};

    // Unload after the time runs out
    if (_timeLeft <= 2 && (_currentLoaded isNotEqualTo [0,0,0])) then {
        // Is unloading

        // Resources to process
        private _supply = _currentLoaded # 0;
        private _ammo = _currentLoaded # 1;
        private _fuel = _currentLoaded # 2;

        {
            if ([_x] call KPLIB_fnc_isStorageFull) then {continue}; // Skip iteration

            // Pushback storage with space
            _storages pushBack _x;
        } forEach _storageAreas;

        if (count _storages > 0) then {
            // Storages found and they are not full
            [_supply, _ammo, _fuel, _storages] call KPLIB_fnc_restoreResources;
        } else {
            // All storages full or no storages found. Spawn crates instead.

            private _storagePos = (getPosATL (selectRandom _storages)); // Select a random storage to spawn the crates around it
            while {(_supply > 0) || (_ammo > 0) || (_fuel > 0)} do {
                if (_supply > 0) then {
                    private _amount = _supply min 100;
                    [KPLIB_b_crateSupply, _amount, _storagePos] call KPLIB_fnc_createCrate;
                    _supply = _supply - _amount;
                };

                if (_ammo > 0) then {
                    private _amount = _ammo min 100;
                    [KPLIB_b_crateAmmo, _amount, _storagePos] call KPLIB_fnc_createCrate;
                    _ammo = _ammo - _amount;
                };

                if (_fuel > 0) then {
                    private _amount = _fuel min 100;
                    [KPLIB_b_crateFuel, _amount, _storagePos] call KPLIB_fnc_createCrate;
                    _fuel = _fuel - _amount;
                };
            };
        };

        // In this new model of resource management, it will always restore all the resources
        _logiData set [CURRENT_LOADED_INDEX, [0,0,0]];

        ["KPLIB_recalculateResources", []] call CBA_fnc_serverEvent;
        if (KPLIB_logistic_debug > 0) then {[format ["Logistic group (%1) unloaded cargo.", _logiID], "VIRTUAL LOGISTIC"] call KPLIB_fnc_log;};
    };
} else {
    // Time is less than 1
    // Check for the next state
    private _nextState = 0;
    private _time = -1;

    // Check for resources to transport and resources left on the cargo
    if ((_transpResourcesA isEqualTo [0,0,0]) && (_transpResourcesB isEqualTo [0,0,0]) && (_currentLoaded isEqualTo [0,0,0])) then {
        _logiData set [POINT_A_POS_INDEX, [0,0,0]];
        _logiData set [POINT_B_POS_INDEX, [0,0,0]];
    } else {
        // Change status (unloading finished)
        _nextState = switch _status do {
            case LOGI_STATUS_AT_A_UNLOADING: {LOGI_STATUS_AT_A_LOADING};
            case LOGI_STATUS_AT_B_UNLOADING: {LOGI_STATUS_AT_B_LOADING};
        };
        _transpRes params ["_supplyToLoad", "_ammoToLoad", "_fuelToLoad"];
        _time = ceil (((ceil (_supplyToLoad / 100)) + (ceil (_ammoToLoad / 100)) + (ceil (_fuelToLoad / 100))) / 3);
        
        if (_time > _truckCount) then {
            _time = _truckCount;
        };

        _time = _time + 2;
    };

    _logiData set [STATUS_INDEX, _nextState];
    _logiData set [TIME_LEFT_INDEX, _time];
    _logiData set [LAST_POS_INDEX, _pointPos]; // Change the last know logistic position

    if (KPLIB_logistic_debug > 0) then {[format ["Logistic group (%1) status updated (next status: %2) after unloading.", _logiID, _nextState], "VIRTUAL LOGISTIC"] call KPLIB_fnc_log;};

    publicVariable "KPLIB_logistics";

    [_logiID, _handler] call KPLIB_fnc_logistic_manager;
};

publicVariable "KPLIB_logistics";