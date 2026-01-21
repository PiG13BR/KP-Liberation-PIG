// Update arsenal
["KPLIB_updateArsenal", {
    params["_sector"];
    if (isDedicated) exitWith {};
    
    private _items = KPLIB_sector_arsenalLink get _sector;

    [_items] call KPLIB_fnc_addArsenalItems;

    if (KPLIB_ace && KPLIB_param_arsenalType) then {
        // Refresh arsenal
        [] call ace_arsenal_fnc_refresh;
    } else {
        if !(isNull (uinamespace getvariable ["RSCDisplayArsenal", displayNull])) then {
            // Close BIS display
            (uinamespace getvariable ["RSCDisplayArsenal", displayNull]) closeDisplay 1;
            ["Open", false] spawn BIS_fnc_arsenal;
        };
    };

    // Supply dump preset
    [] call compile preprocessFileLineNumbers 'Extensions\Supply_Menu\presets\custom.sqf';
}] call CBA_fnc_addEventHandler;

["KPLIB_removeArsenalItems", {
    params["_sector"];
    if (isDedicated) exitWith {};

    private _items = KPLIB_sector_arsenalLink get _sector;

    [_items] call KPLIB_fnc_removeArsenalItems;
    
    if (KPLIB_ace && KPLIB_param_arsenalType) then {
        // Refresh arsenal
        [] call ace_arsenal_fnc_refresh;
    } else {
        if !(isNull (uinamespace getvariable ["RSCDisplayArsenal", displayNull])) then {
            // Close BIS display
            (uinamespace getvariable ["RSCDisplayArsenal", displayNull]) closeDisplay 1;
            ["Open", false] spawn BIS_fnc_arsenal;
        };
    };

    // Supply dump preset
    [] call compile preprocessFileLineNumbers 'Extensions\Supply_Menu\presets\custom.sqf';
}] call CBA_fnc_addEventHandler;
