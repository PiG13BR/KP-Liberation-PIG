/*
	File: fn_doParadropCrate.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 01/12/2025
	Last update: 11/01/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Paradrop crates from transport air vehicle

	Parameters:
		_transport - transport vehicle to paradrop crates [OBJECT, defaults to objNull]
        _player - player that pressed the paradrop action [OBJECT, defaults to player]

	Return:
		[BOOL]
*/

params[["_transport", objNull, [objNull]], ["_player", player, [objNull]]];

if (isNull _transport) exitWith {false};

private _cargoLoaded = _transport getVariable ["KPLIB_CARGO_loadedCargo", []];
if (_cargoLoaded isEqualTo []) exitWith {false};

private _crate = _cargoLoaded deleteAt (count _cargoLoaded - 1);

[_crate, _transport] spawn {
    params["_crate", "_transport"];

    // Create parachute function
    private _fnc_createParachute = {
        // Author: Bohemia Interactive, mharis001
        params ["_object", "_parachuteType", "_attachPos"];

        private _parachute = createVehicle [_parachuteType, _object, [], 0, "NONE"];
        _parachute setDir getDir _object;
        _parachute setVelocity [0, 0, -1];

        _object attachTo [_parachute, _attachPos];
    };

    private _backOffset = _transport getVariable ["KPLIB_CARGO_unloadOffset", 0];

    ["KPLIB_crateCollisionChange", [_crate, false]] call CBA_fnc_globalEventJIP;
    _transport allowDamage false;
    private _posOffset = (_transport getPos [_backOffset, getdir _transport]);
    private _posATL = +_posOffset;
    _posATL set [2, ((getPosATL _transport) # 2)];
    _crate setPosATL (_posATL vectorAdd [0,0,-3]);
    detach _crate;

    sleep 1;

    // Create parachute
    [_crate, "B_Parachute_02_F", [0, 0, 1]] call _fnc_createParachute;

    _crate enableRopeAttach true;

    [{["KPLIB_addActionsCrate", _this] call CBA_fnc_globalEventJIP;}, _crate , 1] call CBA_fnc_waitAndExecute;

    sleep 1;

    _transport allowDamage true;
    ["KPLIB_crateCollisionChange", [_crate, true]] call CBA_fnc_globalEventJIP;

    [
        {
            (isTouchingGround _this) || (getPosATL _this # 2 < 3)
        }, 
        {
            private _smoke =  createVehicle ["SmokeShellGreen", getPosATL _this];
            _smoke attachTo [_this];
        }, 
        _crate, 
        60, // Time out
        {
            // Time out code
            detach _this;
            private _smoke = createVehicle ["SmokeShellGreen", getPosATL _this];
            _smoke attachTo [_this];
        }
    ] call CBA_fnc_waitUntilAndExecute;

};

_transport setVariable ["KPLIB_CARGO_nextOffSet", ((_transport getVariable ["KPLIB_CARGO_nextOffSet", 0]) - 1) max 0, true];
_transport setVariable ["KPLIB_CARGO_loadedCargo", _cargoLoaded, true];

// Remove mass
private _crateValue = _crate getVariable ["KPLIB_crateValue", 0];
private _oldMass = getMass _transport;
private _newMass = _oldMass - _crateValue;
_transport setMass _newMass;

_crate