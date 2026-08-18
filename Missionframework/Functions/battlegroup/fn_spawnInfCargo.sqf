/*
    File: fn_spawnInfCargo.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 29/10/2025 
    Last Update: 11/08/2026
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
if (_vehicle isKindOf "Air") then {
    _emptySeats = (_vehicle emptyPositions "Cargo") min 14;
    // Fix for Mi-290 Taru
    if (typeOf _vehicle == "O_Heli_Transport_04_bench_F") then {
        _emptySeats = (_vehicle emptyPositions "Cargo") min 8;
    };
} else {
    _emptySeats = (_vehicle emptyPositions "Cargo");
};

if ((typeOf _vehicle) in KPLIB_o_paradropPlanes) then {
    // Paratroopers
    private _paraSquad = ["paratroopers"] call KPLIB_fnc_getSquadComp;
    if (count _paraSquad > _emptySeats) then {_squad resize _emptySeats;};
    {
        private _unit = [_x, markerPos "ghost_spot", _group, "PRIVATE", 0.5] call KPLIB_fnc_createManagedUnit;
        _unit moveInAny [_vehicle, ["CARGO", "TURRET"]]
    } foreach _paraSquad;
} else {
    private _squad = [] call KPLIB_fnc_getSquadComp;
    if (count _squad > _emptySeats) then {_squad resize _emptySeats;};
    
    {
        private _unit = [_x, _vehicle getPos [5 + random 10, random 360], _group, "PRIVATE", 0.5] call KPLIB_fnc_createManagedUnit;
        _unit moveInAny [_vehicle, ["CARGO", "TURRET"]]
    } foreach _squad;
};

// Check for infantry not in cargo
{
    if (isNull objectParent _x) then {deleteVehicle _x};
}forEach (units _group);

// Add group unit killed to call support
_group addEventHandler ["UnitKilled", {
    params ["_group", "_unit", "_killer"];
    ["KPLIB_onUnitKilled", [_group, _unit, _killer]] call CBA_fnc_localEvent;
}];

_group