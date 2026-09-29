#include "..\defines.hpp"
/*
    File: fn_logistic_deleteTruck.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 31/07/2026
    Last Update: 05/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Delete one truck from the selected logistic group

    Parameter(s):
        _control - delete truck button [CONTROL]

    Returns:
        -
*/
params["_control"];

private _clientID = clientOwner;
private _player = player;

// Get listbox control
private _display = (ctrlParent _control);
private _listBoxCtrl = _display displayCtrl IDC_LOGISTIC_LISTBOX;
private _index = (lbCurSel _listBoxCtrl);

private _nearfob = localNamespace getVariable ["KPLIB_logistic_nearFob", []];
if (isNull _player) then {_player = _nearFob};

// Get truck count
private _group = _listBoxCtrl lbData _index;
private _groupData = (KPLIB_logistics get _group);
private _truckCount = _groupData # 0;
if (_truckCount <= 0) exitWith {};

private _baseData = [_nearFob] call KPLIB_fnc_getBaseResources;
_baseData params ["", "_supplies", "_ammo", "_fuel"];

// Get storage areas
private _storages = [_nearfob] call KPLIB_fnc_getAllStorages;

// Check for existing storages
if ((count _storages) == 0) exitWith {
    [localize "STR_LOGISTIC_NOSPACE", true, 3] remoteExec ["KPLIB_fnc_hint", _clientID];
};

// Sell logi truck (for half of the price)
(KPLIB_b_logiTruck # 1) params ["_supplyPrice", "_ammoPrice", "_fuelPrice"];
private _supplyPrice = _supplyPrice/2;
private _ammoPrice = _ammoPrice/2;
private _fuelPrice = _fuelPrice/2;

if (count _storages > 0) then {
    // Storages found and they are not full
    [_supplyPrice, _ammoPrice, _fuelPrice, _storages] call KPLIB_fnc_restoreResources;
} else {
    // All storages full. Spawn crates instead.
    while {(_supplyPrice > 0) || (_ammoPrice > 0) || (_fuelPrice > 0)} do {
        if (_supplyPrice > 0) then {
            private _price = _supplyPrice min 100;
            [KPLIB_b_crateSupply, _price, getPosATL _player] call KPLIB_fnc_createCrate;
            _supplyPrice = _supplyPrice - _price;
        };

        if (_ammoPrice > 0) then {
            private _price = _ammoPrice min 100;
            [KPLIB_b_crateAmmo, _price, getPosATL _player] call KPLIB_fnc_createCrate;
            _ammoPrice = _ammoPrice - _price;
        };

        if (_fuelPrice > 0) then {
            private _price = _fuelPrice min 100;
            [KPLIB_b_crateFuel, _price, getPosATL _player] call KPLIB_fnc_createCrate;
            _fuelPrice = _fuelPrice - _price;
        };
    };
};

// Set truck count
_groupData set [0, _truckCount - 1];
if (_truckCount < 1) then {
    _groupData set [6, -1]; // Status
};

KPLIB_logistics set [_group, _groupData];

publicVariable "KPLIB_logistics";

[_display, _index] call KPLIB_fnc_logistic_updateControls;