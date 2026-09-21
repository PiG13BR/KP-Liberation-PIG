params ["_targetsector"];

if (KPLIB_enemyReadiness > 15) then {
    
    private _range = [KPLIB_range_sectorCapture, KPLIB_range_sectorCapture * 1.4] select (_targetsector in KPLIB_sectors_capital);
    if (_targetsector in KPLIB_sectors_airport) then {
        _range = markerSize _targetsector;
    };
    private _init_units_count = (([markerPos _targetsector, _range, KPLIB_side_enemy] call KPLIB_fnc_getUnitsCount));

    if !(_targetsector in KPLIB_sectors_capital) then {
        while {(_init_units_count * 0.75) <= ([markerPos _targetsector, _range, KPLIB_side_enemy] call KPLIB_fnc_getUnitsCount)} do {
            sleep 5;
        };
    };

    if (_targetsector in KPLIB_sectors_active) then {

        private _nearestower = [markerpos _targetsector, KPLIB_side_enemy, KPLIB_range_radioTowerScan * 1.4] call KPLIB_fnc_getNearestTower;

        if !(isNil "_nearestower") then {
            private _reinforcements_time = (((((markerpos _nearestower) distance (markerpos _targetsector)) / 1000) ^ 1.66 ) * 120) / (KPLIB_param_difficulty * KPLIB_param_aggressivity);
            if (_targetsector in KPLIB_sectors_capital) then {
                _reinforcements_time = _reinforcements_time * 0.35;
            };
            private _current_timer = time;

            waitUntil {sleep 1; (_current_timer + _reinforcements_time < time) || (_targetsector in KPLIB_sectors_player) || (_nearestower in KPLIB_sectors_player)};

            sleep 15;

            if ((_targetsector in KPLIB_sectors_active) && !(_targetsector in KPLIB_sectors_player) && !(_nearestower in KPLIB_sectors_player) && (!([] call KPLIB_fnc_isCapitalActive) || _targetsector in KPLIB_sectors_capital)) then {
                if ((random KPLIB_enemyReadiness) > (20 + (30 / KPLIB_param_aggressivity))) then {
                    private _amount = 1;
                    if (KPLIB_param_difficulty > 1) then {_amount = round((KPLIB_enemyReadiness/10)/4)};
                    private _groups = [];
                    for "_i" from 0 to _amount do {
                        private _reinf = ["", markerPos _targetsector, "", false] call KPLIB_fnc_battlegroupTransportHeli;
                        sleep 1;
                        _groups pushBack _reinf;
                    };
                    // Only notify if reinforcements managed to spawn in
                    if (count _groups > 0) then {
                        reinforcements_sector_under_attack = _targetsector;
                        reinforcements_set = true;
                        ["lib_reinforcements",[markertext _targetsector]] remoteExec ["bis_fnc_shownotification"];
                    };
                };
                if (_targetsector in KPLIB_sectors_airport) then {
                    ["", markerPos _targetsector, "", false] call KPLIB_fnc_battlegroupAttackHeli;
                    sleep 2; 
                    ["", markerPos _targetsector, "", false] call KPLIB_fnc_battlegroupTransportHeli;
                    sleep 2; 
                    ["", markerPos _targetsector, "", false] call KPLIB_fnc_battlegroupTransportHeli;
                    sleep 2; 
                    ["", markerPos _targetsector, "", false] call KPLIB_fnc_battlegroupSlingLoadVeh;
                    sleep 2; 
                    if ((random KPLIB_enemyReadiness) > (20 + (30 / KPLIB_param_aggressivity))) then { 
                        ["", markerPos _targetsector, "", false] call KPLIB_fnc_battlegroupSlingLoadVeh; 
                    } else { 
                        ["", markerPos _targetsector, "", false] call KPLIB_fnc_battlegroupTransportHeli; 
                    };
                };
                stats_reinforcements_called = stats_reinforcements_called + 1;
            };

            sleep 30 + (random 30);

            // Guerrilla
            if (((random 100) <= KPLIB_resistance_sector_chance) && (([] call KPLIB_fnc_crGetMulti) > 0)) then {
                [_targetsector] spawn KPLIB_fnc_sectorGuerrilla;
            };
        };
    };
};
