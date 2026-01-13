/*
    File: fn_deactiveSector.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 02/12/2025
    Last Update: 19/12/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Deactive sector/delete entities

    Parameter(s):
        _sector - sector to deactivate [STRING]
        _sectorUnits - spawned sector units [ARRAY]
        _delay - delay to deactive sector [NUMBER, defaults to 0]

    Returns:
        -
*/
params["_sector", "_sectorUnits", ["_delay", 0, [0]]];

KPLIB_sector_ticket deleteAt _sector;

KPLIB_sectors_active deleteAt (KPLIB_sectors_active find _sector);
publicVariable "KPLIB_sectors_active";

[{
    params["_sector", "_sectorUnits"];
    // Handle sector objects despawn
    ["KPLIB_deleteSectorObjects", [_sector]] call CBA_fnc_serverEvent;

    // Handle units despawn
    {
        if (_x isKindOf "CAManBase") then {
            if (side group _x != KPLIB_side_player) then {
                [group _x] call KPLIB_fnc_despawnGroup
            };
        } else {
            
            if (!isNull _x) then {
                [_x] call KPLIB_fnc_despawnObject;
            };
        };
    } forEach _sectorUnits;

    [format ["Sector %1 (%2) deactivated - Was managed on: %3", (markerText _sector), _sector, KPLIB_debugSource], "SECTORSPAWN"] remoteExecCall ["KPLIB_fnc_log", 2];
},[_sector, _sectorUnits], _delay] call CBA_fnc_waitAndExecute;