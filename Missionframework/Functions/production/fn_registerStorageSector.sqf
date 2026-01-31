/*
    File: fn_registerStorageSector.sqf
    Author: PiG13BR - https://github.com/KillahPotatoes
    Date: 20/11/2025
    Last Update: 22/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Register sector/factory storage to the production chain.

    Parameter(s):
        _storage - storage to register [OBJECT, defaults to objNull]

    Returns:
        [BOOL]
*/

params[["_storage", objNull, [objNull]]];

if (isNull _storage) exitWith {};

_storage setVariable ["KPLIB_factoryStorage", true, true];

[{
    params["_storage"];

    // Get factory sector
    private _sector = [200, getPosATL _storage] call KPLIB_fnc_getNearestSector;

    KPLIB_sector_storage set [_sector, _storage];
    publicVariable "KPLIB_sector_storage";

    _storage enableRopeAttach false; // Disable rope attach

    _storage setVariable ["KPLIB_storageSector", _sector, true];

    // Insert storage parameters
    private _production = KPLIB_production get _sector;
    _production set [2, [(getPosATL _storage), (getDir _storage), (vectorUpVisual _storage)]];
    publicVariable "KPLIB_production";

    _storage remoteExecCall ["KPLIB_fnc_addActionsStorage"];

    [format["Storage builded in %1. Storage Object: %2", markerText _sector, _storage], "BUILD"] call KPLIB_fnc_log;

}, [_storage], 1] call CBA_fnc_waitAndExecute;

