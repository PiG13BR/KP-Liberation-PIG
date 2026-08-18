/*
    File: fn_createFob.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 13/04/2026
    Last Update: 23/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Creates/notify a new FOB

    Parameter(s):
       _newFobPos - new fob position [POSITION, defaults to [0,0,0]]
       _create - create a new Fob [BOOL, defaults to false]

    Returns:
        Function reached the end [BOOL]
*/

if (!isServer) exitWith {false};

params [
    ["_newFobPos", [0,0,0], [[]]], 
    ["_create", false, [FALSE]]
];


if (_create) then {
    _newFobPos = [(_newFobPos select 0) + 15, (_newFobPos select 1) + 2, 0];
    [_newFobPos, 20, true] call KPLIB_fnc_createClearance;
    private _fobBuilding = KPLIB_b_fobBuilding createVehicle _newFobPos;
    _fobBuilding setpos _newFobPos;
    _fobBuilding setVectorUp [0,0,1];
    [_fobBuilding] call KPLIB_fnc_addObjectInit;
};

spawn KPLIB_fnc_doSave;

[{
    // Find empty arrays in KPLIB_player_fobs
    private _index = KPLIB_player_fobs find [0,0,0];
    if (_index >= 0) then {
        // Empty array found, replace it
        KPLIB_player_fobs set [_index, _this];
    } else {
        // Pushback instead
        KPLIB_player_fobs pushback _this;
    };
    publicVariable "KPLIB_player_fobs";

     [_this, 0] remoteExec ["remote_call_fob"];

    // Update markers
    ["KPLIB_updateBaseMarkers", []] call CBA_fnc_serverEvent;
}, _newFobPos, 3] call CBA_fnc_waitAndExecute;

stats_fobs_built = stats_fobs_built + 1;

true