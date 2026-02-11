/*
	File: fn_doLoadCrate.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 21/10/2025
	Last update: 11/02/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Load crate to transport vehicle

	Parameters:
		_cargo - cargo to load to the transport vehicle [OBJECT, defaults to objNull]

	Return:
		[BOOL]
*/

params[["_cargo", objNull, [objNull]], ["_transport", objNull, [objNull]]];

if (isNull _cargo) exitWith {false};

// Find nearest transport
if (isNull _transport) then {
	private _madeViV = (_cargo nearEntities [KPLIB_transport_classes, 15]) select {_x getVariable ["KPLIB_CARGO_isTransportVeh", false]};
	_madeViV =  _madeViV apply {[_x, _x distance _cargo]};
	_transport = (_madeViV # 0) # 0;
};

if (isNil "_transport") exitWith {false}; // Transport is nil

private _offsets = _transport getVariable ["KPLIB_CARGO_offSets", []];
if (count(_transport getVariable ["KPLIB_CARGO_loadedCargo", []]) isEqualTo (count(_offsets))) exitWith {[localize "STR_CRATE_CANTLOAD", true, 3] call KPLIB_fnc_hint; false}; // It's full

// Get off-sets
private _lastOffset = _offsets # (_transport getVariable ["KPLIB_CARGO_nextOffSet", 0]);
_cargo attachTo [_transport, _lastOffset];

_transport setVariable ["KPLIB_CARGO_nextOffSet", (_transport getVariable ["KPLIB_CARGO_nextOffSet", 0]) + 1, true];
private _loadedCargo = _transport getVariable ["KPLIB_CARGO_loadedCargo", []];
_loadedCargo pushBack _cargo; // Pushback the last object loaded
_transport setVariable ["KPLIB_CARGO_loadedCargo", _loadedCargo, true];
_cargo enableRopeAttach false;

removeAllActions _cargo; // Remove all actions (add them back on unload)

[localize "STR_CRATE_LOADED", false, 2] call KPLIB_fnc_hint;

// Add mass
private _crateValue = _crate getVariable ["KPLIB_crateValue", 0];
private _oldMass = getMass _transport;
private _newMass = _oldMass + _crateValue;
_transport setMass _newMass;

// Disable ViV
_transport enableVehicleCargo false;

true