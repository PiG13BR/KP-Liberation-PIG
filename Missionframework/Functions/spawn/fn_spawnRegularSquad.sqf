/*
    File: fn_spawnRegularSquad.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 03/12/2019
    Last Update: 29/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns a regular enemy squad with given soldier classnames at given sector.

    Parameter(s):
        _sector     - Sector to spawn the squad at          [STRING, defaults to ""]
        _classnames - Classnames of units to spawn in squad [ARRAY, defaults to []]

    Returns:
        Created squad [GROUP]
*/

params [
    ["_sector", "", [""]],
    ["_classnames", [], [[]]]
];

if (_sector isEqualTo "") exitWith {["Empty string given"] call BIS_fnc_error; grpNull};

// Get spawn position for squad
private _spawnPos = [];
if (_sector in KPLIB_sectors_airport) then {
    _spawnPos = [[_sector], [], {true}] call BIS_fnc_randomPos;
} else {
    private _sectorPos = (markerPos _sector) getPos [random 100, random 360];
    private _i = 0;
    while {_spawnPos isEqualTo []} do {
        _i = _i + 1;
        _spawnPos = (_sectorPos getPos [random 50, random 360]) findEmptyPosition [5, 100, "B_Heli_Light_01_F"];
        if (_i isEqualTo 10) exitWith {_spawnPos = (_sectorPos getPos [random 50, random 360]) findEmptyPosition [0, 100, "B_Heli_Light_01_F"];};
    };
};

if (_spawnPos isEqualTo []) exitWith {
    ["No suitable spawn position found."] call BIS_fnc_error;
    [format ["Couldn't find infantry spawn position for sector %1", _sector], "WARNING"] call KPLIB_fnc_log;
    grpNull
};

// Spawn units of squad
private _corrected_amount = round ((count _classnames) * ([] call KPLIB_fnc_getOpforFactor));
private _grp = createGroup [KPLIB_side_enemy, true];
{
    if (_forEachIndex < _corrected_amount) then {
        [_x, _spawnPos, _grp, "PRIVATE", 10] call KPLIB_fnc_createManagedUnit;
    };
} forEach _classnames;

// Add group unit killed to call support
_grp addEventHandler ["UnitKilled", {
    params ["_group", "_unit", "_killer"];
    ["KPLIB_onUnitKilled", [_group, _unit, _killer]] call CBA_fnc_localEvent;
}];

// HC
["KPLIB_sendGroupToHC", _grp] call CBA_fnc_serverEvent;

_grp
