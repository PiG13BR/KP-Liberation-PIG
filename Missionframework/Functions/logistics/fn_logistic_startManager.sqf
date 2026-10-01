/*
    File: fn_logistic_startManager.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 02/08/2026
    Last Update: 26/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Execute the logistic manager for a logistic group

    Parameter(s):
        _args - PFH passed arguments [ARRAY]
        _handler - PFH handler ID [NUMBER, defaults to -1]

    Returns:
        -
*/
params[["_logiID", "", [""]]];

if (!isServer) exitWith {};

if (_logiID == "") exitWith {["No logistic ID provided"] call BIS_fnc_error};

if (KPLIB_logistic_debug > 0) then {[format["Logistic management started for logistic group %1", _logiID], "VIRTUAL LOGISTIC"] call KPLIB_fnc_log};

[{_this call KPLIB_fnc_logistic_manager}, _logiID, 60] call CBA_fnc_waitAndExecute;