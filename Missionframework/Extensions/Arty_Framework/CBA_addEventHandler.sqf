// Artillery firing
["KPLIB_artilleryFiring", {
    params["_gunner", "_targetPos", ["_eta", 60], ["_area", 100]];
    [_gunner, _targetPos, _eta, _area] call remote_call_artillery_firing;
}] call CBA_fnc_addEventHandler;

if (isServer && KPLIB_LAMBS) then {
    ["lambs_danger_OnArtilleryCalled", {
        params["_caller", "_groupCaller", "_artilleryGun", "_targetPos"];

        private _playersInArea = allPlayers select {_x distance2d _targetPos < 200};
        ["KPLIB_artilleryFiring", [gunner _artilleryGun, _targetPos], _playersInArea] call CBA_fnc_targetEvent;
    }] call CBA_fnc_addEventHandler;
};

// Artillery position destroyed
["KPLIB_artilleryPosDestroyed", {
    ["lib_artillery_destroyed", ["", ""]] call BIS_fnc_showNotification;
}] call CBA_fnc_addEventHandler;

// Counter artillery
["KPLIB_counterArtillery", {
    params ["_unit", "_pos"];
    [_unit, _pos] call KPLIB_fnc_counterArtillery;
}] call CBA_fnc_addEventHandler;

if (isServer) then {
    // Detect group unit kills
    ["KPLIB_grpUnitKilled", {
        params ["_group", "_unit", "_killer"];
        [_group, _unit, _killer] call KPLIB_fnc_grpUnitKilled;
    }] call CBA_fnc_addEventHandler;

    // Add CBA event to enemy groups
    addMissionEventHandler ["EntityCreated", {
        params ["_entity"];

        if !(_entity isKindOf "CAManBase") exitWith {};

        private _group = group _entity;
        private _vehicles = [_group, false] call BIS_fnc_groupVehicles;

        // Add group EH "UnitKilled" for each enemy group that spawns in. This EH is responsable for enemy artillery support.
        if ((side _group == KPLIB_side_enemy) && {_vehicles isEqualTo []} && {(typeOf (leader _group)) in [KPLIB_o_officer, KPLIB_o_squadLeader, KPLIB_o_teamLeader]}) then {

            _group addEventHandler ["UnitKilled", {
                params ["_group", "_unit", "_killer"];
                ["KPLIB_grpUnitKilled", [_group, _unit, _killer]] call CBA_fnc_localEvent;
            }];
        }
    }];
};