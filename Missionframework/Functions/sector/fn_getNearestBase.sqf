/*
    File: fn_getNearestBase.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 20/12/2025
    Last Update: 20/12/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Gets nearest military marker occupied by given side inside given radius from given position.

    Parameter(s):
        _pos    - Position from which to look for the nearest military base [POSITION, defaults to [0, 0, 0]]
        _side   - Side of owner for nearest military base                   [SIDE, defaults to KPLIB_side_enemy]
        _radius - Radius in which to look for the military base             [NUMBER, defaults to 1000]

    Returns:
        Marker of military base [STRING]
*/

params [
    ["_pos", [0, 0, 0], [[]], [2, 3]],
    ["_side", KPLIB_side_enemy, [sideEmpty]],
    ["_radius", 1000, [0]]
];

private _bases = [KPLIB_sectors_military select {_x in KPLIB_sectors_player}, KPLIB_sectors_military - KPLIB_sectors_player] select (_side == KPLIB_side_enemy);
_bases = (_bases apply {[(markerPos _x) distance2d _pos, _x]}) select {(_x select 0) <= _radius};
_bases sort true;

(_bases select 0) select 1