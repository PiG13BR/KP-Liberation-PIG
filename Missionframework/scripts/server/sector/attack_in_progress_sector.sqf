params ["_sector", "_sectorRange"];

private "_ownership";
private "_grp";

sleep 5;

if (_sector in KPLIB_sectors_airport) then {
    _ownership = [markerpos _sector, getMarkerSize _sector] call KPLIB_fnc_getSectorOwnership;
} else {
    _ownership = [markerpos _sector] call KPLIB_fnc_getSectorOwnership;
};

if (_ownership != KPLIB_side_enemy) exitWith {};

private _squad_type = KPLIB_b_squadLight;
if (_sector in KPLIB_sectors_military) then {
    _squad_type = KPLIB_b_squadInf;
};

if ( KPLIB_param_bluforDefenders ) then {
    _grp = creategroup [KPLIB_side_player, true];
    _grp setVariable ["KPLIB_defenderGroup", true, true];  // To avoid activating sectors by themselves
    {
        [_x, markerPos _sector, _grp] call KPLIB_fnc_createManagedUnit;
        sleep 1;
    } foreach _squad_type;
    sleep 3;
    _grp setBehaviour "COMBAT";
};

sleep 60;

if (_sector in KPLIB_sectors_airport) then {
    _ownership = [markerpos _sector, getMarkerSize _sector] call KPLIB_fnc_getSectorOwnership;
} else {
    _ownership = [markerpos _sector] call KPLIB_fnc_getSectorOwnership;
};

if ( _ownership == KPLIB_side_player ) exitWith {
    if ( KPLIB_param_bluforDefenders ) then {
        {
            if ( alive _x ) then { deleteVehicle _x };
        } foreach (units _grp);
        _grp setVariable ["KPLIB_defenderGroup", nil, true]
    };
};

[_sector, 1] remoteExec ["remote_call_sector"];
private _attacktime = KPLIB_vulnerability_timer;

while {((_attacktime > 0) && ((_ownership == KPLIB_side_enemy)) || (_ownership == KPLIB_side_resistance))} do {
    if (_sector in KPLIB_sectors_airport) then {
        _ownership = [markerpos _sector, getMarkerSize _sector] call KPLIB_fnc_getSectorOwnership;
    } else {
        _ownership = [markerpos _sector] call KPLIB_fnc_getSectorOwnership;
    };
    _attacktime = _attacktime - 1;
    sleep 1;
};

waitUntil {

    sleep 1;

    if (_sector in KPLIB_sectors_airport) then {
        _ownership = [markerpos _sector, getMarkerSize _sector] call KPLIB_fnc_getSectorOwnership;
    } else {
        _ownership = [markerpos _sector] call KPLIB_fnc_getSectorOwnership;
    };

    _ownership != KPLIB_side_resistance;
};

if ( KPLIB_endgame == 0 ) then {
    if (_sector in KPLIB_sectors_airport) then {
        _ownership = [markerpos _sector, getMarkerSize _sector] call KPLIB_fnc_getSectorOwnership;
    } else {
        _ownership = [markerpos _sector] call KPLIB_fnc_getSectorOwnership;
    };
    if (_attacktime <= 1 && (_ownership == KPLIB_side_enemy)) then {
        KPLIB_sectors_player deleteAt (KPLIB_sectors_player find _sector);
        publicVariable "KPLIB_sectors_player";
        [_sector, 2] remoteExec ["remote_call_sector"];
        ["KPLIB_ResetBattleGroups", []] call CBA_fnc_serverEvent;
        [] call KPLIB_fnc_doSave;
        stats_sectors_lost = stats_sectors_lost + 1;

        ["KPLIB_setSectorColors"] call CBA_fnc_serverEvent;
        ["KPLIB_removeArsenalItems", [_sector]] call CBA_fnc_globalEvent;
        ["KPLIB_removeFactoryProduction", _sector] call CBA_fnc_serverEvent;
    } else {
        [_sector, 3] remoteExec ["remote_call_sector"];
        if (_sectorRange isEqualType []) then {
            {
                if ((count ([getPosATL _x, 25] call KPLIB_fnc_getNearbyPlayers)) < 1) then {continue};
                if (captive _x) then {
                    [_x, true] call KPLIB_fnc_setCapturable;
                } else {
                    [_x] call KPLIB_fnc_setCapturable;
                }; 
            } forEach ((allUnits select {side (group _x) == KPLIB_side_enemy}) inAreaArray _sector);
        } else {
            {
                if ((count ([getPosATL _x, 25] call KPLIB_fnc_getNearbyPlayers)) < 1) then {continue};
                if (captive _x) then {
                    [_x, true] call KPLIB_fnc_setCapturable;
                } else {
                    [_x] call KPLIB_fnc_setCapturable;
                };
            } forEach ((markerPos _sector) nearEntities [["CAManBase"], _sectorRange * 1.2]);
        };
    };
};

sleep 60;

if (KPLIB_param_bluforDefenders) then {
    {
        if (alive _x) then { 
            if (isNull objectParent _x) then {deleteVehicle _x} else {(objectParent _x) deleteVehicleCrew _x}; 
        };
    } foreach (units _grp);
};
