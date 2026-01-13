/*
    File: fn_factoryProductionPFH.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 14/11/2025
    Last Update: 20/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Factory production PFH. Called when a factory starts to produce resources. It handles each factory separately.

    Parameter(s):
        _factory - sector marker (factory) [STRING]

    Returns:
        [BOOL]
*/

params["_factory"];

if (!isServer) exitWith {false};
if !(_factory in KPLIB_production) exitWith {["This sector is not in the production list"] call BIS_fnc_error; false};

[format["Production management started for %1", markerText _factory], "PRODUCTION"] call KPLIB_fnc_log;

// Save PFH handler in a hashmap
if (isNil "KPLIB_production_PFH") then {
    KPLIB_production_PFH = createHashMapFromArray [];
};

// Wait for the first minute
[{
    params["_factory"];

    // Get handler
    private _pfh = KPLIB_production_PFH getOrDefault [_factory, -1];
    [_pfh] call CBA_fnc_removePerFrameHandler; // Remove handler for this sector

    // Update it each minute
    [{
        params["_factory", "_handler"];

        KPLIB_production_PFH set [_factory, _handler];

        if !(_factory in KPLIB_production || {KPLIB_endgame == 1}) exitWith {[_handler] call CBA_fnc_removePerFrameHandler}; // Remove PFH if production list was removed

        [_factory] call KPLIB_fnc_factoryProduceResource;
    }, 60, _factory] call CBA_fnc_addPerFrameHandler;
}, [_factory], 60] call CBA_fnc_waitAndExecute;

true