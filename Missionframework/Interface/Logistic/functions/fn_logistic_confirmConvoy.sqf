#include "..\defines.hpp"
/*
    File: fn_logistic_confirmConvoy.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 31/07/2026
    Last Update: 27/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Confirm convoy mission

    Parameter(s):
        _control - confirm mission button [CONTROL]

    Returns:
        -
*/
params["_control"];

// Controls
private _display = (ctrlParent _control);
private _listBoxCtrl = _display displayCtrl IDC_LOGISTIC_LISTBOX;
private _listSelect = (lbCurSel _listBoxCtrl);

private _A_ComboCtrl = _display displayCtrl IDC_A_COMBO;
private _indexA = (lbCurSel _A_ComboCtrl);
private _A_Supply_EditCtrl = _display displayCtrl IDC_A_SUPPLY_EDIT;
private _A_Ammo_EditCtrl = _display displayCtrl IDC_A_AMMO_EDIT;
private _A_Fuel_EditCtrl = _display displayCtrl IDC_A_FUEL_EDIT;

private _B_ComboCtrl = _display displayCtrl IDC_B_COMBO;
private _indexB = (lbCurSel _B_ComboCtrl);
private _B_Supply_EditCtrl = _display displayCtrl IDC_B_SUPPLY_EDIT;
private _B_Ammo_EditCtrl = _display displayCtrl IDC_B_AMMO_EDIT;
private _B_Fuel_EditCtrl = _display displayCtrl IDC_B_FUEL_EDIT;

private _clientID = clientOwner;

if ((_indexA != -1) && (_indexB != -1)) then {
    private _logi_destinations = localNamespace getVariable ["KPLIB_logistic_destinations", []];
    
    // Get destination infos
    private _destinationA = (_logi_destinations # _indexA) # 1;
    private _dest_A_resources = [(_logi_destinations # _indexA) # 2, (_logi_destinations # _indexA) # 3, (_logi_destinations # _indexA) # 4];
    private _A_supplyNumber = parseNumber (ctrlText _A_Supply_EditCtrl);
    private _A_ammoNumber = parseNumber (ctrlText _A_Ammo_EditCtrl);
    private _A_fuelNumber = parseNumber (ctrlText _A_Fuel_EditCtrl);
    private _resources_A = [_A_supplyNumber, _A_ammoNumber, _A_fuelNumber];

    private _destinationB = (_logi_destinations # _indexB) # 1;
    private _dest_B_resources = [(_logi_destinations # _indexB) # 2, (_logi_destinations # _indexB) # 3, (_logi_destinations # _indexB) # 4];
    private _B_supplyNumber = parseNumber (ctrlText _B_Supply_EditCtrl);
    private _B_ammoNumber = parseNumber (ctrlText _B_Ammo_EditCtrl);
    private _B_fuelNumber = parseNumber (ctrlText _B_Fuel_EditCtrl);
    private _resources_B = [_B_supplyNumber, _B_ammoNumber, _B_fuelNumber];

    // No resources on edit boxes (ToDo: specific warning)
    if ((_resources_A isEqualTo [0,0,0]) && (_resources_B isEqualTo [0,0,0])) exitWith {
        [localize "STR_LOGISTIC_SAVE_ERROR", true, 3] remoteExecCall ["KPLIB_fnc_hint", _clientID];
    };

    // Compare amount of resources on edit boxes and what is actually available on storages
    if (
        (_A_supplyNumber > (_dest_A_resources # 0)) 
        ||  (_A_ammoNumber > (_dest_A_resources # 1))
        ||  (_A_fuelNumber > (_dest_A_resources # 2))
    ) exitWith {
        [localize "STR_LOGISTIC_SAVE_ERROR", true, 3] remoteExecCall ["KPLIB_fnc_hint", _clientID];
    };

    if (
        (_B_supplyNumber > (_dest_B_resources # 0))
        ||  (_B_ammoNumber > (_dest_B_resources # 1))
        ||  (_B_fuelNumber > (_dest_B_resources # 2))
    ) exitWith {
        [localize "STR_LOGISTIC_SAVE_ERROR", true, 3] remoteExecCall ["KPLIB_fnc_hint", _clientID];
    };

    // Find amount of resources in both edit boxes (ToDo: specific warning)
    if (
        ((_A_supplyNumber != 0) && (_B_supplyNumber != 0))
        || ((_A_ammoNumber != 0) && (_B_ammoNumber != 0))
        || ((_A_fuelNumber != 0) && (_B_fuelNumber != 0))
    ) exitWith {
        [localize "STR_LOGISTIC_SAVE_ERROR", true, 3] remoteExecCall ["KPLIB_fnc_hint", _clientID];
    };

    // Original and destination is equal (ToDo: specific warning)
    if (_destinationA isEqualTo _destinationB) exitWith {
        [localize "STR_LOGISTIC_SAVE_ERROR", true, 3] remoteExecCall ["KPLIB_fnc_hint", _clientID];
    };

    // Make sure the player puts something to load on A (origin)
    if ((_A_supplyNumber == 0) && (_A_ammoNumber != 0) && (_A_fuelNumber != 0)) exitWith {
        [localize "STR_LOGISTIC_SAVE_ERROR", true, 3] remoteExecCall ["KPLIB_fnc_hint", _clientID];
    };

    /*
        private _error = false;
        {
            private _dest_a = _y # 1;
            private _dest_b = _y # 2;
            if (
                ((_dest_a isEqualTo _destinationA) || (_dest_a isEqualTo _destinationB))
                && ((_dest_b isEqualTo _destinationA) || (_dest_b isEqualTo _destinationB))
            ) exitWith {_error = true;}
        } forEach KPLIB_logistics;

        if (_error) exitWith {
            [localize "STR_LOGISTIC_SAVE_ERROR", true, 3] remoteExecCall ["KPLIB_fnc_hint", _clientID];
        };
    */
    
    private _time = ceil (((ceil (_A_supplyNumber / 100)) + (ceil (_A_ammoNumber / 100)) + (ceil (_A_FuelNumber / 100))) / 3);

    // Get logi data
    private _logiID = _listBoxCtrl lbData _listSelect;
    private _logiData = (KPLIB_logistics getOrDefault [_logiID, []]);
    private _truckCount = _logiData # 0;
    private _currentLoaded = _logiData # 5;
    
    if (_time > _truckCount) then {
        _time = _truckCount;
    };

    _time = _time + 2;

    // Get the last know logistic position
    private _lastLocation = _logiData # 9;
    private _status = LOGI_STATUS_AT_A_LOADING;

    // Only starts loading if the convoy is on the selected origin, otherwise travel to it
    if (_destinationA distance2D _lastLocation > 100) then {
        _status = LOGI_STATUS_TO_A;
        _time = ceil ((_destinationA distance2D _destinationB) / 400);
        _time = _time + 2;
    };

    // Update logistic variable
    KPLIB_logistics set [_logiID,
    [
        _truckCount,
        _destinationA,
        _destinationB,
        _resources_A,
        _resources_B,
        _currentLoaded,
        _status, // Set status to loading at A
        _time, // Time left
        LOGI_NO_FLAG,
        _lastLocation,
        -1
    ]];

    publicVariable "KPLIB_logistics";

    [_display, _listSelect] call KPLIB_fnc_logistic_updateControls;

    ["KPLIB_logistic_startManager", _logiID] call CBA_fnc_serverEvent;
} else {
    [localize "STR_LOGISTIC_SAVE_ERROR", true, 3] call KPLIB_fnc_hint;
};
