params["_sector"];

switch _sector do {
    // "Airport" sectors - land and deliver supplies
    case "military_8" :  {
        [format["Aeronave aliada irá pousar em alguns minutos em %1", markerText _sector]] remoteExec ["systemChat"];
        [{["Flex_CUP_FIA_CESSNA", 4, _this, KPLIB_b_heliPilotUnit] call KPLIB_fnc_spawnPlaneResources;}, _sector, 300] call CBA_fnc_waitAndExecute;
    };
    case "military" :  {
        [format["Aeronave aliada irá pousar em alguns minutos em %1", markerText _sector]] remoteExec ["systemChat"];
        [{["Flex_CUP_FIA_CESSNA", 3, _this, KPLIB_b_heliPilotUnit] call KPLIB_fnc_spawnPlaneResources;}, _sector, 300] call CBA_fnc_waitAndExecute;
        [format["O inimigo está preparando um contra-ataque em %1", markerText _sector]] remoteExec ["systemChat"];
        [{[_this, 3, "Helicopter"] call KPLIB_fnc_massiveCounterAttack;}, _sector, 60] call CBA_fnc_waitAndExecute;
    };
    case "military_4" :  {
        [format["Aeronave aliada irá pousar em alguns minutos em %1", markerText _sector]] remoteExec ["systemChat"];
        [{["Flex_CUP_FIA_CESSNA", 5, _this, KPLIB_b_heliPilotUnit] call KPLIB_fnc_spawnPlaneResources;}, _sector, 300] call CBA_fnc_waitAndExecute;
    };
    case "military_5" :  {
        [format["Aeronave aliada irá pousar em alguns minutos em %1", markerText _sector]] remoteExec ["systemChat"];
        [{["Flex_CUP_FIA_CESSNA", 2, _this, KPLIB_b_heliPilotUnit] call KPLIB_fnc_spawnPlaneResources;}, _sector, 300] call CBA_fnc_waitAndExecute;
    };
    case "military_7" :  {
        [format["Aeronave aliada irá pousar em alguns minutos em %1", markerText _sector]] remoteExec ["systemChat"];
        [{["Flex_CUP_FIA_CESSNA", 1, _this, KPLIB_b_heliPilotUnit] call KPLIB_fnc_spawnPlaneResources;}, _sector, 300] call CBA_fnc_waitAndExecute;
    };
    case "military_13" :  {
        if (_sector in KPLIB_sectors_player && {"military_14" in KPLIB_sectors_player}) then {
            [format["Aeronave aliada irá pousar em alguns minutos em %1", markerText _sector]] remoteExec ["systemChat"];
            [{["CUP_B_C130J_USMC", 0, _this, KPLIB_b_heliPilotUnit, [[KPLIB_b_crateSupply, 15], [KPLIB_b_crateAmmo, 15], [KPLIB_b_crateFuel, 10]]] call KPLIB_fnc_spawnPlaneResources;}, _sector, 300] call CBA_fnc_waitAndExecute;
        };
    };
    case "military_14" :  {
        if (_sector in KPLIB_sectors_player && {"military_13" in KPLIB_sectors_player}) then {
            [format["Aeronave aliada irá pousar em alguns minutos em %1", markerText _sector]] remoteExec ["systemChat"];
            [{["CUP_B_C130J_USMC", 0, _this, KPLIB_b_heliPilotUnit, [[KPLIB_b_crateSupply, 15], [KPLIB_b_crateAmmo, 15], [KPLIB_b_crateFuel, 10]]] call KPLIB_fnc_spawnPlaneResources;}, _sector, 300] call CBA_fnc_waitAndExecute;
        };
    };

    // Massive counter-attack
    case "bigtown" :  {
        KPLIB_sectorLiberated deleteAt (KPLIB_sectorLiberated find _sector); // Delete this sector from the captured list
        [format["O inimigo está preparando um contra-ataque em %1", markerText _sector]] remoteExec ["systemChat"];
        [{[_this, 3, "Plane"] call KPLIB_fnc_massiveCounterAttack;}, _sector, 60] call CBA_fnc_waitAndExecute;
    };
    case "bigtown_2" :  {
        KPLIB_sectorLiberated deleteAt (KPLIB_sectorLiberated find _sector); // Delete this sector from the captured list
        [format["O inimigo está preparando um contra-ataque em %1", markerText _sector]] remoteExec ["systemChat"];
        [{[_this, 2] call KPLIB_fnc_massiveCounterAttack;}, _sector, 60] call CBA_fnc_waitAndExecute;
    };
    case "bigtown_3" :  {
        KPLIB_sectorLiberated deleteAt (KPLIB_sectorLiberated find _sector); // Delete this sector from the captured list
        [format["O inimigo está preparando um contra-ataque em %1", markerText _sector]] remoteExec ["systemChat"];
        [{[_this, 2] call KPLIB_fnc_massiveCounterAttack;}, _sector, 60] call CBA_fnc_waitAndExecute;
    };
};