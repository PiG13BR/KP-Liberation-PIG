/*
    File: fn_spawnSquadRP.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 27/10/2025
    Last update: 12/02/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns a squad/group rally point

    Parameter(s)
        _leader - leader who is going to spawn rally point object [OBJECT, defaults to player]
        _model - rally point object classname to spawn [STRING, defaults to "Land_TentSolar_01_folded_bluewhite_F"]

    Returns:
        -
*/
params[["_leader", player, [objNull]], ["_model", "Land_TentSolar_01_folded_olive_F", [""]]];

if (isNull _player) exitWith {};
private _group = (group _leader);

private _rallyPoint = [group _leader] call KPLIB_fnc_getSquadRP;
if (!isNull _rallyPoint) then {
    // Delete previous rally point
    deleteVehicle _rallyPoint;
};

_rallyPoint = createVehicle [_model , getPosATL _leader, [], 0, "CAN_COLLIDE"];

_group setVariable ["KPLIB_RP_squadRallyPoint", _rallyPoint, true]; // Save rally point object
_rallyPoint setVariable ["KPLIB_RP_rallyPointSquad", _group, true]; // Save original group

// If hit, delete RP
_rallyPoint addEventHandler ["Hit", {
	params ["_object"];
    private _grp = _object getVariable ["KPLIB_RP_rallyPointSquad", _grpNull];
    [ _grp, _object] call KPLIB_fnc_deleteSquadRP;
    _unit removeEventHandler [_thisEvent, _thisEventHandler];
}];

// If leader gets killed, delete RP
_leader addEventHandler ["Killed", {
	params ["_unit"];

    [group _unit] call KPLIB_fnc_deleteSquadRP;
    _unit removeEventHandler [_thisEvent, _thisEventHandler];
}];

// if the leader changes, delete RP
_group addEventHandler ["LeaderChanged", {
	params ["_group"];

    [_group] call KPLIB_fnc_deleteSquadRP;
    _group removeEventHandler [_thisEvent, _thisEventHandler];
}];

// Check if unit left group, if so, delete rally point local marker
_group addEventHandler ["UnitLeft", {
	params ["_group", "_oldUnit"];
    private _rallyPoint = [_group] call KPLIB_fnc_getSquadRP;
    if (isNull _rallyPoint) exitWith {};
    if (leader _oldUnit == _oldUnit) then {[_group] call KPLIB_fnc_deleteSquadRP;};
    //["KPLIB_RP_squadDeleteMarker", [_rallyPoint], _oldUnit] call CBA_fnc_targetEvent;
    [_rallyPoint] remoteExecCall ["KPLIB_fnc_squadDeleteMarker", _oldUnit];
}];

// Check if unit joined group, if so, add rally point local marker
_group addEventHandler ["UnitJoined", {
	params ["_group", "_newUnit"];
    private _rallyPoint = [_group] call KPLIB_fnc_getSquadRP;
    if (isNull _rallyPoint) exitWith {}; 
    //["KPLIB_RP_squadCreateMarker", [_group, _rallyPoint], _newUnit] call CBA_fnc_targetEvent;
    [_group, _rallyPoint] remoteExecCall ["KPLIB_fnc_squadCreateMarker", _newUnit];
}];

//["KPLIB_RP_squadCreateMarker", [_group, _rallyPoint], _group] call CBA_fnc_targetEvent; // Create local marker
[_group, _rallyPoint] remoteExecCall ["KPLIB_fnc_squadCreateMarker", _group, true];

[localize "STR_RALLYPOINT_DEPLOYED", false, 5, 2] call ace_common_fnc_displayText;

// Rally Point deploy cooldown / RP Auto deletion
if (PIG_RallyPoint_Setting_Cooldown > 0) then {
    _group setVariable ["KPLIB_RP_squadCooldown", true, true];
    [{
        [_this] call KPLIB_fnc_deleteSquadRP;
        _this setVariable ["KPLIB_RP_squadCooldown", false, true]
    
    }, _group, (60 * PIG_RallyPoint_Setting_Cooldown)] call CBA_fnc_waitAndExecute;
};