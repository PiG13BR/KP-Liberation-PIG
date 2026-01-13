/*
    File: fn_manageSectorPFH.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BBR
    Date: 02/12/2025
    Last Update: 19/12/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Manage one sector per frame handler

    Parameter(s):
        _sector - sector to manage [STRING]
        _localCaptureSize - capture radius [NUMBER]
        _sectorUnits - spawned sector units [ARRAY]

    Returns:
        -
*/

// Base amount of sector lifetime tickets
// If there are no enemies, one ticket is removed every SECTOR_TICK_TIME seconds
// 12 * 5 = 60s by default
#define BASE_TICKETS                12
#define SECTOR_TICK_TIME            5
// Delay in minutes from which addional time will be added
#define ADDITIONAL_TICKETS_DELAY    5

params["_sector", "_localCaptureSize", "_sectorUnits"];

private _activationTime = time;
private _opforcount = [] call KPLIB_fnc_getOpforCap;
private _sector_despawn_tickets = BASE_TICKETS;

if (isNil "KPLIB_sector_ticket") then {
    KPLIB_sector_ticket = createHashMapFromArray [];
};

KPLIB_sector_ticket set [_sector, _sector_despawn_tickets];

private _maximum_additional_tickets = (KPLIB_param_maxDespawnDelay * 60 / SECTOR_TICK_TIME);

// Sector lifetime loop
[{
    params["_args", "_handle"];
    _args params ["_sector", "_localCaptureSize", "_sectorUnits", "_activationTime", "_opforcount", "_maximum_additional_tickets"];

    private _sector_despawn_tickets = KPLIB_sector_ticket get _sector;
    private _sectorPos = markerPos _sector;

    // Sector was captured
    if (([_sectorPos, _localCaptureSize] call KPLIB_fnc_getSectorOwnership == KPLIB_side_player) && (KPLIB_endgame == 0)) then {
        // Liberate sector
        if (isServer) then {
            [_sector] spawn KPLIB_fnc_liberatedSector;
        } else {
            [_sector] remoteExec ["KPLIB_fnc_liberatedSector", 2];
        };

        // Prisonners
        {
            if (captive _x) then {
                [_x, true] call KPLIB_fnc_setCapturable;
            } else {
                [_x] call KPLIB_fnc_setCapturable;
            };
        } forEach ((markerPos _sector) nearEntities [["CAManBase"], _localCaptureSize * 1.2]);

        // Initiate sector deactivation
        [
            {
                params["_sector", "_sectorUnits", "_opforcount"];
                ([markerPos _sector, (([_opforcount, _sector] call KPLIB_fnc_getSectorRange) + 300), KPLIB_side_player] call KPLIB_fnc_getUnitsCount) == 0
            }, 
            {
                params["_sector", "_sectorUnits"];
                [_sector, _sectorUnits, 60] call KPLIB_fnc_deactivateSector;
        }, [_sector, _sectorUnits, _opforcount]] call CBA_fnc_waitUntilAndExecute;
        
        // Exit PFH
        [_handle] call CBA_fnc_removePerFrameHandler;
    } else {
        if (([_sectorPos, (([_opforcount, _sector] call KPLIB_fnc_getSectorRange) + 300), KPLIB_side_player] call KPLIB_fnc_getUnitsCount) == 0) then {
            // No blufor nearby, subtract tickets
            _sector_despawn_tickets = _sector_despawn_tickets - 1;
            KPLIB_sector_ticket set [_sector, _sector_despawn_tickets];
        } else {
            // start counting running minutes after ADDITIONAL_TICKETS_DELAY
            private _runningMinutes = (floor ((time - _activationTime) / 60)) - ADDITIONAL_TICKETS_DELAY;
            private _additionalTickets = (_runningMinutes * BASE_TICKETS);

            // clamp from 0 to "_maximum_additional_tickets"
            _additionalTickets = (_additionalTickets max 0) min _maximum_additional_tickets;

            _sector_despawn_tickets = BASE_TICKETS + _additionalTickets;
            KPLIB_sector_ticket set [_sector, _sector_despawn_tickets];
        };

        // Initiate sector deactivation once out of tickets
        if (_sector_despawn_tickets <= 0) then {

            [_sector, _sectorUnits] call KPLIB_fnc_deactivateSector;

            // Exit PFH
            [_handle] call CBA_fnc_removePerFrameHandler;
        };
    }
}, SECTOR_TICK_TIME, [_sector, _localCaptureSize, _sectorUnits, _activationTime, _opforcount, _maximum_additional_tickets]] call CBA_fnc_addPerFrameHandler;