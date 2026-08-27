scriptName "lose_sectors";

waitUntil {!isNil "KPLIB_player_fobs"};
waitUntil {!isNil "KPLIB_sectors_player"};

sleep 5;

attack_in_progress = false;
private _ownership = KPLIB_side_player;

while {KPLIB_endgame == 0} do {
    {
        // Ignore activated sectors
        if (_x in KPLIB_sectors_active) then {continue};

        private _sectorRange = KPLIB_range_sectorCapture * 0.8;
        if (_x in KPLIB_sectors_airport) then {
            _sectorRange = getMarkerSize _x;
            _ownership = [markerpos _x, _sectorRange] call KPLIB_fnc_getSectorOwnership;

        } else {
            _ownership = [markerpos _x] call KPLIB_fnc_getSectorOwnership;
        };
        
        if (_ownership == KPLIB_side_enemy) then {
            [_x, _sectorRange] call attack_in_progress_sector;
        };
        sleep 0.5;
    } foreach (KPLIB_sectors_player - KPLIB_fillers_all);

    {
        _ownership = [_x] call KPLIB_fnc_getSectorOwnership;
        if ( _ownership == KPLIB_side_enemy ) then {
            [ _x ] call attack_in_progress_fob;
        };
        sleep 0.5;
    } foreach (KPLIB_player_fobs + KPLIB_player_outposts);

    sleep 30;
};
