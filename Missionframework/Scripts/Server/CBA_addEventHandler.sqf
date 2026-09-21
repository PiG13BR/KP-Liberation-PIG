// Kills manager
["KPLib_manageKills", {
    params ["_unit", "_killer"];
    [_unit, _killer] call kill_manager;
}] call CBA_fnc_addEventHandler;

// Reset battlegroups
["KPLIB_ResetBattleGroups", {
    {
        if (_x getVariable ["KPLIB_isBattleGroup", false]) then {
            private _vehicles = [_x] call BIS_fnc_groupVehicles;
            if (count _vehicles > 0) then {
                {[_x] call KPLIB_fnc_despawnObject};
            } else {
                [_x] call KPLIB_fnc_despawnGroup;
            }
        }
    } foreach (allGroups select {side _x == KPLIB_side_enemy});
}] call CBA_fnc_addEventHandler;

// Manage battlegroup groups
["KPLIB_battlegroupSpawn", {
    params["_group", "_spawnPoint"];

    KPLIB_enemyReadiness = (KPLIB_enemyReadiness - (round (1 + (random 1)))) max 0;
    stats_hostile_battlegroups = stats_hostile_battlegroups + 1;

    [{
        KPLIB_usedOpforSpawnPoints deleteAt (KPLIB_usedOpforSpawnPoints find _this); // Remove marker from variable
    }, _spawnPoint, 180] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;

// Update production map markers
["KPLIB_updateProductionMarkers", {
    params["_sector"];

    private _prodList = KPLIB_production get _sector;
    private _prodMarkers = KPLIB_production_markers get _sector;
    _prodMarkers set [0, (_prodList # 3)];
    _prodMarkers set [1, (_prodList # 4)];
    _prodMarkers set [2, (_prodList # 5)];

    private _originalMarkerName = _prodMarkers # 3;
    
    // Update map marker
    private _markerText = _originalMarkerName + " [";
    if (_prodList # 3) then {_markerText = _markerText + "S";}; // Can produce supply
    if (_prodList # 4) then {_markerText = _markerText + "A";}; // Can produce ammo
    if (_prodList # 5) then {_markerText = _markerText + "F";}; // Can produce fuel
    _markerText = _markerText + "]";

    _sector setMarkerText _markerText;
    publicVariable "KPLIB_production_markers";
}] call CBA_fnc_addEventHandler;

// Ace captive listen event
["ace_captiveStatusChanged", {
    params["_unit", "_state", "_reason", "_player"];

    if !(_unit getVariable ["KPLIB_prisonner_surrendered", false]) exitWith {};
    if !(alive _unit) exitWith {};

    if (_state && _reason == "SetHandcuffed") then {
        _unit setVariable ["KPLIB_prisonner_captured", true, true];
        _unit setVariable ["KPLIB_prisonner_whois", _player, true];
        [localize "STR_POW_HINT", false, 3] remoteExec ["KPLIB_fnc_hint", _player];
        // Add action to finish capturing in FOB
        ["KPLIB_addActionDeliverPOW", _unit] call CBA_fnc_globalEventJIP; 
    }; 
    if (!_state && _reason == "SetHandcuffed") then {
         if !(_unit getVariable ["KPLIB_powDelivered", false]) then {
            // Remove action
            _unit removeAction (_unit getVariable ["KPLIB_actionID_Capture", -1]);
            _unit setVariable ["KPLIB_prisonner_captured", false, true];
            _unit setVariable ["KPLIB_prisonner_whois", objNull, true];
            [_unit, true] call KPLIB_fnc_setCapturable; // Set capturable again (revert ace normal release event)
        };
    };
}] call CBA_fnc_addEventHandler;

["KPLIB_manageSector", {
    _this call KPLIB_fnc_prepareSector;
}] call CBA_fnc_addEventHandler;

// Enemy Reinforcements
["KPLIB_sectorReinforcements", {
    _this spawn reinforcements_manager;
}] call CBA_fnc_addEventHandler;

// FOB/Outpost markers
["KPLIB_updateBaseMarkers", {
        if (isNil "KPLIB_player_fobMarkers") then {
            KPLIB_player_fobMarkers = [];
        };
        if (isNil "KPLIB_player_outpostMarkers") then {
            KPLIB_player_outpostMarkers = [];
        };

        {deleteMarker _x;} forEach (KPLIB_player_fobMarkers + KPLIB_player_outpostMarkers);

        for "_idx" from 0 to ((count KPLIB_player_fobs) - 1) do {
            private _pos = (KPLIB_player_fobs select _idx);
            if (_pos isEqualTo [0,0,0]) then {continue}; // Ignore
            private _marker = createMarker [format ["fobmarker%1", _idx], markers_reset];
            _marker setMarkerType "b_hq";
            _marker setMarkerSize [1.5, 1.5];
            _marker setMarkerPos _pos;
            _marker setMarkerText format ["FOB %1", KPLIB_fobNames select _idx];
            _marker setMarkerColor "ColorYellow";
            KPLIB_player_fobMarkers pushback _marker;
        };

        for "_idx" from 0 to ((count KPLIB_player_outposts) - 1) do {
            private _pos = (KPLIB_player_outposts select _idx);
            if (_pos isEqualTo [0,0,0]) then {continue}; // Ignore
            private _marker = createMarker [format ["outpostmarker%1", _idx], markers_reset];
            _marker setMarkerType "b_hq";
            _marker setMarkerSize [1.2, 1.2];
            _marker setMarkerPos _pos;
            _marker setMarkerText format ["Outpost %1", KPLIB_outpostNames select _idx];
            _marker setMarkerColor "ColorYellow";
            KPLIB_player_outpostMarkers pushback _marker;
        };
}] call CBA_fnc_addEventHandler;