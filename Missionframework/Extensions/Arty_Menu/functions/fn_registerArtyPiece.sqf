/*
    File: fn_registerArtillery.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 27/07/2025
    Last update: 26/11/2025

    Description:
        Register artillery to be called in the artillery menu
        [this] call KPLIB_fnc_registerArtyPiece

    Parameter(s):
        _arty - artillery piece object [OBJECT, defaults to objNull]
    
    Returns:
        BOOL - true on success
*/

params[["_arty", objNull, [objNull]]];

if (isNull _arty) exitWith {["[ARTY MENU] Arty object is null"] call BIS_fnc_error; false};
if (getNumber(configFile >> "cfgVehicles" >> typeOf _arty >> "artilleryScanner") < 1) exitWith {["[ARTY MENU] this vehicle is not an artillery piece by configs"] call BIS_fnc_error; false};
if (!local _arty) exitWith {false};

if (isNil "KPLIB_ARTY_supportList") then {KPLIB_ARTY_supportList = []; publicVariable "KPLIB_ARTY_supportList";};

if (KPLIB_ARTY_supportList find _arty >= 0) exitWith {}; // Exit on already registered artillery piece

KPLIB_ARTY_supportList pushBack _arty; 
publicVariable "KPLIB_ARTY_supportList";

// Add EH
_arty addEventHandler ["Killed", {
    params ["_unit", "_killer", "_instigator", "_useEffects"];

    KPLIB_ARTY_supportList deleteAt (KPLIB_ARTY_supportList find _unit);
    publicVariable "KPLIB_ARTY_supportList";
    _unit removeEventHandler [_thisEvent, _thisEventHandler];
}];

_arty addEventHandler ["HandleDamage", {
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitPartIndex", "_instigator", "_hitPoint", "_directHit", "_context"];

    if (!canFire _unit) then {
        KPLIB_ARTY_supportList deleteAt (KPLIB_ARTY_supportList find _unit);
        publicVariable "KPLIB_ARTY_supportList";
        _unit removeEventHandler [_thisEvent, _thisEventHandler];
    };
}];

_arty addEventHandler ["GetOut", {
	params ["_vehicle", "_role", "_unit", "_turret", "_isEject"];

    if (count crew _vehicle == 0) then {
        KPLIB_ARTY_supportList deleteAt (KPLIB_ARTY_supportList find _vehicle);
        publicVariable "KPLIB_ARTY_supportList";
        _vehicle removeEventHandler [_thisEvent, _thisEventHandler];
    };
}];

// Log
["KPLIB_generateLog", 
    [
        format ["Artillery %1 registered", typeOf _arty],
        "ARTILLERY MENU"
    ]
] call CBA_fnc_serverEvent;

true