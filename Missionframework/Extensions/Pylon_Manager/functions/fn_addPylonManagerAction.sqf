/*
	File: fn_addPylonManagerAction.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 20/10/2025
	Last Update: 22/11/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Add plyon manager action to all air vehicle classes

	Parameter(s):
		_aircraft - aircraft object to add pylon management [OBJECT]
	
	Returns:
		-
*/

params ["_aircraft"];

if !(isClass ((configOf _aircraft) >> "Components" >> "TransportPylonsComponent")) exitWith {};
if (hasPilotCamera _aircraft) then {
	if (!alive _aircraft) exitWith {};

	if (KPLIB_ace) then {
		private _action = [
			"PIG_PylonManager_Action", 
			"Pylon Manager", 
			"a3\weapons_f\mfd\ui\icon_place_cas_02_bomb_03_ca.paa", 
			{
				[_target] call KPLIB_fnc_createPylonManagerRsc
			}, 
			{
				PIG_PylonManager_Setting_Enabled && {_player == driver _target} && {speed _target < 1} && {!isEngineOn _target} && {_target nearEntities [PIG_PylonManager_RequireNearby, 50] isNotEqualTo []}
			}
		] call ace_interact_menu_fnc_createAction;

		[_aircraft, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
	};
};