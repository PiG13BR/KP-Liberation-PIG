/*
	File: fn_checkAirLoadout.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 13/10/2026
	Last Update: 13/10/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Check air preset if custom preset is available

	Parameter(s):
		_aircraft - aircraft object to check loadout [OBJECT]
	
	Returns:
		-
*/
params ["_aircraft"];

if (count PIG_PAS_customPreset > 0) then {
    private _checkPreset = PIG_PAS_customPreset apply {toLowerANSI _x};
    {
        private _pylonIndex = _x # 0;
        private _turret = _x # 2;
        private _magazine = _x # 3;

        if !((toLowerANSI _magazine) in _checkPreset) then {
            ["PAS_setPylonArmament", [_aircraft, _pylonIndex, "", _turret]] call CBA_fnc_globalEvent;
        };
    }forEach (getAllPylonsInfo _aircraft);
};