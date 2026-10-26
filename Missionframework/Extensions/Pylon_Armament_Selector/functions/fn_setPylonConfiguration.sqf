/*
	File: fn_setPylonConfiguration.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 15/06/2026
	Last Update: 20/07/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Apply the selected ammo on the pylon of the aircraft

	Parameter(s):
		_aircraft - aircraft to remove remnant weapons [OBJECT]
        _pylonIndex - pylon index [NUMBER]
        _magazine - magazine to add to pylon [STRING]
        _turret - target turret to add the magazine [ARRAY, defaults to gunner turret [0]]
	
	Returns:
		-
*/
params["_aircraft", "_pylonIndex", "_magazine", ["_turret", [0]], ["_lbIndex", -1, [0]]];

if (_lbIndex == -1) then {_lbIndex = _pylonIndex - 1;};

if (!isNil "PIG_PAS_airLoadout") then {
	PIG_PAS_airLoadout set [_lbIndex, [_magazine, _turret]];
};

[_aircraft, _pylonIndex, _turret] call KPLIB_fnc_removeTurretWeapons;

_aircraft setPylonLoadout [_pylonIndex, _magazine, false, _turret];