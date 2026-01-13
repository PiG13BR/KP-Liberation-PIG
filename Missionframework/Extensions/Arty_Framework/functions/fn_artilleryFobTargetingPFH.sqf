/*
    File: fn_artilleryFobTargetingPFH.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 23/11/2024 
    Last Update: 14/12/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Artillery target fobs CBA PFH. Tries to target a FOB in each execution.

    Parameter(s):
        _delay - amount of time (in seconds) between executions [NUMBER]

    Returns:
        -
*/

[{
    params["_args", "_handler"];

    // No enemy arty available in the pool
    if (KPLIB_o_artilleryUnits isEqualTo []) exitWith {
        [_handler] call CBA_fnc_removePerFrameHandler; // Remove PFH. Call it off.
    };

    // Enemy arty available but no fobs found, try again
    if (KPLIB_sectors_fob isEqualTo []) exitWith {
        [_handler] call CBA_fnc_removePerFrameHandler;
        [] call KPLIB_fnc_artilleryFobTargeting; // Run it again to gain a random sleep time
    };

    // Check if there are FOBs with players on it
    private _possibleTargetFobs = [];
    
    _possibleTargetFobs = KPLIB_sectors_fob select {
        count ([_x, KPLIB_range_fob] call KPLIB_fnc_getNearbyPlayers) > ceil(([] call KPLIB_fnc_getPlayerCount)/2)
        //count ((_x nearEntities KPLIB_range_fob) select {(isPlayer _x) && {alive _x} && {[_x] call KPLIB_fnc_ace_isAwake}}) > ceil(([] call KPLIB_fnc_getPlayerCount)/2)
    };

    // No fobs with players on it
    if (count _possibleTargetFobs == 0) exitWith {
        [_handler] call CBA_fnc_removePerFrameHandler;
        [] call KPLIB_fnc_artilleryFobTargeting; // Run it again to gain a random sleep time
    };

    // ---------------------------------------------------------- GET A FOBS IN RANGE
    // Check all artillery available in the pool to see if it has range at least for one FOB. The players can move the FOB out of the artillery range.
    private _poolHasRange = false;
    private _artyPoolRangeCheck = [];

    private _fobsAtRange = [];
    {
        private _arty = _x;
        _fobsAtRange = _possibleTargetFobs select {(_x vectorAdd [200,200,0]) inRangeOfArtillery [[_arty], (KPLIB_artyHashMap_ammo get "KPLIB_arty_HE_round")]};
        if (count _fobsAtRange > 0) then {
            _artyPoolRangeCheck pushBack _x; // The artillery has range
        };
    }forEach KPLIB_o_artilleryUnits;

    if (count _artyPoolRangeCheck == count KPLIB_o_artilleryUnits) then {
        _poolHasRange = true;
    };

    // Artillery pool has range to at least one FOB
    if (_poolHasRange) then {

        // Recalculate the chance using combat readiness and agressivity from mission params
        _fireAtFOBChance = 15; // Reset to the base value
        if (KPLIB_enemyReadiness >= (50 - (5 * KPLIB_param_aggressivity))) then {_fireAtFOBChance = _fireAtFOBChance + 10};	// + 10
        if (KPLIB_enemyReadiness >= (65 - (5 * KPLIB_param_aggressivity))) then {_fireAtFOBChance = _fireAtFOBChance + 10}; // + 10 + 10
        if (KPLIB_enemyReadiness >= (85 - (5 * KPLIB_param_aggressivity))) then {_fireAtFOBChance = _fireAtFOBChance + 10};	// + 10 + 10 + 10
        if (KPLIB_enemyReadiness >= (95 - (5 * KPLIB_param_aggressivity))) then {_fireAtFOBChance = _fireAtFOBChance + 10}; // + 10 + 10 + 10 + 10

        if (_fireAtFOBChance > 100) then {_fireAtFOBChance = 100};

        if ((random 100) <= _fireAtFOBChance) then {

            // Returns a random fob position
            private _targetFob = selectRandom _fobsAtRange; 
            
            [_targetFob] call KPLIB_fnc_artilleryCreateDrone;
            //[_targetFob] call KPLIB_fnc_artilleryFobFiring;

            // Remove PFH
            [_handler] call CBA_fnc_removePerFrameHandler;
        }
    }
}, _sleeptime, []] call CBA_fnc_addPerFrameHandler;