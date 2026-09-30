/*
    File: fn_hintResurcesFactory.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 06/07/2026
    Last update: 30/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT
    
    Description:
        Display the resources list for the player of selected factory

    Parameter(s):
        _sector - factory sector to get resources info [STRING, defaults to ""]
    
    Returns:
        -
*/
params[["_sector", "", [""]]];

if (_sector isEqualTo "") exitWith {false};

private _prodList = KPLIB_production get _sector;
private _type = _prodList # 6;

private _storagePos = (_prodList # 2) # 0;

private _storage = nearestObject [_storagePos, KPLIB_b_smallStorage];
(_storage call KPLIB_fnc_getStorageValues) params ["_supply", "_ammo", "_fuel"];

private _typeName = "";
private _color = "";
switch _type do {
    case 0 : {
        _typeName = "<img image='Images\ui_manpo.paa'/>"; //localize "STR_MANPOWER";
        //_color = "<t size='1.2' color='#80FF80'>";
    };
    case 1 : {
        _typeName = "<img image='Images\ui_ammo.paa'/>"; //localize "STR_AMMO"; 
        //_color = "<t size='1.2' color='#80FF80'>";
    };
    case 2 : {
        _typeName = "<img image='Images\ui_fuel.paa'/>"; // localize "STR_FUEL";
        //_color = "<t size='1.2' color='#80FF80'>";
    };
    case 3 : {
        _typeName = 'N/A';
        _color = "<t size='1.2' color='#FF0000'>";
    };
    default {};
};

[parseText (format[[
    "<t size='1.3'>", localize "STR_PRODUCTION_RESOURCES_LIST", "</t><br/>",
    "<img image='Images\ui_manpo.paa'/>", " ", "%1", 
    "<br/>", // Spaces
    "<img image='Images\ui_ammo.paa'/>", " ", "%2", 
    "<br/>", // Spaces
    "<img image='Images\ui_fuel.paa'/>", " ", "%3",
    "<br/>", "<br/>", // Spaces
    _color, "<t size='1.1'>", localize "STR_PRODUCING", " ", "%4", "</t>"
] joinString "", _supply, _ammo, _fuel, _typeName]), true, 7] call KPLIB_fnc_hint;

true