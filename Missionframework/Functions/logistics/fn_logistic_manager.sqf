#include "script_components.hpp"
/*
    File: fn_logistic_manager.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 02/08/2026
    Last Update: 26/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        The management of the logi group is done by checking its status/states individually.
        Each of them might be in different states. The status are changed once completing a task.
        The next time this code runs again, it will call the right function acoording to the logi's status.
        The status is used to updated GUI controls as well.

    Parameter(s):
        _logiID - logistic group ID [STRING, defaults to ""]
        _handler - PFH handler ID [NUMBER, defaults to -1]

    Returns:
        -
*/
params[["_logiID", "", [""]], ["_handler", -1, [0]]];

if (!isServer) exitWith {};

if (_logiID == "") exitWith {["No logistic ID provided"] call BIS_fnc_error};

if (KPLIB_endgame == 1) exitWith {[KPLIB_VIRTUAL_LOGISTIC_PFH] call CBA_fnc_removePerFrameHandler};

// Remove handler
if (_handler >= 0) then {
    [_handler] call CBA_fnc_removePerFrameHandler;
};

// Get updated status
private _logiData = KPLIB_logistics getOrDefault [_logiID, []];
private _status = _logiData # 6;

if (KPLIB_logistic_debug > 0) then {[format["Logistic group (%1) manager. Current status: %2", _logiID, _status], "VIRTUAL LOGISTIC"] call KPLIB_fnc_log};

// Check status to update the KPLIB_logistics variable
_handler = switch _status do {
    case LOGI_STATUS_STANDBY : {-1}; // Do nothing
    case LOGI_STATUS_AT_A_LOADING; // Skip if true and call the next one
    case LOGI_STATUS_AT_B_LOADING : {
        [{_this call KPLIB_fnc_logistic_loading}, 60, [_logiID, _logiData]] call CBA_fnc_addPerFrameHandler;
    };
    case LOGI_STATUS_TO_B; // Skip if true and call the next one
    case LOGI_STATUS_TO_A : {
        [{_this call KPLIB_fnc_logistic_travelling}, 60, [_logiID, _logiData]] call CBA_fnc_addPerFrameHandler;
    };
    case LOGI_STATUS_AT_A_UNLOADING; // Skip if true and call the next one
    case LOGI_STATUS_AT_B_UNLOADING : {
        [{_this call KPLIB_fnc_logistic_unloading}, 60, [_logiID, _logiData]] call CBA_fnc_addPerFrameHandler;
    };
    case LOGI_STATUS_ABORTING_TO_A; // Skip if true and call the next one
    case LOGI_STATUS_ABORTING_TO_B : {
        [{_this call KPLIB_fnc_logistic_aborting}, 60, [_logiID, _logiData]] call CBA_fnc_addPerFrameHandler;
    };
    default {-1};
};

_logiData set [PFH_ID_INDEX, _handler];
publicVariable "KPLIB_logistics"