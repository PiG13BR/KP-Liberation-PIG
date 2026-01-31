#include "..\defines.hpp"
/*
    File: fn_production_loadMenu.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 10/11/2025
    Last Update: 12/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Load the production menu

    Parameter(s):
        _display - production menu display [DISPLAY, defaults to findDisplay IDD_PRODUCTION_MENU]

    Returns:
        -
*/

params[["_display", findDisplay IDD_PRODUCTION_MENU]];

// Controls
private _mapControl = _display displayCtrl IDC_MAP;
private _prodLbControl = _display displayCtrl IDC_PRODUCTION_LISTBOX;
private _productionBoostCtrl = _display displayCtrl IDC_PRODUCTION_BOOST_TEXT;

lbClear _prodLbControl;
{
    _prodLbControl lbAdd (_y # 0); // Add marker text
    _prodLbControl lbSetData [_forEachIndex, _x]; // Save key as data
} forEach KPLIB_production;

ctrlMapAnimClear _mapControl;

if (lbCurSel _prodLbControl == -1) then {
    _prodLbControl lbSetCurSel 0;
};

private _listcolor = [0.6,0.6,0.6,0.8];
{
    private _storageArray = _y # 2;
    private _typeOfResource = _y # 6;
    if ((count _storageArray) > 0) then {
        switch _typeOfResource do {
            case 1: {_listcolor = [0.75,0,0,1];}; // Supply
            case 2: {_listcolor = [0.75,0.75,0,1];}; // Ammo
            case 3: {_listcolor = [1,1,1,1];};  // Fuel
            default {_listcolor = [0,0.75,0,1];};   // None
        };
    };

    _prodLbControl lbSetColor [_forEachIndex, _listcolor];
} forEach KPLIB_production;

_productionBoostCtrl ctrlSetText (format [localize "STR_PRODUCTION_BOOST", round (30 + (10 * KPLIB_param_difficulty))]);