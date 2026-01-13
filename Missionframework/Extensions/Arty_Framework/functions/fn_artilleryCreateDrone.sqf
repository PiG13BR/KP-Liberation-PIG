/*
    File: fn_artilleryCreateDrone.sqf
    Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/12/2025
	Last Update: 14/12/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        PROTOTYPE
        Spawns a drone in some nearby enemy sector direction and fly towards the player's fob and start artillery attack scheduler
*/

params["_centerPos"];

if (missionNamespace getVariable ["KPLIB_artilleryFob", false]) exitWith {};
missionNamespace setVariable ["KPLIB_artilleryFob", true, true];

// Define how many artillery attacks that can happen while the drone is alive
#define MAX_ARTILLERY_ATTACKS 3

private _nearestSector = [2000, _centerPos, true, true] call KPLIB_fnc_getNearestSector;
if (_nearestSector isEqualTo "") exitWith {}; 

// Find position to spawn
private _spawnPos = [[[_centerPos, 500]], [[_centerPos, 175]], {
    count ([_this, 250] call KPLIB_fnc_getNearbyPlayers) < 1 && 
    {[_centerPos, (_centerPos getDir (markerPos _nearestSector)), 30, _this] call BIS_fnc_inAngleSector}
}] call BIS_fnc_randomPos;

// Spawn drone
private _drone = createVehicle ["O_UAV_01_F", _spawnPos, [], 0, "FLY"];
[_drone] call KPLIB_fnc_createCrew;

// Set Attributes
{_x setVariable ["lambs_danger_disableAI", true];}forEach (crew _drone);
_drone flyInHeightASL [200, 200, 200];
_drone enableDynamicSimulation false;
{
    _x addCuratorEditableObjects [[_drone]];
} forEach (allCurators);

// Move to location
_drone doMove ([[[_centerPos, 50]], [], {true}] call BIS_fnc_randomPos);

// Start fob artillery fire
[_drone, _centerPos, _spawnPos] spawn {
    params ["_drone", "_centerPos", "_spawnPos"];

    waitUntil {sleep 1; !alive _drone || {_drone distance2D _centerPos < 100}};

    private _attackCount = 0;
    while {!alive _drone || _attackCount < MAX_ARTILLERY_ATTACKS} do {
        sleep (30 + (random 30));

        // Arty fire
        [_centerPos] call KPLIB_fnc_artilleryFobFiring;

        _attackCount = _attackCount + 1;
    };

    if (alive _drone) then {
        // Despawn drone
        [_drone] call KPLIB_fnc_despawnObject;
        _drone doMove _spawnPos;
    };

    missionNamespace setVariable ["KPLIB_artilleryFob", false, true];
};
/*
// PFHO
[
    { 
        // Execute
        (_this getVariable "params") params ["_drone", "_centerPos"];

        if !(alive _drone) exitWith {};

        // Arty fire
        [_centerPos] call KPLIB_fnc_artilleryFobFiring;

        _attacksCount = _attacksCount + 1;
    },
    30 + (random 30), // Tick
    [_drone, _centerPos, _spawnPos], // Parameters
    
    {
        // On start
        _attacksCount = 0
    },
    {
        // On exit
        (_this getVariable "params") params ["_drone", "_centerPos", "_spawnPos"];

        missionNamespace setVariable ["KPLIB_artilleryFob", false, true];
        if (alive _drone) then {
            // Despawn drone
            //[_drone] call KPLIB_fnc_despawnObject;
            _drone doMove _spawnPos;
        };
    },
    {
        // Start condition
        (_this getVariable "params") params ["_drone", "_centerPos"];

        !alive _drone || {_drone distance2D _centerPos < 100}
    },
    {
        // Exit condition
        (_this getVariable "params") params ["_drone", "_centerPos", "_spawnPos"];

        !alive _drone || _attacksCount >= (MAX_ARTILLERY_ATTACKS - 1)
    },
    "_attacksCount" // List of local variables that are serialized between executions.
] call CBA_fnc_createPerFrameHandlerObject;

/*
_drone setVariable ["KPLIB_maxArtyAttacks", 0];
[{
    params["_drone", "_centerPos"];

    !alive _drone || {_drone distance2D _centerPos < 100}

}, {
    params["_drone", "_centerPos", "_spawnPos"];

    if !(alive _drone) exitWith {};

    // Wait to start artillery attack. Players have a chance to destroy the drone.
    [{
        params["_drone", "_centerPos", "_spawnPos"];
        [{
            params["_args", "_handle"];
            _args params["_drone", "_centerPos", "_spawnPos"];

            private _attacksCount = _drone getVariable ["KPLIB_maxArtyAttacks", 0];

            // Cancel arty attack
            if !(alive _drone) exitWith {
                    [_handle]  call CBA_fnc_removePerFrameHandler;
                    missionNamespace setVariable ["KPLIB_artilleryFob", false, true];    
                }; 
            if (_attacksCount >= MAX_ARTILLERY_ATTACKS ||{ count ([_centerPos, KPLIB_range_fob] call KPLIB_fnc_getNearbyPlayers) < ceil(([] call KPLIB_fnc_getPlayerCount)/2)}) exitWith {
                // Despawn drone
                [_drone] call KPLIB_fnc_despawnObject;
                _drone doMove _spawnPos;
                [_handle]  call CBA_fnc_removePerFrameHandler;
                missionNamespace setVariable ["KPLIB_artilleryFob", false, true];
            };

            _attacksCount = _attacksCount + 1;
            _drone setVariable ["KPLIB_maxArtyAttacks", _attacksCount];
            
            // Arty fire
            [_centerPos] call KPLIB_fnc_artilleryFobFiring;
        },  120 + (random 60), [_drone, _centerPos, _spawnPos]] call CBA_fnc_addPerFrameHandler;

        // [] call KPLIB_fnc_artilleryFiring

    }, [_drone, _centerPos, _spawnPos], 20 + (random 30)] call CBA_fnc_waitAndExecute;

}, [_drone, _centerPos, _spawnPos]] call CBA_fnc_waitUntilAndExecute;
