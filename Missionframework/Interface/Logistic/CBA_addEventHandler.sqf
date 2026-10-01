["KPLIB_logi_addTruck", {
    _this call KPLIB_fnc_subtractResources;

    stats_supplies_spent = stats_supplies_spent + (_this # 0);
    stats_ammo_spent = stats_ammo_spent + (_this # 1);
    stats_fuel_spent = stats_fuel_spent + (_this # 2);
}] call CBA_fnc_addEventHandler;

["KPLIB_logi_deleteTruck", {
    params["_supply", "_ammo", "_fuel", "_storages", "_player"];

    if (count _storages > 0) then {
        // Storages found and they are not full
        [_supply, _ammo, _fuel, _storages] call KPLIB_fnc_restoreResources;
    } else {
        // All storages full. Spawn crates instead.
        while {(_supply > 0) || (_ammo > 0) || (_fuel > 0)} do {
            if (_supply > 0) then {
                private _price = _supply min 100;
                [KPLIB_b_crateSupply, _price, getPosATL _player] call KPLIB_fnc_createCrate;
                _supply = _supply - _price;
            };

            if (_ammo > 0) then {
                private _price = _ammo min 100;
                [KPLIB_b_crateAmmo, _price, getPosATL _player] call KPLIB_fnc_createCrate;
                _ammo = _ammo - _price;
            };

            if (_fuel > 0) then {
                private _price = _fuel min 100;
                [KPLIB_b_crateFuel, _price, getPosATL _player] call KPLIB_fnc_createCrate;
                _fuel = _fuel - _price;
            };
        };
    };
}] call CBA_fnc_addEventHandler;