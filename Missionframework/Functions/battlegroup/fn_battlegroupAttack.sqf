/*
    File: fn_battlegroupAttack.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
    Date: 07/11/2025
    Last Update: 13/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handle battlegroup attack movement

    Parameter(s):
        _grp - battlegroup group [GROUP, defaults to grpNull]
        _objPos - blufor objective [POSITION, defaults to [0,0,0]]

    Returns:
        [BOOL]
*/

params [
    ["_grp", grpNull, [grpNull]],
    ["_objPos", [0,0,0], [[]], [2,3]]
];

if (isNull _grp) exitWith {false};

if (_objPos isEqualTo [0,0,0]) then {
    _objPos = [getPos (leader _grp)] call KPLIB_fnc_getNearestBluforObjective;
};

// Resets group waypoint
{ deleteWaypoint _x } forEachReversed waypoints _grp;
{_x doFollow (leader _grp)} forEach units _grp;

_grp setCombatBehaviour "AWARE"; 
_grp setCombatMode "RED";

if (([_grp] call BIS_fnc_groupVehicles) isEqualTo []) then {
    // Inf

    // Start Assaulting
    _grp setVariable ["KPLIB_o_infantryIsAssaulting", true];
    
    [_grp, true] call lambs_wp_fnc_taskReset; {deleteWaypoint _x}forEachReversed (waypoints _grp);
    private _wp1 = _grp addWaypoint [_objPos, 25];
    _wp1 setWaypointType "SAD";
    _wp1 setWaypointFormation (selectRandom ["STAG COLUMN", "WEDGE", "VEE", "LINE", "ECH LEFT", "ECH RIGHT", "DIAMOND"]);

    /*
    if (KPLIB_LAMBS) then {
        // Check for allied forces inside sector
        if (({_x distance _objPos < KPLIB_range_sectorCapture * 1.4} count (allUnits select {side _x == KPLIB_side_player})) > 0) then {
            // Start Rushing (Lambs)
            _grp setVariable ["KPLIB_o_infantryIsAssaulting", false];

            [_grp, true] call lambs_wp_fnc_taskReset; {deleteWaypoint _x}forEachReversed (waypoints _grp);
            [_grp, KPLIB_range_sectorCapture * 1.4, 15, [], _objPos] spawn lambs_wp_fnc_taskRush;
        } else {
            // Start Assaulting
            _grp setVariable ["KPLIB_o_infantryIsAssaulting", true];
            
            [_grp, true] call lambs_wp_fnc_taskReset; {deleteWaypoint _x}forEachReversed (waypoints _grp);
            private _wp1 = _grp addWaypoint [_objPos, 25];
            _wp1 setWaypointType "SAD";
            _wp1 setWaypointFormation (selectRandom ["STAG COLUMN", "WEDGE", "VEE", "LINE", "ECH LEFT", "ECH RIGHT", "DIAMOND"]);
        };

         // PFH to change mode if there are players inside sector (only with lambs)
        [{
            params["_args", "_handle"];
            _args params ["_objPos", "_grp"];

            if ((units _grp) findIf {alive _x} < 0) exitWith {[_handle] call CBA_fnc_removePerFrameHandler;};

            // Check for allied forces inside sector
            if (({_x distance _objPos < KPLIB_range_sectorCapture * 1.4} count (allPlayers select {side _x == KPLIB_side_player})) > 0) then {
                // Change mode only if necessary
                systemChat str "ASSAULTING";
                
                if (_grp getVariable ["KPLIB_o_infantryIsAssaulting", false]) then {
                    // Rush
                    _grp setVariable ["KPLIB_o_infantryIsAssaulting", false];

                    [_grp, true] call lambs_wp_fnc_taskReset; {deleteWaypoint _x}forEachReversed (waypoints _grp);
                    [_grp, KPLIB_range_sectorCapture * 1.4, 15, [], _objPos] spawn lambs_wp_fnc_taskRush;
                };
            } else {
                // Change mode only if necessary
                if !(_grp getVariable ["KPLIB_o_infantryIsAssaulting", false]) then {
                    // Assault
                    _grp setVariable ["KPLIB_o_infantryIsAssaulting", true];
                    
                    [_grp, true] call lambs_wp_fnc_taskReset; {deleteWaypoint _x}forEachReversed (waypoints _grp);
                    private _wp1 = _grp addWaypoint [_objPos, 25];
                    _wp1 setWaypointType "SAD";
                    _wp1 setWaypointFormation (selectRandom ["STAG COLUMN", "WEDGE", "VEE", "LINE", "ECH LEFT", "ECH RIGHT", "DIAMOND"]);
                    //[_grp, _objPos] spawn lambs_wp_fnc_taskAssault;
                }
            }
        }, 60, [_objPos, _grp]] call CBA_fnc_addPerFrameHandler;
    } else {
        // Start Assaulting
        _grp setVariable ["KPLIB_o_infantryIsAssaulting", true];
        
        [_grp, true] call lambs_wp_fnc_taskReset; {deleteWaypoint _x}forEachReversed (waypoints _grp);
        private _wp1 = _grp addWaypoint [_objPos, 25];
        _wp1 setWaypointType "SAD";
        _wp1 setWaypointFormation (selectRandom ["STAG COLUMN", "WEDGE", "VEE", "LINE", "ECH LEFT", "ECH RIGHT", "DIAMOND"]);
    };
    */
} else {
    // Veh
    _waypoint = _grp addWaypoint [_objPos, 100];
    _waypoint setWaypointType "SAD";
};

true