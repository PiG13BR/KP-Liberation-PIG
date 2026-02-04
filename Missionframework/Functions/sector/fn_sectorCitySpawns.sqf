/*
    File: fn_sectorCitySpawns.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BBR
    Date: 02/12/2025
    Last Update: 03/02/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handles city spawns

    Parameter(s):
        _sector - sector to spawn units [STRING]
        _localCaptureSize - capture radius [NUMBER, defaults to KPLIB_range_sectorCapture]

    Returns:
        Spawned units [ARRAY]
*/
params["_sector", ["_localCaptureSize", KPLIB_range_sectorCapture]];

if (!canSuspend) exitWith {_this spawn KPLIB_fnc_sectorCitySpawns};

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
private _squad3 = [];
if (KPLIB_param_unitcap >= 1.25) then {_squad2 = ([_infType] call KPLIB_fnc_getSquadComp);};
if ((random 100) > (33 / KPLIB_param_difficulty)) then {
    _squad3 = ([_infType] call KPLIB_fnc_getSquadComp);
};

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
}forEach [_squad1, _squad2, _squad3];

// Select vehicles to spawn
private _vehToSpawn = [];
if ((random 100) > (66 / KPLIB_param_difficulty)) then {_vehToSpawn pushback (selectRandom KPLIB_o_militiaVehicles);};
if ((random 100) > (33 / KPLIB_param_difficulty)) then {_vehToSpawn pushback (selectRandom KPLIB_o_militiaVehicles);};
if (_infType == "army") then {
    _vehToSpawn pushback (selectRandom KPLIB_o_militiaVehicles);
    if ((random 100) > (33 / KPLIB_param_difficulty)) then {
        _vehToSpawn pushback ([] call KPLIB_fnc_getAdaptiveVehicle);
    };
};

// Spawn vehicles
{
    private _roadSpawn = [[[_sectorPos, 200]], [], {
        isOnRoad _this && 
        ((_this nearEntities [["LandVehicle"], 10]) isEqualTo []) &&
        !(_this isFlatEmpty [-1, -1, 0.3, 10, 0] isEqualTo [])
    }] call BIS_fnc_randomPos;
    private _vehicle = [_roadSpawn, _x] call KPLIB_fnc_spawnVehicle;
    _sectorUnits pushback _vehicle;
    {_sectorUnits pushback _x;} foreach (crew _vehicle);

    // Vehicle patrol streets
    {deleteWaypoint _x}forEachReversed (waypoints (group driver _vehicle));
    private _lastPos = _roadSpawn;

    // Tanks and apcs types don't patrol
    if ((_vehicle isKindOf "Tank") || (_vehicle isKindOf "Wheeled_Apc_F")) then {
        _vehicle setDir (_sectorPos getDir _vehicle);
        continue
    };

    // Random chance patrol
    if ((random 100) < 45) then {
        _vehicle setDir (_sectorPos getDir _vehicle);
        continue
    };

    for "_i" from 0 to 2 do {
        private _pos = [[[_sectorPos, 200]], [], {isOnRoad _this && {_lastPos distance _this >= 150}}] call BIS_fnc_randomPos;
        if (_pos isEqualTo [0,0]) then {continue};
        _lastPos = _pos;
        _wp = (group (driver _vehicle)) addWaypoint [_pos, 0];
        _wp setWaypointType "MOVE";
        _wp setWaypointSpeed "LIMITED";
        // Last waypoint
        if (_i >= 3) then {
            _wp setWaypointType "CYCLE";
        };
    };

        _vehicle addEventHandler ["Hit", {
        params ["_unit", "_source", "_damage", "_instigator"];
        private _group = (group (driver _unit));

        if (isNull _source) exitWith {};
        if (_source isKindOf "Air") exitWith {
            _group setCombatBehaviour "COMBAT";
        };

        // Find enemy pos if knows about
        private _enemyPos = _unit getHideFrom _source;
        if (_enemyPos isEqualTo [0,0,0]) exitWith {
            // Don't change waypoints, only its behaviour
            _group setCombatBehaviour "COMBAT";
        };

        // Check distance with true source pos
        if (_enemyPos distance _source >= 100) exitWith {};
        if (_enemyPos distance _unit >= 300) exitWith {
            _wp setWaypointBehaviour "COMBAT";
        };

        // Remove patrol waypoints
        {deleteWaypoint _x}forEachReversed (waypoints _group);

        private _wp = _group addWaypoint [_enemyPos, 100];
        _wp setWaypointType "SAD";
        _wp setWaypointBehaviour "COMBAT";

        // Remove this event handler
        _unit removeEventHandler [_thisEvent, _thisEventHandler];
    }];

    _vehicle addEventHandler ["Fired", {
        params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
        {deleteWaypoint _x}forEachReversed (waypoints (group (driver _unit)));
        _unit setCombatBehaviour "COMBAT";
    }];
    _vehicle addEventHandler ["FiredNear", {
        params ["_unit", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];

        private _group = (group (driver _unit));

        if (isNull _firer) exitWith {};
        if (_firer isKindOf "Air") exitWith {
            _group setCombatBehaviour "COMBAT";
        };

        // Find enemy pos if knows about
        private _enemyPos = _unit getHideFrom _firer;
        if (_enemyPos isEqualTo [0,0,0]) exitWith {
            // Don't change waypoints, only its behaviour
            _group setCombatBehaviour "COMBAT";
        };

        // Check distance with true source pos
        if (_enemyPos distance _firer >= 100) exitWith {};

        // Remove patrol waypoints
        {deleteWaypoint _x}forEachReversed (waypoints _group);

        private _wp = _group addWaypoint [_enemyPos, 100];
        _wp setWaypointType "SAD";
        _wp setWaypointBehaviour "COMBAT";

        // Remove this event handler
        _unit removeEventHandler [_thisEvent, _thisEventHandler];
    }];

    sleep 1;
} forEach _vehToSpawn;

// Spawns civs
if (KPLIB_param_civActivity > 0) then {
    _sectorUnits = _sectorUnits + ([_sector] call KPLIB_fnc_spawnCivilians);
};

sleep 1;

// Guerrila
if (((random 100) <= KPLIB_resistance_sector_chance) && (([] call KPLIB_fnc_crGetMulti) > 0)) then {
    [_sector] spawn sector_guerilla;
};

sleep 1;

// Garrisons
private _garrisonsCount = 2;

if (KPLIB_enemyReadiness >= (35 - (5 * KPLIB_param_aggressivity))) then {_garrisonsCount = _garrisonsCount + 1};
if (KPLIB_enemyReadiness >= (50 - (5 * KPLIB_param_aggressivity))) then {_garrisonsCount = _garrisonsCount + 1};
if (KPLIB_param_unitcap >= 1 && {KPLIB_enemyReadiness >= (65 - (5 * KPLIB_param_aggressivity))}) then {_garrisonsCount = _garrisonsCount + 1};
if (KPLIB_param_unitcap >= 1.5 && {KPLIB_enemyReadiness >= (85 - (5 * KPLIB_param_aggressivity))}) then {_garrisonsCount = _garrisonsCount + 1};

private _garrisonedUnits = [_sector, _garrisonsCount, _localCaptureSize, _infType] call KPLIB_fnc_findSectorGarrisons;
_sectorUnits append _garrisonedUnits;

// Check civ reputation to spawn ied
private _iedcount = 0;
private _radius = 200;

if (KPLIB_civ_rep < 0) then {
    _iedcount = round ((ceil (random 4)) * (round ((KPLIB_civ_rep * -1) / 33)) * KPLIB_param_difficulty);
};
if (_iedcount > 12) then {_iedcount = 12};

if (KPLIB_asymmetric_debug > 0) then {
    [format ["Sector %1 (%2) - Range: %3 - Count: %4", (markerText _sector), _sector, _radius, _iedcount], "ASYMMETRIC"] remoteExecCall ["KPLIB_fnc_log", 2];
};
[_sector, _radius, _iedcount] spawn ied_manager;

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