#include "script_components.hpp"
/*
    File: fn_logistic_aborting.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 02/08/2026
    Last Update: 26/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Convoy aborting mission. If not storages are found in the final destination, spawn the resources in the central position

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
    "_transResourcesA", 
    "_transResourcesB",
    "_currentLoaded",
    "_status",
    "_timeLeft",
    "_specialFlag"
];

private _pointPos = [0,0,0]; // Get position point information

if (_timeLeft > 1) then {

    // Check status
    _pointPos = switch _status do {
        case LOGI_STATUS_ABORTING_TO_A: {
            _posDestA;
        }; 
        case LOGI_STATUS_ABORTING_TO_B: {
            _posDestB; 
        };
    };

    // Check if it's a player's sector, otherwise destroy the convoy from this group
    if !((([_pointPos] call KPLIB_fnc_getNearestBluforObjective) distance2D _pointPos) < 100) exitWith {
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

        _logiID call KPLIB_fnc_logistic_manager;
    };

    private _storageAreas = [_pointPos] call KPLIB_fnc_getAllStorages;

    _logiData set [TIME_LEFT_INDEX, _timeLeft - 1];
    
    if (_timeLeft <= 2  && (_currentLoaded isNotEqualTo [0,0,0])) then {
        // Resources to process
        private _supplies = _currentLoaded # 0;
        private _ammo = _currentLoaded # 1;
        private _fuel = _currentLoaded # 2;
        private _toProcess = ceil ((ceil (_supplies / 100)) + (ceil (_ammo / 100)) + (ceil (_fuel / 100)));
        if (_toProcess > 3) then {_toProcess = 3;};

        private _storages = [];
        {
            if ([_x] call KPLIB_fnc_isStorageFull) then {continue}; // Skip iteration

            private _storageLimit = [_x] call KPLIB_fnc_getStorageLimit;

            // Pushback storage with space
            _storages pushBack _x;
        } forEach _storageAreas;

        if (count _storages > 0) then {
            // Storages found and they are not full
            [_supplies, _ammo, _fuel, _storages] call KPLIB_fnc_restoreResources;
        } else {
            // All storages full or no storages found. Spawn crates instead.
            while {(_supplies > 0) || (_ammo > 0) || (_fuel > 0)} do {
                if (_supplies > 0) then {
                    private _amount = _supplies min 100;
                    [KPLIB_b_crateSupply, _amount, _pointPos] call KPLIB_fnc_createCrate;
                    _supplies = _supplies - _amount;
                };

                if (_ammo > 0) then {
                    private _amount = _ammo min 100;
                    [KPLIB_b_crateAmmo, _amount, _pointPos] call KPLIB_fnc_createCrate;
                    _ammo = _ammo - _amount;
                };

                if (_fuel > 0) then {
                    private _amount = _fuel min 100;
                    [KPLIB_b_crateFuel, _amount, _pointPos] call KPLIB_fnc_createCrate;
                    _fuel = _fuel - _amount;
                };
            };
        };

        _logiData set [CURRENT_LOADED_INDEX, [0,0,0]];

        ["KPLIB_recalculateResources", []] call CBA_fnc_serverEvent;
        if (KPLIB_logistic_debug > 0) then {[format ["Logistic Group Update: %1", _logiID], "LOGISTIC"] call KPLIB_fnc_log;};
    };
} else {
    _logiData set [POINT_A_POS_INDEX, [0,0,0]];
    _logiData set [POINT_B_POS_INDEX, [0,0,0]];
    _logiData set [RES_TRANS_A_INDEX, [0,0,0]];
    _logiData set [RES_TRANS_B_INDEX, [0,0,0]];
    _logiData set [CURRENT_LOADED_INDEX, [0,0,0]];
    _logiData set [STATUS_INDEX, 0];
    _logiData set [TIME_LEFT_INDEX, -1];
    _logiData set [SPECIAL_FLAG_INDEX, -1];

    if (KPLIB_logistic_debug > 0) then {[format ["Logistic Group Update: %1", _logiID], "LOGISTIC"] call KPLIB_fnc_log;};

    [_logiID, _handler] call KPLIB_fnc_logistic_manager;
};

publicVariable "KPLIB_logistics";