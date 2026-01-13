/*
	File: fn_addBushAction.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 07/11/2025
	Last Update: 28/11/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Add clear bush action to player entity

	Parameter(s):
		_player - player to add the action [OBJECT, defaults to player]
	
	Returns:
		-
*/

params[["_player", player, [objNull]]];

if (isNull _player || {!isPlayer _player}) exitWith {};

_action = [
    "ClearBushAction", 
    "Derrubar", 
    "\a3\modules_f\data\hideterrainobjects\icon32_ca.paa", 
    {[{_this call KPLIB_fnc_clearBush}, _player] call CBA_fnc_execNextFrame}, 
    {_player call KPLIB_fnc_canClearBush}, 
    {}, 
    [], 
    [0, 0, 0], 
    100
] call ace_interact_menu_fnc_createAction;

[_player, 1, ["ACE_SelfActions", "ACE_Equipment"], _action] call ace_interact_menu_fnc_addActionToObject;