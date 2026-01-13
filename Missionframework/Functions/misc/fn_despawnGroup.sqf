/*
    File: fn_despawnGroup.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 18/09/2024 
    Last Update: 03/12/2025 
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handles despawn of a group using CBA's PFH. it will wait until any player side units are far enough to delete the group.

    Parameter(s):
        _group - group to despawn [GROUP, defaults to grpNull]

    Returns:
        -
*/
params[
	["_group", grpNull, [grpNull]]
];

if (_group isEqualTo grpNull) exitWith {};

if (_group getVariable ["KPLIB_inDespawner", false]) exitWith {};
_group setVariable ["KPLIB_inDespawner", true];

[{
	_group = _this # 0;
	_handler = _this # 1;
	
	private _leader = leader _group;
	if (isNull _leader) exitWith {[_handler] call CBA_fnc_removePerFrameHandler;}; // No existent leader = no alive members for this group

	private _near_units = false;
	{	
		private _blufor_unit = _x;
		{
			if ((_blufor_unit distance _x) < 1200) exitWith { _near_units = true };
		}forEach units _group;
		
	} forEach (allUnits select {(alive _x) && (side _x == KPLIB_side_player)});

	private _despawn = call {
		if (_near_units) exitWith {false};
		true;
	};

	if (_despawn) exitWith { 
		
		{
			if (isNull objectParent _x) then {
				deleteVehicle _x
			} else {
				(objectParent _x) deleteVehicleCrew _x
			};
		}forEach units _group;

		_group setVariable ["KPLIB_inDespawner", nil];
		[_handler] call CBA_fnc_removePerFrameHandler;
	};
}, 60, _group] call CBA_fnc_addPerFrameHandler;
