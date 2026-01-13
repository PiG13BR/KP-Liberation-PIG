/*
    File: fn_doRecycle.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 22/11/2025
    Last Update: 23/11/2025
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
    private _crateSum = (ceil (_price_s / 100)) + (ceil (_price_a / 100)) + (ceil (_price_f / 100));
    private _spaceSum = 0;

    {
        if (typeOf _x == KPLIB_b_largeStorage) then {
            _spaceSum = _spaceSum + (count KPLIB_large_storage_positions) - (count (attachedObjects _x));
        };
        if (typeOf _x == KPLIB_b_smallStorage) then {
            _spaceSum = _spaceSum + (count KPLIB_small_storage_positions) - (count (attachedObjects _x));
        };
    } forEach _storage_areas;

    if (_spaceSum < _crateSum) then {
        [localize "STR_CANCEL_ERROR", true, 2] call KPLIB_fnc_hint;
    } else {
        ["KPLIB_recycleResources", [_vehToRecycle, _price_s, _price_a, _price_f, _storage_areas]] call CBA_fnc_serverEvent;
    };
};
