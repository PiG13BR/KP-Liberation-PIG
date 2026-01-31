/*
    File: fn_addActionsStorage.sqf
    Author: PiG13BR - https://github.com/KillahPotatoes
    Date: 21/11/2025
    Last Update: 28/01/2026
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
        {(([_target] call KPLIB_fnc_getStorageValues) # 0) > 0} &&
        {isNull (_this getVariable ["KPLIB_carriedObject", objNull])}
    },
    10
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
        {(([_target] call KPLIB_fnc_getStorageValues) # 1) > 0} &&
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
        {(([_target] call KPLIB_fnc_getStorageValues) # 2) > 0} &&
        {isNull (_this getVariable ["KPLIB_carriedObject", objNull])}
    },
    12
];

_storage addAction [
    "<t color='#FFFF00'>" + localize "STR_ACTION_CHECK_RESOURCES" + "</t>",
    {
        params["_storage", "_player"];
        ([_storage] call KPLIB_fnc_getStorageValues) params ["_supply", "_ammo", "_fuel"];

        [(parseText (format[["<t size='1.3'>", "SUPPLY", "</t><br/>%1<br/><br/><t size='1.3'>", "AMMO", "</t><br/>%2<br/><br/><t size='1.3'>", "FUEL", "</t><br/>%3"] joinString "", _supply, _ammo, _fuel])), true, 4] call KPLIB_fnc_hint;
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
        {isNull (_this getVariable ["KPLIB_carriedObject", objNull])}
    },
    12
];

true