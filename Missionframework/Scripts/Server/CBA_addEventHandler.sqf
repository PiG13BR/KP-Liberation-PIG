// Kills manager
["KPLib_manageKills", {
    params ["_unit", "_killer"];
    [_unit, _killer] call kill_manager;
}] call CBA_fnc_addEventHandler;

// Reset battlegroups
["KPLIB_ResetBattleGroups", {
    {
        if (_x getVariable ["KPLIB_isBattleGroup", false]) then {
            [_x, markerPos _this] call KPLIB_fnc_battlegroupAttack;
        }
    } foreach allGroups;
}] call CBA_fnc_addEventHandler;

// Manage battlegroup groups
["KPLIB_battlegroupSpawn", {
    params["_group"];

    if (local _group) then {
        _headless_client = [] call KPLIB_fnc_getLessLoadedHC;
        if (!isNull _headless_client) then {
            _group setGroupOwner (owner _headless_client);
        };
    };

    KPLIB_enemyReadiness = (KPLIB_enemyReadiness - (round (1 + (random 1)))) max 0;
    stats_hostile_battlegroups = stats_hostile_battlegroups + 1;
}] call CBA_fnc_addEventHandler;

// Update production map markers
["KPLIB_updateProductionMarkers", {
    params["_sector"];

    private _prodMarkers = KPLIB_production_markers get _sector;
    _prodMarkers set [0, (_y # 3)];
    _prodMarkers set [1, (_y # 4)];
    _prodMarkers set [2, (_y # 5)];

    private _originalMarkerName = _prodMarkers # 3;
    
    // Update map marker
    private _markerText = _originalMarkerName + " [";
    if (_y # 3) then {_markerText = _markerText + "S";}; // Can produce supply
    if (_y # 4) then {_markerText = _markerText + "A";}; // Can produce ammo
    if (_y # 5) then {_markerText = _markerText + "F";}; // Can produce fuel
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
["KPLIB_enemyReinforcements", {
    _this spawn reinforcements_manager;
}] call CBA_fnc_addEventHandler;