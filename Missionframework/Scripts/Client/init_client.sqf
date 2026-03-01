[] call compile preprocessFileLineNumbers "Scripts\Client\misc\init_markers.sqf";

[player] call KPLIB_fnc_initArsenal;
[player] call KPLIB_fnc_addPlayerEH;

spawn_camera = compile preprocessFileLineNumbers "Scripts\Client\spawn\spawn_camera.sqf";
cinematic_camera = compile preprocessFileLineNumbers "Scripts\Client\ui\cinematic_camera.sqf";
write_credit_line = compile preprocessFileLineNumbers "Scripts\Client\ui\write_credit_line.sqf";
kp_fuel_consumption = compile preprocessFileLineNumbers "Scripts\Client\misc\kp_fuel_consumption.sqf";
kp_vehicle_permissions = compile preprocessFileLineNumbers "Scripts\Client\misc\vehicle_permissions.sqf";

[player] call KPLIB_fnc_enforceCmdrWhitelist;
[player] call KPLIB_fnc_enforceZeusWhitelist;
[] call KPLIB_fnc_enforceZeusWhitelist;
if (KPLIB_param_mapMarkers) then {execVM "Scripts\Client\markers\empty_vehicles_marker.sqf";};
execVM "Scripts\Client\markers\fob_markers.sqf";
if (!KPLIB_param_highCommand && KPLIB_param_mapMarkers) then {execVM "Scripts\Client\markers\group_icons.sqf";};
execVM "Scripts\Client\markers\hostile_groups.sqf";
if (KPLIB_param_mapMarkers) then {execVM "Scripts\Client\markers\huron_marker.sqf";} else {deleteMarkerLocal "huronmarker"};
execVM "Scripts\Client\markers\sector_manager.sqf";
execVM "Scripts\Client\markers\spot_timer.sqf";
execVM "Scripts\Client\misc\broadcast_squad_colors.sqf";
execVM "Scripts\Client\misc\permissions_warning.sqf";
if (!KPLIB_ace) then {execVM "Scripts\Client\misc\resupply_manager.sqf";};
execVM "Scripts\Client\misc\secondary_jip.sqf";
execVM "Scripts\Client\misc\synchronise_vars.sqf";
execVM "Scripts\Client\misc\playerNamespace.sqf";
execVM "Scripts\Client\ui\ui_manager.sqf";
execVM "Scripts\Client\ui\tutorial_manager.sqf";

execVM "Scripts\Client\ui\intro.sqf";

[player] joinSilent (createGroup [KPLIB_side_player, true]);

// Commander init
if (player isEqualTo ([] call KPLIB_fnc_getCommander)) then {
    // Start tutorial
    if (KPLIB_param_tutorial) then {
        [] call KPLIB_fnc_tutorial;
    };
};

// Extensions
if (KPLIB_param_ArtyMenu && KPLIB_ace) then {
    [player] call KPLIB_fnc_addArtyMenuAction;
};


if (KPLIB_param_clearBrush && KPLIB_ace) then {
    [player] call KPLIB_fnc_clearBushAction;
};

if (KPLIB_param_rallyPoint && KPLIB_ace) then {
    [player] call KPLIB_fnc_addRallyPointAction;
};

if (KPLIB_param_VAMGUI) then {
    [] call compile preprocessFileLineNumbers 'Extensions\VAM_GUI\VAM_GUI_init.sqf'
};

/*
// Create a zeus interface for the player to access
if ((getPlayerUID player) in KPLIB_whitelist_Zeus) then {
    [player] call KPLIB_fnc_initZeusPlayer;
}