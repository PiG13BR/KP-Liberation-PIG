#include "defines.hpp"

// Check if CBA is running
if (isClass (configFile >> "CfgPatches" >> "cba_main")) then {KPLIB_CBA = true} else {KPLIB_CBA = false};
// Check if Lambs is running
if (isClass (configfile >> "CfgPatches" >> "lambs_wp")) then {KPLIB_LAMBS = true; ["LAMBS_danger detected.", "MOD"] call KPLIB_fnc_log;} else {KPLIB_LAMBS = false};
// Check if ACE is running
if (isClass (configfile >> "CfgPatches" >> "ace_common")) then {KPLIB_ace = true; ["ACE detected. Deactivating resupply script from Liberation.", "MOD"] call KPLIB_fnc_log;} else {KPLIB_ace = false};
// Check if ACE Medical is running
if (isClass (configfile >> "CfgPatches" >> "ace_medical")) then {KPLIB_ace_med = true; ["ACE Medical detected. switch some script for ACE Medical.", "MOD"] call KPLIB_fnc_log;} else {KPLIB_ace_med = false};
// Check if KP Ranks is running
if (isClass (configFile >> "CfgPatches" >> "KP_Ranks")) then {KPPLM_KPR = true} else {KPPLM_KPR = false};
// Check if KLPQ is running
if (isClass (configfile >> "CfgPatches" >> "klpq_musicRadio")) then {KPLIB_klpq = true;} else {KPLIB_klpq = false};

/* Not saveable params */
KPLIB_param_wipe_savegame_1 = ["WipeSave1", 0] call bis_fnc_getParamValue;
KPLIB_param_wipe_savegame_2 = ["WipeSave2", 0] call bis_fnc_getParamValue;
KPLIB_civinfo_debug = ["DebugCivInfo", 0] call bis_fnc_getParamValue;
KPLIB_civrep_debug = ["DebugCivRep", 0] call bis_fnc_getParamValue;
KPLIB_savegame_debug = ["DebugSave", 0] call bis_fnc_getParamValue;
KPLIB_asymmetric_debug = ["DebugAsymmetric", 0] call bis_fnc_getParamValue;
KPLIB_logistic_debug = ["DebugLogistic", 0] call bis_fnc_getParamValue;
KPLIB_sectorspawn_debug = ["DebugSectorSpawn", 0] call bis_fnc_getParamValue;
KPLIB_kill_debug = ["DebugKill", 0] call bis_fnc_getParamValue;
KPLIB_production_debug = ["DebugProduction", 0] call bis_fnc_getParamValue;
KPLIB_highcommand_debug = ["DebugHighCommand", 0] call bis_fnc_getParamValue;

KP_load_params = ["LoadSaveParams", 1] call BIS_fnc_getParamValue;

if(isServer) then {
    /* Saveable params */
    ["----- Server starts parameter initialization", "PARAM"] call KPLIB_fnc_log;
    switch (KP_load_params) do {
        case 0: {
            ["Save/Load is set to SAVE", "PARAM"] call KPLIB_fnc_log;
        };
        case 1: {
            ["Save/Load is set to LOAD", "PARAM"] call KPLIB_fnc_log;
        };
        case 2: {
            ["Save/Load is set to USE SELECTED", "PARAM"] call KPLIB_fnc_log;
        };
        default {
            ["Save/Load has no valid value", "PARAM"] call KPLIB_fnc_log;
        };
    };

    // Presets
    ["--- Presets ---", "PARAM"] call KPLIB_fnc_log;
    GET_PARAM(KPLIB_presetPlayer, "BLUFORPreset", 0);
    GET_PARAM(KPLIB_presetEnemy, "OPFORPreset", 0);
    GET_PARAM(KPLIB_presetResistance, "guerPreset", 0);
    GET_PARAM(KPLIB_presetCivilians, "civPreset", 0);
    GET_PARAM(KPLIB_param_useArsenalPreset, "ArsenalUsePreset", 1);
    GET_PARAM(KPLIB_presetArsenal, "arsenalPreset", 0);
    GET_PARAM(KPLIB_presetArsenalWhitelist, "arsenalWhiteListPreset", 0);

    // Mission Options
    ["--- Mission Options ---", "PARAM"] call KPLIB_fnc_log;
    GET_PARAM(KPLIB_param_unitcap, "Unitcap", 2);
    GET_PARAM(KPLIB_param_difficulty, "Difficulty", 2);
    GET_PARAM(KPLIB_param_aggressivity, "Aggressivity", 2);
    GET_PARAM_BOOL(KPLIB_param_adaptive, "AdaptToPlayercount", 1);
    GET_PARAM(KPLIB_param_civActivity, "Civilians", 1);
    GET_PARAM_BOOL(KPLIB_param_firstFobBuilt, "FirstFob", 0);
    GET_PARAM_BOOL(KPLIB_param_fobVehicle, "FirstFobVehicle", 0);
    GET_PARAM(KPLIB_param_maxFobs, "MaximumFobs", 26);
    GET_PARAM(KPLIB_param_maxSquadSize, "MaxSquadSize", 10);
    GET_PARAM_BOOL(KPLIB_param_bluforDefenders, "BluforDefenders", 1);
    GET_PARAM_BOOL(KPLIB_param_autodanger, "Autodanger", 0);
    GET_PARAM(KPLIB_param_timeMulti, "DayDuration", 12);
    GET_PARAM_BOOL(KPLIB_param_shorterNights, "ShorterNights", 0);
    GET_PARAM(KPLIB_param_weather, "Weather", 3);
    GET_PARAM_BOOL(KPLIB_param_vanillaFog, "VanillaFog", 1);
    GET_PARAM(KPLIB_param_resourcesMulti, "ResourcesMultiplier", 3);
    GET_PARAM_BOOL(KPLIB_param_arsenalType, "ArsenalType", 0);
    GET_PARAM_BOOL(KPLIB_param_directArsenal, "DirectArsenal", 0);
    GET_PARAM_BOOL(KPLIB_param_playerMenu, "PlayerMenu", 1);
    GET_PARAM(KPLIB_param_victoryCondition, "VictoryCondition", 0);

    // Deactivate BI Revive when ACE Medical is running
    if (KPLIB_ace_med) then {
        bis_reviveParam_mode = 0; publicVariable "bis_reviveParam_mode";
        ["ACE Medical detected. Deactivating BI Revive System.", "PARAM"] call KPLIB_fnc_log;
    } else {
        // Revive Options
        ["--- Revive Options ---", "PARAM"] call KPLIB_fnc_log;
        GET_PARAM(bis_reviveParam_mode, "ReviveMode", 1);
        GET_PARAM(bis_reviveParam_duration, "ReviveDuration", 6);
        GET_PARAM(bis_reviveParam_requiredTrait, "ReviveRequiredTrait", 1);
        GET_PARAM(bis_reviveParam_medicSpeedMultiplier, "ReviveMedicSpeedMultiplier", 1);
        GET_PARAM(bis_reviveParam_requiredItems, "ReviveRequiredItems", 1);
        GET_PARAM(bis_reviveParam_unconsciousStateMode, "UnconsciousStateMode", 0);
        GET_PARAM(bis_reviveParam_bleedOutDuration, "ReviveBleedOutDuration", 180);
        GET_PARAM(bis_reviveParam_forceRespawnDuration, "ReviveForceRespawnDuration", 10);
    };

    // Extension Options
    ["--- Extension Options ---", "PARAM"] call KPLIB_fnc_log;
    GET_PARAM_BOOL(KPLIB_param_enemyArtillery, "EnemyArtillery", 1);
    GET_PARAM_BOOL(KPLIB_param_ArtyMenu, "ArtyMenu", 1);
    GET_PARAM_BOOL(KPLIB_param_clearBrush, "ClearBrushes", 1);
    GET_PARAM_BOOL(KPLIB_param_enemyFighters, "EnemyFighters", 1);
    GET_PARAM(KPLIB_param_lockArsenal, "LockArsenal", 0);
    GET_PARAM_BOOL(KPLIB_param_pylonManager, "PylonManager", 1);
    GET_PARAM_BOOL(KPLIB_param_rallyPoint, "RallyPoint", 1);
    GET_PARAM(KPLIB_param_SAMSite, "SAMSites", 1);
    GET_PARAM(KPLIB_param_SectorEvents, "SectorEvents", 0);
    GET_PARAM(KPLIB_param_respawnCost, "RespawnCost", 0);
    GET_PARAM_BOOL(KPLIB_param_VAMGUI, "VAMGUI", 1);

    // Gameplay Options
    ["--- Gameplay Options ---", "PARAM"] call KPLIB_fnc_log;
    GET_PARAM_BOOL(KPLIB_param_fatigue, "Fatigue", 1);
    GET_PARAM_BOOL(KPLIB_param_weaponSway, "WeaponSway", 1);
    GET_PARAM_BOOL(KPLIB_param_mapMarkers, "MapMarkers", 1);
    GET_PARAM_BOOL(KPLIB_param_mobileRespawn, "MobileRespawn", 1);
    GET_PARAM(KPLIB_param_mobileRespawnCooldown, "RespawnCooldown", 900);
    GET_PARAM_BOOL(KPLIB_param_mobileArsenal, "MobileArsenal", 1);
    GET_PARAM_BOOL(KPLIB_param_attackedFobRespawn, "AttackedSectorRespawn", 0);
    GET_PARAM_BOOL(KPLIB_param_fullHeal, "FOBFullHeal", 1);
    GET_PARAM_BOOL(KPLIB_param_fullHealCheckEnemies, "FOBFullHealCheckEnemies", 1);
    GET_PARAM(KPLIB_param_fullHealCooldown, "FOBFullHealCooldown", 300);
    GET_PARAM_BOOL(KPLIB_param_timeweather, "FOBTimeWeather", 1);
    GET_PARAM_BOOL(KPLIB_param_fuelconsumption, "FuelConsumption", 1);
    GET_PARAM_BOOL(KPLIB_param_logistic, "AiLogistics", 1);
    GET_PARAM_BOOL(KPLIB_param_buildingDamaged, "CR_Building", 0);
    GET_PARAM(KPLIB_param_halo, "HaloJump", 1);
    GET_PARAM_BOOL(KPLIB_param_clearCargo, "ClearCargo", 1);
    GET_PARAM(KPLIB_param_allowEnemiesInImmobile, "AllowEnemiesInImmobile", 50);
    GET_PARAM(KPLIB_param_maxDespawnDelay, "DelayDespawnMax", 5);
    GET_PARAM_BOOL(KPLIB_param_zeusAddEnemies, "ZeusAddEnemies", 1);
    GET_PARAM_BOOL(KPLIB_param_highCommand, "HighCommand", 1);
    GET_PARAM(KPLIB_param_supportModule, "SuppMod", 1);
    GET_PARAM_BOOL(KPLIB_param_tutorial, "Tutorial", 1);
    GET_PARAM_BOOL(KPLIB_param_airActiveSector, "airActiveSector", 0);
    
    // Technical Options
    ["--- Technical Options ---", "PARAM"] call KPLIB_fnc_log;
    GET_PARAM_BOOL(KPLIB_param_permissions, "Permissions", 1);
    GET_PARAM(KPLIB_param_vehicleCleanup, "CleanupVehicles", 2);
    GET_PARAM_BOOL(KPLIB_param_introCinematic, "Introduction", 1);
    GET_PARAM_BOOL(KPLIB_param_deployCinematic, "DeploymentCinematic", 1);
    GET_PARAM(KPLIB_param_restart, "ServerRestart", 0);

    GREUH_allow_mapmarkers = KPLIB_param_mapMarkers; publicVariable "GREUH_allow_mapmarkers";
    GREUH_allow_platoonview = KPLIB_param_mapMarkers; publicVariable "GREUH_allow_platoonview";
};

// Fix for not working float values in mission params
switch (KPLIB_param_unitcap) do {
    case 0: {KPLIB_param_unitcap = 0.5;};
    case 1: {KPLIB_param_unitcap = 0.75;};
    case 2: {KPLIB_param_unitcap = 1;};
    case 3: {KPLIB_param_unitcap = 1.25;};
    case 4: {KPLIB_param_unitcap = 1.5;};
    case 5: {KPLIB_param_unitcap = 2;};
    default {KPLIB_param_unitcap = 1;};
};

switch (KPLIB_param_difficulty) do {
    case 0: {KPLIB_param_difficulty = 0.5;};
    case 1: {KPLIB_param_difficulty = 0.75;};
    case 2: {KPLIB_param_difficulty = 1;};
    case 3: {KPLIB_param_difficulty = 1.25;};
    case 4: {KPLIB_param_difficulty = 1.5;};
    case 5: {KPLIB_param_difficulty = 2;};
    case 6: {KPLIB_param_difficulty = 4;};
    case 7: {KPLIB_param_difficulty = 10;};
    default {KPLIB_param_difficulty = 1;};
};

switch (KPLIB_param_aggressivity) do {
    case 0: {KPLIB_param_aggressivity = 0.25;};
    case 1: {KPLIB_param_aggressivity = 0.5;};
    case 2: {KPLIB_param_aggressivity = 1;};
    case 3: {KPLIB_param_aggressivity = 2;};
    case 4: {KPLIB_param_aggressivity = 4;};
    default {KPLIB_param_aggressivity = 1;};
};

switch (KPLIB_param_civActivity) do {
    case 0: {KPLIB_param_civActivity = 0;};
    case 1: {KPLIB_param_civActivity = 0.5;};
    case 2: {KPLIB_param_civActivity = 1;};
    case 3: {KPLIB_param_civActivity = 2;};
    default {KPLIB_param_aggressivity = 1;};
};

switch (KPLIB_param_resourcesMulti) do {
    case 0: {KPLIB_param_resourcesMulti = 0.25;};
    case 1: {KPLIB_param_resourcesMulti = 0.5;};
    case 2: {KPLIB_param_resourcesMulti = 0.75;};
    case 3: {KPLIB_param_resourcesMulti = 1;};
    case 4: {KPLIB_param_resourcesMulti = 1.25;};
    case 5: {KPLIB_param_resourcesMulti = 1.5;};
    case 6: {KPLIB_param_resourcesMulti = 2;};
    case 7: {KPLIB_param_resourcesMulti = 3;};
    default {KPLIB_param_resourcesMulti = 1;};
};

switch (KPLIB_param_victoryCondition) do {
    case 1: {
        KPLIB_victoryCheck = {
            (count (KPLIB_sectors_player select {_x in KPLIB_sectors_capital})) == (count KPLIB_sectors_capital)
            &&
            {
                (count (KPLIB_sectors_player select {_x in KPLIB_sectors_military})) == (count KPLIB_sectors_military)
            }
        };
    };
    case 2: {
        KPLIB_victoryCheck = {
            (count (KPLIB_sectors_player select {_x in KPLIB_sectors_capital})) == (count KPLIB_sectors_capital)
            &&
            {
                (count (KPLIB_sectors_player select {!(_x in KPLIB_sectors_capital)})) >= ((count (KPLIB_sectors_all - KPLIB_sectors_capital)) * 0.6)
            }
        };
    };
    case 3: {
        KPLIB_victoryCheck = {
            (count (KPLIB_sectors_player select {_x in KPLIB_sectors_capital})) == (count KPLIB_sectors_capital)
            &&
            {
                (count (KPLIB_sectors_player select {!(_x in KPLIB_sectors_capital)})) >= ((count (KPLIB_sectors_all - KPLIB_sectors_capital)) * 0.8)
            }
        };
    };
    case 4: {
        KPLIB_victoryCheck = {
            (count KPLIB_sectors_player) == (count KPLIB_sectors_all)
        };
    };
    default {
        KPLIB_victoryCheck = {
            (count (KPLIB_sectors_player select {_x in KPLIB_sectors_capital})) == (count KPLIB_sectors_capital)
        };
    };
};

if(isServer) then {
    private _start = diag_tickTime;
    KPLIB_param_serverInitDone = true;
    publicVariable "KPLIB_param_serverInitDone";
    [format ["----- Server finished parameter initialization - Time needed: %1 seconds", diag_ticktime - _start], "PARAM"] call KPLIB_fnc_log;
};

if (!isDedicated && hasInterface) then {
    // Create diary section for an overview of actual mission parameters
    player createDiarySubject ["parameters", "Mission Parameters"];

    private _value = 0;
    private _text = "";
    
    _param = localize "STR_PARAMS_BLUFORPRESET";
    switch (KPLIB_presetPlayer) do {
        case 1: {_value = "Apex Tanoa";};
        case 2: {_value = "3cb BAF (MTP)";};
        case 3: {_value = "3cb BAF (Desert)";};
        case 4: {_value = "BWMod Bundeswehr (Flecktarn)";};
        case 5: {_value = "BWMod Bundeswehr (Tropentarn)";};
        case 6: {_value = "RHS USAF (Woodland)";};
        case 7: {_value = "RHS USAF (Desert)";};
        case 8: {_value = "RHS AFRF (VDV/MSV)";};
        case 9: {_value = "Germany West (Global Mobilization)";};
        case 10: {_value = "Germany West Winter (Global Mobilization)";};
        case 11: {_value = "Germany East (Global Mobilization)";};
        case 12: {_value = "Germany East Winter (Global Mobilization)";};
        case 13: {_value = "CSAT Brown";};
        case 14: {_value = "CSAT Green";};
        case 15: {_value = "Unsung US";};
        case 16: {_value = "CUP British Armed Forces (Desert)";};
        case 17: {_value = "CUP British Armed Forces (Woodland)";};
        case 18: {_value = "CUP US Marine Corps (Desert)";};
        case 19: {_value = "CUP US Marine Corps (Woodland)";};
        case 20: {_value = "CUP US Army (Desert)";};
        case 21: {_value = "CUP US Army (Woodland)";};
        case 22: {_value = "CUP Chernarus Defense Force";};
        case 23: {_value = "CUP Army of the Czech Republic (Desert)";};
        case 24: {_value = "CUP Army of the Czech Republic (Woodland)";};
        case 25: {_value = "CUP Chernarussian Movement of the Red Star";};
        case 26: {_value = "CUP Sahrani Liberation Army";};
        case 27: {_value = "CUP Takistani Army";};
        case 28: {_value = "SFP (Woodland)";};
        case 29: {_value = "SFP (Desert)";};
        case 30: {_value = "LDF (Contact DLC)";};
        case 31: {_value = "CUP AAF Deserters mix (AAF, Aegis Task Force and CTRG)";};
        default {_value = "Default (Vanilla NATO)"};
    };
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_OPFORPRESET";
    switch (KPLIB_presetEnemy) do {
        case 1: {_value = "Apex Tanoa";};
        case 2: {_value = "RHS AFRF (EMR/MSV)";};
        case 3: {_value = "Project OPFOR (Takistan)";};
        case 4: {_value = "Project OPFOR (Islamic State)";};
        case 5: {_value = "Project OPFOR (Sahrani)";};
        case 6: {_value = "AAF";};
        case 7: {_value = "NATO";};
        case 8: {_value = "Germany West (Global Mobilization)";};
        case 9: {_value = "Germany West Winter (Global Mobilization)";};
        case 10: {_value = "Germany East (Global Mobilization)";};
        case 11: {_value = "Germany East Winter (Global Mobilization)";};
        case 12: {_value = "Unsung NVA";};
        case 13: {_value = "CUP Sahrani Liberation Army";};
        case 14: {_value = "CUP Takistani Army";};
        case 15: {_value = "CUP Chernarussian Movement of the Red Star";};
        case 16: {_value = "CUP Armed Forces of the Russian Federation (MSV - EMR)";};
        case 17: {_value = "CUP Armed Forces of the Russian Federation (Modern MSV)";};
        case 18: {_value = "CUP Chernarus Defense Force";};
        case 19: {_value = "CUP British Armed Forces (Desert)";};
        case 20: {_value = "CUP British Armed Forces (Woodland)";};
        case 21: {_value = "CUP AAF";};
        default {_value = "Default (Vanilla CSAT)"};
    };
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_GUERPRESET";
    switch (KPLIB_presetResistance) do {
        case 1: {_value = "Apex Tanoa (apex vanilla Syndikat)";};
        case 2: {_value = "RHS GREF";};
        case 3: {_value = "Project OPFOR (Middle Eastern)";};
        case 4: {_value = "Project OPFOR (Sahrani)";};
        case 5: {_value = "Germany (Global Mobilization)";};
        case 6: {_value = "Unsung";};
        case 7: {_value = "CUP Takistani Locals";};
        case 8: {_value = "CUP National Party of Chernarus";};
        case 9: {_value = "CUP FIA";};
        default {_value = "Default Vanilla FIA"};
    };
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_CIVPRESET";
    switch (KPLIB_presetCivilians) do {
        case 1: {_value = "Apex Tanoa (apex vanilla)";};
        case 2: {_value = "Project OPFOR (Middle Eastern)";};
        case 3: {_value = "RDS Civilians";};
        case 4: {_value = "Germany (Global Mobilization)";};
        case 5: {_value = "CUP Takistani Civilians";};
        case 6: {_value = "Unsung";};
        case 7: {_value = "CUP Chernarussian Civilians";};
        case 8: {_value = "CUP ACW";};
        default {_value = "Default Vanilla"};
    };
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_ARSENALUSEPRESET";
    switch (KPLIB_param_useArsenalPreset) do {
        case 1: {_value = localize "STR_PARAMS_USEPRESET";};
        case 2: {_value = localize "STR_PARAMS_ARSENAL_WHITELIST";};
        default {_value = localize "STR_PARAMS_NORESTRICTIONS";};
    };

    _param = localize "STR_PARAMS_ARSENALPRESET";
    switch (KPLIB_param_useArsenalPreset) do {
        case 1: {};
        case 2: {};
        default {};
    };
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_ARSENALPRESET";
    switch (KPLIB_presetArsenal) do {
        case 1: {_value = "Custom arsenal preset (Presets\Arsenal\custom.sqf)";};
        case 2: {_value = "RHS USAF arsenal preset",;};
        case 3: {_value = "3cbBAF and RHS USAF arsenal preset";};
        case 4: {_value = "GM West arsenal preset";};
        case 5: {_value = "GM East arsenal preset";};
        case 6: {_value = "CSAT arsenal preset";};
        case 7: {_value = "Unsung US arsenal preset";};
        case 8: {_value = "SFP arsenal preset";};
        case 9: {_value = "BWMod arsenal preset";};
        case 10: {_value = "NATO MTP arsenal preset";};
        case 11: {_value = "NATO Tropic arsenal preset";};
        case 12: {_value = "NATO Woodland arsenal preset";};
        case 13: {_value = "CSAT Hex arsenal preset";};
        case 14: {_value = "CSAT Green Hex arsenal preset";};
        case 15: {_value = "AAF arsenal preset";};
        case 16: {_value = "LDF arsenal preset";};
        default {_value = "Blacklist method (Presets\Arsenal\blacklist.sqf)"};
    };
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];
    
    _param = localize "STR_PARAMS_ARSENALWHITELIST_PRESET";
    switch (KPLIB_presetArsenalWhitelist) do {
        default {_value = "Custom Preset (Presets\Arsenal\roles_presets\custom.sqf)"};
    };
    
    _param = localize "STR_PARAMS_UNITCAP";
    _value = (format ["%1", KPLIB_param_unitcap * 100]) + "%";
    _text = format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_DIFFICULTY";
    switch (KPLIB_param_difficulty) do {
        case 0.75: {_value = localize "STR_PARAMS_DIFFICULTY2";};
        case 1: {_value = localize "STR_PARAMS_DIFFICULTY3";};
        case 1.25: {_value = localize "STR_PARAMS_DIFFICULTY4";};
        case 1.5: {_value = localize "STR_PARAMS_DIFFICULTY5";};
        case 2: {_value = localize "STR_PARAMS_DIFFICULTY6";};
        case 4: {_value = localize "STR_PARAMS_DIFFICULTY7";};
        case 10: {_value = localize "STR_PARAMS_DIFFICULTY8";};
        default {_value = localize "STR_PARAMS_DIFFICULTY1";};
    };
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_AGGRESSIVITY_PARAM";
    switch (KPLIB_param_aggressivity) do {
        case 0.5: {_value = localize "STR_AGGRESSIVITY_PARAM1";};
        case 1: {_value = localize "STR_AGGRESSIVITY_PARAM2";};
        case 2: {_value = localize "STR_AGGRESSIVITY_PARAM3";};
        case 4: {_value = localize "STR_AGGRESSIVITY_PARAM4";};
        default {_value = localize "STR_AGGRESSIVITY_PARAM0";};
    };
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAM_ADAPT_TO_PLAYERCOUNT";
    _value = if (KPLIB_param_adaptive) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_CIVILIANS";
    switch (KPLIB_param_civActivity) do {
        case 0.5: {_value = localize "STR_PARAMS_CIVILIANS2";};
        case 1: {_value = localize "STR_PARAMS_CIVILIANS3";};
        case 2: {_value = localize "STR_PARAMS_CIVILIANS4";};
        default {_value = localize "STR_PARAMS_CIVILIANS1";};
    };
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_FIRSTFOB";
    _value = if (KPLIB_param_firstFobBuilt) then {localize "STR_YES";} else {localize "STR_NO";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_FIRSTFOBVEHICLE";
    _value = if (KPLIB_param_fobVehicle) then {localize "STR_PARAMS_FIRSTFOBVEHICLE_TRUCK";} else {localize "STR_PARAMS_FIRSTFOBVEHICLE_CONTAINTER";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAM_FOBS_COUNT";
    _value = str KPLIB_param_maxFobs;
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAM_SQUAD_SIZE";
    _value = str KPLIB_param_maxSquadSize;
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAM_BLUFOR_DEFENDERS";
    _value = if (KPLIB_param_bluforDefenders) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAM_AUTODANGER";
    _value = if (KPLIB_param_autodanger) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_DAYDURATION";
    _value = str (24 / KPLIB_param_timeMulti);
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_SHORTER_NIGHTS_PARAM";
    _value = if (KPLIB_param_shorterNights) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_WEATHER_PARAM";
    switch (KPLIB_param_weather) do {
        case 2: {_value = localize "STR_WEATHER_PARAM2";};
        case 3: {_value = localize "STR_WEATHER_PARAM3";};
        default {_value = localize "STR_WEATHER_PARAM1";};
    };
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_FOG_PARAM";
    _value = if (KPLIB_param_vanillaFog) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_RESOURCESMULTIPLIER";
    _value = format ["x%1", KPLIB_param_resourcesMulti];
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_ARSENAL";
    _value = if (KPLIB_param_arsenalType) then {localize "STR_PARAMS_ARSENAL_ACE";} else {localize "STR_PARAMS_ARSENAL_BI";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_DIRECTARSENAL";
    _value = if (KPLIB_param_directArsenal) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_PLAYERMENU_KP";
    _value = if (KPLIB_param_playerMenu) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_KPPLM_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_VICTORYCONDITION";
    switch (KPLIB_param_victoryCondition) do {
        case 1: {_value = localize "STR_PARAMS_VICTORYCONDITION_1";};
        case 2: {_value = localize "STR_PARAMS_VICTORYCONDITION_2";};
        case 3: {_value = localize "STR_PARAMS_VICTORYCONDITION_3";};
        case 4: {_value = localize "STR_PARAMS_VICTORYCONDITION_4";};
        default {_value = localize "STR_PARAMS_VICTORYCONDITION_0";};
    };
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_TITLE_ENEMYARTILLERY";
    _value = if (KPLIB_param_enemyArtillery) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_ARTY_MENU_TITLE";
    _value = if (KPLIB_param_ArtyMenu) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_CLEAR_BRUSHES_TITLE";
    _value = if (KPLIB_param_clearBrush) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];
    
    _param = localize "STR_ENEMY_FIGHTER_TITLE";
    _value = if (KPLIB_param_enemyFighters) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_LOCK_ARSENAL_TITLE";
    switch (KPLIB_param_lockArsenal) do {
        case 1: {_value = localize "STR_LOCK_ARSENAL_DEFAULT"};
        default {_value = localize "STR_PARAMS_DISABLED"};
    };
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_TITLE_PYLONMANAGER";
    _value = if (KPLIB_param_pylonManager) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_TITLE_RALLYPOINT";
    _value = if (KPLIB_param_rallyPoint) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_SAM_TITLE";
    switch (KPLIB_param_SAMSite) do {
        case 1: {_value = localize "STR_PARAMS_SAM_ENABLED_DEFAULT"};
        case 2: {_value = localize "STR_PARAMS_SAM_ENABLED_CUSTOM"};
        default {_value = localize "STR_PARAMS_DISABLED"};
    };
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_SECTOR_EVENTS_TITLE";
        switch (KPLIB_param_SectorEvents) do {
        case 1: {_value = localize "STR_SECTOR_EVENTS_CUSTOM"};
        case 2: {_value = localize "STR_SECTOR_EVENTS_ALTIS"};
        default {_value = localize "STR_PARAMS_DISABLED"};
    };
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];
    
    _param = localize "STR_PARAMS_RESPAWNCOST";
    switch (KPLIB_param_respawnCost) do {
        case 1: {_value = localize "STR_PARAMS_RESPAWNCOST_1"};
        case 2: {_value = localize "STR_PARAMS_RESPAWNCOST_2"};
        case 3: {_value = localize "STR_PARAMS_RESPAWNCOST_3"};
        case 4: {_value = localize "STR_PARAMS_RESPAWNCOST_4"};
        Case 5: {_value = localize "STR_PARAMS_RESPAWNCOST_5"};
        default {_value = localize "STR_PARAMS_DISABLED"};
    };
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_VAM_GUI_TITLE";
    _value = if (KPLIB_param_VAMGUI) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];
   
    _param = localize "STR_A3_ReviveMode";
    _value = if (bis_reviveParam_mode == 1) then {localize "STR_A3_EnabledForAllPlayers";} else {localize "STR_A3_Disabled";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    if (bis_reviveParam_mode == 1) then {
        _param = localize "STR_A3_ReviveDuration";
        _value = str bis_reviveParam_duration;
        _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

        _param = localize "STR_A3_RequiredTrait";
        _value = if (bis_reviveParam_requiredTrait == 1) then {localize "STR_A3_Medic";} else {localize "STR_A3_None";};
        _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

        _param = localize "STR_A3_RequiredTrait_MedicSpeedMultiplier";
        _value = format ["x%1", bis_reviveParam_medicSpeedMultiplier];
        _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

        _param = localize "STR_A3_RequiredItems";
        switch (bis_reviveParam_requiredItems) do {
            case 1: {_value = localize "STR_A3_Medikit";};
            case 2: {_value = localize "STR_A3_FirstAidKitOrMedikit";};
            default {_value = localize "STR_A3_None";};
        };
        _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

        _param = localize "STR_A3_IncapacitationMode";
        switch (bis_reviveParam_unconsciousStateMode) do {
            case 1: {_value = localize "STR_A3_Advanced";};
            case 2: {_value = localize "STR_A3_Realistic";};
            default {_value = localize "STR_A3_Basic";};
        };
        _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

        _param = localize "STR_A3_BleedOutDuration";
        _value = str bis_reviveParam_bleedOutDuration;
        _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

        _param = localize "STR_A3_ForceRespawnDuration";
        _value = str bis_reviveParam_forceRespawnDuration;
        _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];
    };

    _param = localize "STR_PARAMS_FATIGUE";
    _value = if (KPLIB_param_fatigue) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAM_WEAPSWAY";
    _value = if (KPLIB_param_weaponSway) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_MAPMARKERS";
    _value = if (KPLIB_param_mapMarkers) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_MOBILERESPAWN";
    _value = if (KPLIB_param_mobileRespawn) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAM_RESPAWN_COOLDOWN";
    _value = if (KPLIB_param_mobileRespawnCooldown == 0) then {localize "STR_PARAMS_DISABLED";} else {str (KPLIB_param_mobileRespawnCooldown / 60);};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_MOBILEARSENAL";
    _value = if (KPLIB_param_mobileArsenal) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_ATTACKEDSECTORRESPAWN";
    _value = if (KPLIB_param_attackedFobRespawn) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_FOBFULLHEAL";
    _value = if (KPLIB_param_fullHeal) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_FOBFULLHEAL_CHECKENEMIES";
    _value = if (KPLIB_param_fullHealCheckEnemies) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_FOBFULLHEAL_COOLDOWN";
    _value = if (KPLIB_param_fullHealCooldown == 0) then {localize "STR_PARAMS_DISABLED";} else {str (KPLIB_param_fullHealCooldown / 60);};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_FOBTIMEWEATHER";
    _value = if (KPLIB_param_timeweather) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_FUELCONSUMPTION";
    _value = if (KPLIB_param_fuelconsumption) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_AILOGISTICS";
    _value = if (KPLIB_param_logistic) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAM_CR_BUILDING";
    _value = if (KPLIB_param_buildingDamaged) then {localize "STR_PARAM_CR_DAMAGED";} else {localize "STR_PARAM_CR_DESTROYED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_HALO_PARAM";
    switch (KPLIB_param_halo) do {
        case 1: {_value = localize "STR_HALO_PARAM1";};
        case 5: {_value = localize "STR_HALO_PARAM2";};
        case 10: {_value = localize "STR_HALO_PARAM3";};
        case 15: {_value = localize "STR_HALO_PARAM4";};
        case 20: {_value = localize "STR_HALO_PARAM5";};
        case 30: {_value = localize "STR_HALO_PARAM6";};
        default {_value = localize "STR_PARAMS_DISABLED";};
    };
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAM_CLEAR_CARGO";
    _value = if (KPLIB_param_clearCargo) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAM_ALLOW_ENEMIES_IN_IMMOBILE";
    _value = if (KPLIB_param_allowEnemiesInImmobile == 0) then {localize "STR_PARAMS_DISABLED";} else {KPLIB_param_allowEnemiesInImmobile;};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAM_DELAY_DESPAWN_MAX";
    _value = if (KPLIB_param_maxDespawnDelay == 0) then {localize "STR_PARAMS_DISABLED";} else {KPLIB_param_maxDespawnDelay;};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAM_ZEUSADDENEMIES";
    _value = if (KPLIB_param_zeusAddEnemies) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAM_HIGHCOMMAND";
    _value = if (KPLIB_param_highCommand) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAM_SUPPMOD";
    switch (KPLIB_param_supportModule) do {
        case 1: {_value = localize "STR_PARAM_SUPPMOD_CMDRANDWHITELIST";};
        case 2: {_value = localize "STR_PARAM_SUPPMOD_EVERYONE";};
        default {_value = localize "STR_PARAMS_DISABLED";};
    };
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAM_TUTORIAL";
    _value = if (KPLIB_param_tutorial) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAM_AIR_ACTIVESECTOR";
    _value = if (KPLIB_param_airActiveSector) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PERMISSIONS_PARAM";
    _value = if (KPLIB_param_permissions) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_CLEANUP_PARAM";
    switch (KPLIB_param_vehicleCleanup) do {
        case 1: {_value = localize "STR_CLEANUP_PARAM1";};
        case 2: {_value = localize "STR_CLEANUP_PARAM2";};
        case 4: {_value = localize "STR_CLEANUP_PARAM3";};
        default {_value = localize "STR_PARAMS_DISABLED";};
    };
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_INTRO";
    _value = if (KPLIB_param_introCinematic) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_PARAMS_DEPLOYMENTCAMERA";
    _value = if (KPLIB_param_deployCinematic) then {localize "STR_PARAMS_ENABLED";} else {localize "STR_PARAMS_DISABLED";};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    _param = localize "STR_RESTART_PARAM";
    _value = if (KPLIB_param_restart == 0) then {localize "STR_PARAMS_DISABLED";} else {KPLIB_param_restart;};
    _text = _text + format ["<font color='#ff8000'>%1</font><br />%2<br /><br />", _param, _value];

    player createDiaryRecord ["parameters", ["Active", _text]];
};

// Adjustments calculation depending on selected mission parameters (shouldn't be edited)
KPLIB_production_interval   = ceil (KPLIB_production_interval / KPLIB_param_resourcesMulti);
KPLIB_battlegroup_size      = KPLIB_battlegroup_size * (sqrt KPLIB_param_unitcap) * (sqrt KPLIB_param_aggressivity);
KPLIB_civilians_amount      = KPLIB_civilians_amount * KPLIB_param_civActivity;
KPLIB_cap_playerSide        = (KPLIB_cap_playerSide * KPLIB_param_unitcap) min 100;
KPLIB_cap_enemySide         = KPLIB_cap_enemySide * KPLIB_param_unitcap;
KPLIB_cap_battlegroup       = KPLIB_cap_battlegroup * KPLIB_param_unitcap;
KPLIB_cap_patrol            = KPLIB_cap_patrol * KPLIB_param_unitcap;
