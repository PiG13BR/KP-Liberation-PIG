params [ "_thispos" ];
private [ "_attacktime", "_ownership", "_grp" ];

sleep 5;

_ownership = [ _thispos ] call KPLIB_fnc_getSectorOwnership;
if ( _ownership != KPLIB_side_enemy ) exitWith {};

if ( KPLIB_param_bluforDefenders ) then {
    _grp = creategroup [KPLIB_side_player, true];
    _grp setVariable ["KPLIB_defenderGroup", true, true];  // To avoid activating sectors by themselves
    {
        [_x, _thispos, _grp] call KPLIB_fnc_createManagedUnit;
    } foreach KPLIB_b_squadInf;
    sleep 3;
    _grp setBehaviour "COMBAT";
};

sleep 60;

KPLIB_sectorsUnderAttack pushBack _thispos;
publicVariable "KPLIB_sectorsUnderAttack";

_ownership = [ _thispos ] call KPLIB_fnc_getSectorOwnership;
if ( _ownership == KPLIB_side_player ) exitWith {
    if ( KPLIB_param_bluforDefenders ) then {
        {
            if ( alive _x ) then { deleteVehicle _x };
        } foreach units _grp;
        _grp setVariable ["KPLIB_defenderGroup", nil, true]
    };
};

[_thispos, 1] remoteExec ["remote_call_fob"];
_attacktime = KPLIB_vulnerability_timer;

while { _attacktime > 0 && ( _ownership == KPLIB_side_enemy || _ownership == KPLIB_side_resistance ) } do {
    _ownership = [ _thispos ] call KPLIB_fnc_getSectorOwnership;
    _attacktime = _attacktime - 1;
    sleep 1;
};

waitUntil {
    sleep 1;
    [ _thispos ] call KPLIB_fnc_getSectorOwnership != KPLIB_side_resistance;
};

if ( KPLIB_endgame == 0 ) then {
    if ( _attacktime <= 1 && ( [ _thispos ] call KPLIB_fnc_getSectorOwnership == KPLIB_side_enemy ) ) then {
        [_thispos, 2] remoteExec ["remote_call_fob"];

        sleep 3;

        ["KPLIB_ResetBattleGroups", []] call CBA_fnc_serverEvent;
        
        switch (true) do {
            case (_thispos in KPLIB_player_outposts) : {[_thispos] call KPLIB_fnc_destroyOutpost;};
            default {
                [_thispos] call KPLIB_fnc_destroyFob;    
                stats_fobs_lost = stats_fobs_lost + 1;
            };
        };
        
        [] call KPLIB_fnc_doSave;

    } else {
        [_thispos, 3] remoteExec ["remote_call_fob"];
        {
            if ((count ([getPosATL _x, 25] call KPLIB_fnc_getNearbyPlayers)) < 1) then {continue};
            if (captive _x) then {
                [_x, true] call KPLIB_fnc_setCapturable;
            } else {
                [_x] call KPLIB_fnc_setCapturable;
            };
        } foreach ((_thispos nearEntities ["CAManBase", KPLIB_range_sectorCapture * 0.8]) select {side group _x == KPLIB_side_enemy});
    };
};

KPLIB_sectorsUnderAttack = KPLIB_sectorsUnderAttack - [_thispos];
publicVariable "KPLIB_sectorsUnderAttack";

sleep 60;

if ( KPLIB_param_bluforDefenders ) then {
    {
        if ( alive _x ) then { if (isNull objectParent _x) then {deleteVehicle _x} else {(objectParent _x) deleteVehicleCrew _x}; };
    } foreach units _grp;
};
