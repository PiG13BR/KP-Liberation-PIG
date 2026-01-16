/*
    File: fn_initSectors.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2020-04-29
    Last Update: 2026-01-14
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Sorts the placed sector markers to their category array.

    Parameter(s):
        NONE

    Returns:
        Function reached the end [BOOL]
*/

KPLIB_sectors_airSpawn = [];
KPLIB_sectors_all = [];
KPLIB_sectors_capital = [];
KPLIB_sectors_city = [];
KPLIB_sectors_factory = [];
KPLIB_sectors_military = [];
KPLIB_sectors_spawn = [];
KPLIB_road_spawn = [];
KPLIB_sectors_tower = [];
KPLIB_sectors_outpost = [];
KPLIB_sectors_filler = [];

{
    switch (true) do {
        case (_x find "bigtown" == 0): {KPLIB_sectors_capital pushBack _x; KPLIB_sectors_all pushBack _x;};
        case (_x find "capture" == 0): {KPLIB_sectors_city pushBack _x; KPLIB_sectors_all pushBack _x;};
        case (_x find "factory" == 0): {KPLIB_sectors_factory pushBack _x; KPLIB_sectors_all pushBack _x;};
        case (_x find "military" == 0): {KPLIB_sectors_military pushBack _x; KPLIB_sectors_all pushBack _x;};
        case (_x find "opfor_airspawn" == 0): {KPLIB_sectors_airSpawn pushBack _x;};
        case (_x find "opfor_point" == 0): {KPLIB_sectors_spawn pushBack _x;};
        case (_x find "opfor_spawn_road" == 0): {KPLIB_road_spawn pushBack _x;};
        case (_x find "tower" == 0): {KPLIB_sectors_tower pushBack _x; if (isServer) then {_x setMarkerText format ["%1 %2",markerText _x, mapGridPosition (markerPos _x)];}; KPLIB_sectors_all pushBack _x;};
        case (_x find "outpost" == 0): {KPLIB_sectors_outpost pushBack _x; _x setMarkerAlpha 0; KPLIB_sectors_filler pushBack _x;};
    };
} forEach allMapMarkers;

true
