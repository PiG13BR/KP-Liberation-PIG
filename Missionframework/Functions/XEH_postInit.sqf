KPLIB_respawn_marker = "respawn";

// Get mission parameters and transform them into usable variables
[] call compile preprocessFileLineNumbers 'Scripts\Shared\fetch_params.sqf';

// Read presets
[] call compile preprocessFileLineNumbers 'Presets\init_presets.sqf';

// Read objects inits
[] call compile preprocessFileLineNumbers 'Configurations\KPLIB_objectInits.sqf';

// Call init shared (scripts shared between client and server)
[] call compile preprocessFileLineNumbers 'Scripts\Shared\init_shared.sqf';

// Static weapons configuration
[] call compile preprocessFileLineNumbers 'Extensions\Sector_Objects\KPLIB_staticsConfigs.sqf';

// Lock arsenal items by sector
if (KPLIB_param_lockArsenal > 0) then {
    [] call compile preprocessFileLineNumbers 'Extensions\Lock_Arsenal\init_presets.sqf';
};

// Init sector variables
[] call KPLIB_fnc_initSectors;

// Sector events
if (KPLIB_param_sectorEvents > 0) then {
    [] call compile preprocessFileLineNumbers 'Extensions\Sector_Events\init_events.sqf';
};

// Set up CBA event handlers
[] call compile preprocessFileLineNumbers 'CBA_addEventHandler.sqf';

// Set up CBA settings
[] call compile preprocessFileLineNumbers 'CBA_initSettings.sqf';

// Load saved game and initiate server scripts
if (isServer) then {
    [] call KPLIB_fnc_loadSavedGame; 
    [] call compile preprocessFileLineNumbers "Scripts\Server\init_server.sqf";
};

["XEH Postinit done", "XEH POSTNIT"] call KPLIB_fnc_log;
KPLIB_postInit = true;