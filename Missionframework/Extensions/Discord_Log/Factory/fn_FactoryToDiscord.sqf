if (!isServer) exitWith {};

if (!isNil "KPLIB_factoryLogLoop_handle") exitWith {};

KPLIB_factoryLogLoop_handle = [
    {
        params ["_args", "_handle"];

        if (!KPLIB_factory_logging_enabled) exitWith {
            [_handle] call CBA_fnc_removePerFrameHandler;
            KPLIB_factoryLogLoop_handle = nil;
        };
        private _playerCount = [] call KPLIB_fnc_getPlayerCount;

        if (count KPLIB_production > 0 && _playerCount > 0) then {
            private _productionTypes = ["Supply", "Ammo", "Fuel"];

            diag_log "--- FACTORY_DATA_START ---";

            {
                _y params [
                    "_sectorName",
                    "_sectorType",
                    "_storageArray",
                    "_canProduceS",
                    "_canProduceA",
                    "_canProduceF",
                    "_typeOfResource",
                    "_time",
                    "_supplyValue",
                    "_ammoValue",
                    "_fuelValue"
                ];

                private _resourceName = _productionTypes select (_typeOfResource min 2);

                private _factoryJson = format [
                    "[FACTORY_JSON] {""name"": ""%1"", ""production_type"": ""%2"", ""storage"": {""supply"": %3, ""ammo"": %4, ""fuel"": %5}, ""time_left"": %6}",
                    _sectorName,
                    _resourceName,
                    _supplyValue,
                    _ammoValue,
                    _fuelValue,
                    _time
                ];
                diag_log _factoryJson;
            } forEach KPLIB_production;

            diag_log "--- FACTORY_DATA_END ---";
        };
    }, 
    600, 
    []
] call CBA_fnc_addPerFrameHandler;