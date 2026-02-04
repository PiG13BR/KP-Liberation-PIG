/*
    File: fn_sectorOutpostSpawns.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 17/12/2025
    Last Update: 03/02/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handles filler sector spawns
        This is not actually a sector, but rather a filler just to put patrols and garrisons units.
        This sector is aimed not to be shown on the map.

    Parameter(s):
        _sector - sector to spawn units [STRING]
        _localCaptureSize - capture radius [NUMBER, defaults to KPLIB_range_sectorCapture * 0.3]

    Returns:
        Spawned units [ARRAY]
*/

params["_sector", ["_localCaptureSize", KPLIB_range_sectorCapture * 0.5]];

if (!canSuspend) exitWith {_this spawn KPLIB_fnc_sectorOutpostSpawns};

private _sectorUnits = [];
private _sectorPos = markerPos _sector;

// Create objects
["KPLIB_createSectorObjects", [_sector]] call CBA_fnc_serverEvent;

// Get unit cap
private _popfactor = 1;
if (KPLIB_param_unitcap < 1) then {_popfactor = KPLIB_param_unitcap;};

// Select infantry squad compositions
private _infType = "army";
if (KPLIB_enemyReadiness < 25) then {_infType = "militia";};

private _squad1 = ([_infType] call KPLIB_fnc_getSquadComp);
private _squad2 = [];
if (KPLIB_param_unitcap >= 1.25) then {_squad2 = ([_infType] call KPLIB_fnc_getSquadComp);};

// Spawn squads
{
    if (count _x < 1) then {continue};

    private _grp = [_sector, _x] call KPLIB_fnc_spawnRegularSquad;
    if (KPLIB_LAMBS) then {
        [_grp, _sectorPos, _localCaptureSize, 4 + ceil(random 4), [], true] call lambs_wp_fnc_taskPatrol;
    } else {
        [_grp, _sectorPos] spawn add_defense_waypoints;
    };

    _sectorUnits = _sectorUnits + (units _grp);

    sleep 1;
}forEach [_squad1, _squad2];

// Garrisons
private _garrisonsCount = 1 + round(random 1);

if (KPLIB_enemyReadiness >= (35 - (5 * KPLIB_param_aggressivity))) then {_garrisonsCount = _garrisonsCount + 1};
if (KPLIB_enemyReadiness >= (50 - (5 * KPLIB_param_aggressivity))) then {_garrisonsCount = _garrisonsCount + 1};
if (KPLIB_param_unitcap >= 1 && {KPLIB_enemyReadiness >= (65 - (5 * KPLIB_param_aggressivity))}) then {_garrisonsCount = _garrisonsCount + 1};
if (KPLIB_param_unitcap >= 1.5 && {KPLIB_enemyReadiness >= (85 - (5 * KPLIB_param_aggressivity))}) then {_garrisonsCount = _garrisonsCount + 1};

sleep 1;

private _garrisonedUnits = [_sector, _garrisonsCount, _localCaptureSize, _infType] call KPLIB_fnc_findSectorGarrisons;
_sectorUnits append _garrisonedUnits;

[{
    params["_sector", "_localCaptureSize", "_sectorUnits"];

    if (KPLIB_sectorspawn_debug > 0) then {[format ["Sector %1 (%2) - populating done", (markerText _sector), _sector], "SECTORSPAWN"] remoteExecCall ["KPLIB_fnc_log", 2];};

    [_sector, _localCaptureSize, _sectorUnits] call KPLIB_fnc_manageSectorPFH;
}, [_sector, _localCaptureSize, _sectorUnits], 10] call CBA_fnc_waitAndExecute;

// IA state machine
private _stateMachine = [{allGroups select {side _x == KPLIB_side_enemy && ((leader _x) distance2D _sectorPos < _localCaptureSize)}}, true] call CBA_statemachine_fnc_create;

[_stateMachine, "Initial", "Alert", {combatMode _this == "YELLOW"}, {
    {
        _x setCombatBehaviour "COMBAT";
        _x setSkill ["spotDistance", ((_x skill "spotDistance") * 1.5) min 1];
        _x setSkill ["spotTime",     ((_x skill "spotTime")     * 1.5) min 1];
    } forEach (units _this);
}, "InCombat"] call CBA_statemachine_fnc_addTransition;

_sectorUnits