/* 
	File: fn_artilleryFobTargeting.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 28/04/2024 
	Last Update: 23/11/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Find a FOB with players inside of it (meaning for the enemy "an active FOB") to do a fire mission (try each 5-10 min + chance)
	
	Parameter(s):
		-

	Return(s):
		-
*/

// Random sleep for PFH
private _sleeptime =  (300 + (random 300)) / (([] call KPLIB_fnc_getOpforFactor) * KPLIB_param_aggressivity);

[{ 
	params ["_sleepTime"];
	[_sleeptime] call KPLIB_fnc_artilleryFobTargetingPFH;
}, _sleeptime, _sleeptime] call CBA_fnc_waitAndExecute;

