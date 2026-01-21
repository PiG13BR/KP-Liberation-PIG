/*
    File: fn_spawnBattlegroup.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BBR
    Date: 29/10/2025
    Last Update: 15/12/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns a battlegroup and warn players

    Parameter(s):
        _objPos - position to move/attack [POSITION, defaults to [0,0,0]]
        _vehType - type of vehicle to spawn (i.e: "LandVehicle", "Helicopter", "Plane"), _infOnly must be false [STRING, defaults to ""]

    Returns:
        Function reached the end [BOOL]
*/

params [
    ["_objPos", [0, 0, 0], [[]]],
    ["_vehType", "", [""]]
];

if (!isServer) exitWith {false};

if (KPLIB_endgame == 1) exitWith {false};

private _objPos = [_objPos] call KPLIB_fnc_getBluforObjective;

KPLIB_last_battlegroup_time = diag_tickTime;

private _selectedVehiclePool = [];
private _target_size = (round (KPLIB_battlegroup_size * ([] call KPLIB_fnc_getOpforFactor) * (sqrt KPLIB_param_aggressivity))) min 16;
if (KPLIB_enemyReadiness < 60) then {_target_size = round (_target_size * 0.65);};

// Spawn vehicle battlegroup
// Select vehicle pool
private _vehiclePool = [KPLIB_o_battleGrpVehicles, KPLIB_o_battleGrpVehiclesLight] select (KPLIB_enemyReadiness < 50);

// Check for vehicle type parameter
if (_vehType isNotEqualTo "") then {
    _vehiclePool = _vehiclePool select {
        _x isKindOf _vehType
    };
};

while {count _selectedVehiclePool < _target_size} do {
    _selectedVehiclePool pushback (selectRandom _vehiclePool);
};

if (_selectedVehiclePool isEqualTo []) exitWith {}; // Exit on empty

private _heliAspawnedOnce = false; // Spawns only once attack helicopter
private _paraTrooperSpawnedOnce = false; // Spawns only once paratroopers

// Iterate vehicle pool
{    
    if !([] call KPLIB_fnc_getOpforCap < KPLIB_cap_battlegroup) then {continue};
    private _class = _x;

    if (_class isKindOf "Air") then {
        // Handle air units
        if (_class isKindOf "Helicopter") then {
            // Helicopters
            if (_class in KPLIB_o_troopTransports) then {
                // Spawn helicopter transport
                _spawnPoint = [1500, 4000, false, _objPos] call KPLIB_fnc_getOpforSpawnPoint;
                [_class, _objPos, _spawnPoint] call KPLIB_fnc_battlegroupTransportHeli;
            } else {
                // Spawn attack helicopter
                if ((_class in KPLIB_o_attackHelicopters) && {!_heliAspawnedOnce}) then {
                    _spawnPoint = [2000, 4000, false, _objPos] call KPLIB_fnc_getOpforSpawnPoint;
                    [_class, _objPos, _spawnPoint] call KPLIB_fnc_battlegroupAttackHeli;
                    _heliAspawnedOnce = true;
                };
            };
        } else {
            // Probably planes. Use the sector as reference, not spawn point.
            if ((_class in KPLIB_o_troopTransports) && {!_paraTrooperSpawnedOnce}) then {

                // Spawn paratroopers
                _spawnPoint = ([KPLIB_sectors_airSpawn, [_objPos], {(markerPos _x) distance _input0}, "ASCEND"] call BIS_fnc_sortBy) select 0;
                [_class, _objPos, _spawnPoint] call KPLIB_fnc_battlegroupParatroopers;
                _paraTrooperSpawnedOnce = true;
            };
        };
    } else {
        // Handle land vehicles, including transport vehicles
        private _spawnPoint = [1000, 2000, false, _objPos] call KPLIB_fnc_getOpforRoadSpawnPoint;
        [_class, _objPos, _spawnPoint] call KPLIB_fnc_battlegroupLandVehicle;
    };
    
}forEach _selectedVehiclePool;

// Spawn attack jet
if (KPLIB_param_aggressivity > 0.9 && ((random 100) < 25)) then {
    [_objPos] spawn KPLIB_fnc_battlegroupJet;
};

if (_selectedVehiclePool isEqualTo []) exitWith {["Vehicle pool returned empty", "BATTLEGROUP"] call KPLIB_fnc_log; false};

["KPLIB_reinfIncoming", ["", _objPos]] call CBA_fnc_globalEvent;

true