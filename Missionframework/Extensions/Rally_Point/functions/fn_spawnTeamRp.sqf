/*
    File: fn_spawnTeamRP.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 06/11/2025
    Last update: 09/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns a team rally point

    Parameter(s)
        _commander - commander who is going to spawn rally point object [OBJECT, defaults to player]
        _model - rally point object classname to spawn [STRING, defaults to "Land_TentSolar_01_folded_bluewhite_F"]

    Returns:
        -
*/
params[["_commander", player, [objNull]], ["_model", "Land_TentSolar_01_folded_bluewhite_F", [""]]];

if (isNull _player) exitWith {};

private _rallyPoint = [_commander] call KPLIB_fnc_getTeamRP;
if (!isNull _rallyPoint) then {
    // Delete previous rally point
    deleteVehicle _rallyPoint;
};

_rallyPoint = createVehicle [_model , getPosATL _commander, [], 0, "CAN_COLLIDE"];

missionNamespace setVariable ["KPLIB_RP_teamRallyPoint", _rallyPoint, true]; // Save rally point

// If hit, gets deleted
_rallyPoint addEventHandler ["Hit", {
	params ["_unit"];
    [] call KPLIB_fnc_deleteTeamRP;
    _unit removeEventHandler [_thisEvent, _thisEventHandler];
}];

// If commander gets killed or if the leader changes, delete RP
_commander addEventHandler ["Killed", {
	params ["_unit"];

    [] call KPLIB_fnc_deleteTeamRP;
    _unit removeEventHandler [_thisEvent, _thisEventHandler];
}];

// Create global marker
_sqRPmk = createMarker ["Team_RallyPoint", getPosASL _rallyPoint];
_sqRPmk setMarkerType "loc_LetterT";
_sqRPmk setMarkerText "Team Rally Point";

[localize "STR_RALLYPOINT_DEPLOYED", false, 5, 2] call ace_common_fnc_displayText;

// Rally Point deploy cooldown / RP Auto deletion
if (PIG_RallyPoint_Setting_Cooldown > 0) then {
    missionNamespace setVariable ["KPLIB_RP_teamCooldown", true, true];
    [{
        [] call KPLIB_fnc_deleteTeamRP;
        missionNamespace setVariable ["KPLIB_RP_teamCooldown", false, true];
    }, _group, (60 * PIG_RallyPoint_Setting_Cooldown)] call CBA_fnc_waitAndExecute;
};