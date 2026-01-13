#include "..\defines.hpp"
/*
    File: fn_doBuildFob.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 12/11/2025
    Last Update: 12/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Start fob building process

    Parameter(s):
        Action passed arguments 
            _fobPlacer - fob object that was deployed [OBJECT]

    Returns:
        [BOOL]
*/
params ["_fobPlacer"];

if ( count KPLIB_sectors_fob >= KPLIB_param_maxFobs ) exitWith {
    [format [ localize "STR_HINT_FOBS_EXCEEDED", KPLIB_param_maxFobs], true, 3] call KPLIB_fnc_hint;
};

// Check for nearest fobs
private _index = KPLIB_sectors_fob findIf {(_x distance2D _fobPlacer) < KPLIB_distance_fob};
if (_index >= 0) exitWith {
    private _distFob = _fobPlacer distance ([getPosATL _fobPlacer] call KPLIB_fnc_getNearestFOB);
    [format [localize "STR_FOB_BUILDING_IMPOSSIBLE", floor KPLIB_distance_fob, floor _distFob], true, 3] call KPLIB_fnc_hint;
};

// Check for nearest sector
private _index = KPLIB_sectors_all findIf {((markerPos _x) distance2D _fobPlacer) < KPLIB_distance_sector};
if (_index >= 0) exitWith {
    private _distSector = _fobPlacer distance (markerPos ([KPLIB_distance_sector, getPosATL _fobPlacer] call KPLIB_fnc_getNearestSector));
    [format [localize "STR_FOB_BUILDING_IMPOSSIBLE_SECTOR", floor KPLIB_distance_sector, floor _distSector], true, 3] call KPLIB_fnc_hint;
};

// Check if terrain is relatively flat
if (((ASLToAGL (getPosASL _fobPlacer)) isFlatEmpty [-1, -1, KPLIB_terrainGradient_fob, 10, 0]) isEqualTo []) exitWith {
    [localize "STR_FOB_BUILDING_IMPOSSIBLE_GRADIENT", true, 3] call KPLIB_fnc_hint;
};

missionNamespace setVariable ["KPLIB_isBuildingFob", false, true];

// Build Fob!
[BUILDTYPE_FOB] call KPLIB_fnc_buildItem;
deleteVehicle _fobPlacer; // Delete fob placer