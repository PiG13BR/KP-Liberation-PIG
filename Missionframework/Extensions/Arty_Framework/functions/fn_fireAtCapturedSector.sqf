/* 
	File: fn_fireAtCapturedSector.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 07/11/2025
	Last Update: 18/12/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Fire artillery at captured sector
	
	Parameter(s):
		_sectorToFire - sector to fire upon [STRINGS, defaults to ""]

	Return(s):
		-
*/

params[["_sectorToFire", "", [""]]];

if (_sectorToFire isEqualTo "") exitWith {};

if (!isNil "KPLIB_o_artilleryUnits" && {KPLIB_o_artilleryUnits isNotEqualTo []}) then {
    //sleep (10 + (random 1)) / (([] call KPLIB_fnc_getOpforFactor) * KPLIB_param_aggressivity);
    private _delay = (10 + (random 1)) / (([] call KPLIB_fnc_getOpforFactor) * KPLIB_param_aggressivity);
    [
        {
            _this params ["_sectorToFire"];
            
            private _chance = -1; // Default chance is -1

            // Call artillery if players captured a military or a tower sector 
            switch (true) do {
                case (_sectorToFire in KPLIB_sectors_military) : {
                    _chance = (25 + KPLIB_enemyReadiness * ([] call KPLIB_fnc_getOpforFactor)) min 75;
                };
                case (_sectorToFire in KPLIB_sectors_tower) : {
                    _chance = (10 + KPLIB_enemyReadiness * ([] call KPLIB_fnc_getOpforFactor)) min 50;
                };
                default {_chance = -1}; // Don't fire at cities and capitals
            };

            // ---------------------------------------------------------- FIRE MISSION
            if ((random 100) <= _chance) then {
                _targetPos = getMarkerPos _sectorToFire;
                _ammoType = [["HE", (3 + (random 7))], ["CLUSTER", (2 + (random 1))]] selectRandomWeighted [0.8, 0.2];
                _ammoType params ["_shell", "_rounds"];

                if (sunOrMoon == 0) then {
                    private _artyReturns = [_targetPos, 10, "FLARE", 1] call KPLIB_fnc_fireArtillery;
                    _artyReturns params ["_fired", "_artyElements"];
                    if (_fired) then {
                        private _eta = _artyElements select 1; // Gets the shell's ETA
                        //sleep _eta + 5;
                        [
                            {
                                _this params ["_targetPos", "_shell", "_rounds"];
                                [_targetPos, KPLIB_range_sectorCapture, _shell, _rounds] call KPLIB_fnc_fireArtillery;
                            }, 
                            [_targetPos, _shell, _rounds], 
                            _eta + 5
                        ] call CBA_fnc_waitAndExecute;
                    } else {
                        // No flare, fire directly
                        [_targetPos, KPLIB_range_sectorCapture, _shell, _rounds] call KPLIB_fnc_fireArtillery;
                    }		
                } else {
                    [_targetPos, KPLIB_range_sectorCapture, _shell, _rounds] call KPLIB_fnc_fireArtillery;
                }
            };
        }, 
        [_sectorToFire], 
        _delay
    ] call CBA_fnc_waitAndExecute;
};