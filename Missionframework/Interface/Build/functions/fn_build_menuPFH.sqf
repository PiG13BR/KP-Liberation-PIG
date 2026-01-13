#include "..\defines.hpp"
/*
    File: fn_build_menuPFH.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 10/11/2025
    Last Update: 12/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Update build menu label page

    Parameter(s):
        _listNboxCtrl - listbox control [CONTROL]
        _build_list - build list to update [ARRAY]

    Returns:
        -
*/
params["_listNboxCtrl", "_build_list"];

if (!isNil "KPLIB_BUILD_labelPfhandle") then {[KPLIB_BUILD_labelPfhandle] call CBA_fnc_removePerFrameHandler;}; // Delete previous PFH

private _display = ctrlParent _listNboxCtrl;

private _suppliesTextCtrl = _display displayCtrl IDC_SUPPLIES_TEXT;
private _ammoTextCtrl = _display displayCtrl IDC_AMMO_TEXT;
private _fuelTextCtrl = _display displayCtrl IDC_FUEL_TEXT;
private _labelCapTextCtrl = _display displayCtrl IDC_LABELCAP_TEXT;

KPLIB_BUILD_labelPfhandle = [{
    params ["_args", "_handle"];
    _args params ["_controls", "_build_list"];

    [_build_list, _controls] call KPLIB_fnc_build_updateLabelPage; // Update the whole label page

    [(_controls # 0)] call KPLIB_fnc_build_updateBuildCtrl; // Update build controls for selected item

}, 0.1, [[_listNboxCtrl, _suppliesTextCtrl, _ammoTextCtrl, _fuelTextCtrl, _labelCapTextCtrl], _build_list]] call CBA_fnc_addPerFrameHandler;