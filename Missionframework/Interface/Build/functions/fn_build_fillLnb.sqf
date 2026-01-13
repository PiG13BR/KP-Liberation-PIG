#include "..\defines.hpp"
/*
    File: fn_build_fillLnb.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 09/11/2025
    Last Update: 13/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Fill listNBox with items provided by the players preset

    Parameter(s):
        _buildType - build type (label button pressed in the build menu) [NUMBER, defaults to 1]
        _display - build menu display [DISPLAY, defaults to findDisplay IDD_BUILD_MENU]

    Returns:
        -
*/

params[["_buildType", BUILDTYPE_INFANTRY, [0]], ["_display", findDisplay IDD_BUILD_MENU]];

private _listNboxCtrl = _display displayCtrl IDC_BUILD_LISTBOX;
private _pageLabelTextCtrl = _display displayCtrl IDC_PAGELABEL_TEXT;

lbClear _listNboxCtrl; // Clear lnb

private _build_list = KPLIB_buildList # _buildType; // Select build list
localNamespace setVariable ["KPLIB_Build_type", _buildType]; // Save selected build type

// Select page label text
private _labelText = "";
switch (_buildType) do {
    case 1 : {_labelText = localize "STR_BUILD1"};  // Infantry
    case 2 : {_labelText = localize "STR_BUILD2"};  // Transport
    case 3 : {_labelText = localize "STR_BUILD3"};  // Combat Vehicles
    case 4 : {_labelText = localize "STR_BUILD4"};  // Aerial
    case 5 : {_labelText = localize "STR_BUILD5"};  // Defense
    case 6 : {_labelText = localize "STR_BUILD6"};  // Building
    case 7 : {_labelText = localize "STR_BUILD7"};  // Support
    case 8 : {_labelText = localize "STR_BUILD8"};  // Squad
};

// Set page label text
_pageLabelTextCtrl ctrlSetText _labelText;

private _cfg = configFile >> "cfgVehicles";

{
    // Get prices
    private _supplies = _x # 1;
    private _ammo = _x # 2;
    private _fuel = _x # 3;

    // Update values based on civillian reputation
    private _priceAdd = 0;
    if (KPLIB_civ_rep >= 0) then {
        if (KPLIB_civ_rep >= 10) then {_priceAdd = _priceAdd - 0.05};
        if (KPLIB_civ_rep >= 20) then {_priceAdd = _priceAdd - 0.05};
        if (KPLIB_civ_rep >= 30) then {_priceAdd = _priceAdd - 0.05};
        if (KPLIB_civ_rep >= 40) then {_priceAdd = _priceAdd - 0.05};
        if (KPLIB_civ_rep >= 50) then {_priceAdd = _priceAdd - 0.05};
        if (KPLIB_civ_rep >= 75) then {_priceAdd = _priceAdd - 0.05};
        if (KPLIB_civ_rep >= 100) then {_priceAdd = _priceAdd - 0.05};
    } else {
        if (KPLIB_civ_rep <= -10) then {_priceAdd = _priceAdd + 0.05};
        if (KPLIB_civ_rep <= -20) then {_priceAdd = _priceAdd + 0.05};
        if (KPLIB_civ_rep <= -30) then {_priceAdd = _priceAdd + 0.05};
        if (KPLIB_civ_rep <= -40) then {_priceAdd = _priceAdd + 0.05};
        if (KPLIB_civ_rep <= -50) then {_priceAdd = _priceAdd + 0.05};
        if (KPLIB_civ_rep <= -75) then {_priceAdd = _priceAdd + 0.05};
        if (KPLIB_civ_rep <= -100) then {_priceAdd = _priceAdd + 0.05};
    };

    if (_priceAdd < 0) then {
        if (_supplies > 0) then {_supplies = (_supplies - round(_supplies * abs(_priceAdd))) max 0;};
        if (_ammo > 0) then {_ammo = (_ammo - round(_ammo * abs(_priceAdd))) max 0;};
        if (_fuel > 0) then {_fuel = (_fuel - round(_fuel * abs(_priceAdd))) max 0;};
    } else {
        if (_supplies > 0) then {_supplies = _supplies + round(_supplies * _priceAdd);};
        if (_ammo > 0) then {_ammo = _ammo + round(_ammo * _priceAdd);};
        if (_fuel > 0) then {_fuel = _fuel + round(_fuel * _priceAdd);};  
    };

    if (_buildType != BUILDTYPE_SQUAD) then {
        // Not squad composition

        private _class = (_x select 0);
        private _customName = (_x select 4);

        // Get entry text to show on lnb
        private _entryText = [_class, _buildType] call KPLIB_fnc_build_getEntryText; 

        _listNboxCtrl lnbAddRow [_entryText, format ["%1", _supplies], format ["%1", _ammo], format ["%1", _fuel]];

        // Get icon
        private _icon = getText (_cfg >> _class >> "icon");
        if(isText (configFile >> "CfgVehicleIcons" >> _icon)) then {
            _icon = (getText (configFile >> "CfgVehicleIcons" >> _icon));
        };
        _listNboxCtrl lnbSetPicture [[((lnbSize _listNboxCtrl) select 0) - 1, 0], _icon];
    } else {
        // Squad composition
        private _squadName = "";    
        if (((lnbSize  _listNboxCtrl) select 0) <= count KPLIB_b_squadNames) then {
            _squadName = KPLIB_b_squadNames select ((lnbSize  _listNboxCtrl) select 0);
        };
        _listNboxCtrl lnbAddRow  [_squadName, format ["%1", _supplies], format ["%1", _ammo], format ["%1", _fuel]];
    };

    [_x, _listNBoxCtrl] call KPLIB_fnc_build_updateAffordableItems;
}forEach _build_list;

if (lnbCurSelRow _listNboxCtrl == -1) then {
    _listNboxCtrl lnbSetCurSelRow 0;
};

[_listNboxCtrl, _build_list] call KPLIB_fnc_build_MenuPFH;