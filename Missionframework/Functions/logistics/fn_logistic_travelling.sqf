#include "script_components.hpp"
/*
    File: fn_logistic_travelling.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 02/08/2026
    Last Update: 26/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Logistic travel process

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

private _transpRes = [0,0,0]; // Get resources transport count information

// Check status
switch _status do {
    case LOGI_STATUS_TO_A: {
        _transpRes = _transpResourcesA;
    }; 
    case LOGI_STATUS_TO_B: {
        _transpRes = _transpResourcesB;
    };
};

if (_timeLeft > 1) then {
    private _checkDist = (_timeLeft <= ((ceil ((_posDestA distance2D _posDestB) / 400)) - 3));

    // Check for conditions to create ambush task
    if (
        _checkDist 
        && _timeLeft >= 3 
        && (_currentLoaded isNotEqualTo [0,0,0]) 
        && !KPLIB_convoy_ambush_inProgress
        && (KPLIB_civ_rep <= -25)
        && ((_timeLeft % 2) == 0)
    ) then {
        private _dice = 100; // round (random 100);
        private _chance = 100; // KPLIB_convoy_ambush_chance
        if (_chance > 0) then {
            _chance = _chance + ([] call KPLIB_fnc_crGetMulti);
        };
        if (KPLIB_asymmetric_debug > 0) then {[format ["Logistic convoy %1: ambush possible - current ETA: %2 - Dice: %3 - Chance: %4", _logiID, _timeLeft, _dice, _chance], "ASYMMETRIC"] call KPLIB_fnc_log;};

        if (_dice <= _chance) then {
            private _ambushed = _logiID call KPLIB_fnc_logistic_convoyAmbush;
            if (_ambushed) then {
                _logiData set [POINT_A_POS_INDEX, [0,0,0]];
                _logiData set [POINT_B_POS_INDEX, [0,0,0]];
                _logiData set [RES_TRANS_A_INDEX, [0,0,0]];
                _logiData set [RES_TRANS_B_INDEX, [0,0,0]];
                _logiData set [CURRENT_LOADED_INDEX, [0,0,0]];
                _logiData set [STATUS_INDEX, LOGI_STATUS_AMBUSHED];
                _logiData set [TIME_LEFT_INDEX, -1];

                [_logiID, _handler] call KPLIB_fnc_logistic_manager;
            } else {
                _logiData set [TIME_LEFT_INDEX, (_timeLeft - 1)];
                KPLIB_convoy_ambush_check = 0;
            };
        } else {
            _logiData set [TIME_LEFT_INDEX, _timeLeft - 1];
        };
    } else {
        _logiData set [TIME_LEFT_INDEX, _timeLeft - 1];
    };

    if (KPLIB_logistic_debug > 0) then {[format ["Logistic Group Update: %1", _logiID], "LOGISTIC"] call KPLIB_fnc_log;};
} else {
    private _nextState = 0;
    private _time = 0;

    // Change to the next state
    if (_currentLoaded isEqualTo [0,0,0]) then {
        // Just traveled
        // Start loading process
        _nextState = switch _status do {
            case LOGI_STATUS_TO_A: {LOGI_STATUS_AT_A_LOADING};
            case LOGI_STATUS_TO_B: {LOGI_STATUS_AT_B_LOADING};
        };
        _transpRes params ["_supplyToLoad", "_ammoToLoad", "_fuelToLoad"];
        _time = ceil (((ceil (_supplyToLoad / 100)) + (ceil (_ammoToLoad / 100)) + (ceil (_fuelToLoad / 100))) / 3);
        
        if (_time > _truckCount) then {
            _time = _truckCount;
        };

        _time = _time + 2;
    } else {
         // Change status to unloading
        _nextState = switch _status do {
            case LOGI_STATUS_TO_A: {
                LOGI_STATUS_AT_A_UNLOADING;
            };
            case LOGI_STATUS_TO_B: {
                LOGI_STATUS_AT_B_UNLOADING;
            };
        };
        if (_time > _truckCount) then {_time = _truckCount;};

        private _supplies = _currentLoaded # 0;
        private _ammo = _currentLoaded # 1;
        private _fuel = _currentLoaded # 2;

        _time = _time + (ceil (((ceil (_supplies / 100)) + (ceil (_ammo / 100)) + (ceil (_fuel / 100))) / 3));
        _time = _time + 2;
    };

    _logiData set [STATUS_INDEX, _nextState];
    _logiData set [TIME_LEFT_INDEX, _time];

    if (KPLIB_logistic_debug > 0) then {[format ["Logistic Group Update: %1", _logiID], "LOGISTIC"] call KPLIB_fnc_log;};

    [_logiID, _handler] call KPLIB_fnc_logistic_manager;
};

publicVariable "KPLIB_logistics";