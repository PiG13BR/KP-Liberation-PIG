/*
    File: fn_crateFromStorage.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 2017-03-27
    Last Update: 2026-02-01
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Unloads given crate type from storage area.

    Parameter(s):
        _cratetype  - Crate type                [STRING, defaults to ""]
        _storage    - Storage                   [OBJECT, defaults to objNull]
        _player     - player                    [OBJECT, defaults to player]
        _update     - Update sector resources   [BOOL, defaults to false]

    Returns:
        Function reached the end [BOOL]
*/

params [
    ["_cratetype", "", [""]],
    ["_storage", objNull, [objNull]],
    ["_player", player, [objNull]],
    ["_update", false, [false]]
];

#define SUPPLY_INDEX 0
#define AMMO_INDEX 1
#define FUEL_INDEX 2

// Validate parameters
if !((toLowerANSI _cratetype) in KPLIB_crates) exitWith {["Invalid craty type given: %1", _cratetype] call BIS_fnc_error; false};
if (isNull _storage) exitWith {["Null object given"] call BIS_fnc_error; false};

private _resources = [_storage] call KPLIB_fnc_getStorageValues;

private _index = -1;
switch _cratetype do {
    case KPLIB_b_crateSupply : {
        _index = SUPPLY_INDEX;
    };
    case KPLIB_b_crateAmmo : {
        _index = AMMO_INDEX;
    };
    case KPLIB_b_crateFuel : {
        _index = FUEL_INDEX;
    };
    default {}
};

private _resourceValue = _resources # _index;
if (_resourceValue < 1) exitWith {}; // NO RESOURCE FOR THIS TYPE

private _valueToCrate = _resourceValue min 100;
_resources set [_index, (_resources # _index) - _valueToCrate];

private _crate = [_cratetype, _valueToCrate] call KPLIB_fnc_createCrate;

// Update sector resources
if (_update) then {
    if (_storage getVariable ["KPLIB_factoryStorage", false]) then {
        private _sector = _storage getVariable ["KPLIB_storageSector", ""];
        [_sector] call KPLIB_fnc_updateProductionValues;
    };
};

// Carry
_crate attachTo [_player, [0, 2, 1]];
["KPLIB_crateCollisionChange", [_crate, false]] call CBA_fnc_globalEventJIP;
_crate setVariable ["KPLIB_beignCarried", true, true];
_player setVariable ["KPLIB_carriedObject", _crate];

// Drop crate action
_player addAction [
    ["<t color='#FFFF00'>", localize "STR_ACTION_CRATE_DROP", "</t>"] joinString "",
    {
        params ["_player", "_caller", "_actionId", "_arguments"];
        private _crate = _player getVariable ["KPLIB_carriedObject", objNull];

        // prevent players from putting crates inside vehicles
        private _crateSize = sizeOf typeOf _crate * 1.5;
        private _nearObjects = (_crate nearEntities [["CAManBase", "Air", "Car", "Tank"], _crateSize]) - [_crate, _player];
        if (_nearObjects isNotEqualTo []) exitWith {
            [format [localize "STR_PLACEMENT_IMPOSSIBLE", count _nearObjects, _crateSize toFixed 0], true, 3] call KPLIB_fnc_hint
        };

        _player setVariable ["KPLIB_carriedObject", nil];
        _crate setVariable ["KPLIB_beignCarried", false, true];
        ["KPLIB_crateCollisionChange", [_crate, true]] call CBA_fnc_globalEventJIP;
        detach _crate;
        _crate awake true;
        _crate enableRopeAttach true;
        _player removeAction _actionId; // Remove action from player
    },
    nil,
    -504,
    true,
    false,
    "",
    toString {
        alive _originalTarget &&
        {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])} && {isNull (objectParent _originalTarget)} && {!isNull (_originalTarget getVariable ["KPLIB_carriedObject", objNull])}
    }
];

_storage setVariable ["KPLIB_storageResources", _resources, true];

// Remove mass to a transportable storage
if (typeOf _storage == KPLIB_b_transStorage) then {
    private _oldMass = getMass _storage;
    private _newMass = _oldMass - (_crate getVariable ["KPLIB_crateValue", 0]);
    _storage setMass _newMass;
};

true
