#include "..\defines.hpp"
/*
    File: fn_logistic_addGroup.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 31/07/2026
    Last Update: 05/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Create a new logistic group

    Parameter(s):
        _control - add group button [CONTROL]

    Returns:
        -
*/
params["_control"];

private _display = ctrlParent _control;
private _logisticListBox = _display displayCtrl IDC_LOGISTIC_LISTBOX;

// Select new ID by getting the first element always
private _militaryAlphabet = KPLIB_militaryAlphabet - (keys KPLIB_logistics);
private _newID = _militaryAlphabet # 0;
// private _newID = [count KPLIB_logistics] call KPLIB_fnc_getMilitaryId;

private _fob = localNamespace getVariable ["KPLIB_logistic_nearFob", [0,0,0]];

KPLIB_logistics set [
    _newID,             // ID 
    [
        0,              // Truck Count
        [0,0,0],        // Position Point A
        [0,0,0],        // Position Point B
        [0,0,0],        // Ressource transport count A -> B [S,A,F]
        [0,0,0],        // Ressource transport count B -> A [S,A,F]
        [0,0,0],        // Currently loaded [S,A,F]
        -1,             // Status (Indexes on defines.hpp)
        -1,             // Time left in current status
        -1,             // Special Flag (Indexes on defines.hpp)
        _fob,           // Origin. Fob position where the group was builded and where the convoy starts.
        -1              // PFH ID
    ]
];

publicVariable "KPLIB_logistics";

// Update listbox
lbClear _logisticListBox;
{
    private _logiID = _x;
    _logisticListBox lbAdd _logiID;
    _logisticListBox lbSetData [_forEachIndex, _logiID]; // Save key as data
} forEach KPLIB_logistics;

lbSort _logisticListBox;
_logisticListBox lbSetCurSel ((count KPLIB_logistics) - 1);