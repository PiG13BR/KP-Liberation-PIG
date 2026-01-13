private _crawled = [] call KPLIB_fnc_crawlAllItems;

// Check for locked items (Extension)
[] call compile preprocessFileLineNumbers "Extensions\Arsenal_Events\locked_arsenal.sqf";

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