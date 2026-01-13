/*
    File: fn_recalculateResourcesInit.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
    Date: 10/09/2025
    Last update: 12/11/2025

    Description:
        Resources variables init

    Parameter(s):
        -
    
    Returns:
        -
*/
[{
    !isNil "KPLIB_saveLoaded" && {KPLIB_saveLoaded}
}, {
    KPLIB_fob_resources = [];
    KPLIB_supplies_global = 0;
    KPLIB_ammo_global = 0;
    KPLIB_fuel_global = 0;
    KPLIB_heli_slots = 0;
    KPLIB_plane_slots = 0;
    infantry_cap = 50 * KPLIB_param_resourcesMulti;

    ["KPLIB_recalculateResources", []] call CBA_fnc_serverEvent;
}] call CBA_fnc_waitUntilAndExecute;