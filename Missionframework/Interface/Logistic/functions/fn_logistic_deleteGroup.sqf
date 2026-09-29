#include "..\defines.hpp"
/*
    File: fn_logistic_deleteGroup.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 31/07/2026
    Last Update: 05/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Delete selected logistic group

    Parameter(s):
        _control - delete group button [CONTROL]

    Returns:
        -
*/
params["_control"];

private _display = ctrlParent _control;
private _logisticListBox = _display displayCtrl IDC_LOGISTIC_LISTBOX;
private _logiNameCtrl = _display displayCtrl IDC_LOGISTIC_NAME_TEXT;

// Delete group and update hashmap
private _lbCurSel = lbCurSel _logisticListBox;
private _group = _logisticListBox lbData _lbCurSel;
KPLIB_logistics deleteAt _group;
private _temp = createHashMapFromArray [];

if (count KPLIB_logistics > 0) then {
    {
        private _key = _x;
        private _data = _y;
        _temp set [_key, _data];
    } forEach KPLIB_logistics;
};

KPLIB_logistics = +_temp;
publicVariable "KPLIB_logistics";

// Update listbox
lbClear _logisticListBox;
{
    private _logiID = _x;
    _logisticListBox lbAdd _logiID;
    _logisticListBox lbSetData [_forEachIndex, _logiID]; // Save key as data
} forEach KPLIB_logistics;

lbSort _logisticListBox;

if ((count KPLIB_logistics) < 1) then {
    // Disable controls
    {ctrlShow [_x, false]} forEach DETAIL_CONTROLS;
    [_display] call KPLIB_fnc_logistic_disableControls;
    _logiNameCtrl ctrlSetText "";
};
_logisticListBox lbSetCurSel ((count KPLIB_logistics) - 1);