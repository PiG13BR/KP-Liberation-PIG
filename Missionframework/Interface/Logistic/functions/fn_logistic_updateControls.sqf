#include "..\defines.hpp"
/*
    File: fn_logistic_updateControls.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 01/08/2026
    Last Update: 30/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Update controls from the logistic menu

    Parameter(s):
        _display - virtual logistic menu display [DISPLAY, defaults to findDisplay IDD_LOGISTIC_MENU]
        _lbCurSel - selected group from the group listbox [NUMBER, defaults to -1]
        
    Returns:
        -
*/
params[["_display", findDisplay IDD_LOGISTIC_MENU], ["_lbCurSel", -1, [0]]];

// Disable controls
[_display] call KPLIB_fnc_logistic_disableControls;

private _logi_count = (count KPLIB_logistics);

// Controls
private _listBoxCtrl = _display displayCtrl IDC_LOGISTIC_LISTBOX;
private _logiNameCtrl = _display displayCtrl IDC_LOGISTIC_NAME_TEXT;
private _A_ComboCtrl = _display displayCtrl IDC_A_COMBO;
private _B_ComboCtrl = _display displayCtrl IDC_B_COMBO;
private _A_Supply_EditCtrl = _display displayCtrl IDC_A_SUPPLY_EDIT;
private _A_Ammo_EditCtrl = _display displayCtrl IDC_A_AMMO_EDIT;
private _A_Fuel_EditCtrl = _display displayCtrl IDC_A_FUEL_EDIT;
private _B_Supply_EditCtrl = _display displayCtrl IDC_B_SUPPLY_EDIT;
private _B_Ammo_EditCtrl = _display displayCtrl IDC_B_AMMO_EDIT;
private _B_Fuel_EditCtrl = _display displayCtrl IDC_B_FUEL_EDIT;

private _mapControl = _display displayCtrl IDC_MAP;

if (_lbCurSel == -1) then {
    _lbCurSel = (lbCurSel _listBoxCtrl);
};

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

if ((_lbCurSel != -1) && (_logi_count > 0)) then {
    switch (_status) do {
        case LOGI_STATUS_STANDBY: {
            "start_marker" setMarkerPosLocal _logiPos;
            "start_marker" setMarkerColorLocal "ColorGreen";
            "destination_marker" setMarkerPosLocal markers_reset;
            _mapControl ctrlMapAnimAdd [0.5, 0.2, _logiPos]; 
            ctrlMapAnimCommit _mapControl;
        };
        case LOGI_STATUS_AT_A_LOADING: {
            "start_marker" setMarkerPosLocal _posDestA;
            "start_marker" setMarkerColorLocal "ColorOrange";
            "destination_marker" setMarkerPosLocal markers_reset;
            _mapControl ctrlMapAnimAdd [0.5, 0.2, _posDestA]; 
            ctrlMapAnimCommit _mapControl;
        };
        case LOGI_STATUS_AT_A_UNLOADING: {
            "start_marker" setMarkerPosLocal _posDestA;
            "start_marker" setMarkerColorLocal "ColorOrange";
            "destination_marker" setMarkerPosLocal markers_reset;
            _mapControl ctrlMapAnimAdd [0.5, 0.2, _posDestA]; 
            ctrlMapAnimCommit _mapControl;
        };
        case LOGI_STATUS_TO_B: {
            ctrlMapAnimClear _mapControl;
            "start_marker" setMarkerPosLocal _posDestA;
            "start_marker" setMarkerColorLocal "ColorGreen";
            "destination_marker" setMarkerPosLocal _posDestB;
            "destination_marker" setMarkerColorLocal "ColorOrange";
        };
        case LOGI_STATUS_AT_B_LOADING: {

            "start_marker" setMarkerPosLocal _posDestB;
            "start_marker" setMarkerColorLocal "ColorOrange";
            "destination_marker" setMarkerPosLocal markers_reset;
            _mapControl ctrlMapAnimAdd [0.5, 0.2, _posDestB]; 
            ctrlMapAnimCommit _mapControl;
        };
        case LOGI_STATUS_AT_B_UNLOADING: {
            "start_marker" setMarkerPosLocal _posDestB;
            "start_marker" setMarkerColorLocal "ColorOrange";
            "destination_marker" setMarkerPosLocal markers_reset;
            _mapControl ctrlMapAnimAdd [0.5, 0.2, _posDestB]; 
            ctrlMapAnimCommit _mapControl;
        };
        case LOGI_STATUS_TO_A: {
            ctrlMapAnimClear _mapControl;
            "start_marker" setMarkerPosLocal _posDestB;
            "start_marker" setMarkerColorLocal "ColorGreen";
            "destination_marker" setMarkerPosLocal _posDestA;
            "destination_marker" setMarkerColorLocal "ColorOrange";
        };
        case LOGI_STATUS_ABORTING_TO_A: {
            ctrlMapAnimClear _mapControl;
            "start_marker" setMarkerPosLocal _posDestB;
            "start_marker" setMarkerColorLocal "ColorGreen";
            "destination_marker" setMarkerPosLocal _posDestA;
            "destination_marker" setMarkerColorLocal "ColorRed";
        };
        case LOGI_STATUS_ABORTING_TO_B: {
            ctrlMapAnimClear _mapControl;
            "start_marker" setMarkerPosLocal _posDestA;
            "start_marker" setMarkerColorLocal "ColorGreen";
            "destination_marker" setMarkerPosLocal _posDestB;
            "destination_marker" setMarkerColorLocal "ColorRed";
        };
        case LOGI_STATUS_AMBUSHED: {
            ctrlMapAnimClear _mapControl;
            "start_marker" setMarkerPosLocal markers_reset;
            "destination_marker" setMarkerPosLocal markers_reset;
        };
        default {
            "start_marker" setMarkerPosLocal markers_reset;
            "destination_marker" setMarkerPosLocal markers_reset;
        };
    };
};

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
    private _storagePos = (_y # 2) # 0;

    private _storage = nearestObject [_storagePos, KPLIB_b_smallStorage];
    private _resources = _storage getVariable ["KPLIB_storageResources", [0,0,0]];

    private _supply = _resources # 0;
    private _ammo = _resources # 1;
    private _fuel = _resources # 2;

    _logi_destinations pushBack [_sectorName, (markerPos _sector), _supply, _ammo, _fuel];
} forEach KPLIB_production;

_logi_destinations sort true;
localNamespace setVariable ["KPLIB_logistic_destinations", _logi_destinations];

if ((_lbCurSel != -1) && (_logi_count > 0)) then {

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
        "_specialFlag"
    ];

    _logiNameCtrl ctrlSetText _logiID;

    // Fill A and B combo boxes
    lbClear _A_ComboCtrl;
    lbClear _B_ComboCtrl;
    if (_logi_destinations isNotEqualTo []) then {
        {
            _x params ["_destName", "", "_supply", "_ammo", "_fuel"];
            _A_ComboCtrl lbAdd (format ["%1 (%2/%3/%4)",_destName, _supply, _ammo, _fuel]);
            _B_ComboCtrl lbAdd (format ["%1 (%2/%3/%4)",_destName, _supply, _ammo, _fuel]);
        } forEach _logi_destinations;
    };

    _transResourcesA params ["_supplyCount", "_ammoCount", "_fuelCount"];
    _A_Supply_EditCtrl ctrlSetText (str _supplyCount);
    _A_Ammo_EditCtrl ctrlSetText (str _ammoCount);
    _A_Fuel_EditCtrl ctrlSetText (str _fuelCount);

    _transResourcesB params ["_supplyCount", "_ammoCount", "_fuelCount"];
    _B_Supply_EditCtrl ctrlSetText (str _supplyCount);
    _B_Ammo_EditCtrl ctrlSetText (str _ammoCount);
    _B_Fuel_EditCtrl ctrlSetText (str _fuelCount);

    [_display] call KPLIB_fnc_logistic_drawArrow;
} else {
    // Hide controls
    {ctrlShow [_x, false]} forEach DETAIL_CONTROLS;
    [_display, true] call KPLIB_fnc_logistic_drawArrow;
};