/*
    File: fn_build_isItemAffordable.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 10/11/2025
    Last Update: 08/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Check if item is affordable by comparing its price to nearest fob available resources
        This is also used to check if the item can be builded repeatedly

    Parameter(s):
        _itemToCheck - item from the menu to check if is affordable [ARRAY, defaults to []]

    Returns:
        [BOOL]
*/

params[["_itemToCheck", [], [[]]]];

if (_itemToCheck isEqualTo []) exitWith {false};

// Get item cost
private _supplies = _itemToCheck # 1;
private _ammo = _itemToCheck # 2;
private _fuel = _itemToCheck # 3;

// Check fob available supplies
private _nearfob = [] call KPLIB_fnc_getNearestFob;
private _fobData = KPLIB_fob_resources select {((_x select 0) distance _nearfob) < KPLIB_range_fob};

private _affordable = false;

(_fobData # 0) params ["", "_fobSupplies", "_fobAmmo", "_fobFuel"];

if (((_supplies == 0 ) || (_supplies <= _fobSupplies)) && ((_ammo == 0 ) || (_ammo <= _fobAmmo)) && ((_fuel == 0 ) || (_fuel <= _fobFuel))) then {
    // Squad Comp
    if ((_itemToCheck # 0) isEqualType []) then {
        _affordable = true
    } else {
        // Others
        if ((toLowerANSI (_itemToCheck # 0)) in KPLIB_b_air_classes && !([_itemToCheck # 0] call KPLIB_fnc_isClassUAV)) then {
        
            if (KPLIB_b_airControl_near && ((((_itemToCheck # 0) isKindOf "Helicopter") && (KPLIB_heli_count < KPLIB_heli_slots)) || (((_itemToCheck # 0) isKindOf "Plane") && (KPLIB_plane_count < KPLIB_plane_slots)))) then {
                _affordable = true;
            };

        } else {
            if (!((toLowerANSI (_itemToCheck # 0)) in KPLIB_airSlots) || (((toLowerANSI (_itemToCheck # 0)) in KPLIB_airSlots) && KPLIB_b_airControl_near)) then {
                _affordable = true;
            };
        };
    };
};

_affordable