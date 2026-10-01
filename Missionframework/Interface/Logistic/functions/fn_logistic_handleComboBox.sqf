#include "..\defines.hpp"
/*
    File: fn_logistic_handleComboBox.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 31/07/2026
    Last Update: 05/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Manages comboboxes selections (destinations)

    Parameter(s):
        _control - destination combobox [CONTROL]
        _lbCurSel - selected index [NUMBER]

    Returns:
        -
*/
params["_control", "_lbCurSel"];

private _display = ctrlParent _control;

private _mapControl = _display displayCtrl IDC_MAP;

private _logi_destinations = localNamespace getVariable ["KPLIB_logistic_destinations", []];
private _destSel = (_logi_destinations # _lbCurSel) # 1;

_mapControl ctrlMapAnimAdd [0.5, 0.2, _destSel]; 
ctrlMapAnimCommit _mapControl;

[_display] call KPLIB_fnc_logistic_drawArrow;