/*
    File: fn_build_isItemLinked.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 10/11/2025
    Last Update: 12/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Check if item is linked to a base and returns its linked base

    Parameter(s):
        _classToCheck - classname of an item from build menu to check [STRING, defaults to ""]

    Returns:
        Base Link [STRING]
*/

params[["_classToCheck", "", [""]]];

if (_classToCheck isEqualTo "") exitWith {};

private _base_link = ""; // Marker name of the linked base

{
    _x params ["_class", "_marker"];

    if (_classToCheck == _class) exitWith {
        _base_link = _marker; 
    };
} foreach KPLIB_sector_vehicleLinks;

_base_link