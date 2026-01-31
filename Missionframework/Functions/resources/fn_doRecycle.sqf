/*
    File: fn_doRecycle.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 22/11/2025
    Last Update: 28/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Recycle object

    Parameter(s):
        _vehToRecycle - vehicle to recycle [OBJECT]

    Returns:
        -
*/
params ["_vehToRecycle"];

private _gains = localNamespace getVariable ["KPLIB_recycleGain", []];
if (_gains isEqualTo []) exitWith {};

_gains params ["_vehToRecycle", "_price_s", "_price_a", "_price_f"];

if (!(isnull _vehToRecycle) && {alive _vehToRecycle}) then {
    if (!(KPLIB_b_logiStation_near) && ((_price_s + _price_a + _price_f) > 0)) exitWith {
        [localize "STR_NORECBUILDING_ERROR", true, 2] call KPLIB_fnc_hint;
    };

    private _storage_areas = (([] call KPLIB_fnc_getNearestFob) nearobjects (KPLIB_range_fob * 1.2)) select {_x getVariable ["KPLIB_fobStorage", false]};
    private _sum = (_price_s + _price_a + _price_f);

    private _storages = [];
    {
        if ([_x] call KPLIB_fnc_isStorageFull) then {continue}; // Skip iteration

        private _storageLimit = [_x] call KPLIB_fnc_getStorageLimit;
        if (_sum >= _storageLimit) then {continue}; // Skip iteration

        // Pushback storage with space
        _storages pushBack _x;
    } forEach _storage_areas;

    if (_storages isEqualTo []) then {
        [localize "STR_CANCEL_ERROR", true, 2] call KPLIB_fnc_hint;
    } else {
        ["KPLIB_recycleResources", [_vehToRecycle, _price_s, _price_a, _price_f, _storages]] call CBA_fnc_serverEvent;
    };
};
