/*
    File: fn_FOBToDiscord.sqf
    Author: FernandimModelador (https://github.com/FernandimModelador)
    Date: 07/03/2026
    Last Update: 07/03/2026
    License: MIT License - http://www.opensource.org/licenses/MIT
    
    Description:
        Exports information about the FOBs in a json format for python parsing.
    
    Parameter(s):
        -
    
    Returns:
        -
*/

if (!isServer) exitWith {};

if (!isNil "KPLIB_fobLogLoop_handle") exitWith {};

KPLIB_fobLogLoop_handle = [
    {
        params ["_args", "_handle"];

        if (!KPLIB_fob_logging_enabled) exitWith {
            [_handle] call CBA_fnc_removePerFrameHandler;
            KPLIB_fobLogLoop_handle = nil;
        };

        private _playerCount = [] call KPLIB_fnc_getPlayerCount;

        if (count KPLIB_sectors_fob > 0 && _playerCount > 0) then {
            
            diag_log "--- FOB_DATA_START ---";

            {
                private _fobPos = _x;
                private _fobName = [_fobPos] call KPLIB_fnc_getFobName;
                private _fobData = [_fobPos] call KPLIB_fnc_getFobResources;

                _fobData params [
                    "_pos",
                    "_supplies",
                    "_ammo",
                    "_fuel"
                ];

                private _fobJson = format [
                    "[FOB_JSON] {""name"": ""%1"", ""resources"": {""supply"": %2, ""ammo"": %3, ""fuel"": %4}}",
                    _fobName,
                    _supplies,
                    _ammo,
                    _fuel
                ];
                
                diag_log _fobJson;
            } forEach KPLIB_sectors_fob;

            diag_log "--- FOB_DATA_END ---";
        };
    }, 
    600, 
    []
] call CBA_fnc_addPerFrameHandler;