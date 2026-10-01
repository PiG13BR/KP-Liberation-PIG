#include "..\defines.hpp"
/*
    File: fn_logistic_addTruck.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 31/07/2026
    Last Update: 30/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Add a new truck for the selected logistic group

    Parameter(s):
        _control - add truck button [CONTROL]

    Returns:
        -
*/
params["_control"];

private _display = (ctrlParent _control);
private _listBoxCtrl = _display displayCtrl IDC_LOGISTIC_LISTBOX;
private _index = (lbCurSel _listBoxCtrl);
private _clientID = clientOwner;
private _nearFob = localNamespace getVariable ["KPLIB_logistic_nearFob", [0,0,0]];

private _baseData = [_nearFob] call KPLIB_fnc_getBaseResources;
_baseData params ["", "_supplies", "_ammo", "_fuel"];

// Get storage areas
private _storages = [_nearfob] call KPLIB_fnc_getAllStorages;

// Check for existing storages
if ((count _storages) == 0) exitWith {
    [localize "STR_LOGISTIC_CANTAFFORD", true, 3] remoteExecCall ["KPLIB_fnc_hint", _clientID];
};

// Buy logi truck price
KPLIB_b_logiTruck params ["", "_supplyPrice", "_ammoPrice", "_fuelPrice"];

// Check for enough resources
if ((_supplyPrice > _supplies) || (_ammoPrice > _ammo) || (_fuelPrice > _fuel)) exitWith {
    [localize "STR_LOGISTIC_CANTAFFORD", true, 3] remoteExecCall ["KPLIB_fnc_hint", _clientID];
};

// Buy truck
["KPLIB_logi_addTruck", [_supplyPrice, _ammoPrice, _fuelPrice, _storages]] call CBA_fnc_serverEvent;

// Add truck count
private _group = _listBoxCtrl lbData _index;

// Set truck count
private _groupData = (KPLIB_logistics get _group);
private _truckCount = _groupData # 0;
_groupData set [0, _truckCount + 1];
_groupData set [6, 0]; // Status
KPLIB_logistics set [_group, _groupData];
publicVariable "KPLIB_logistics";

[_display, _index] call KPLIB_fnc_logistic_updateControls;