#include "..\defines.hpp"
/*
    File: fn_build_loadMenu.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 10/11/2025
    Last Update: 12/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Load the build menu

    Parameter(s):
        _display - build menu display [DISPLAY, defaults to findDisplay IDD_BUILD_MENU]

    Returns:
        -
*/

params[["_display", findDisplay IDD_BUILD_MENU]];

// Controls
private _squadButtonCtrl = _display displayCtrl IDC_SQUAD_BUTTON;
private _squadImageCtrl = _display displayCtrl IDC_SQUAD_IMAGE;
private _mannedButtonCtrl = _display displayCtrl IDC_MANNED_WEAPON;

private _iscommandant = false;
if (player == [] call KPLIB_fnc_getCommander) then {
    _iscommandant = true;
};

// Show or hide squad composition tab
_squadButtonCtrl ctrlShow _iscommandant;
_squadImageCtrl ctrlShow _iscommandant;
_mannedButtonCtrl ctrlShow _iscommandant;

[BUILDTYPE_INFANTRY, _display] call KPLIB_fnc_build_fillLnb; // Always opens the menu showing the infantry tab