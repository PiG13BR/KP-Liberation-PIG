/*
    File: fn_initArsenal.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2020-05-11
    Last Update: 2026-01-23
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Loads the arsenal preset and adjusts the available arsenal gear accordingly.

    Parameter(s):
        _player - player object [OBJECT, defaults to player]

    Returns:
        Function reached the end [BOOL]
*/

params[["_player", player, [objNull]]];

["Arsenal Init", "ARSENAL"] call KPLIB_fnc_log;

if (KPLIB_param_useArsenalPreset > 0) then {
    KPLIB_arsenalWeapons = [];
    KPLIB_arsenalMagazines = [];
    KPLIB_arsenalItems = [];
    KPLIB_arsenalBackpacks = [];
    KPLIB_arsenalBlacklist = [];
    KPLIB_arsenalAllowed = [];
    KPLIB_arsenalAllowedExtension = [];

    if (KPLIB_param_useArsenalPreset == 2) then {
        // Role whitelist
        switch (KPLIB_presetArsenalWhitelist) do {
            default {[typeOf _player] call compile preprocessFileLineNumbers "Presets\Arsenal\roles_Presets\custom.sqf";};
        };
    } else {
        // Default mode
        switch (KPLIB_presetArsenal) do {
            case  1: {[] call compile preprocessFileLineNumbers "Presets\Arsenal\custom.sqf";};
            case  2: {[] call compile preprocessFileLineNumbers "Presets\Arsenal\rhsusaf.sqf";};
            case  3: {[] call compile preprocessFileLineNumbers "Presets\Arsenal\3cbBAF.sqf";};
            case  4: {[] call compile preprocessFileLineNumbers "Presets\Arsenal\gm_west.sqf";};
            case  5: {[] call compile preprocessFileLineNumbers "Presets\Arsenal\gm_east.sqf";};
            case  6: {[] call compile preprocessFileLineNumbers "Presets\Arsenal\csat.sqf";};
            case  7: {[] call compile preprocessFileLineNumbers "Presets\Arsenal\unsung.sqf";};
            case  8: {[] call compile preprocessFileLineNumbers "Presets\Arsenal\sfp.sqf";};
            case  9: {[] call compile preprocessFileLineNumbers "Presets\Arsenal\bwmod.sqf";};
            case  10: {[] call compile preprocessFileLineNumbers "Presets\Arsenal\vanilla_nato_mtp.sqf";};
            case  11: {[] call compile preprocessFileLineNumbers "Presets\Arsenal\vanilla_nato_tropic.sqf";};
            case  12: {[] call compile preprocessFileLineNumbers "Presets\Arsenal\vanilla_nato_wdl.sqf";};
            case  13: {[] call compile preprocessFileLineNumbers "Presets\Arsenal\vanilla_csat_hex.sqf";};
            case  14: {[] call compile preprocessFileLineNumbers "Presets\Arsenal\vanilla_csat_ghex.sqf";};
            case  15: {[] call compile preprocessFileLineNumbers "Presets\Arsenal\vanilla_aaf.sqf";};
            case  16: {[] call compile preprocessFileLineNumbers "Presets\Arsenal\vanilla_ldf.sqf";};
            default  {[] call compile preprocessFileLineNumbers "Presets\Arsenal\blacklist.sqf";};
        };
    };
    [] call compile preprocessFileLineNumbers "Presets\Arsenal\allowedExtension.sqf";

    private _crawled = [] call KPLIB_fnc_crawlAllItems;

    // Check for locked items (Extension)
    if (KPLIB_param_lockArsenal > 0) then {
        [] call KPLIB_fnc_lockArsenalItems;
    };
    
    if (KPLIB_arsenalWeapons isEqualTo []) then {KPLIB_arsenalWeapons = (_crawled select 0) select {!(_x in KPLIB_arsenalBlacklist)};};
    [missionNamespace, KPLIB_arsenalWeapons] call BIS_fnc_addVirtualWeaponCargo;
    KPLIB_arsenalAllowed append KPLIB_arsenalWeapons;

    if (KPLIB_arsenalMagazines isEqualTo []) then {KPLIB_arsenalMagazines = (_crawled select 1) select {!(_x in KPLIB_arsenalBlacklist)};};
    [missionNamespace, KPLIB_arsenalMagazines] call BIS_fnc_addVirtualMagazineCargo;
    KPLIB_arsenalAllowed append KPLIB_arsenalMagazines;

    if (KPLIB_arsenalItems isEqualTo []) then {KPLIB_arsenalItems = (_crawled select 2) select {!(_x in KPLIB_arsenalBlacklist)};};
    [missionNamespace, KPLIB_arsenalItems] call BIS_fnc_addVirtualItemCargo;
    KPLIB_arsenalAllowed append KPLIB_arsenalItems;

    if (KPLIB_arsenalBackpacks isEqualTo []) then {KPLIB_arsenalBackpacks = (_crawled select 3) select {!(_x in KPLIB_arsenalBlacklist)};};
    [missionNamespace, KPLIB_arsenalBackpacks] call BIS_fnc_addVirtualBackpackCargo;
    KPLIB_arsenalAllowed append KPLIB_arsenalBackpacks;

    // Support for CBA disposable launchers, https://github.com/CBATeam/CBA_A3/wiki/Disposable-Launchers
    if !(configProperties [configFile >> "CBA_DisposableLaunchers"] isEqualTo []) then {
        private _disposableLaunchers = ["CBA_FakeLauncherMagazine"];
        {
            private _loadedLauncher = cba_disposable_LoadedLaunchers get _x;
            if (!isNil "_loadedLauncher") then {
                _disposableLaunchers pushBack _loadedLauncher;
            };

            private _normalLauncher = cba_disposable_NormalLaunchers get _x;
            if (!isNil "_normalLauncher") then {
                _normalLauncher params ["_loadedLauncher"];
                _disposableLaunchers pushBack _loadedLauncher;
            };
        } forEach KPLIB_arsenalAllowed;
        KPLIB_arsenalAllowed append _disposableLaunchers;
    };

    {
        // Handle CBA optics, https://github.com/CBATeam/CBA_A3/wiki/Scripted-Optics
        if (missionNamespace getVariable ["CBA_optics", false]) then {
            private _pipOptic = CBA_optics_PIPOptics getVariable _x;
            if (!isNil "_pipOptic") then {
                KPLIB_arsenalAllowedExtension pushBackUnique _pipOptic;
            };

            private _nonPipOptic = CBA_optics_NonPIPOptics getVariable _x;
            if (!isNil "_nonPipOptic") then {
                KPLIB_arsenalAllowedExtension pushBackUnique _nonPipOptic;
            };
        };

        // Handle CBA (MRT) Accessories, https://github.com/CBATeam/CBA_A3/wiki/Accessory-Functions
        private _itemCfg = configFile >> "CfgWeapons" >> _x;
        if (!isNull _itemCfg) then {
            private _nextItem = getText (_itemCfg >> "MRT_SwitchItemPrevClass");
            if (_nextItem != "") then {
                KPLIB_arsenalAllowedExtension pushBackUnique _nextItem;
            };

            private _prevItem = getText (_itemCfg >> "MRT_SwitchItemNextClass");
            if (_prevItem != "") then {
                KPLIB_arsenalAllowedExtension pushBackUnique _prevItem;
            };
        };
    } forEach KPLIB_arsenalAllowed;

    KPLIB_arsenalAllowed append KPLIB_arsenalAllowedExtension;
    if (KPLIB_ace && KPLIB_param_arsenalType) then {[player, KPLIB_arsenalAllowed, false] call ace_arsenal_fnc_addVirtualItems;};

    // Lowering to avoid issues with incorrect capitalized classnames in KPLIB_fnc_checkGear
    KPLIB_arsenalAllowed = KPLIB_arsenalAllowed apply {toLower _x};

} else {
    [missionNamespace, true] call BIS_fnc_addVirtualWeaponCargo;
    [missionNamespace, true] call BIS_fnc_addVirtualMagazineCargo;
    [missionNamespace, true] call BIS_fnc_addVirtualItemCargo;
    [missionNamespace, true] call BIS_fnc_addVirtualBackpackCargo;
    if (KPLIB_ace && KPLIB_param_arsenalType) then {[player, true, false] call ace_arsenal_fnc_addVirtualItems;};
};

true
