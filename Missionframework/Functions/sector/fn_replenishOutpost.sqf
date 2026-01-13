/*
    Replenish outpost if there is an enemy military sector within range.
    Basically by removing it from the players captured sectors list so it can be activated again.
*/

params["_outpost"];

private _base = [markerPos _outpost, KPLIB_side_enemy, KPLIB_range_replenishRadius] call KPLIB_fnc_getNearestBase;

if !(isNil "_base") then {
    // Now this outpost can spawn assets again
    KPLIB_sectors_player deleteAt (KPLIB_sectors_player find _outpost);
};
