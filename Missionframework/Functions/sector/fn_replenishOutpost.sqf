/*
	File: fn_replenishOutpost.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 20/12/2025
	Last Update: 13/02/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Replenish outpost if there is an enemy military sector within range.
        Basically by removing it from the players captured sectors list so it can be activated again.

	Parameter(s):
		_outpost - outpost sector [STRING]
	
	Returns:
		-
*/

params["_outpost"];

if (KPLIB_sectors_fob findIf {((markerPos _outpost) distance2D _x) < 500} >= 0) exitWith {}; // Exit if there is a FOB nearby

private _base = [markerPos _outpost, KPLIB_side_enemy, KPLIB_range_replenishRadius] call KPLIB_fnc_getNearestBase;

if !(isNil "_base") then {
    // Now this outpost can spawn assets again
    KPLIB_sectors_player deleteAt (KPLIB_sectors_player find _outpost);
};
