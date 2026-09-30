#include "..\defines.hpp"
/*
    File: fn_logistic_loadMenu.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 31/07/2026
    Last Update: 30/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Load the virtual logistic menu

    Parameter(s):
        _display - virtual logistic menu display [DISPLAY, defaults to findDisplay IDD_LOGISTIC_MENU]

    Returns:
        -
*/

params[["_display", findDisplay IDD_LOGISTIC_MENU]];

disableSerialization;

uiNamespace setVariable ["KPLIB_logistic_display", _display];

// Controls
private _mapControl = _display displayCtrl IDC_MAP;
private _logisticListBox = _display displayCtrl IDC_LOGISTIC_LISTBOX;
private _createGroupCtrl = _display displayCtrl IDC_CREATE_GROUP_BUTTON;

ctrlMapAnimClear _mapControl;

private _nearfob = [] call KPLIB_fnc_getNearestFob;
localNamespace setVariable ["KPLIB_logistic_nearFob", _nearFob];
_createGroupCtrl ctrlEnable true;

// Get possible destinations
private _logi_destinations = [];
{
    _x params ["_pos", "_supply", "_ammo", "_fuel"];
    if (_pos isEqualTo [0,0,0]) then {continue};
    if (_pos in KPLIB_player_outposts) then {continue}; // Skip outposts
    
    _logi_destinations pushBack [
        (format ["FOB %1", KPLIB_fobNames # _forEachIndex]), _pos, _supply, _ammo, _fuel];
} forEach KPLIB_base_resources;

{
    private _sector = _x;
    private _sectorName = (_y # 0);
    private _supply = (_y # 8);
    private _ammo = (_y # 9);
    private _fuel = (_y # 10);

    _logi_destinations pushBack [_sectorName, (markerPos _sector), _supply, _ammo, _fuel];
} forEach KPLIB_production;

_logi_destinations sort true;
localNamespace setVariable ["KPLIB_logistic_destinations", _logi_destinations];

// Add existing logistics to listbox
private _logi_count = 0;
if (_logi_count != (count KPLIB_logistics)) then {
    _logi_count = (count KPLIB_logistics);
    lbClear _logisticListBox;
    {
        private _logiID = _x;
        _logisticListBox lbAdd _logiID;
        _logisticListBox lbSetData [_forEachIndex, _logiID]; // Save key as data
    } forEach KPLIB_logistics;

    lbSort _logisticListBox;
};

[_display] call KPLIB_fnc_logistic_disableControls;

// Select element from listbox
if ((_logi_count > 0) && (lbCurSel _logisticListBox == -1)) then {
    _logisticListBox lbSetCurSel 0;
};

createMarkerLocal ["start_marker", markers_reset];
"start_marker" setMarkerColorLocal "ColorGreen";
"start_marker" setMarkerTypeLocal "Select";

createMarkerLocal ["destination_marker", markers_reset];
"destination_marker" setMarkerColorLocal "ColorOrange";
"destination_marker" setMarkerTypeLocal "selector_selectedMission";

// Disable user actions
inGameUISetEventHandler ["PrevAction", "true"];
inGameUISetEventHandler ["NextAction", "true"];
inGameUISetEventHandler ["Action", "true"];