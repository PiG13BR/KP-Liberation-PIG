params["_sector", ["_amount", 3, [0]], ["_vehType", "", [""]]];

private _sleep = 10;
for "_i" from 1 to _amount do {
    _sleep = _sleep + 5;
    [{[_this # 0, _this # 1] call KPLIB_fnc_spawnBattlegroup;}, [(markerPos _sector), _vehType], _sleep] call CBA_fnc_waitAndExecute;
};