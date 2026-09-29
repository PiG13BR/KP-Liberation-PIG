#include "..\defines.hpp"
/*
    File: fn_logistic_disableControls.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 31/07/2026
    Last Update: 05/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Disable controls from the virtual logistic menu

    Parameter(s):
        _display - virtual logistic menu display [DISPLAY, defaults to findDisplay IDD_LOGISTIC_MENU]

    Returns:
        -
*/
params[["_display", findDisplay IDD_LOGISTIC_MENU]];

// Controls
private _mapControl = _display displayCtrl IDC_MAP;
private _deleteGroupCtrl = _display displayCtrl IDC_DELETE_GROUP_BUTTON;
private _buyTruckCtrl = _display displayCtrl IDC_BUY_TRUCK_BUTTON;
private _sellTruckCtrl = _display displayCtrl IDC_SELL_TRUCK_BUTTON;
private _A_ComboCtrl = _display displayCtrl IDC_A_COMBO;
private _A_Supply_EditCtrl = _display displayCtrl IDC_A_SUPPLY_EDIT;
private _A_Ammo_EditCtrl = _display displayCtrl IDC_A_AMMO_EDIT;
private _A_Fuel_EditCtrl = _display displayCtrl IDC_A_FUEL_EDIT;
private _B_ComboCtrl = _display displayCtrl IDC_B_COMBO;
private _B_Supply_EditCtrl = _display displayCtrl IDC_B_SUPPLY_EDIT;
private _B_Ammo_EditCtrl = _display displayCtrl IDC_B_AMMO_EDIT;
private _B_Fuel_EditCtrl = _display displayCtrl IDC_B_FUEL_EDIT;
private _saveButtonCtrl = _display displayCtrl IDC_SAVE_BUTTON;
private _abortButtonCtrl = _display displayCtrl IDC_ABORT_BUTTON;

// Disable controls as default
_deleteGroupCtrl ctrlEnable false;
_buyTruckCtrl ctrlEnable false;
_sellTruckCtrl ctrlEnable false;
_A_ComboCtrl ctrlEnable false;
_A_Supply_EditCtrl ctrlEnable false;
_A_Ammo_EditCtrl ctrlEnable false;
_A_Fuel_EditCtrl ctrlEnable false;
_B_ComboCtrl ctrlEnable false;
_B_Supply_EditCtrl ctrlEnable false;
_B_Ammo_EditCtrl ctrlEnable false;
_B_Fuel_EditCtrl ctrlEnable false;
_saveButtonCtrl ctrlEnable false;
_abortButtonCtrl ctrlEnable false;

private _destCtrl = _display displayCtrl IDC_DESTINATION;
private _logiStatusCtrl = _display displayCtrl IDC_LOGISTIC_STATUS;
private _timeLabelCtrl = _display displayCtrl IDC_TIME_LABEL;
private _truckCountCtrl = _display displayCtrl IDC_TRUCK_COUNT;
private _loadedSupplyCtrl = _display displayCtrl IDC_LOADED_SUPPLY;
private _loadedAmmoCtrl = _display displayCtrl IDC_LOADED_AMMO;
private _loadedFuelCtrl = _display displayCtrl IDC_LOADED_FUEL;
private _A_labelTextCtrl = _display displayCtrl IDC_A_LABEL_TEXT;
private _B_labelTextCtrl = _display displayCtrl IDC_B_LABEL_TEXT;

_destCtrl ctrlSetText "";
_logiStatusCtrl ctrlSetText "";
_timeLabelCtrl ctrlSetText "";
_truckCountCtrl ctrlSetText "";
_loadedSupplyCtrl ctrlSetText "";
_loadedAmmoCtrl ctrlSetText "";
_loadedFuelCtrl ctrlSetText "";
_A_labelTextCtrl ctrlSetText "";
_B_labelTextCtrl ctrlSetText "";
_A_Supply_EditCtrl ctrlSetText "";
_A_Ammo_EditCtrl ctrlSetText "";
_A_Fuel_EditCtrl ctrlSetText "";
_B_Supply_EditCtrl ctrlSetText "";
_B_Ammo_EditCtrl ctrlSetText "";
_B_Fuel_EditCtrl ctrlSetText "";