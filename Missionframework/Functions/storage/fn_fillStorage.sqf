/*
    File: fn_fillStorage.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 2019-12-03
    Last Update: 2026-02-01
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Fills given storage with given amounts of resources.

    Parameter(s):
        _supply     - Amount of supply resource                                         [NUMBER, defaults to 0]
        _ammo       - Amount of ammo resource                                           [NUMBER, defaults to 0]
        _fuel       - Amount of fuel resource                                           [NUMBER, defaults to 0]
        _storage    - Storage object to fill                                            [OBJECT, defaults to objNull]

    Returns:
        Function reached the end [BOOL]
*/

params [
    ["_supply", 0, [0]],
    ["_ammo", 0, [0]],
    ["_fuel", 0, [0]],
    ["_storage", objNull, [objNull]]
];

if (isNull _storage) exitWith {["Null object given"] call BIS_fnc_error; false};

_storage setVariable ["KPLIB_storageResources", [_supply, _ammo, _fuel], true];
if (typeOf _storage == KPLIB_b_transStorage) then {
    private _oldMass = getMass _storage;
    private _newMass = _oldMass + _supply + _ammo + _fuel;
    _storage setMass _newMass;
};

true
