/*
    File: fn_sectorTowerSpawns.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BBR
    Date: 02/12/2025
    Last Update: 11/02/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handles tower spawns

    Parameter(s):
        _sector - sector to spawn units [STRING]
        _localCaptureSize - capture radius [NUMBER, defaults to KPLIB_range_sectorCapture]

    Returns:
        Spawned units [ARRAY]
*/
params["_sector", ["_localCaptureSize", KPLIB_range_sectorCapture]];

if (!canSuspend) exitWith {_this spawn KPLIB_fnc_sectorTowerSpawns};

private _sectorUnits = [];
private _sectorPos = markerPos _sector;

// Create objects
["KPLIB_createSectorObjects", [_sector]] call CBA_fnc_serverEvent;

// Select infantry squad compositions
private _infType = "army";

private _squad1 = ([_infType] call KPLIB_fnc_getSquadComp);
private _squad2 = [];
private _squad3 = [];
private _squad4 = [];
if (KPLIB_enemyReadiness > 30) then {_squad2 = ([_infType] call KPLIB_fnc_getSquadComp);};
if (KPLIB_param_unitcap >= 1.5) then {_squad3 = ([_infType] call KPLIB_fnc_getSquadComp);};
if (KPLIB_enemyReadiness > 80) then {_squad4 = ([_infType] call KPLIB_fnc_getSquadComp);};

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
}forEach [_squad1, _squad2, _squad3, _squad4];

[{
    params["_sector", "_localCaptureSize", "_sectorUnits"];

    // Reinforcements
    if ((_sector in KPLIB_sectors_factory) || (_sector in KPLIB_sectors_city) || (_sector in KPLIB_sectors_capital) || (_sector in KPLIB_sectors_military)) then {
        //[_sector] remoteExec ["reinforcements_remote_call",2];
        ["KPLIB_enemyReinforcements", _sector] call CBA_fnc_serverEvent
    };

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