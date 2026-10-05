scriptName "random_battlegroups";

sleep (900 / KPLIB_param_aggressivity);
private _sleeptime = 0;
while {KPLIB_param_aggressivity > 0.9 && KPLIB_endgame == 0} do {
    _sleeptime = (1800 + (random 1800)) / (([] call KPLIB_fnc_getOpforFactor) * KPLIB_param_aggressivity);

    if (KPLIB_enemyReadiness >= 80) then {_sleeptime = _sleeptime * 0.75;};
    if (KPLIB_enemyReadiness >= 90) then {_sleeptime = _sleeptime * 0.75;};
    if (KPLIB_enemyReadiness >= 95) then {_sleeptime = _sleeptime * 0.75;};

    sleep _sleeptime;

    if (!isNil "KPLIB_last_battlegroup_time") then {
        waitUntil {
            sleep 5;
            diag_tickTime > (KPLIB_last_battlegroup_time + (2100 / KPLIB_param_aggressivity))
        };
    };

    if (
        (count (allPlayers - entities "HeadlessClient_F") >= 4) // ToDo: mission parameter to select min. amount of players to start an attack
        && {KPLIB_enemyReadiness >= (60 - (5 * KPLIB_param_aggressivity))}
        && {[] call KPLIB_fnc_getOpforCap < KPLIB_cap_battlegroup}
        && {diag_fps > 15.0}
    ) then {
        private _hc = [] call KPLIB_fnc_getLessLoadedHC;

        private _playerAirports = KPLIB_sectors_player select {_x in KPLIB_sectors_airport};
        if ((random 100 <= (KPLIB_enemyReadiness/2 + (5 * KPLIB_param_difficulty))) && ((count _playerAirports) > 0)) then {
            // Raid Random Airport
            private _sector = selectRandom _playerAirports;
            private _targetPos = markerPos _sector;
            if (isNull _hc) then {
                [_sector, _targetPos] spawn KPLIB_fnc_airportRaid;
            } else {
                [_sector, _targetPos] remoteExec ["KPLIB_fnc_airportRaid", _hc];
            };
        } else {
            // Random battlegroup for random sector closer to the front
            if (isNull _hc) then {
                [] call KPLIB_fnc_spawnBattlegroup;
            } else {
                [] remoteExec ["KPLIB_fnc_spawnBattlegroup", _hc];
            };
        }
    };
};
