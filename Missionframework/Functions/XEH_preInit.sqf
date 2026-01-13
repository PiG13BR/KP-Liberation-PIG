KPLIB_endgame = 0;

// Version of the KP Liberation framework
KPLIB_version = [0, 97, "0pig"];

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

// Read configuration
[] call compile preprocessFileLineNumbers 'Configurations\KPLIB_config.sqf';

// Read whitelist
[] call compile preprocessFileLineNumbers 'Configurations\KPLIB_whitelists.sqf';

// Read transport configuration (to carry crate resources)
[] call compile preprocessFileLineNumbers 'Configurations\KPLIB_transportConfigs.sqf';

// Read misc classname list
[] call compile preprocessFileLineNumbers 'Configurations\KPLIB_classnameLists.sqf';

["XEH Preinit done", "XEH PREINIT"] call KPLIB_fnc_log;