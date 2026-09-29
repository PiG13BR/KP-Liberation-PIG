#include "..\defines.hpp"
/*
    File: fn_logistic_updateControls.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 05/08/2026
    Last Update: 28/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Update labels with selected logi's data

    Parameter(s):
        _display - virtual logistic menu display [DISPLAY, defaults to findDisplay IDD_LOGISTIC_MENU]
        _lbCurSel - selected group from the group listbox [NUMBER, defaults to -1]

    Returns:
        -
*/
params[["_display", findDisplay IDD_LOGISTIC_MENU], ["_lbCurSel", -1, [0]]];

private _logi_count = (count KPLIB_logistics);

// Controls
private _listBoxCtrl = _display displayCtrl IDC_LOGISTIC_LISTBOX;

private _A_ComboCtrl = _display displayCtrl IDC_A_COMBO;
private _A_Supply_EditCtrl = _display displayCtrl IDC_A_SUPPLY_EDIT;
private _A_Ammo_EditCtrl = _display displayCtrl IDC_A_AMMO_EDIT;
private _A_Fuel_EditCtrl = _display displayCtrl IDC_A_FUEL_EDIT;

private _B_ComboCtrl = _display displayCtrl IDC_B_COMBO;
private _B_Supply_EditCtrl = _display displayCtrl IDC_B_SUPPLY_EDIT;
private _B_Ammo_EditCtrl = _display displayCtrl IDC_B_AMMO_EDIT;
private _B_Fuel_EditCtrl = _display displayCtrl IDC_B_FUEL_EDIT;

private _deleteGroupCtrl = _display displayCtrl IDC_DELETE_GROUP_BUTTON;
private _buyTruckCtrl = _display displayCtrl IDC_BUY_TRUCK_BUTTON;
private _sellTruckCtrl = _display displayCtrl IDC_SELL_TRUCK_BUTTON;
private _saveButtonCtrl = _display displayCtrl IDC_SAVE_BUTTON;

// private _mapControl = _display displayCtrl IDC_MAP;

if (_lbCurSel == -1) then {
    _lbCurSel = (lbCurSel _listBoxCtrl);
};

if ((_lbCurSel != -1) && (_logi_count > 0)) then {
    // Show controls
    {ctrlShow [_x, true]} forEach DETAIL_CONTROLS;

    private _logiID = _listBoxCtrl lbData _lbCurSel;
    private _logiData = (KPLIB_logistics getOrDefault [_logiID, []]);
    _logiData params [
        "_truckCount", 
        "_posDestA",
        "_posDestB", 
        "_transResourcesA", 
        "_transResourcesB",
        "_currentLoaded",
        "_status",
        "_timeLeft",
        "_specialFlag",
        "_logiPos"
    ];

    if ((_status == LOGI_NO_STATUS) || (_status == LOGI_STATUS_STANDBY)) then {
        _buyTruckCtrl ctrlEnable true;
        if (_truckCount <= 0) then {
            // If truck count is 0, enable group deletion
            _deleteGroupCtrl ctrlEnable true;
            _sellTruckCtrl ctrlEnable false;
        } else {
            _deleteGroupCtrl ctrlEnable false;
            _sellTruckCtrl ctrlEnable true;
            _A_ComboCtrl ctrlEnable true;
            _A_Supply_EditCtrl ctrlEnable true;
            _A_Ammo_EditCtrl ctrlEnable true;
            _A_Fuel_EditCtrl ctrlEnable true;
            if (lbCurSel _A_ComboCtrl != -1) then {
                _B_ComboCtrl ctrlEnable true;
                _B_Supply_EditCtrl ctrlEnable true;
                _B_Ammo_EditCtrl ctrlEnable true;
                _B_Fuel_EditCtrl ctrlEnable true;
            };
            _saveButtonCtrl ctrlEnable true;
        };
    };

    // Update status and related labels
    private _destTextCtrl = _display displayCtrl IDC_DESTINATION_TEXT;
    private _destCtrl = _display displayCtrl IDC_DESTINATION;
    private _logiStatusCtrl = _display displayCtrl IDC_LOGISTIC_STATUS;
    private _abortButtonCtrl = _display displayCtrl IDC_ABORT_BUTTON;

    _logiStatusCtrl ctrlSetTextColor COLOR_NEUTRAL;

    switch (_status) do {
        case LOGI_STATUS_STANDBY: {
            _destCtrl ctrlSetText "-"; 
            _logiStatusCtrl ctrlSetText (localize "STR_LOGISTIC_STANDBY");
            _logiStatusCtrl ctrlSetTextColor COLOR_POSITIVE;

            private _name = "A";
            if (_logiPos in KPLIB_player_fobs) then {
                _name = format["FOB %1", [_logiPos] call KPLIB_fnc_getBaseName];
            } else {
                // Sector
                private _marker = [100, _logiPos] call KPLIB_fnc_getNearestSector;
                _name = markerText _marker;
            };

            _destTextCtrl ctrlSetText (localize "STR_LOGISTIC_WAITING_AT");
            _destCtrl ctrlSetText _name;
        };
        case LOGI_STATUS_AT_A_LOADING: {
            private _name = "A";
            if (_posDestA in KPLIB_player_fobs) then {
                _name = format["FOB %1", [_posDestA] call KPLIB_fnc_getBaseName];
            } else {
                // Sector
                private _marker = [100, _posDestA] call KPLIB_fnc_getNearestSector;
                _name = markerText _marker;
            };
            
            _destTextCtrl ctrlSetText (localize "STR_LOGISTIC_WAITING_AT");
            _destCtrl ctrlSetText _name; 
            _logiStatusCtrl ctrlSetText (localize "STR_LOGISTIC_LOADING");
            _logiStatusCtrl ctrlSetTextColor COLOR_LOADING;
            _abortButtonCtrl ctrlEnable true; 

            _transResourcesA params ["_supplyCount", "_ammoCount", "_fuelCount"];
            _A_Supply_EditCtrl ctrlSetText (str _supplyCount);
            _A_Ammo_EditCtrl ctrlSetText (str _ammoCount);
            _A_Fuel_EditCtrl ctrlSetText (str _fuelCount);

            _transResourcesB params ["_supplyCount", "_ammoCount", "_fuelCount"];
            _B_Supply_EditCtrl ctrlSetText (str _supplyCount);
            _B_Ammo_EditCtrl ctrlSetText (str _ammoCount);
            _B_Fuel_EditCtrl ctrlSetText (str _fuelCount);
        };
        case LOGI_STATUS_AT_A_UNLOADING: {
            private _name = "A";
            if (_posDestA in KPLIB_player_fobs) then {
                _name = format["FOB %1", [_posDestA] call KPLIB_fnc_getBaseName];
            } else {
                // Sector
                private _marker = [100, _posDestA] call KPLIB_fnc_getNearestSector;
                _name = markerText _marker;
            };
            
            _destTextCtrl ctrlSetText (localize "STR_LOGISTIC_WAITING_AT");
            _destCtrl ctrlSetText _name; 
            _logiStatusCtrl ctrlSetText (localize "STR_LOGISTIC_UNLOADING");
            _logiStatusCtrl ctrlSetTextColor COLOR_LOADING;
            _abortButtonCtrl ctrlEnable true;
        };
        case LOGI_STATUS_TO_B: {
            private _name = "B";
            if (_posDestB in KPLIB_player_fobs) then {
                _name = format["FOB %1", [_posDestB] call KPLIB_fnc_getBaseName];
            } else {
                // Sector
                private _marker = [100, _posDestB] call KPLIB_fnc_getNearestSector;
                _name = markerText _marker;
            };
            
            _destTextCtrl ctrlSetText (localize "STR_LOGISTIC_DESTINATION");
            _destCtrl ctrlSetText _name; 
            _logiStatusCtrl ctrlSetText (localize "STR_LOGISTIC_TRAVEL"); 
            _logiStatusCtrl ctrlSetTextColor COLOR_POSITIVE;
            _abortButtonCtrl ctrlEnable true;
            ctrlMapAnimClear _mapControl;
        };
        case LOGI_STATUS_AT_B_LOADING: {
            private _name = "B";
            if (_posDestB in KPLIB_player_fobs) then {
                _name = format["FOB %1", [_posDestB] call KPLIB_fnc_getBaseName];
            } else {
                // Sector
                private _marker = [100, _posDestB] call KPLIB_fnc_getNearestSector;
                _name = markerText _marker;
            };
            
            _destTextCtrl ctrlSetText (localize "STR_LOGISTIC_WAITING_AT");
            _destCtrl ctrlSetText _name;  
            _logiStatusCtrl ctrlSetText (localize "STR_LOGISTIC_LOADING");
            _logiStatusCtrl ctrlSetTextColor COLOR_LOADING;
            _abortButtonCtrl ctrlEnable true; 

            _transResourcesA params ["_supplyCount", "_ammoCount", "_fuelCount"];
            _A_Supply_EditCtrl ctrlSetText (str _supplyCount);
            _A_Ammo_EditCtrl ctrlSetText (str _ammoCount);
            _A_Fuel_EditCtrl ctrlSetText (str _fuelCount);

            _transResourcesB params ["_supplyCount", "_ammoCount", "_fuelCount"];
            _B_Supply_EditCtrl ctrlSetText (str _supplyCount);
            _B_Ammo_EditCtrl ctrlSetText (str _ammoCount);
            _B_Fuel_EditCtrl ctrlSetText (str _fuelCount);
        };
        case LOGI_STATUS_AT_B_UNLOADING: {
            private _name = "B";
            if (_posDestB in KPLIB_player_fobs) then {
                _name = format["FOB %1", [_posDestB] call KPLIB_fnc_getBaseName];
            } else {
                // Sector
                private _marker = [100, _posDestB] call KPLIB_fnc_getNearestSector;
                _name = markerText _marker;
            };
            
            _destTextCtrl ctrlSetText (localize "STR_LOGISTIC_WAITING_AT");
            _destCtrl ctrlSetText _name;  
            _logiStatusCtrl ctrlSetText (localize "STR_LOGISTIC_UNLOADING");
            _logiStatusCtrl ctrlSetTextColor COLOR_LOADING;
            _abortButtonCtrl ctrlEnable true; 
        };
        case LOGI_STATUS_TO_A: {
            private _name = "A";
            if (_posDestA in KPLIB_player_fobs) then {
                _name = format["FOB %1", [_posDestA] call KPLIB_fnc_getBaseName];
            } else {
                // Sector
                private _marker = [100, _posDestA] call KPLIB_fnc_getNearestSector;
                _name = markerText _marker;
            };

            _destTextCtrl ctrlSetText (localize "STR_LOGISTIC_DESTINATION");
            _destCtrl ctrlSetText _name;  
            _logiStatusCtrl ctrlSetText (localize "STR_LOGISTIC_TRAVEL");
            _logiStatusCtrl ctrlSetTextColor COLOR_POSITIVE; 
            _abortButtonCtrl ctrlEnable true;
        };
        case LOGI_STATUS_ABORTING_TO_A: {
            private _name = "A";
            if (_posDestA in KPLIB_player_fobs) then {
                _name = format["FOB %1", [_posDestA] call KPLIB_fnc_getBaseName];
            } else {
                // Sector
                private _marker = [100, _posDestA] call KPLIB_fnc_getNearestSector;
                _name = markerText _marker;
            };

            _destTextCtrl ctrlSetText (localize "STR_LOGISTIC_RETURNING_TO");
            _destCtrl ctrlSetText _name;  
            _logiStatusCtrl ctrlSetText (localize "STR_LOGISTIC_ABORT");
            _logiStatusCtrl ctrlSetTextColor COLOR_NEGATIVE;
        };
        case LOGI_STATUS_ABORTING_TO_B: {
            private _name = "B";
            if (_posDestB in KPLIB_player_fobs) then {
                _name = format["FOB %1", [_posDestB] call KPLIB_fnc_getBaseName];
            } else {
                // Sector
                private _marker = [100, _posDestB] call KPLIB_fnc_getNearestSector;
                _name = markerText _marker;
            };

            _destTextCtrl ctrlSetText (localize "STR_LOGISTIC_RETURNING_TO");
            _destCtrl ctrlSetText _name;   
            _logiStatusCtrl ctrlSetText (localize "STR_LOGISTIC_ABORT");
            _logiStatusCtrl ctrlSetTextColor COLOR_NEGATIVE;
        };
        case LOGI_STATUS_AMBUSHED: {
            _destCtrl ctrlSetText "-";
            _logiStatusCtrl ctrlSetText (localize "STR_LOGISTIC_AMBUSHED");
            _logiStatusCtrl ctrlSetTextColor COLOR_NEGATIVE;
        };
        default {
            _destCtrl ctrlSetText "-"; 
            _logiStatusCtrl ctrlSetText (localize "STR_LOGISTIC_NO_TRUCKS");
            _logiStatusCtrl ctrlSetTextColor COLOR_NEGATIVE;
        };
    };

    // Use special flags to add a tooltip on status
    switch _specialFlag do {
        case LOGI_FLAG_NO_STORAGE : {
            _logiStatusCtrl ctrlSetTooltip "No storage found";
        };
        case LOGI_FLAG_NO_RESOURCES : {
            _logiStatusCtrl ctrlSetTooltip "No resources";
        };
        default {
            _logiStatusCtrl ctrlSetTooltip "";
        };
    };

    // Update logi time left or special flags
    private _timeLabelCtrl = _display displayCtrl IDC_TIME_LABEL;
    _timeLabelCtrl ctrlSetTextColor COLOR_NEUTRAL;

    // Update time label
    if (_timeLeft != -1) then {
        _timeLabelCtrl ctrlSetText (format [localize "STR_PRODUCTION_MINUTES", _timeLeft]);
    } else {
        _timeLabelCtrl ctrlSetText "-";
    };

    // Update truck count and cargo
    private _truckCountCtrl = _display displayCtrl IDC_TRUCK_COUNT;
    private _loadedSupplyCtrl = _display displayCtrl IDC_LOADED_SUPPLY;
    private _loadedAmmoCtrl = _display displayCtrl IDC_LOADED_AMMO;
    private _loadedFuelCtrl = _display displayCtrl IDC_LOADED_FUEL;

    _currentLoaded params ["_supplyLoaded", "_ammoLoaded", "_fuelLoaded"];

    _truckCountCtrl ctrlSetText (str _truckCount);
    _loadedSupplyCtrl ctrlSetText (str _supplyLoaded);
    _loadedAmmoCtrl ctrlSetText (str _ammoLoaded);
    _loadedFuelCtrl ctrlSetText (str _fuelLoaded);

    // Update destinations
    private _logiDestinations = localNamespace getVariable ["KPLIB_logistic_destinations", []];
    private _A_labelTextCtrl = _display displayCtrl IDC_A_LABEL_TEXT;
    if !(_posDestA isEqualTo [0,0,0]) then {
        _A_ComboCtrl ctrlShow false;
        _A_labelTextCtrl ctrlShow true;
        {
            _x params ["_destName", "_destPos"];

            if (_posDestA distance2D _destPos < 10) exitWith {
                _A_labelTextCtrl ctrlSetText _destName;
            };
        } forEach _logiDestinations;
    } else {
        _A_ComboCtrl ctrlShow true;
        _A_labelTextCtrl ctrlShow false;
    };

    private _B_labelTextCtrl = _display displayCtrl IDC_B_LABEL_TEXT;
    if !(_posDestB isEqualTo [0,0,0]) then {
        _B_ComboCtrl ctrlShow false;
        _B_labelTextCtrl ctrlShow true;
        {
            _x params ["_destName", "_destPos"];

            if (_posDestB distance2D _destPos < 10) exitWith {
                _B_labelTextCtrl ctrlSetText _destName;
            };
        } forEach _logiDestinations;
    } else {
        _B_ComboCtrl ctrlShow true;
        _B_labelTextCtrl ctrlShow false;
    };
} else {
    // Hide controls
    {ctrlShow [_x, false]} forEach DETAIL_CONTROLS;
}