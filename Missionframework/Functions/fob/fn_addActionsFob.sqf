/*
    File: fn_addActionsFob.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2020-04-13
    Last Update: 2026-10-26
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Adds build action to FOB box and repackage action to FOB building.

    Parameter(s):
        _obj - FOB box/truck/building to add the deploy/repack action to [OBJECT, defaults to objNull]

    Returns:
        Function reached the end [BOOL]
*/

params [
    ["_obj", objNull, [objNull]]
];

if (isNull _obj) exitWith {["Null object given"] call BIS_fnc_error; false};

if ((typeOf _obj) isEqualTo KPLIB_b_fobBuilding) exitWith {
    _obj addAction [
        ["<t color='#FFFF00'>", localize "STR_BASE_REPACKAGE", "</t> <img size='2' image='Images\ui_repackfob.paa'/>"] joinString "",
        {[_this # 0] call KPLIB_fnc_repackage_createMenuRsc},
        nil,
        -754,
        false,
        true,
        "",
        toString {
            alive _target &&
            isNull (objectParent _this) && 
            {player getVariable ['KPLIB_hasDirectAccess', false]}
        },
        20
    ];
    true
};

if ((typeOf _obj) in [KPLIB_b_fobBox, KPLIB_b_fobTruck]) exitWith {
    [
	_obj,
        ["<t color='#FFFF00'>", localize "STR_FOB_ACTION", "</t> <img size='2' image='Images\ui_deployfob.paa'/>"] joinString "",
        "Images\ui_deployfob.paa", "Images\ui_deployfob.paa",
        toString {
            isNull (objectParent _this) 
            && {player getVariable ['KPLIB_hasDirectAccess', false] || {[4] call KPLIB_fnc_hasPermission}} 
            && {player getVariable ['KPLIB_isAwayFromStart', false]}
            && {!(surfaceIsWater getPos player)}
        }, 
        toString {
            _caller distance _target < 10
            && {(KPLIB_player_fobs findIf {(_x distance2D _target) < (KPLIB_distance_base)} < 0)}
            && {(KPLIB_player_outposts findIf {(_x distance2D _target) < (KPLIB_distance_base)} < 0)}
        },
        {},
        {},
        {
            params["_object"];
            [_object] call KPLIB_fnc_doBuildFob
        },
        {
            if ( count (KPLIB_player_fobs select {_x isNotEqualTo [0,0,0]}) >= KPLIB_param_maxFobs) exitWith {
                [format [ localize "STR_HINT_FOBS_EXCEEDED", KPLIB_param_maxFobs], true, 3] call KPLIB_fnc_hint;
            };

            // Check for nearest fobs and outposts
            private _index = (KPLIB_player_fobs + KPLIB_player_outposts) findIf {(_x distance2D _target) < KPLIB_distance_base};
            if (_index >= 0) exitWith {
                private _distFob = _target distance ([getPosATL _target] call KPLIB_fnc_getNearestPlayerBase);
                [format [localize "STR_FOB_BUILDING_IMPOSSIBLE", floor KPLIB_distance_base, floor _distFob], true, 3] call KPLIB_fnc_hint;
            };

            // Check for nearest sector
            private _index = KPLIB_sectors_all findIf {((markerPos _x) distance2D _target) < KPLIB_distance_sector};
            if (_index >= 0) exitWith {
                private _distSector = _target distance (markerPos ([KPLIB_distance_sector, getPosATL _target] call KPLIB_fnc_getNearestSector));
                [format [localize "STR_FOB_BUILDING_IMPOSSIBLE_SECTOR", floor KPLIB_distance_sector, floor _distSector], true, 3] call KPLIB_fnc_hint;
            };

            // Check if there is a FOB in airport area
            private _fobInAirport = if (count KPLIB_sectors_airport < 1) then {false} else {
                private _inAirport = KPLIB_sectors_airport findIf {_target inArea _x};
                if (_inAirport >= 0) then {
                    private _airportArea = KPLIB_sectors_airport # _index;
                    KPLIB_player_fobs findIf {_x inArea _airportArea} >= 0
                };
            };

            if (_fobInAirport) exitWith {
                [localize "STR_FOB_BUILDING_IMPOSSIBLE_FOB_IN_AIRPORT", true, 3] call KPLIB_fnc_hint;
            };

            // Check if terrain is relatively flat
            if (((ASLToAGL (getPosASL _target)) isFlatEmpty [-1, -1, KPLIB_terrainGradient_fob, 10, 0]) isEqualTo []) exitWith {
                [localize "STR_FOB_BUILDING_IMPOSSIBLE_GRADIENT", true, 3] call KPLIB_fnc_hint;
            };
        },
        [], 4, -752, false, false
    ] call BIS_fnc_holdActionAdd;
    true
};

false