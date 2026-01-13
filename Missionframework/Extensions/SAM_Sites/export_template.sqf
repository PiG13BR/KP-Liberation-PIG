/*
    SAM Site exporter

    --- USAGE ---
    Place an object or trigger (recommended with 25/25 area) to serve as center reference, and name it.
    Make a SAM Site inside a 35m area (read required assets below).
    Take the placed center object as an argument and run this script in the debug or execute through a file.

    The fetched information can be found in your client rpt (between the START and END line) for copy/paste.
    Ref for finding your RPT file: https://community.bistudio.com/wiki/Crash_Files#Arma_3

    Replace the needed classname by using the ones from the enemy preset. Check files in the template folder to see how the templates are set up.
    The main variables for radar and launchers are already set up.

    You don't need to worry about commas, the script already get it right for you. Just watch them if you change anything.
    
    --- REQUIRED ASSETS ---
    ONE SAM RADAR (With active radar component). PUT AS CLOSE AS POSSIBLE TO THE CENTER REFERENCE. ALWAYS FACING NORTH / 0º/360º.
    AT LEAST 1 AND MAXIMUM OF 4 SAM LAUNCHERS.
    AT LEAST 1 SHORAD (OPTIONAL)
    AESTHETIC OBJECTS (OPTIONAL)

	--- RECOMMENDATIONS ---
    DON'T EXCEED 35m AREA! Use trigger area as a reference.
    If you're planning on using SAM sites with mods, for non-aesthetic object, use vanilla assets as reference. Exporter might fail with modded assets.
    I don't recommend using POOK SAM PACK. It has a lot of bugs and errors and it can drop your FPS. Stick with the vanilla ones, they're more realible.
*/
params [
    ["_center", player, [objNull]]
];

diag_log text "";
diag_log text "";
diag_log text "[KPLIB] [SAM SITE EXPORT] ---------- START ----------";

diag_log text "";

// Find radar. Can get AAA as well.
private _radars = (nearestObjects [_center, ["LandVehicle", "StaticWeapon"], 35]) select {isClass(configFile >> "CfgVehicles" >> typeOf _x >> "Components" >> "SensorsManagerComponent" >> "Components" >> "ActiveRadarSensorComponent")};
if (_radars isEqualTo []) exitWith {
    diag_log text "[KPLIB] [SAM SITE EXPORT] ---------- FAILED - NO RADAR FOUND ----------";
};

private _radar = _radars # 0; // By the proximity of the center

diag_log text format [
    "private _samSiteRadar = [KPLIB_o_SAM_radars, [%1, %2, %3], %4];",
    ((getPosATL _radar select 0) - (getPosATL _center select 0)) toFixed 2,
    ((getPosATL _radar select 1) - (getPosATL _center select 1)) toFixed 2,
    (getPosATL _radar select 2) toFixed 2,
    (getDir _radar) toFixed 2
];

// All SAM site launchers
diag_log text "";
diag_log text "private _samSiteLaunchers = [";
private _launchers = ((nearestObjects [_center, ["LandVehicle", "StaticWeapon"], 35]) select {getNumber(configOf _x >> "radartype") == 2}) - _radars;
if (_launchers isEqualTo []) exitWith {
    diag_log text "[KPLIB] [SAM SITE EXPORT] ---------- FAILED - NO LAUNCHERS FOUND ----------";
};

{
    private _withComma = ((count (_launchers) - 1) > _forEachIndex);
    diag_log text format [
        "    [KPLIB_o_SAM_launchers, [%1, %2, %3], %4]%5",
        ((getPosATL _x select 0) - (getPosATL _center select 0)) toFixed 2,
        ((getPosATL _x select 1) - (getPosATL _center select 1)) toFixed 2,
        (getPosATL _x select 2) toFixed 2,
        (getDir _x) toFixed 2,
        ["", ","] select _withComma
    ];
} forEach _launchers;
diag_log text "];";

// All SAM SHORAD
diag_log text "";
private _shorads = ((nearestObjects [_center, ["LandVehicle", "StaticWeapon"], 35]) select {getNumber(configOf _x >> "radartype") == 2}) - [_radar] - (_launchers);
diag_log text "private _samSiteSHORAD = [";
{
    private _withComma = ((count (_shorads) - 1) > _forEachIndex);
    diag_log text format [
        "    [KPLIB_o_SAM_SHORAD, [%1, %2, %3], %4]%5",
        ((getPosATL _x select 0) - (getPosATL _center select 0)) toFixed 2,
        ((getPosATL _x select 1) - (getPosATL _center select 1)) toFixed 2,
        (getPosATL _x select 2) toFixed 2,
        (getDir _x) toFixed 2,
        ["", ","] select _withComma
    ];
} forEach _shorads;
diag_log text "];";

// All static weapons (defenses)
diag_log text "";
private _statics = ((nearestObjects [_center, ["StaticWeapon"], 35]) - [_radar] - (_launchers) - (_shorads));
diag_log text "private _samSiteStatics = [";
{
    private _withComma = ((count (_statics) - 1) > _forEachIndex);
    diag_log text format [
        "    [""%1"", [%2, %3, %4], %5]%6",
        typeof _x,
        ((getPosATL _x select 0) - (getPosATL _center select 0)) toFixed 2,
        ((getPosATL _x select 1) - (getPosATL _center select 1)) toFixed 2,
        (getPosATL _x select 2) toFixed 2,
        (getDir _x) toFixed 2,
        ["", ","] select _withComma
    ];
} forEach _statics;
diag_log text "];";

// All aesthetic objects
diag_log text "";
private _miscObjects = (nearestObjects [_center, ["All"], 35]) - (_radars) - (_launchers) - (_shorads) - (_statics);
diag_log text "private _samSiteObjects = [";
{
    private _withComma = ((count (_miscObjects) - 1) > _forEachIndex);
    diag_log text format [
        "    [""%1"", [%2, %3, %4], %5]%6",
        typeof _x,
        ((getPosATL _x select 0) - (getPosATL _center select 0)) toFixed 2,
        ((getPosATL _x select 1) - (getPosATL _center select 1)) toFixed 2,
        (getPosATL _x select 2) toFixed 2,
        (getDir _x) toFixed 2,
        ["", ","] select _withComma
    ];
} forEach _miscObjects;
diag_log text "];";

// All garrison builiding
diag_log text "";
diag_log text "private _samSiteGarrisons = [";
diag_log text "    // Put here all buildings classnames from the _samSiteObjects that you want infantry to garrison";
diag_log text "];";

diag_log text "";
diag_log text "[_samSiteRadar, _samSiteLaunchers, _samSiteSHORAD, _samSiteStatics, _samSiteGarrisons, _samSiteObjects]";

diag_log text "";
diag_log text "[KPLIB] [SAM SITE EXPORT] ---------- END ----------";
diag_log text "";
diag_log text "";