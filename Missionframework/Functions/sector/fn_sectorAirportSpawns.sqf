/*
    File: fn_sectorAirportSpawns.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BBR
    Date: 13/05/2026
    Last Update: 13/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handles Airport spawns

    Parameter(s):
        _sector - sector to spawn units [STRING]
        _localCaptureSize - capture radius [NUMBER, defaults to KPLIB_range_sectorCapture]

    Returns:
        Spawned units [ARRAY]
*/

params["_sector", ["_localCaptureSize", KPLIB_range_sectorCapture * 2]];

if (!canSuspend) exitWith {_this spawn KPLIB_fnc_sectorAirportSpawns};

// Requires marker with shape
if ((markerShape _sector != "RECTANGLE") && (markerShape _sector != "ELLIPSE")) exitWith {[format["Sector %1 should be a shaped area marker", _sector], "WARNING"] call KPLIB_fnc_log};

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
private _squad4 = [];
if (KPLIB_param_unitcap >= 1) then {
    _squad3 = ([_infType] call KPLIB_fnc_getSquadComp);
};
if (KPLIB_param_unitcap >= 1.5) then {
    _squad4 = ([_infType] call KPLIB_fnc_getSquadComp);
};

// Spawn squads
{
    if (count _x < 1) then {continue};

    private _grp = [_sector, _x] call KPLIB_fnc_spawnRegularSquad;

    if (KPLIB_LAMBS) then {
        [_grp, _sectorPos, 200, 4 + ceil(random 4), [], true] call lambs_wp_fnc_taskPatrol;
    } else {
        [_grp, _sectorPos] spawn KPLIB_fnc_addDefenseWaypoints;
    };

    _sectorUnits = _sectorUnits + (units _grp);

    _grp setVariable ["KPLIB_enemy_grpPatrol", true, true];

    sleep 1;
}forEach [_squad1, _squad2, _squad3, _squad4];

// Select vehicles to spawn
// Heavy vehicles
private _vehToSpawn = [([] call KPLIB_fnc_getAdaptiveVehicle), ([] call KPLIB_fnc_getAdaptiveVehicle), ([] call KPLIB_fnc_getAdaptiveVehicle)];
if (KPLIB_enemyReadiness > 25) then {
    _vehToSpawn pushback ([] call KPLIB_fnc_getAdaptiveVehicle);
    if ((random 100) > (33 / KPLIB_param_difficulty)) then {
        _vehToSpawn pushback ([] call KPLIB_fnc_getAdaptiveVehicle);
    };
    if (KPLIB_enemyReadiness > 50) then {
        _vehToSpawn pushback ([] call KPLIB_fnc_getAdaptiveVehicle);
        _vehToSpawn pushback ([] call KPLIB_fnc_getAdaptiveVehicle);
        if ((random 100) > (33 / KPLIB_param_difficulty)) then {
            _vehToSpawn pushback ([] call KPLIB_fnc_getAdaptiveVehicle);
        };
    };
};

// Spawn vehicles
{
    private _vehSpawnPos = [[_sector], [], {
        ((_this nearEntities [["LandVehicle"], 10]) isEqualTo []) 
        && (_this isFlatEmpty [10, -1, 0.3, 10, 0] isNotEqualTo []) 
        && {nearestTerrainObjects [_this, ["Tree", "Rock", "Rocks", "HIDE"], 10] isEqualTo []}
    }] call BIS_fnc_randomPos;

    if (_vehSpawnPos isEqualTo [0,0]) then {[format["Couldn't find a position to spawn vehicle in sector: %1", markerText _sector], "SECTOR"] call KPLIB_fnc_log; continue};
    private _vehicle = [_vehSpawnPos, _x] call KPLIB_fnc_spawnVehicle;
    //[group ((crew _vehicle) select 0),_sectorPos] spawn KPLIB_fnc_addDefenseWaypoints;
    _sectorUnits pushback _vehicle;
    {_sectorUnits pushback _x;} foreach (crew _vehicle);

    // Vehicle patrol
    private _groupVeh = (group (driver _vehicle));
    {deleteWaypoint _x}forEachReversed (waypoints _groupVeh);

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

    private _lastPos = _vehSpawnPos;
    for "_i" from 0 to 3 do {
        private _pos = [[[markerPos _sector, 250]], [], {isOnRoad _this && {_this distance2D (markerPos _sector) >= 100} && {_lastPos distance2D _this >= 150}}] call BIS_fnc_randomPos;
        if (_pos isEqualTo [0,0]) then {continue};
        _lastPos = _pos;
        _wp = _groupVeh addWaypoint [_pos, 0];
        _wp setWaypointType "MOVE";
        _wp setWaypointSpeed "LIMITED";
        // Last waypoint
        if (_i >= 3 && (waypointType [_groupVeh, currentWaypoint _groupVeh]) == "MOVE") then {
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

    (group(effectiveCommander _vehicle)) setVariable ["KPLIB_enemy_vehPatrol", true, false]; 

    sleep 1;
} forEach _vehToSpawn;

sleep 1;

// Garrisons
private _garrisonsCount = 4;

if (KPLIB_enemyReadiness >= (35 - (5 * KPLIB_param_aggressivity))) then {_garrisonsCount = _garrisonsCount + 1};
if (KPLIB_enemyReadiness >= (50 - (5 * KPLIB_param_aggressivity))) then {_garrisonsCount = _garrisonsCount + 1};
if (KPLIB_param_unitcap >= 1 && {KPLIB_enemyReadiness >= (65 - (5 * KPLIB_param_aggressivity))}) then {_garrisonsCount = _garrisonsCount + 1};
if (KPLIB_param_unitcap >= 1.5 && {KPLIB_enemyReadiness >= (85 - (5 * KPLIB_param_aggressivity))}) then {_garrisonsCount = _garrisonsCount + 1};

private _garrisonedUnits = [_sector, _garrisonsCount, _localCaptureSize, _infType] call KPLIB_fnc_findSectorGarrisons;
_sectorUnits append _garrisonedUnits;

sleep 1;

// SAM Radar
private _samPositions = (KPLIB_airportSectorHash get _sector) # 1;
//private _samPositions = (KPLIB_sam_airport select {(markerPos _x) inArea _sector}) apply {markerPos _x};
private "_samRadarPos";
private _samGrp = createGroup [KPLIB_side_enemy, true];
if (count _samPositions > 0) then {
    // Select SAM position preplaced on editor
    _samRadarPos = _samPositions deleteAt (_samPositions find (selectRandom _samPositions));
} else {
    // Find a spawn position for the SAM site
    _samRadarPos = [[_sector], [], {  
        ((_this nearRoads 25) isEqualTo [])
        && ((_this nearEntities [["LandVehicle"], 15]) isEqualTo []) 
        && !(_this isFlatEmpty [15, -1, 0.2, 10, 0] isEqualTo [])
        && {nearestTerrainObjects [_this, ["Tree", "Rock", "Rocks", "HIDE"], 25] isEqualTo []}
    }] call BIS_fnc_randomPos;
};

if (_samRadarPos isNotEqualTo [0,0]) then {
    private _samRadar = [_samRadarPos, selectRandom KPLIB_o_SAM_radars, 0, true] call KPLIB_fnc_spawnVehicle;
    [_samRadar] call KPLIB_fnc_clearCargo;
    _samRadar setAutonomous true;
    _samRadar deleteVehicleCrew (driver _samRadar);
    private _crewRadar = crew _samRadar;
    _crewRadar join _samGrp;
    {
        _x setSkill ["spotDistance", 1];
        _x setSkill ["aimingAccuracy", 0.8];
        _x setSkill ["aimingSpeed", 0.8];
        _x setSkill ["spotTime", 1];
    }forEach _crewRadar;

    // In Pook SAM Pack, when trying to target a jet, gunners in radar assets gets out
    _samRadar addEventHandler ["GetOut", {
        params ["_vehicle", "_role", "_unit", "_turret", "_isEject"];
        if (_role ==  "gunner") then {
            _unit assignAsGunner _vehicle;
            _unit moveInGunner _vehicle;
        };
    }];

    [{
        params["_radar", "_handle"];

        if (!alive _radar || {!alive (gunner _radar)}) exitWith {[_handle] call CBA_fnc_removePerFrameHandler};

        private _watchDir = (_radar getVariable ["KPLIB_radarWatchDir", getDir _radar]) + 30;
        _radar doWatch (_radar getPos [300, _watchDir]);
        _radar setVariable ["KPLIB_radarWatchDir", _watchDir];
    }, 3, _samRadar] call CBA_fnc_addPerFrameHandler;

    _sectorUnits pushback _samRadar;
    {_sectorUnits pushback _x;} foreach _crewRadar;

    sleep 1;

    // SAM Launcher
    private "_samLauncherPos";
    if (count _samPositions > 0) then {
        // Select SAM position preplaced on editor
        _samLauncherPos = _samPositions deleteAt (_samPositions find (selectRandom _samPositions));
    } else {
        // Find a spawn position for the SAM site
        _samLauncherPos = [[_sector], [], {
            ((_this nearRoads 25) isEqualTo [])
            && ((_this nearEntities [["LandVehicle"], 15]) isEqualTo []) 
            && !(_this isFlatEmpty [15, -1, 0.2, 10, 0] isEqualTo [])
            && {nearestTerrainObjects [_this, ["Tree", "Rock", "Rocks", "HIDE"], 25] isEqualTo []}
        }] call BIS_fnc_randomPos;
    };
    private _sam = [_samLauncherPos, selectRandom KPLIB_o_SAM_launchers, 0, true] call KPLIB_fnc_spawnVehicle;
    [_sam] call KPLIB_fnc_clearCargo;
    _sam setAutonomous true;
    private _crewSam = crew _sam;
    _crewSam join _samGrp;
    {
        _x setSkill ["spotDistance", 1];
        _x setSkill ["aimingAccuracy", 1];
        _x setSkill ["aimingSpeed", 1];
        _x setSkill ["spotTime", 1];
    }forEach _crewSam;
    _sectorUnits pushback _sam;
    {_sectorUnits pushback _x;} foreach _crewSam;

    _samGrp addEventHandler ["KnowsAboutChanged", {
        params ["_group", "_targetUnit", "_newKnowsAbout", "_oldKnowsAbout"];
        // Pook SAM tends to fire at ground units
        if (((getPosATL _targetUnit) # 2) < 20) then {_group forgetTarget _targetUnit};
    }];

    if (KPLIB_param_SAMSite == 2) then {
        [_samRadar, [_sam]] call KPLIB_fnc_SAM_customRadarRange;
    };
};

// Manage reinforcements and sector
[{
    params["_sector", "_localCaptureSize", "_sectorUnits"];

    // Reinforcements
    ["KPLIB_sectorReinforcements", _sector] call CBA_fnc_serverEvent;

    if (KPLIB_sectorspawn_debug > 0) then {[format ["Sector %1 (%2) - populating done", (markerText _sector), _sector], "SECTORSPAWN"] remoteExecCall ["KPLIB_fnc_log", 2];};

    [_sector, _localCaptureSize, _sectorUnits] call KPLIB_fnc_manageSectorPFH;
}, [_sector, _localCaptureSize, _sectorUnits], 10] call CBA_fnc_waitAndExecute;

// IA state machine
private _stateMachine = [{(allGroups  select {side _x == KPLIB_side_enemy}) inAreaArray _sector;}, true] call CBA_statemachine_fnc_create;

[_stateMachine, "Initial", "Alert", {combatMode _this == "YELLOW"}, {
    {
        _x setCombatBehaviour "COMBAT";
        _x setSkill ["spotDistance", ((_x skill "spotDistance") * 1.5) min 1];
        _x setSkill ["spotTime",     ((_x skill "spotTime")     * 1.5) min 1];
    } forEach (units _this);
}, "InCombat"] call CBA_statemachine_fnc_addTransition;