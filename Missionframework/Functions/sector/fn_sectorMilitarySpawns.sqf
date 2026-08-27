/*
    File: fn_sectorMilitarySpawns.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BBR
    Date: 02/12/2025
    Last Update: 13/07/2026
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

// Create mines
["KPLIB_createSectorMines", _sector] call CBA_fnc_serverEvent;

// Get unit cap
private _popfactor = 1;
if (KPLIB_param_unitcap < 1) then {_popfactor = KPLIB_param_unitcap;};

// Select infantry squad compositions
private _infType = "army";

private _squad1 = ([_infType] call KPLIB_fnc_getSquadComp);
private _squad2 = ([_infType] call KPLIB_fnc_getSquadComp);
private _squad3 = [];
if (KPLIB_param_unitcap >= 1.5) then {_squad3 = ([_infType] call KPLIB_fnc_getSquadComp);};

// Spawn squads
{
    if (count _x < 1) then {continue};

    private _grp = [_sector, _x] call KPLIB_fnc_spawnRegularSquad;
    if (KPLIB_LAMBS) then {
        [_grp, _sectorPos, _localCaptureSize, 4 + ceil(random 4), [], true] call lambs_wp_fnc_taskPatrol;
    } else {
        [_grp, _sectorPos] spawn KPLIB_fnc_addDefenseWaypoints;
    };

    _sectorUnits = _sectorUnits + (units _grp);

    _grp setVariable ["KPLIB_enemy_grpPatrol", true, true];

    sleep 1;
}forEach [_squad1, _squad2, _squad3];

// Select vehicles to spawn
// Heavy vehicles
private _vehToSpawn = [([] call KPLIB_fnc_getAdaptiveVehicle), ([] call KPLIB_fnc_getAdaptiveVehicle)];
if (KPLIB_enemyReadiness > 25) then {
    _vehToSpawn pushback ([] call KPLIB_fnc_getAdaptiveVehicle);
};
if (KPLIB_enemyReadiness > 50) then {
    _vehToSpawn pushback ([] call KPLIB_fnc_getAdaptiveVehicle);
};
if (KPLIB_enemyReadiness > 75) then {
    _vehToSpawn pushback ([] call KPLIB_fnc_getAdaptiveVehicle);
};

if ((random 100) > (33 / KPLIB_param_difficulty)) then {
    _vehToSpawn pushback ([] call KPLIB_fnc_getAdaptiveVehicle);
};
if ((random 100) > (66 / KPLIB_param_difficulty)) then {
    _vehToSpawn pushback ([] call KPLIB_fnc_getAdaptiveVehicle);
};

// Spawn vehicles
{
    private _spawnPos = [[[_sectorPos, _localCaptureSize]], [], {
        ((_this nearEntities [["LandVehicle"], 10]) isEqualTo []) 
        && (_this isFlatEmpty [3, -1, -1, -1, 0] isNotEqualTo []) 
        && {nearestTerrainObjects [_this, ["Tree", "Rock", "Rocks", "HIDE"], 10] isEqualTo []}
    }] call BIS_fnc_randomPos;
    
    if (_spawnPos isEqualTo [0,0]) then {[format["Couldn't find a position to spawn vehicle in sector: %1", markerText _sector], "SECTOR"] call KPLIB_fnc_log; continue};
    private _vehicle = [_spawnPos, _x, 0] call KPLIB_fnc_spawnVehicle;
    _sectorUnits pushback _vehicle;
    {_sectorUnits pushback _x;} foreach (crew _vehicle);
    
    // Dir
    _vehicle setDir (_sectorPos getDir _vehicle);

    (group(effectiveCommander _vehicle)) setVariable ["KPLIB_enemy_vehPatrol", true, false]; 

    sleep 1;
}forEach _vehToSpawn;

sleep 1;

private _garrisonsCount = round ((floor (2 + (round (KPLIB_enemyReadiness / 10 )))) * _popfactor);

private _garrisonedUnits = [_sector, _garrisonsCount, _localCaptureSize, _infType] call KPLIB_fnc_findSectorGarrisons;
_sectorUnits append _garrisonedUnits;

sleep 1;

// Boat patrol
private _boatUnits = [_sector] call KPLIB_fnc_spawnBoatPatrol;
_sectorUnits append _boatUnits;

[{
    params["_sector", "_localCaptureSize", "_sectorUnits"];

    // Reinforcements
    ["KPLIB_sectorReinforcements", _sector] call CBA_fnc_serverEvent;

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