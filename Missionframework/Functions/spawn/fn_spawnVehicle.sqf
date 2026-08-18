/*
    File: fn_spawnVehicle.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2019-12-03
    Last Update: 2026-16-08
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns a vehicle with all needed Liberation connections/dependencies.

    Parameter(s):
        _pos        - Position to spawn the vehicle                                         [POSITION, defaults to [0, 0, 0]]
        _classname  - Classname of the vehicle to spawn                                     [STRING, defaults to ""]
        _radius    - Selector if the vehicle should spawned precisely on given position     [NUMBER, defaults to 0]
        _rndDir     - Selector if the direction should be randomized                        [BOOL, defaults to true]

    Returns:
        Spawned vehicle [OBJECT]
*/

params [
    ["_pos", [0, 0, 0], [[]], [2, 3]],
    ["_classname", "", [""]],
    ["_radius", 0, [0]],
    ["_rndDir", true, [false]]
];

if (_pos isEqualTo [0, 0, 0]) exitWith {["No or zero pos given"] call BIS_fnc_error; objNull};
if (_classname isEqualTo "") exitWith {["Empty string given"] call BIS_fnc_error; objNull};

private _newvehicle = objNull;
private _spawnpos = [];

if (_radius < 1) then {
    // Directly use given pos
    _spawnpos = _pos;
} else {
    // Otherwise find a suitable position for vehicle spawning near given pos
    private _i = 0;
    while {_spawnpos isEqualTo []} do {
        _i = _i + 1;
        _spawnpos = [[[_pos, _radius]], [], {
            ((_this nearEntities [["LandVehicle"], 10]) isEqualTo []) &&
            !(_this isFlatEmpty [-1, -1, 0.3, 10, 0] isEqualTo [])
        }] call BIS_fnc_randomPos;
        //_spawnpos = (_pos getPos [random 150, random 360]) findEmptyPosition [10, _radius, _classname];
        if (_i isEqualTo 10) exitWith {_spawnpos = zeroPos};
    };
};

if (_spawnPos isEqualTo []) exitWith {
    ["No suitable spawn position found."] call BIS_fnc_error;
    [format ["Couldn't find spawn position for %1 around position %2", _classname, _pos], "WARNING"] call KPLIB_fnc_log;
    objNull
};

// If it's a chopper, spawn it flying
if ((toLowerANSI _classname) in KPLIB_o_helicopters) then {
    _newvehicle = createVehicle [_classname, _pos, [], 0, 'FLY'];
    _newvehicle flyInHeight (100 + (random 120));
    _newvehicle allowDamage false;
} else {
    _newvehicle = createVehicle [_classname, _pos, [], _radius, "NONE"];
    _newvehicle allowDamage false;

    [_newvehicle] call KPLIB_fnc_allowCrewInImmobile;

    // Randomize direction and reset position and vector
    if (_rndDir) then {
        _newvehicle setDir (random 360);
    };

    [{    
        _this setPos (getPosATL _this);
        _this setVectorUp surfaceNormal position _this;
    }, _newvehicle, 3] call CBA_fnc_waitAndExecute;
};

if (isNull _newvehicle) exitWith {_newVehicle};

_newVehicle lock true;
// Clear cargo, if enabled
[_newvehicle] call KPLIB_fnc_clearCargo;
_newvehicle addItemCargoGlobal ["toolkit", 1];
// Process KP object init
[_newvehicle] call KPLIB_fnc_addObjectInit;

// Spawn crew of vehicle
if (_classname in KPLIB_o_militiaVehicles) then {
    [_newvehicle] call KPLIB_fnc_spawnMilitiaCrew;
} else {
    //private _grp = createGroup [KPLIB_side_enemy, true];
    private _crew = units ([_newvehicle] call KPLIB_fnc_createCrew);
    {
        _x addMPEventHandler ["MPKilled", {
            params ["_unit", "_killer"];
            ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
        }];
    } forEach _crew;
};

// Add Killed and GetIn EHs and enable damage again
_newvehicle addMPEventHandler ["MPKilled", {
    params ["_unit", "_killer"];
    ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
}];

[{
    _this allowDamage true;
    _this setDamage 0;
    _this lock false;
}, _newvehicle, 5] call CBA_fnc_waitAndExecute;

_newvehicle