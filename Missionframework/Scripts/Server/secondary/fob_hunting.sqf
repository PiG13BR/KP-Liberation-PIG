
_spawn_marker = [2000,999999,false] call KPLIB_fnc_getOpforSpawnPoint;
if (_spawn_marker == "") exitWith {["Could not find position for fob hunting mission", "ERROR"] call KPLIB_fnc_log;};

if (!isNil "KPLIB_usedOpforSpawnPoints") then {
    KPLIB_usedOpforSpawnPoints pushBack _spawn_marker;
} else {
    KPLIB_usedOpforSpawnPoints = [];
};
private _base_position = markerpos _spawn_marker;
private _base_objects = [];
private _base_objectives = [];
private _defenderGrps = [];

([] call (compile preprocessFileLineNumbers (selectRandom KPLIB_fob_templates))) params [
    "_objects_to_build",
    "_objectives_to_build",
    "_building_static_weapons",
    "_building_to_garrison",
    "_base_corners"
];

[_base_position, 50] call KPLIB_fnc_createClearance;

private _nextobject = objNull;

{
    _x params [
        "_nextclass",
        "_nextpos",
        "_nextdir"
    ];

    _nextpos = [((_base_position select 0) + (_nextpos select 0)), ((_base_position select 1) + (_nextpos select 1)), 0];

    _nextobject = _nextclass createVehicle _nextpos;
    _nextobject allowDamage false;
    _nextobject setVectorUp [0, 0, 1];
    _nextobject setdir _nextdir;
    _nextobject setpos _nextpos;
    _nextobject setVectorUp [0, 0, 1];
    _nextobject setdir _nextdir;
    _nextobject setpos _nextpos;

    _base_objects pushBack _nextobject;
} forEach _objects_to_build;

sleep 1;

{
    _x params [
        "_nextclass",
        "_nextpos",
        "_nextdir"
    ];

    _nextpos = [((_base_position select 0) + (_nextpos select 0)), ((_base_position select 1) + (_nextpos select 1)), 0];

    _nextobject = _nextclass createVehicle _nextpos;
    _nextobject allowDamage false;
    _nextobject setVectorUp [0, 0, 1];
    _nextobject setpos _nextpos;
    _nextobject setdir _nextdir;
    _nextobject setVectorUp [0, 0, 1];
    _nextobject setpos _nextpos;
    _nextobject setdir _nextdir;
    _nextobject lock 2;

    _base_objectives pushBack _nextobject;
} forEach _objectives_to_build;

sleep 1;

private _allGarrisons = [];
{
    _x params [
        "_nextclass",
        "_nextpos",
        "_nextdir"
    ];

    _nextpos = [((_base_position select 0) + (_nextpos select 0)), ((_base_position select 1) + (_nextpos select 1)), 0];

    _nextobject = _nextclass createVehicle _nextpos;
    _nextobject allowDamage false;
    _nextobject setVectorUp [0, 0, 1];
    _nextobject setdir _nextdir;
    _nextobject setpos _nextpos;
    _nextobject setVectorUp [0, 0, 1];
    _nextobject setdir _nextdir;
    _nextobject setpos _nextpos;

    _allGarrisons pushBack _nextobject;
    _base_objects pushBack _nextobject;

} forEach _building_static_weapons;

private _allStaticWeapons = [];
if (count _allGarrisons > 0) then {
    private _grp = createGroup [KPLIB_side_enemy, true];
    // Loop the garrison objects found
    {
        private _garrison = _x;
        // Loop statics configuration provided in KPLIB_staticsConfigs.sqf
        {
            // Check if the object type matches one of the configuration
            if ((_x # 0 == typeOf _garrison)) then {
                // Count how many positions are available for static weapons by counting the second element of the main array
                private _positions = count (_x # 1);
                if (_positions > 0) then {
                    for "_index" from 0 to (_positions - 1) do {
                        // The provided _index number in this loop will select each array that contains the necessary values to spawn correctly the static weapon for each relative position provided in the configuration
                        private _type = (((_x # 1) # _index) # 0); // Get the types
                        private _relPos = (((_x # 1) # _index) # 1); // Get the relativePosition
                        private _relDir = (((_x # 1) # _index) # 2); // Get the rotation

                        private _typeSel = "";
                        // It will select randomly the type if more than one is provided.
                        if (count _type > 1) then {
                            _typeSel = selectRandom _type;
                        } else {
                            _typeSel = _type # 0;
                        };

                        // For the selected type, it will check the static weapons presets
                        private _staticClass = "";
                        switch _typeSel do {
                            case "RAISED-HMG" : {
                                _staticClass = selectRandom KPLIB_o_statics_H_HMG;
                            };
                            case "LOWERED-HMG" : {
                                _staticClass = selectRandom KPLIB_o_statics_L_HMG;
                            };
                            case "RAISED-GMG" : {
                                _staticClass = selectRandom KPLIB_o_statics_H_GMG;
                            };
                            case "LOWERED-GMG" : {
                                _staticClass = selectRandom KPLIB_o_statics_L_GMG;
                            };
                            case "AT" : {
                                _staticClass = selectRandom KPLIB_o_statics_AT;
                            };
                            case "AA" : {
                                _staticClass = selectRandom KPLIB_o_statics_AA;
                            };
                        };

                        if (isNil "_staticClass") then {[format ["No static weapon classname found in type %1", _typeSel], "WARNING"] call KPLIB_fnc_log; continue};

                        // Create the static weapon and it's crew
                        private _weapon = [(_garrison modelToWorld _relPos), _staticClass, (getDir _garrison + (_relDir)), _grp] call KPLIB_fnc_spawnStaticWeapon;
                        if (!isNil "_weapon") then {
                            _allStaticWeapons pushBack _weapon;
                        };	
                    };
                };
            }
        }forEach KPLIB_staticsConfigs;
    }forEach _allGarrisons;
};

_base_objects append _allStaticWeapons;

sleep 1;

{
    _x params [
        "_nextclass",
        "_nextpos",
        "_nextdir"
    ];

    _nextpos = [((_base_position select 0) + (_nextpos select 0)), ((_base_position select 1) + (_nextpos select 1)), 0];

    // Check position first
    private _objectPos = nearestObject [_nextpos, _nextClass];
    if !(isNull _objectPos) then {
        // Don't create
        [_objectPos] call KPLIB_fnc_spawnBuildingGarrison;
    } else {
        // Create
        _nextobject = _nextclass createVehicle _nextpos;
        _nextobject allowDamage false;
        _nextobject setVectorUp [0, 0, 1];
        _nextobject setdir _nextdir;
        _nextobject setpos _nextpos;
        _nextobject setVectorUp [0, 0, 1];
        _nextobject setdir _nextdir;
        _nextobject setpos _nextpos;

        _base_objects pushBack _nextobject;
        private _grp = [_nextobject] call KPLIB_fnc_spawnBuildingGarrison;
        _defenderGrps pushBack _grp;
    }
}forEach _building_to_garrison;

{_x setDamage 0; _x allowDamage true;} foreach (_base_objectives + _base_objects);

private _sentryMax = ceil ((3 + (floor (random 4))) * (sqrt (KPLIB_param_unitcap)));

_grpsentry = createGroup [KPLIB_side_enemy, true];
_base_sentry_pos = [(_base_position select 0) + ((_base_corners select 0) select 0), (_base_position select 1) + ((_base_corners select 0) select 1), 0];
for [{_idx=0}, {_idx < _sentryMax}, {_idx=_idx+1}] do {
    [KPLIB_o_sentry, _base_sentry_pos, _grpsentry, "PRIVATE", 0.5] call KPLIB_fnc_createManagedUnit;
};

_defenderGrps pushBack _grpsentry;

{ deleteWaypoint _x } forEachReversed waypoints _grpsentry;
private _waypoint = [];
{
    _waypoint = _grpsentry addWaypoint [[((_base_position select 0) + (_x select 0)), ((_base_position select 1) + (_x select 1)), 0], -1];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointSpeed "LIMITED";
    _waypoint setWaypointBehaviour "SAFE";
    _waypoint setWaypointCompletionRadius 5;
} forEach _base_corners;

_waypoint = _grpsentry addWaypoint [[(_base_position select 0) + ((_base_corners select 0) select 0), (_base_position select 1) + ((_base_corners select 0) select 1), 0], -1];
_waypoint setWaypointType "CYCLE";

secondary_objective_position = _base_position;
secondary_objective_position_marker = [(((secondary_objective_position select 0) + 800) - random 1600), (((secondary_objective_position select 1) + 800) - random 1600), 0];
publicVariable "secondary_objective_position_marker";
sleep 1;

KPLIB_secondary_in_progress = 0; publicVariable "KPLIB_secondary_in_progress";
[2] remoteExec ["remote_call_intel"];

waitUntil {
    sleep 5;
    (_base_objectives select {alive _x}) isEqualTo []
};

KPLIB_enemyReadiness = round (KPLIB_enemyReadiness * (1 - KPLIB_secondary_objective_impact));
stats_secondary_objectives = stats_secondary_objectives + 1;
sleep 1;
[] spawn KPLIB_fnc_doSave;
sleep 3;

[3] remoteExec ["remote_call_intel"];

KPLIB_secondary_in_progress = -1; publicVariable "KPLIB_secondary_in_progress";

{[_x] call KPLIB_fnc_despawnObject} forEach _base_objectives;
{[_x] call KPLIB_fnc_despawnObject} forEach _base_objects;
{
    [_x] call KPLIB_fnc_despawnGroup
} forEach _defenderGrps;
