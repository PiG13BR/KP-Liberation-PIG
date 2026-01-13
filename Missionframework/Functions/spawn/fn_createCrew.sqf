/*
	File: fn_createCrew.sqf
	Author: PiG13BR - https://github.com/PiG13BR/
	Date: 26/08/2024 
	Last Update: 07/12/2025 
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Creates vehicle crew based on preset configuration only
		Uses default createVehicleCrew command for UAV units
	
	Parameter(s):
		_vehicle - Vehicle to add crew [OBJECT, defaults to objNull]
		_side - crew side: KPLIB_side_enemy or KPLIB_side_player [SIDE, defaults to KPLIB_side_enemy]
		_grp - group to add crews in [GROUP, defaults to grpNull]

	Returns:
		Crew group
*/

params[
	["_vehicle", objNull, [objNull]],
	["_side", KPLIB_side_enemy, [sideUnknown]],
	["_grp", grpNull, [grpNull]]
];

if (isNull _vehicle) exitWith {["Vehicle is null"] call BIS_fnc_error;};

// If unit is UAV, use createVehicleCrew instead
if (unitIsUAV _vehicle) exitWith {
	_grp = _side createVehicleCrew _vehicle;
	_grp // Return
};

private _typeCrew = "";

switch (_side) do {
	case KPLIB_side_enemy : {
		if (_vehicle isKindOf "Air") then {
			// Air
			if (_vehicle isKindOf "Helicopter") then {
				_typeCrew = KPLIB_o_heliPilot;
			} else {
				_typeCrew = KPLIB_o_jetPilot;
			};
		} else {
			// Land
			if ((_vehicle isKindOf "Tank") || {_vehicle isKindOf "Wheeled_APC_F"}) then {
				_typeCrew = KPLIB_o_crewman;
			} else {
				// Sea
				if (_vehicle isKindOf "Ship") then {
					_typeCrew = KPLIB_o_boatCrew
				} else {
					// Last option
					_typeCrew = KPLIB_o_rifleman;
				};
			}
		};	
	};
	case KPLIB_side_player : {
		if (_vehicle isKindOf "Air") then {
			_typeCrew = KPLIB_b_heliPilotUnit;
		} else {
			if ((_vehicle isKindOf "Tank") || {_vehicle isKindOf "Wheeled_APC_F"}) then {
				_typeCrew = KPLIB_b_crewUnit;
			} else {
				_typeCrew = KPLIB_b_crewStatic;
			}
		}
	}
};

if (_typeCrew isEqualTo "") exitWith {["No class provided"] call BIS_fnc_error;};

// Get all available sets from the vehicle
private _seats = fullCrew [_vehicle, "", true]; 
/*
	Return example:
	[
	[<NULL-object>,"driver",-1,[],false,<NULL-object>,"$STR_POSITION_DRIVER"],
	[<NULL-object>,"gunner",-1,[0],false,<NULL-object>,"$STR_POSITION_GUNNER"],
	[<NULL-object>,"commander",-1,[0,0],false,<NULL-object>,"$STR_POSITION_COMMANDER"]
	]
*/

// Create group if is null
if (isNull _grp) then {
	_grp = createGroup [_side, true];
};

{	
	_x params[
		"_checkSeat", // Unit - For empty seat must retun <NULL-object>
		"_role", // Role - "driver", "gunner", "turret", "cargo", "commander"
		"_index", // Index - "-1", "0", "1", etc.
		"_turretPath" // Turret Path - [number]
	];
	private _crew = objNull;

	// If it's empty
	if (isNull _checkSeat) then {
		switch (_role) do {
			case "driver" : {
				if !(_vehicle isKindOf "staticWeapon") then {
					_crew = [_typeCrew, getPosATL _vehicle, _grp] call KPLIB_fnc_createManagedUnit;
					_crew assignAsDriver _vehicle;
					_crew moveInDriver _vehicle;
				}
			};
			case "gunner" : {
				_crew = [_typeCrew, getPos _vehicle, _grp] call KPLIB_fnc_createManagedUnit;
				_crew assignAsGunner _vehicle;
				_crew moveInGunner _vehicle;
			};
			case "commander" : {
				_crew = [_typeCrew, getPos _vehicle, _grp] call KPLIB_fnc_createManagedUnit;
				_crew assignAsCommander _vehicle;
				_crew moveInCommander _vehicle;
			};
			
			case "turret" : {
				//Cargo index -1 = copilot (vanilla models)
				if (((_vehicle isKindOf "Air") && (_index == -1)) || {_vehicle isKindOf "staticWeapon"}) then {
					_crew = [_typeCrew, getPosATL _vehicle, _grp] call KPLIB_fnc_createManagedUnit;
					_crew assignAsTurret [_vehicle, _turretPath];
					_crew moveInTurret [_vehicle, _turretPath];
				};
			};
			case "cargo" : {
				// Static weapons (fill up)
				if (_vehicle isKindOf "staticWeapon") then {
					_crew = [_typeCrew, getPosATL _vehicle, _grp] call KPLIB_fnc_createManagedUnit;
					_crew assignAsCargo _vehicle;
					_crew moveInCargo _vehicle;
				}
			};
		};

		// Check if the vehicle crew spawned is in the vehicle, if not, delete it
		if !(_crew in (crew _vehicle)) then {
			deleteVehicle _crew;
		};
	}
}forEach _seats;

// Return group
_grp