/*
    File: fn_crateToStorage.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2017-03-27
    Last Update: 2026-01-26
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Attach given crate at storage area.

    Parameter(s):
        _crate      - Crate                     [OBJECT, defaults to objNull]
        _storage    - Storage                   [OBJECT, defaults to objNull]
        _update     - Update sector resources   [BOOL, defaults to false]

    Returns:
        Function reached the end [BOOL]
*/

params [
    ["_crate", objNull, [objNull]],
    ["_storage", objNull, [objNull]],
    ["_update", false, [false]]
];

// Validate parameters
if (isNull _crate) exitWith {["Null object given"] call BIS_fnc_error; false};

// Handle return values from nearestObjects of function call in ammobox action manager
if (!isNull _storage) then {
    // Get storage and crate specific values
    ([_storage] call KPLIB_fnc_getStoragePositions) params ["_storage_positions", "_unload_distance"];
    private _height = [typeOf _crate] call KPLIB_fnc_getCrateHeight;

    // Remove possible cargo from crate
    [_crate, true] call KPLIB_fnc_clearCargo;

    // Check for enough space in storage
    private _crates_count = count (attachedObjects _storage);
    if (_crates_count >= (count _storage_positions)) exitWith {
        if (!isDedicated) then {
            [localize "STR_BOX_CANTSTORE", true, 2] call KPLIB_fnc_hint;
        };
    };

    // Store crate
    _crate attachTo [_storage, [(_storage_positions select _crates_count) select 0, (_storage_positions select _crates_count) select 1, _height]];
    _crate enableRopeAttach true;

    // Remove all actions
    [{
        time > 65
    }, {
        ["KPLIB_removeAllActionsCrate", _this] call CBA_fnc_globalEventJIP;
    }, _crate] call CBA_fnc_waitUntilAndExecute;
    
    // Update sector resource values, if requested
    if (_update) then {
        if (_storage getVariable ["KPLIB_factoryStorage", false]) then {
            private _sector = _storage getVariable ["KPLIB_storageSector", ""];
            [_sector] call KPLIB_fnc_updateProductionValues;
        };
    };

    _crate enableRopeAttach false;

    _crate setVariable ["KPLIB_crateInStorage", true, true];
} else {
    if (!isDedicated) then {
        [localize "STR_BOX_CANTSTORE", true, 2] call KPLIB_fnc_hint;
    };
};

true