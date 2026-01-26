#include "..\defines.hpp"
/*
    File: fn_buildItem.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 11/11/2025
    Last update: 26/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Build selected item

    Parameter(s)
        _buildType - build type selected in the build menu [NUMBER, defaults to 1]
        _itemToBuild - item to build with its resources cost [ARRAY, defaults to []]
        _manned - spawn crew [BOOL, defaults to false]

    Returns:
        -
*/
params[["_buildType", BUILDTYPE_INFANTRY, [0]], ["_itemToBuild", [], [[]]], ["_manned", false, [false]]];

private _itemClass = "";
private _fobPos = [] call KPLIB_fnc_getNearestFob; // Get fob position before server event
if (_itemToBuild isNotEqualTo []) then {
    _itemClass = _itemToBuild # 0; // Get class

    // Substract resources from storages
    ["KPLIB_subtractResources", [_itemToBuild, _buildType, _fobPos]] call CBA_fnc_serverEvent;
};

localNamespace setVariable ["KPLIB_BUILD_itemToBuild", _itemToBuild]; // Save building array
localNamespace setVariable ["KPLIB_BUILD_buildType", _buildType]; // Save build type number
localNamespace setVariable ["KPLIB_BUILD_requireCrew", _manned]; // Save manned bool

switch _buildType do {
    case BUILDTYPE_INFANTRY : {
        [_itemClass] call KPLIB_fnc_buildInfantry;
    };
    case BUILDTYPE_SQUAD : {
        [_itemClass] call KPLIB_fnc_buildSquad;
    };
    case BUILDTYPE_FOB : {
        private _itemClass = KPLIB_b_fobBuilding;
        [_itemClass] call KPLIB_fnc_spawnPreplaceObject;
    };
    case BUILDTYPE_FACTORY_STORAGE : {
        private _itemClass = KPLIB_b_smallStorage;
        [_itemClass] call KPLIB_fnc_spawnPreplaceObject;
    };
    default {[_itemClass] call KPLIB_fnc_spawnPreplaceObject}; 
};