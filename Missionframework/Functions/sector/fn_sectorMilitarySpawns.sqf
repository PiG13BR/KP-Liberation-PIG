/*
    File: fn_sectorMilitarySpawns.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BBR
    Date: 02/12/2025
    Last Update: 03/02/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handles military base spawns

    Parameter(s):
        _sector - sector to spawn units [STRING]
        _localCaptureSize - capture radius [NUMBER, defaults to KPLIB_range_sectorCapture]

    Returns:
        Spawned units [ARRAY]
*/
params["_sector", ["_localCaptureSize", KPLIB_range_sectorCapture]];

if (!canSuspend) exitWith {_this spawn KPLIB_fnc_sectorMilitarySpawns};

private _sectorUnits = [];
private _sectorPos = markerPos _sector;

// Create objects
["KPLIB_createSectorObjects", [_sector]] call CBA_fnc_serverEvent;

// Get unit cap
private _popfactor = 1;
if (KPLIB_param_unitcap < 1) then {_popfactor = KPLIB_param_unitcap;};

// Select infantry squad compositions
private _infType = "army";

private _squad1 = ([_infType] call KPLIB_fnc_getSquadComp);
private _squad2 = ([_infType] call KPLIB_fnc_getSquadComp);
private _squad3 = [];
if (KPLIB_param_unitcap >= 1.5) then {_squad3 = ([_infType] call KPLIB_fnc_getSquadComp);};
if ((random 100) > (33 / KPLIB_param_difficulty)) then {_squad4 = ([_infType] call KPLIB_fnc_getSquadComp);};
_squad4 = ([] call KPLIB_fnc_getSquadComp);

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

// Select vehicles to spawn
// Heavy vehicles
private _vehToSpawn = [];
if (KPLIB_enemyReadiness > 20) then {
    _vehToSpawn pushback ([] call KPLIB_fnc_getAdaptiveVehicle);
    _vehToSpawn pushback ([] call KPLIB_fnc_getAdaptiveVehicle);
    if ((random 100) > (33 / KPLIB_param_difficulty)) then {
        _vehToSpawn pushback ([] call KPLIB_fnc_getAdaptiveVehicle);
    };
};

// Select vehicles to spawn
private _vehToSpawn = [([] call KPLIB_fnc_getAdaptiveVehicle), ([] call KPLIB_fnc_getAdaptiveVehicle)];
if ((random 100) > (33 / KPLIB_param_difficulty)) then {
    _vehToSpawn pushback ([] call KPLIB_fnc_getAdaptiveVehicle);
};
if ((random 100) > (66 / KPLIB_param_difficulty)) then {
    _vehToSpawn pushback ([] call KPLIB_fnc_getAdaptiveVehicle);
    _vehToSpawn pushback ([] call KPLIB_fnc_getAdaptiveVehicle);
};

// Spawn vehicles
{
    private _vehicle = [_sectorPos, _x] call KPLIB_fnc_spawnVehicle;
    _sectorUnits pushback _vehicle;
    {_sectorUnits pushback _x;} foreach (crew _vehicle);
    
    // Dir
    _vehicle setDir (_sectorPos getDir _vehicle);

    sleep 1;
}forEach _vehToSpawn;

sleep 1;

private _garrisonsCount = round ((floor (2 + (round (KPLIB_enemyReadiness / 4 )))) * _popfactor);

private _garrisonedUnits = [_sector, _garrisonsCount, _localCaptureSize, _infType] call KPLIB_fnc_findSectorGarrisons;
_sectorUnits append _garrisonedUnits;

sleep 1;

// Boat patrol
private _boatUnits = [_sector] call KPLIB_fnc_spawnBoatPatrol;
_sectorUnits append _boatUnits;

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

_sectorUnits