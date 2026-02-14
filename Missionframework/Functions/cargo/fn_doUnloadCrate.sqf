/*
	File: fn_doUnloadCrate.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 21/10/2025
	Last update: 16/01/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Unload crate from transport vehicle and directly attach it to the player

	Parameters:
		_transport - transport vehicle to unload crate [OBJECT, defaults to objNull]
        _player - player that wants to unload cargo [OBJECT, defaults to player]

	Return:
		[BOOL]
*/

params[["_transport", objNull, [objNull]], ["_player", player, [objNull]]];

if (isNull _transport) exitWith {false};

private _cargoLoaded = _transport getVariable ["KPLIB_CARGO_loadedCargo", []];
if (_cargoLoaded isEqualTo []) exitWith {false};

// Get the last element always
private _crate = _cargoLoaded deleteAt (count _cargoLoaded - 1);
_transport allowDamage false; 

// Carry
_crate attachTo [_player, [0, 2, 1]];
["KPLIB_crateCollisionChange", [_crate, false]] call CBA_fnc_globalEventJIP;
_crate setVariable ["KPLIB_beignCarried", true, true];
_player setVariable ["KPLIB_carriedObject", _crate];

// Drop crate action
_player addAction [
	["<t color='#FFFF00'>", localize "STR_ACTION_CRATE_DROP", "</t>"] joinString "",
	{
		params ["_player", "_caller", "_actionId", "_arguments"];
		private _crate = _player getVariable ["KPLIB_carriedObject", objNull];

		// prevent players from putting crates inside vehicles
		private _crateSize = sizeOf typeOf _crate * 1.5;
		private _nearObjects = (_crate nearEntities [["CAManBase", "Air", "Car", "Tank"], _crateSize]) - [_crate, _player];
		if (_nearObjects isNotEqualTo []) exitWith {
			[format [localize "STR_PLACEMENT_IMPOSSIBLE", count _nearObjects, _crateSize toFixed 0], true, 3] call KPLIB_fnc_hint
		};

		_player setVariable ["KPLIB_carriedObject", nil];
		_crate setVariable ["KPLIB_beignCarried", false, true];
		["KPLIB_crateCollisionChange", [_crate, true]] call CBA_fnc_globalEventJIP;
		detach _crate;
		_crate awake true;
		_crate enableRopeAttach true;
		_player removeAction _actionId; // Remove action from player
	},
	nil,
	-504,
	true,
	false,
	"",
	toString {
		alive _originalTarget &&
		{!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])} && {isNull (objectParent _originalTarget)} && {!isNull (_originalTarget getVariable ["KPLIB_carriedObject", objNull])}
	}
];

_transport setVariable ["KPLIB_CARGO_nextOffSet", ((_transport getVariable ["KPLIB_CARGO_nextOffSet", 0]) - 1) max 0, true];

[{["KPLIB_addActionsCrate", _this] call CBA_fnc_globalEventJIP;}, _crate , 1] call CBA_fnc_waitAndExecute;

[localize "STR_CRATE_UNLOADED", false, 2] call KPLIB_fnc_hint;

_transport allowDamage true; 

_transport setVariable ["KPLIB_CARGO_loadedCargo", _cargoLoaded, true];

// Remove mass
private _crateValue = _crate getVariable ["KPLIB_crateValue", 0];
private _oldMass = getMass _transport;
private _newMass = _oldMass - _crateValue;
_transport setMass _newMass;

// Enable ViV again if the var is empty
if (_transport getVariable ["KPLIB_CARGO_loadedCargo", []] isEqualTo []) then {_transport enableVehicleCargo true;};

true