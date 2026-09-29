/*
    File: fn_logistic_handleComboBox.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 31/07/2026
    Last Update: 05/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Manages list box selections (logi groups)

    Parameter(s):
        _control - logi groups listbox [CONTROL]
        _lbCurSel - selected index [NUMBER]

    Returns:
        -
*/
params ["_control", "_lbCurSel"];

private _display = ctrlParent _control;

[_display, _lbCurSel] call KPLIB_fnc_logistic_updateControls;

if (!isNil "KPLIB_LOGISTIC_MENU_PFH") then {
    [KPLIB_LOGISTIC_MENU_PFH] call CBA_fnc_removePerFrameHandler;
};

KPLIB_LOGISTIC_MENU_PFH = [{
    params["_args", "_handler"];
    _args call KPLIB_fnc_logistic_updateLabels;
}, 0.1, [_display, _lbCurSel]] call CBA_fnc_addPerFrameHandler;
