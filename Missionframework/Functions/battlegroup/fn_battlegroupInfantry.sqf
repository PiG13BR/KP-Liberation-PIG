/*
    File: fn_battlegroupInfantry.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 30/10/2025
    Last Update: 05/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns an infantry battlegroup

    Parameter(s):
        _spawnPoint - spawn point or sector reference [STRING, defaults to ""]
        _targetPos - position to attack [POSITION, defaults to []]

    Returns:
        Group spawned [GROUP]
*/

params[
    ["_targetPos", [0 ,0 ,0], [[]]],
    ["_spawnPoint", "", [""]],
    ["_notify", true, [false]]
];

if (!isServer) exitWith {[]};

// Get target position if not provided
if (_targetPos isEqualTo [0 ,0 ,0]) then {
    _targetPos = [_targetPos] call KPLIB_fnc_getBluforObjective;
};
if (_targetPos isEqualTo []) exitWith {[]};

// Get spawn point if not provided
if (_spawnPoint isEqualTo "") then {
    _spawnPoint = [400, 1000, false, _targetPos] call KPLIB_fnc_getOpforSpawnPoint;
};
if (_spawnPoint isEqualTo "") exitWith {[]};

// Clear area
if (worldName in KPLIB_battlegroup_clearance) then {
    [markerPos _spawnPoint, 15] call KPLIB_fnc_createClearance;
};

// Infantry units to choose from
// Create group
private _infClasses = [KPLIB_o_inf_classes, KPLIB_o_militiaInfantry] select (KPLIB_enemyReadiness < 50);

// Adjust target size for infantry
private _target_size = (round (KPLIB_battlegroup_size * ([] call KPLIB_fnc_getOpforFactor) * (sqrt KPLIB_param_aggressivity))) min 16;
private _target_size = 12 max (_target_size * 4);
private _squadNumber = round (_target_size/8);

private _groups = [];
for "_i" from 1 to _squadNumber do {
    private _grp = createGroup [KPLIB_side_enemy, true];
    _groups pushBack _grp;
    // Create infantry groups with up to 8 units per squad
    for "_i" from 0 to (5 + round(random 3)) do {
        [selectRandom _infClasses, markerPos _spawnPoint, _grp] call KPLIB_fnc_createManagedUnit;
    };
    
    [_grp] call KPLIB_fnc_LAMBS_enableReinforcements;
    _grp setVariable ["KPLIB_isBattleGroup", true];

    // Commit attack
    [_grp, _targetPos] call KPLIB_fnc_battlegroupAttack;
};

if (_notify) then {
    ["KPLIB_reinfIncoming", [_spawnPoint, _targetPos]] call CBA_fnc_globalEvent;
};

{
    ["KPLIB_battlegroupSpawn", [_x]] call CBA_fnc_serverEvent;
}forEach _groups;

_groups