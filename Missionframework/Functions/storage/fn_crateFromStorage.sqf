/*
    File: fn_crateFromStorage.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2017-03-27
    Last Update: 2026-01-11
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

// Validate parameters
if !((toLowerANSI _cratetype) in KPLIB_crates) exitWith {["Invalid craty type given: %1", _cratetype] call BIS_fnc_error; false};
if (isNull _storage) exitWith {["Null object given"] call BIS_fnc_error; false};

// Get correct storage positions
([_storage] call KPLIB_fnc_getStoragePositions) params ["_storagePositions", "_unloadDist"];

// Check for next empty unload position
private _i = 0;
private _dir = (getDir _storage) - 180;
private _unloadPos = _storage getPos [_unloadDist, _dir];
while {!((nearestObjects [_unloadPos, KPLIB_crates, 1]) isEqualTo [])} do {
    _i = _i + 1;
    _unloadPos = _storage getPos [_unloadDist + _i * 1.8, _dir];
};

// Fetch all stored crates
private _storedCrates = attachedObjects _storage;
reverse _storedCrates;
private _crate = _storedCrates deleteAt (_storedCrates findIf {(typeOf _x) == _crateType});

// Exit if desired crate isn't stored
if (isNil "_crate") exitWith {false};

// Unload crate
//detach _crate;
[_crate, true] call KPLIB_fnc_clearCargo;
//_crate setPos _unloadPos;
//[_crate, true] remoteExec ["enableRopeAttach"];
_crate lockInventory true;

// Fill the possible gap in the storage area
reverse _storedCrates;
_i = 0;
{
    detach (_x select 0);
    (_x select 0) attachTo [_storage, [(_storagePositions select _i) select 0, (_storagePositions select _i) select 1, _x select 1]];
    _i = _i + 1;
} forEach (_storedCrates apply {[_x, [typeOf _x] call KPLIB_fnc_getCrateHeight]});

// Update sector resources
if (_update) then {
    if (_storage getVariable ["KPLIB_factoryStorage", false]) then {
        private _sector = _storage getVariable ["KPLIB_storageSector", ""];
        [_sector] call KPLIB_fnc_updateProductionValues;
    };
};

// Add actions back to the crate
[{["KPLIB_addActionsCrate", _this] call CBA_fnc_globalEventJIP;}, _crate , 1] call CBA_fnc_waitAndExecute;


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
        [_crate, true] remoteExec ["enableRopeAttach"];
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

true
