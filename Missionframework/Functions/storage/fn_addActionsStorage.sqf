/*
    File: fn_addActionsStorage.sqf
    Author: PiG13BR - https://github.com/KillahPotatoes
    Date: 21/11/2025
    Last Update: 28/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Add actions to a storage object.

    Parameter(s):
        _storage - storage to add actions [OBJECT, defaults to objNull]

    Returns:
        [BOOL]
*/

params[["_storage", objNull, [objNull]]];

if (isNull _storage) exitWith {false};

_storage addAction [
    "<t color='#FFFF00'>" + localize "STR_ACTION_UNSTORE_SUPPLY" + "</t>",
    {
        [KPLIB_b_crateSupply, (_this # 0), (_this # 1), true] call KPLIB_fnc_crateFromStorage;
    },
    "",
    -504,
    true,
    true,
    "",
    toString {
        !(_this getVariable ['KPLIB_BUILD_isBuilding', false]) && 
        {[5] call KPLIB_fnc_hasPermission} &&
        {isNull objectParent _this} &&
        {(attachedObjects _target) findIf {typeOf _x == KPLIB_b_crateSupply} >= 0} &&
        {isNull (_this getVariable ["KPLIB_carriedObject", objNull])}
    },
    11
];

_storage addAction [
    "<t color='#FFFF00'>" + localize "STR_ACTION_UNSTORE_AMMO" + "</t>",
    {
        [KPLIB_b_crateAmmo, (_this # 0), (_this # 1), true] call KPLIB_fnc_crateFromStorage;
    },
    "",
    -505,
    true,
    true,
    "",
        toString {
        !(_this getVariable ['KPLIB_BUILD_isBuilding', false]) && 
        {[5] call KPLIB_fnc_hasPermission} &&
        {isNull objectParent _this} &&
        {(attachedObjects _target) findIf {typeOf _x == KPLIB_b_crateAmmo} >= 0} &&
        {isNull (_this getVariable ["KPLIB_carriedObject", objNull])}
    },
    11
];

_storage addAction [
    "<t color='#FFFF00'>" + localize "STR_ACTION_UNSTORE_FUEL" + "</t>",
    {
        [KPLIB_b_crateFuel, (_this # 0), (_this # 1), true] call KPLIB_fnc_crateFromStorage;
    },
    "",
    -506,
    true,
    true,
    "",
    toString {
        !(_this getVariable ['KPLIB_BUILD_isBuilding', false]) && 
        {[5] call KPLIB_fnc_hasPermission} &&
        {isNull objectParent _this} &&
        {(attachedObjects _target) findIf {typeOf _x == KPLIB_b_crateFuel} >= 0} &&
        {isNull (_this getVariable ["KPLIB_carriedObject", objNull])}
    },
    11
];

_storage addAction [
    "<t color='#FFFF00'>" + localize "STR_ACTION_SORT_STORAGE" + "</t>",
    {
        [(_this # 0)] call KPLIB_fnc_sortStorage;
    },
    "",
    -507,
    true,
    true,
    "",
    toString {
        !(_this getVariable ['KPLIB_BUILD_isBuilding', false]) && 
        {[5] call KPLIB_fnc_hasPermission} &&
        {isNull objectParent _this} &&
        {(attachedObjects _target) isNotEqualTo []} &&
        {isNull (_this getVariable ["KPLIB_carriedObject", objNull])}
    },
    11
];

true