/*
    File: fn_build_updateAffordableItems.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 10/11/2025
    Last Update: 12/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Update lnb list for affordable items. Change row color.

    Parameter(s):
        _itemToCheck - item from the menu to check if is affordable [ARRAY, defaults to []]

    Returns:
       -
*/

params[["_itemToCheck", [], [[]]], "_listNboxCtrl"];

// Check if item is affordable
private _affordable = [_itemToCheck] call KPLIB_fnc_build_isItemAffordable;

// Change controls colors
if (_affordable) then {
    _listNboxCtrl lnbSetColor [[((lnbSize _listNboxCtrl) select 0) - 1, 0], [1,1,1,1]];
    _listNboxCtrl lnbSetColor [[((lnbSize _listNboxCtrl) select 0) - 1, 1], [1,1,1,1]];
    _listNboxCtrl lnbSetColor [[((lnbSize _listNboxCtrl) select 0) - 1, 2], [1,1,1,1]];
    _listNboxCtrl lnbSetColor [[((lnbSize _listNboxCtrl) select 0) - 1, 3], [1,1,1,1]];
} else {
    _listNboxCtrl lnbSetColor [[((lnbSize _listNboxCtrl) select 0) - 1, 0], [0.4,0.4,0.4,1]];
    _listNboxCtrl lnbSetColor [[((lnbSize _listNboxCtrl) select 0) - 1, 1], [0.4,0.4,0.4,1]];
    _listNboxCtrl lnbSetColor [[((lnbSize _listNboxCtrl) select 0) - 1, 2], [0.4,0.4,0.4,1]];
    _listNboxCtrl lnbSetColor [[((lnbSize _listNboxCtrl) select 0) - 1, 3], [0.4,0.4,0.4,1]];
};