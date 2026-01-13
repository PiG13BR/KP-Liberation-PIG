#include "..\defines.hpp"
/*
    File: fn_build_updateBuildCtrl.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 10/11/2025
    Last Update: 03/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Update build button controls for the selected build item

    Parameter(s):
        _lnbControl - listNbox control where the build items are visible [CONTROL]

    Returns:
        -
*/

params["_lnbControl"];

// Controls
private _display = (ctrlParent _lnbControl); 
private _linkedSectorTextCtrl = _display displayCtrl IDC_LINKEDSECTOR_TEXT;
private _buildButtonCtrl = _display displayCtrl IDC_BUILD_BUTTON;
private _crewButtonCtrl = _display displayCtrl IDC_CREW_BUTTON;

// Get element
private _lbCurSel = lnbCurSelRow _lnbControl;
if (_lbCurSel == -1) exitWith {}; // Failsafe
private _buildType = (localNamespace getVariable ["KPLIB_Build_type", 1]); // Get build type selected (label)
private _buildList = KPLIB_buildList # _buildType; // Get actual list
if (count _buildList < _lbCurSel) then {_lbCurSel = 0};
private _selectedBuild = _buildList # _lbCurSel; // Get actual selected element
private _buildClass = _selectedBuild # 0; // Get Class

// Check affordable
private _affordable = [_selectedBuild] call KPLIB_fnc_build_isItemAffordable;

// Check player's squad size
private _squad_full = false;
if ((_buildType == BUILDTYPE_INFANTRY) && (count (units (group player)) >= KPLIB_param_maxSquadSize)) then {
    _squad_full = true;
};

// Check if there are barracks to buy IA/Squads
private _barracksNearby = true;
if (_buildType == BUILDTYPE_INFANTRY || _buildType == BUILDTYPE_SQUAD) then {
    private _nearestFob = player getVariable ["KPLIB_fobPos", []];
    _barracksNearby = if (count (_nearestFob nearObjects [KPLIB_b_barrack, KPLIB_range_fob]) > 1) then {true} else {false};
};

if (!_barracksNearby) then {
    _affordable = false;
    _linkedSectorTextCtrl ctrlSetStructuredText parseText ("<t color='#e00000' align='center'>" + localize "STR_INF_BARRACKS_REQUIRED"  +  "<br/>" + "2" + "</t>");
}; 

// Check linked item
private _linked = false;
private _linked_unlocked = true;
private _link_color = "#0040e0"; // Unlocked default color
private _link_str = localize "STR_VEHICLE_UNLOCKED"; // Unlocked default text
private _base_link = "";
if (_buildType != BUILDTYPE_SQUAD) then {

    // Get base link
    _base_link = [_buildClass] call KPLIB_fnc_build_isItemLinked;

    // Check if returned a linked base
    if (_base_link isNotEqualTo "") then {_linked = true}; 

    // Check is unlocked
    if (_linked) then {
        if (!(_base_link in KPLIB_sectors_player)) then {_linked_unlocked = false};
    };
};

if (!_linked_unlocked) then {
    // Item Locked
    _link_color = "#e00000"; // Locked color
    _link_str = localize "STR_VEHICLE_LOCKED"; // Locked text
};

if (_linked) then {
    // Add linked sector text
    _linkedSectorTextCtrl ctrlSetStructuredText parseText ("<t color='" + _link_color + "' align='center'>" + _link_str +  "<br/>" + ( markerText _base_link ) + "</t>");
} else {
    if (_barracksNearby) then {_linkedSectorTextCtrl ctrlSetStructuredText parseText "";};
};

// Check affordable crew
private _affordable_crew = _affordable;
if (unitcap >= ([] call KPLIB_fnc_getLocalCap)) then {
    _affordable_crew = false;
    if ((_buildtype == BUILDTYPE_INFANTRY) || {_buildType == BUILDTYPE_SQUAD}) then {
        _affordable = false;
    };
};

// Disable/Enable ctrl build buttons by checking generated bools
_buildButtonCtrl ctrlEnable (_affordable && _linked_unlocked && !(_squad_full));
_crewButtonCtrl ctrlEnable (_affordable_crew && _linked_unlocked);