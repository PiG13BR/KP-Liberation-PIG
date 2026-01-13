/*
    File: fn_activateSector.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BBR
    Date: 02/12/2025
    Last Update: 31/12/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Activate sector and check sector type to start spawning stuff

    Parameter(s):
        _sector - sector that was activated [STRING]

    Returns:
        -
*/

params ["_sector"];

[format ["Sector %1 (%2) activated - Managed on: %3", (markerText _sector), _sector, KPLIB_debugSource], "SECTORSPAWN"] remoteExecCall ["KPLIB_fnc_log", 2];

private _sectorPos = markerPos _sector;

private _opforcount = [] call KPLIB_fnc_getOpforCap;

private _localCaptureSize = KPLIB_range_sectorCapture;

private _sectorRange = [_opforcount, _sector] call KPLIB_fnc_getSectorRange;
private _sectorPos = markerPos _sector;
// Get player unit count 
private _unitsCount = [_sectorPos, _sectorRange, KPLIB_side_player] call KPLIB_fnc_getUnitsCount;

// Enemy sector
if ((!(_sector in KPLIB_sectors_player)) && (_unitsCount > 0)) then {
    diag_log format ["SECTOR ACTIVATED: %1", _sector];

    // Handle capital
    if (_sector in KPLIB_sectors_capital) then {
        _localCaptureSize = KPLIB_range_sectorCapture * 1.4;
        [_sector, _localCaptureSize] call KPLIB_fnc_sectorCapitalSpawns;
    };

    // Handle military
    if (_sector in KPLIB_sectors_military) then {
        [_sector, _localCaptureSize] call KPLIB_fnc_sectorMilitarySpawns;
    };

    // Handle city
    if (_sector in KPLIB_sectors_city) then {
        [_sector, _localCaptureSize] call KPLIB_fnc_sectorCitySpawns;
    };

    // Handle tower
    if (_sector in KPLIB_sectors_tower) then {
        [_sector, _localCaptureSize] call KPLIB_fnc_sectorTowerSpawns;
    };
    
    // Handle factory
    if (_sector in KPLIB_sectors_factory) then {
        [_sector, _localCaptureSize] call KPLIB_fnc_sectorFactorySpawns;
    };

    // Handle outpost
    if (_sector in KPLIB_sectors_outpost) then {
        [_sector, _localCaptureSize * 0.5] call KPLIB_fnc_sectorOutpostSpawns;
    };
} else {
    // Friendly sector
    [{
        params["_sector"];

        KPLIB_sectors_active deleteAt (KPLIB_sectors_active find _sector);
        publicVariable "KPLIB_sectors_active";

        [format ["Sector %1 (%2) deactivated - Was managed on: %3", (markerText _sector), _sector, KPLIB_debugSource], "SECTORSPAWN"] remoteExecCall ["KPLIB_fnc_log", 2];
    }, [_sector], 40] call CBA_fnc_waitAndExecute;
};