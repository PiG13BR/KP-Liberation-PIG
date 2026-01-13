/*
    File: fn_despawnObject.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 18/09/2024 
    Last Update: 22/12/2025 
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handles despawn of an object using CBA's PFH. it will wait until any player side units are far enough to delete the object.

    Parameter(s):
        _veh - Object to despawn [OBJECT, defaults to objNull]

    Returns:
        -
*/
params[
	["_veh", objNull, [objNull]]
];

if (isNull _veh) exitWith {};
if (_veh getVariable ["KPLIB_inDespawner", false]) exitWith {};
_veh setVariable ["KPLIB_inDespawner", true];

[{
	_veh = (_this # 0);
	_handler = (_this # 1);

	if (_veh getVariable ["KPLIB_captured", false]) exitWith {[_handler] call CBA_fnc_removePerFrameHandler;};
	
	private _near_units = false;
	{		
		if ((_x distance _veh) < 1500) exitWith { _near_units = true };
	} forEach (allUnits select {(alive _x) && (side _x == KPLIB_side_player)});

	private _despawn = call {
		if ({ alive _x } count crew _veh > 0) exitWith {false};
		if (_near_units) exitWith {false};
		true;
	};

	if (_despawn) exitWith {
		[_veh] call KPLIB_fnc_cleanOpforVehicle; 
		[_handler] call CBA_fnc_removePerFrameHandler; 
	};
	
}, 60, _veh] call CBA_fnc_addPerFrameHandler;
