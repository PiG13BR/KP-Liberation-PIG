#include "..\defines.hpp"
/*
    File: fn_logistic_abortConvoy.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 31/07/2026
    Last Update: 27/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Abort current mission for the selected convoy

    Parameter(s):
        _control - abort mission button [CONTROL]

    Returns:
        -
*/
params["_control"];

private _display = (ctrlParent _control);
private _listBoxCtrl = _display displayCtrl IDC_LOGISTIC_LISTBOX;
private _index = (lbCurSel _listBoxCtrl);

private _clientID = clientOwner;

private _groupID = _listBoxCtrl lbData _index;
private _groupData = (KPLIB_logistics getOrDefault [_groupID, []]);

private _logiStatus = _groupData # 6;

if ((_logiStatus == LOGI_STATUS_STANDBY) || (_logiStatus == LOGI_STATUS_ABORTING_TO_A) || (_logiStatus == LOGI_STATUS_ABORTING_TO_B)) exitWith {
    [localize "STR_LOGISTIC_STANDBY_ERROR", true, 3] remoteExecCall ["KPLIB_fnc_hint", _clientID]; 
};

private _loadedSupply = (_groupData # 5) # 0;
private _loadedAmmo = (_groupData # 5) # 1;
private _loadedFuel = (_groupData # 5) # 2;

private _destinationA = _groupData # 1;
private _destinationB = _groupData # 2;

private _time = 0;
private _timeLeft = _groupData # 7;

private _pfhID = _groupData # 10;

// Update its status
switch _logiStatus do {
    case LOGI_STATUS_AT_A_LOADING;
    case LOGI_STATUS_AT_B_LOADING : {
        _time = ceil (((ceil (_loadedSupply / 100)) + (ceil (_loadedAmmo / 100)) + (ceil (_loadedFuel / 100))) / 3);
        _time = _time + 1;
    };
    case LOGI_STATUS_TO_A;
    case LOGI_STATUS_TO_B : {
        _time = ceil ((_destinationA distance2D _destinationB) / 400);
        _time = _time - _timeLeft;

        _time = _time + (ceil (((ceil (_loadedSupply / 100)) + (ceil (_loadedAmmo / 100)) + (ceil (_loadedFuel / 100))) / 3));
        _time = _time + 1;
    };
    case LOGI_STATUS_AT_A_UNLOADING;
    case LOGI_STATUS_AT_B_UNLOADING : {
        _time = ceil ((_destinationA distance2D _destinationB) / 400);

        _time = _time + (ceil (((ceil (_loadedSupply / 100)) + (ceil (_loadedAmmo / 100)) + (ceil (_loadedFuel / 100))) / 3));
        _time = _time + 1;
    };
    default {_time = 2};
};

private _nextState = switch _logiStatus do {
    case LOGI_STATUS_AT_A_LOADING: {LOGI_STATUS_ABORTING_TO_A};
    case LOGI_STATUS_AT_B_LOADING: {LOGI_STATUS_ABORTING_TO_B};
    case LOGI_STATUS_AT_A_UNLOADING: {LOGI_STATUS_ABORTING_TO_B};
    case LOGI_STATUS_AT_B_UNLOADING: {LOGI_STATUS_ABORTING_TO_A};
    case LOGI_STATUS_TO_A: {LOGI_STATUS_ABORTING_TO_B};
    case LOGI_STATUS_TO_B: {LOGI_STATUS_ABORTING_TO_A};
};

_groupData set [6, _nextState];
_groupData set [7, _time];
_groupData set [8, -1];

/*
KPLIB_logistics set [_groupID,
[
    _groupData # 0,
    _groupData # 1,
    _groupData # 2,
    _groupData # 3,
    _groupData # 4,
    _groupData # 5,
    _nextState,
    _time,
    -1,
    // _fob
    -1
]];
*/

// Terminate logistic PFH
if (!isNil "_pfhID") then {
    [_groupID, _pfhID] call KPLIB_fnc_logistic_manager;
} else {
    [_groupID] call KPLIB_fnc_logistic_manager;
};

publicVariable "KPLIB_logistics";

[_display, _index] call KPLIB_fnc_logistic_updateControls;