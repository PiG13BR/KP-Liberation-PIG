#include "..\defines.hpp"
/*
    File: fn_addRallypointAction.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 27/10/2025
    Last update: 11/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Add rally point action

    Parameter(s)
        _player - player who is going to recieve the action [OBJECT, defaults to player]

    Returns:
        -
*/

params[["_player", player, [objNull]]];

if (isNull _player) exitWith {};
if !(KPLIB_ace) exitWith {};

if (_player != ([] call KPLIB_fnc_getCommander)) then {
    // Squad Leaders Rally Point
    private _spawnRPAction = [
        "PIG_RP_SquadSpawnRPAction", 
        "Squad Rally Point", 
        "", 
        {  
            // Exit if cooldown is activated for this group
            if ((group _player) getVariable ["KPLIB_RP_squadCooldown", false]) exitWith {[localize "STR_RALLYPOINT_DEPLOY_FAILED", true, 5, 2] call ace_common_fnc_displayText;};

            // Check for nearby enemies
            if ((ASLToAGL (getPosATL _player) nearEntities [["CAManBase", "LandVehicle", "Air"], MIN_DIST_TO_DEPLOY]) findIf {(alive _x) && {[_x] call KPLIB_fnc_ace_isAwake} && {side _x == KPLIB_side_enemy}} >= 0) exitWith {[localize "STR_RALLYPOINT_DEPLOY_FAILED", true, 5, 2] call ace_common_fnc_displayText};
            private _isLowered = weaponLowered _player;
            if (!_isLowered) then {_player action ["WeaponOnBack", _player];}; // Lower weapon
            
            [_player] call ace_common_fnc_goKneeling; // Kneel
            "ace_gestures_regroup" call ace_gestures_fnc_playsignal; // Play ace regroup signal

            // Progress Bar
            [5, [_player, _isLowered], 
                {
                    (_this#0) params ["_player", "_isLowered"]; 
                    
                    [_player] call KPLIB_fnc_spawnSquadRP;
                    if (!_isLowered) then {_player action ["WeaponInHand", _player];}
                }, 
                {[localize "STR_RALLYPOINT_DEPLOY_CANCELLED", true, 5, 2] call ace_common_fnc_displayText}, 
                localize "STR_RALLYPOINT_DEPLOYING_PROGRESS"
            ] call ace_common_fnc_progressBar
        }, 
        {
            private _requiredItems = ((parseSimpleArray PIG_RallyPoint_Setting_RequiredItems) apply {toLowerANSI _x});
            private _items = ((assignedItems _player) + (backpackitems _player) + (uniformItems _player) + (vestItems _player)) + [backpack _player];
            
            alive _player && 
            {leader _player == _player} && 
            {({alive _x && {_x in (units group _player)}} count((getPos _player) nearEntities ["CAManBase", 7]) - [_player]) >= PIG_RallyPoint_Setting_Members} &&
            {(_requiredItems isNotEqualTo [] && {_items findIf {(toLowerANSI _x) in _requiredItems} >= 0}) || {_requiredItems isEqualTo []}}
        },
        {}, 
        [], 
        [0, 0, 0], 
        100
    ] call ace_interact_menu_fnc_createAction;

    [_player, 1, ["ACE_SelfActions"], _spawnRPAction] call ace_interact_menu_fnc_addActionToObject;

} else {
    // Commander/Team Rally Point
    private _spawnRPAction = [
        "PIG_RP_TeamSpawnRPAction", 
        "Team Rally Point", 
        "", 
        {
            // Exit if cooldown is activated
            if (missionNamespace getVariable ["KPLIB_RP_teamCooldown", false]) exitWith {[localize "STR_RALLYPOINT_DEPLOY_FAILED", true, 5, 2] call ace_common_fnc_displayText;};

            // Check for nearby enemies
            if ((ASLToAGL (getPosATL _player) nearEntities [["CAManBase", "LandVehicle", "Air"], MIN_DIST_TO_DEPLOY]) findIf {(alive _x) && {[_x] call KPLIB_fnc_ace_isAwake} && {side _x == KPLIB_side_enemy}} >= 0) exitWith {[localize "STR_RALLYPOINT_DEPLOY_FAILED", true, 5, 2] call ace_common_fnc_displayText};
            private _isLowered = weaponLowered _player;
            if (!_isLowered) then {_player action ["WeaponOnBack", _player];}; // Lower weapon
            
            [player] call ace_common_fnc_goKneeling; // Kneel
            "ace_gestures_regroup" call ace_gestures_fnc_playsignal; // Play ace regroup signal

            // Progress Bar
            [5, [_player, _isLowered], 
                {
                    (_this#0) params ["_player", "_isLowered"]; 
                    
                    [_player] call KPLIB_fnc_spawnTeamRP; 
                    if (!_isLowered) then {_player action ["WeaponInHand", _player];}
                }, 
                {[localize "STR_RALLYPOINT_DEPLOY_CANCELLED", true, 5, 2] call ace_common_fnc_displayText}, 
                localize "STR_RALLYPOINT_DEPLOYING_PROGRESS"
            ] call ace_common_fnc_progressBar
        }, 
        {
            private _requiredItems = ((parseSimpleArray PIG_RallyPoint_Setting_RequiredItems) apply {toLowerANSI _x});
            private _items = ((assignedItems _player) + (backpackitems _player) + (uniformItems _player) + (vestItems _player)) + [backpack _player];

            alive _player && 
            {leader _player == _player} && 
            {({alive _x && {side _x == side _player} && {leader _x == _x}} count((getPos _player) nearEntities ["CAManBase", 7]) - [_player]) >= 2} &&
            {(_requiredItems isNotEqualTo [] && {_items findIf {(toLowerANSI _x) in _requiredItems} >= 0}) || {_requiredItems isEqualTo []}}
        },
        {}, 
        [], 
        [0, 0, 0], 
        100
    ] call ace_interact_menu_fnc_createAction;

    [_player, 1, ["ACE_SelfActions"], _spawnRPAction] call ace_interact_menu_fnc_addActionToObject;
};