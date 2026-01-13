/*
    File: fn_spawnInfCargo.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 29/10/2025 
    Last Update: 27/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns infantry in vehicle cargo

    Parameter(s):
        _vehicle - vehicle to load infantry in [OBJECT, defaults to objNull]
        _group - group to add infantry in [GROUP, defaults to grpNull]

    Returns:
        Group loaded in vehicle [GROUP]
*/

params[["_vehicle", objNull, [objNull]], ["_group", grpNull, [grpNull]]];

if (!isServer) exitWith {};
if (isNull _vehicle) exitWith {grpNull};

if (isNull _group) then {
    _group = createGroup [KPLIB_side_enemy, true];
};
private _infClasses = [KPLIB_o_inf_classes, KPLIB_o_militiaInfantry] select (KPLIB_enemyReadiness < 50);

private _emptySeats = ((_vehicle emptyPositions "CargoNoFFV") min 8); // Count empty cargo seats, max 8 seats

// If Air unit, fill more seats
if (_vehicle isKindOf "Air") then {_emptySeats = (_vehicle emptyPositions "CargoNoFFV") min 14;};

if ((typeOf _vehicle) in KPLIB_o_paradropPlanes) then {
    // Paratroopers
    private _paraSquad = ["paratroopers"] call KPLIB_fnc_getSquadComp;

    {
        if (_forEachIndex > _emptySeats) exitWith {};
        [_x, markerPos "ghost_spot", _group, "PRIVATE", 0.5] call KPLIB_fnc_createManagedUnit;
    } foreach _paraSquad;
} else {
    private _squad = [] call KPLIB_fnc_getSquadComp;
    {
        if (_forEachIndex > _emptySeats) exitWith {};
        [_x, markerPos "ghost_spot", _group, "PRIVATE", 0.5] call KPLIB_fnc_createManagedUnit;
    } foreach _squad;
};

[_group] call KPLIB_fnc_LAMBS_enableReinforcements;

{
    //_x assignAsCargo _vehicle;
    _x moveInCargo _vehicle;
} forEach (units _group);

_group