params["_factory", "_units"];

[{
    params["_args", "_handle"];
	
	_args params ["_factory", "_units"];

    if (({(_x distance (markerPos _factory) < KPLIB_range_sectorCapture) && alive _x && [_x] call KPLIB_fnc_ace_isAwake} count _units < 5) || (KPLIB_civ_rep >= 0)) then {
        
        {
            [group _x] call KPLIB_fnc_despawnGroup;
        }forEach (_units select {alive _x && [_x] call KPLIB_fnc_ace_isAwake});
        
        KPLIB_blockedFactories deleteAt (KPLIB_blockedFactories find _factory);
        publicVariable "KPLIB_blockedFactories";

        deleteMarker (format["%1_blocked", _factory]);
        
        ["lib_factory_liberated", [markerText _factory]] remoteExec ["BIS_fnc_showNotification"];

        [_handle] call CBA_fnc_removePerFrameHandler;
    };

}, 5, [_factory, _units]] call CBA_fnc_addPerFrameHandler;