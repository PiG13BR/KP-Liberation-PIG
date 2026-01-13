private _start = diag_tickTime;
if (isServer) then {["init_buildings.sqf initialising...", "CIVREP"] call KPLIB_fnc_log;};

switch (worldName) do {
    case "altis": {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\altis.sqf"};
    case "chernarus_summer": {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\chernarus.sqf"};
    case "Chernarus_Winter": {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\chernarus.sqf"};
    case "chernarus": {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\chernarus.sqf"};
    case "cup_chernarus_A3": {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\chernarus2020.sqf"};
    case "Enoch": {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\enoch.sqf"};
    case "gm_weferlingen_summer": {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\gm_weferlingen_summer.sqf"};
    case "gm_weferlingen_winter": {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\gm_weferlingen_winter.sqf"};
    case "lythium": {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\lythium.sqf"};
    case "Malden": {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\malden.sqf"};
    case "panthera3": {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\panthera3.sqf"};
    case "pja310": {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\pja310.sqf"};
    case "Sara": {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\sara.sqf"};
    case "song_bin_tanh": {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\song_bin_tanh.sqf"};
    case "Takistan": {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\takistan.sqf"};
    case "Tanoa": {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\tanoa.sqf"};
    case "WL_Rosche": {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\wl_rosche.sqf"};
    case "xcam_taunus": {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\xcam_taunus.sqf"};
    default {call compile preprocessFileLineNumbers "Scripts\Server\civrep\ignored\allterrain.sqf"};
};

KPLIB_cr_sectorbuildings = [];

{
    KPLIB_cr_sectorbuildings pushBack [_x, [_x] call F_cr_getBuildings];
} forEach KPLIB_sectors_city;

{
    KPLIB_cr_sectorbuildings pushBack [_x, [_x] call F_cr_getBuildings];
} forEach KPLIB_sectors_capital;

if (isServer) then {[format ["init_buildings.sqf finished. Time needed: %1 seconds", diag_ticktime - _start], "CIVREP"] call KPLIB_fnc_log;};
if (KPLIB_civrep_debug > 0) then {
    {
        [format ["%1: %2", markerText (_x select 0), (_x select 1)], "CIVREP"] call KPLIB_fnc_log;
    } forEach KPLIB_cr_sectorbuildings;
};
