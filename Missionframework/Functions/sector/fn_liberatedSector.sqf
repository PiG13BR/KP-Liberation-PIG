params ["_liberated_sector"];

private _KPLIB_enemyReadiness_increase = 0;
switch (true) do {
    case (_liberated_sector in KPLIB_sectors_capital):    {_KPLIB_enemyReadiness_increase = 6 + (floor (random 6)) * KPLIB_param_difficulty;};
    case (_liberated_sector in KPLIB_sectors_city):    {_KPLIB_enemyReadiness_increase = 6 + (floor (random 4)) * KPLIB_param_difficulty;};
    case (_liberated_sector in KPLIB_sectors_military):   {_KPLIB_enemyReadiness_increase = 5 + (floor (random 12)) * KPLIB_param_difficulty;};
    case (_liberated_sector in KPLIB_sectors_factory):    {_KPLIB_enemyReadiness_increase = 3 + (floor (random 7)) * KPLIB_param_difficulty;};
    case (_liberated_sector in KPLIB_sectors_tower):      {_KPLIB_enemyReadiness_increase = 3 + (floor (random 3)) * KPLIB_param_difficulty;};
    case (_liberated_sector in KPLIB_sectors_outpost):      {_KPLIB_enemyReadiness_increase = 3 + (floor (random 3)) * KPLIB_param_difficulty;};
};

KPLIB_enemyReadiness = KPLIB_enemyReadiness + _KPLIB_enemyReadiness_increase;
if (KPLIB_enemyReadiness > 100.0 && KPLIB_param_difficulty <= 2.0) then {KPLIB_enemyReadiness = 100.0};
stats_readiness_earned = stats_readiness_earned + _KPLIB_enemyReadiness_increase;

KPLIB_sectors_player pushback _liberated_sector; publicVariable "KPLIB_sectors_player";

// Outpost
if (_liberated_sector in KPLIB_sectors_outpost) exitWith {
    ["lib_enemy_pos_destroyed", [mapGridPosition (markerPos _liberated_sector)]] remoteExec ["BIS_fnc_showNotification"];

    // 1 hour delay to be able to spawn it again if there's military sector nearby to replenish it
    [{_this call KPLIB_fnc_replenishOutpost}, _liberated_sector, 3600] call CBA_fnc_waitAndExecute;

    // 50% chance of enemy QRF (nearby military base)
    if ((random 100 <= KPLIB_enemyReadiness)) then {
        [{
            params["_liberated_sector"];

            private _base = [markerPos _liberated_sector,  KPLIB_side_enemy, KPLIB_range_replenishRadius] call KPLIB_fnc_getNearestBase;
            if !(isNil "_base") then {
                // Check distance
                if ((markerPos _base) distance2D (markerPos _liberated_sector) >= 1000) then {
                    ["", markerPos _liberated_sector, _base, false] call KPLIB_fnc_battlegroupTransportHeli
                } else {
                    ["", markerPos _liberated_sector, _base, false] call KPLIB_fnc_battlegroupLandVehicle
                };
            };
        }, [_liberated_sector], 60 + (random 60)] call CBA_fnc_waitAndExecute; 

    };
};

[_liberated_sector, 0] remoteExecCall ["remote_call_sector"];
stats_sectors_liberated = stats_sectors_liberated + 1;

["KPLIB_ResetBattleGroups", _liberated_sector] call CBA_fnc_serverEvent;

if (_liberated_sector in KPLIB_sectors_factory) then {

    ["KPLIB_addFactoryProduction", _liberated_sector] call CBA_fnc_serverEvent;
};

[_liberated_sector] spawn F_cr_liberatedSector;

if ((random 100) <= KPLIB_cr_wounded_chance || (count KPLIB_sectors_player) == 1) then {
    [_liberated_sector] spawn civrep_wounded_civs;
};

asymm_blocked_sectors pushBack [_liberated_sector, time];
publicVariable "asymm_blocked_sectors";

[] spawn check_victory_conditions;

["KPLIB_sectorLiberated", _liberated_sector] call CBA_fnc_serverEvent;

sleep 1;

[] spawn KPLIB_fnc_doSave;

sleep 1;

// Update arsenal for unlocked items
if ((KPLIB_sector_arsenalLink getOrDefault [_liberated_sector, []]) isNotEqualTo []) then {
    ["KPLIB_updateArsenal", _liberated_sector] call CBA_fnc_globalEvent;
};

sleep 45;

if (KPLIB_endgame == 0) then {
    if (
        !(_liberated_sector in KPLIB_sectors_tower)
        && {
            (random (150 / (KPLIB_param_difficulty * KPLIB_param_aggressivity))) < (KPLIB_enemyReadiness - 15)
            || _liberated_sector in KPLIB_sectors_capital
        }
        && {[] call KPLIB_fnc_getOpforCap < KPLIB_cap_battlegroup}
    ) then {
        [markerPos _liberated_sector] call KPLIB_fnc_spawnBattlegroup;
    };
};

[{[_this] call KPLIB_fnc_fireAtCapturedSector;}, _liberated_sector, 45] call CBA_fnc_waitAndExecute;