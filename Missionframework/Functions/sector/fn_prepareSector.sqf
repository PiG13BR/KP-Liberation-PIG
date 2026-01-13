/*
    File: fn_prepareSector.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BBR
    Date: 02/12/2025
    Last Update: 03/12/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Prepare sector to activate

    Parameter(s):
        _sector - sector to activated [STRING]

    Returns:
        -
*/

params ["_sector"];

// Exit if sector is activated
if (_sector in KPLIB_sectors_active) exitWith {};

KPLIB_sectors_active pushback _sector; 
publicVariable "KPLIB_sectors_active";

private _opforcount = [] call KPLIB_fnc_getOpforCap;

private _start = diag_tickTime;
[format ["Sector %1 (%2) - Waiting to spawn sector...", (markerText _sector), _sector], "SECTORSPAWN"] remoteExecCall ["KPLIB_fnc_log", 2];

private _corrected_size = [_opforcount, _sector] call KPLIB_fnc_getSectorRange;
private _delay = 0.1;
private _unitscount = [markerPos _sector, _corrected_size , KPLIB_side_player] call KPLIB_fnc_getUnitsCount;

if (_unitscount > 0 && _unitscount <= 10) then {
    _delay = _delay + 1;
};
_delay = _delay + 0.1;

_unitscount = [markerPos _sector, _corrected_size, KPLIB_side_player] call KPLIB_fnc_getUnitsCount;
if (_unitscount > 0 && _unitscount <= 6) then {
    _delay = _delay + 1;
};
_delay = _delay + 0.1;

_unitscount = [markerPos _sector, _corrected_size, KPLIB_side_player] call KPLIB_fnc_getUnitsCount;
if (_unitscount > 0 && _unitscount <= 4) then {
    _delay = _delay + 1;
};
_delay = _delay + 0.1;

_unitscount = [markerPos _sector, _corrected_size, KPLIB_side_player] call KPLIB_fnc_getUnitsCount;
if (_unitscount > 0 && _unitscount <= 3) then {
    _delay = _delay + 1;
};
_delay = _delay + 0.1;

_unitscount = [markerPos _sector, _corrected_size, KPLIB_side_player] call KPLIB_fnc_getUnitsCount;
if (_unitscount > 0 && _unitscount <= 2) then {
    _delay = _delay + 1;
};
_delay = _delay + 0.1;

_unitscount = [markerPos _sector, _corrected_size, KPLIB_side_player] call KPLIB_fnc_getUnitsCount;
if (_unitscount == 1) then {
    _delay = _delay + 1;
};

diag_log format ["SECTOR SPAWN: %1, delay %2", _sector, _delay];
[{
    params["_sector", "_start"];

    [_sector] call KPLIB_fnc_activateSector;
    
    [format ["Sector %1 (%2) - Waiting done - Time needed: %3 seconds", (markerText _sector), _sector, diag_tickTime - _start], "SECTORSPAWN"] remoteExecCall ["KPLIB_fnc_log", 2];
}, [_sector, _start], _delay] call CBA_fnc_waitAndExecute;