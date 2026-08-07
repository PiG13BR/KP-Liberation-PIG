/*
    File: fn_getAllStorages.sqf
    Author: Author: PiG13BR (https://github.com/PiG13BR)
    Date: 31/07/2026
    Last Update: 03/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Get all storages in an area

    Parameter(s):
        _centerPos - position to get all storages in the area [POSITION, defaults to player's position]

    Returns:
        Storages objects in the area [ARRAY]
*/
params[["_centerPos", getPosATL player, [[]], [2,3]]];

if (_centerPos isEqualTo [0,0,0]) exitWith {["Invalid position"] call BIS_fnc_error};

private _inAirport = (KPLIB_sectors_airport findIf {_centerPos inArea _x});

// Get storage areas
private _storages = if (_inAirport >= 0) then {
    private _airportArea = KPLIB_sectors_airport # _inAirport;
    (vehicles inAreaArray _airportArea) select {((_x getVariable ["KPLIB_fobStorage", false]) || (_x getVariable ["KPLIB_factoryStorage", false])) && {((getPosATL _x) # 2) < 1}};
} else {
    (_centerPos nearobjects (KPLIB_range_fob * 2)) select {((_x getVariable ["KPLIB_fobStorage", false]) || (_x getVariable ["KPLIB_factoryStorage", false])) && {((getPosATL _x) # 2) < 1}};
};

_storages