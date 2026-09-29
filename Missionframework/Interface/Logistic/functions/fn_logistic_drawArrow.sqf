#include "..\defines.hpp"
/*
    File: fn_logistic_drawArrow.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 31/07/2026
    Last Update: 06/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Draw arrow between the origin and destination

    Parameter(s):
        _display - virtual logistic menu display [DISPLAY, defaults to findDisplay IDD_LOGISTIC_MENU]
        _deleteArrow - delete arrow and exit function [BOOL, defaults to false]

    Returns:
        -
*/
params[["_display", findDisplay IDD_LOGISTIC_MENU], ["_deleteArrow", false, [false]]];

if (_deleteArrow) exitWith {
    // Just delete the arrow and exit
    if (!isNil "KPLIB_LOGISTIC_ARROW") then {
        KPLIB_LOGISTIC_ARROW call BIS_fnc_drawArrow;
    };
};

if (!isNil "KPLIB_LOGISTIC_ARROW") then {
    KPLIB_LOGISTIC_ARROW call BIS_fnc_drawArrow;
};

private _listBoxCtrl = _display displayCtrl IDC_LOGISTIC_LISTBOX;
private _mapControl = _display displayCtrl IDC_MAP;
private _A_ComboCtrl = _display displayCtrl IDC_A_COMBO;
private _B_ComboCtrl = _display displayCtrl IDC_B_COMBO;

private _lbCurSel = (lbCurSel _listBoxCtrl);
private _logiID = _listBoxCtrl lbData _lbCurSel;
private _logiData = (KPLIB_logistics getOrDefault [_logiID, []]);
private _status = _logiData # 6;

if (_status == LOGI_NO_STATUS) exitWith {};

private _logiData = (KPLIB_logistics getOrDefault [_logiID, []]);
_logiData params [
    "", 
    ["_destinationA",[0,0,0]],
    ["_destinationB",[0,0,0]], 
    "", 
    "",
    "",
    "_status",
    "",
    "_specialFlag"
];

private _arrowFrom = [0,0,0];
private _arrowTo = [0,0,0];

// Draw arrow on confirmed destinations or do it on selected valid destinations
if ((_destinationA isEqualTo [0,0,0]) && (_destinationB isEqualTo [0,0,0])) then {
    private _indexA = lbCurSel _A_ComboCtrl;
    private _indexB = lbCurSel _B_ComboCtrl;
    // Exit on non selected element from combo box
    if (_indexA == -1 || _indexB == -1) exitWith {};

    private _logi_destinations = localNamespace getVariable ["KPLIB_logistic_destinations", []];
    _arrowFrom = (_logi_destinations # _indexA) # 1;
    _arrowTo = (_logi_destinations # _indexB) # 1;
} else {
    // If travelling
    switch _status do {
        case LOGI_STATUS_TO_A: {
            _arrowFrom = _destinationB;
            _arrowTo = _destinationA;
        }; 
        case LOGI_STATUS_TO_B: {
            _arrowFrom = _destinationA;
            _arrowTo = _destinationB;
        };
        case LOGI_STATUS_ABORTING_TO_A: {
            _arrowFrom = _destinationB;
            _arrowTo = _destinationA;
        };
        case LOGI_STATUS_ABORTING_TO_B: {
            _arrowFrom = _destinationA;
            _arrowTo = _destinationB;
        };
        default {};
    };
};

// Exit on the same origin and destination
if (_arrowFrom isEqualTo _arrowTo) exitWith {};

if ((_arrowFrom isEqualTo [0,0,0]) || (_arrowTo isEqualTo [0,0,0])) exitWith {};

// Draw arrows for both directions
private _coef = (_arrowFrom distance2D _arrowTo)/100;
private _dir = _arrowFrom getDir _arrowTo;
KPLIB_LOGISTIC_ARROW = [_arrowFrom getPos [150, _dir], _arrowTo getPos [150, _dir + 180], [0,0,0,1], [30,1/_coef,6], true, _mapControl] call BIS_fnc_drawArrow;