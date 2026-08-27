/*
    File: fn_fillerAASpawns.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 26/05/2026
    Last Update: 30/07/2026
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

if (!canSuspend) exitWith {_this spawn KPLIB_fnc_fillerAASpawns};

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

private _squad1 = KPLIB_o_squadAir;
private _squad2 = [];
if (KPLIB_param_unitcap >= 1.25) then {_squad2 = KPLIB_o_squadAir;};

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
}forEach [_squad1, _squad2];

// Spawn AA vehicle without driver
private _vehicle = [markerPos _sector, selectRandom KPLIB_o_antiAirVehicles, 0, true] call KPLIB_fnc_spawnVehicle;
_vehicle deleteVehicleCrew (driver _vehicle);
_sectorUnits pushback _vehicle;
{_sectorUnits pushback _x;} foreach (crew _vehicle);

[{
	params["_vehAA", "_handle"];

	if (!canFire _vehAA || !alive _vehAA || {!alive (gunner _vehAA)}) exitWith {[_handle] call CBA_fnc_removePerFrameHandler};
    if !(unitReady _vehAA) then {continue};

	private _watchDir = (_vehAA getVariable ["KPLIB__vehAAWatchDir", getDir _vehAA]) + 45;
	_vehAA doWatch ((_vehAA getPos [300, _watchDir]) vectorAdd [0,0,120]);
	_vehAA setVariable ["KPLIB__vehAAWatchDir", _watchDir];
}, 3, _vehicle] call CBA_fnc_addPerFrameHandler;

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