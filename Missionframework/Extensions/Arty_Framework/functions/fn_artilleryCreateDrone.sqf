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
_drone flyInHeightASL [300, 300, 300];
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
    while {alive _drone && _attackCount < MAX_ARTILLERY_ATTACKS} do {
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