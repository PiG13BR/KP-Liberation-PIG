#include "..\defines.hpp"
/*
    File: fn_build_isItemAffordable.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 10/11/2025
    Last Update: 23/07/2026
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
private _itemClass = _itemToCheck # 0;
if !(_itemClass isEqualType []) then {
    _itemClass = toLowerANSI (_itemToCheck # 0);
};
private _supplies = _itemToCheck # 1;
private _ammo = _itemToCheck # 2;
private _fuel = _itemToCheck # 3;

// Update values based on civilian reputation
private _priceAdd = -(KPLIB_civ_rep/1000);

// Update cost to box and truck fob/outpost containers per fob builded
if (_itemClass in ([KPLIB_b_fobBox, KPLIB_b_fobTruck] apply {toLowerANSI _x})) then {
    private _fobsBuilded = count (KPLIB_player_fobs select {_x isNotEqualTo [0,0,0]});
    _supplies = _supplies * _fobsBuilded;
    _ammo = _ammo * _fobsBuilded;
    _fuel = _fuel * _fobsBuilded;
};

if (_priceAdd < 0) then {
    if (_supplies > 0) then {_supplies = (_supplies - round(_supplies * abs(_priceAdd))) max 0;};
    if (_ammo > 0) then {_ammo = (_ammo - round(_ammo * abs(_priceAdd))) max 0;};
    if (_fuel > 0) then {_fuel = (_fuel - round(_fuel * abs(_priceAdd))) max 0;};
} else {
    if (_supplies > 0) then {_supplies = _supplies + round(_supplies * _priceAdd);};
    if (_ammo > 0) then {_ammo = _ammo + round(_ammo * _priceAdd);};
    if (_fuel > 0) then {_fuel = _fuel + round(_fuel * _priceAdd);};  
};

// Check fob available supplies
private _nearBase = [] call KPLIB_fnc_getNearestPlayerBase;
private _baseData = ([_nearBase] call KPLIB_fnc_getBaseResources);
(_baseData) params ["", "_fobSupplies", "_fobAmmo", "_fobFuel", "_hasAir", "_hasRecycling", "_hasMedical", "_hasBarracks", "_inAirport"];

private _buildType = (localNamespace getVariable ["KPLIB_Build_type", 1]);

private _affordable = false;

if (((_supplies == 0 ) || (_supplies <= _fobSupplies)) && ((_ammo == 0 ) || (_ammo <= _fobAmmo)) && ((_fuel == 0 ) || (_fuel <= _fobFuel))) then {
    // Squad Comp
    if (_itemClass isEqualType []) then {
        _affordable = true
    } else {
        // To build air vehicles
        if (_itemClass in KPLIB_b_air_classes && !([_itemToCheck # 0] call KPLIB_fnc_isClassUAV)) then {
            if (_hasAir && (((_itemClass isKindOf "Helicopter") && (KPLIB_heli_count < KPLIB_heli_slots)) || ((_itemClass isKindOf "Plane") && (KPLIB_plane_count < KPLIB_plane_slots)))) then {
                // Check there are airport sectors in this mission
                if ((_itemClass isKindOf "Plane") && (count KPLIB_sectors_airport > 0)) then {
                    if (_inAirport) then {
                        _affordable = true;
                    };
                } else {
                    _affordable = true;
                };
            };
        } else {
            if !(_itemClass in KPLIB_b_air_classes) then {
                // To build vehicles outside support label
                if (_buildType != BUILDTYPE_SUPPORT && (((_itemClass isKindOf "LandVehicle") && !(_itemClass isKindOf "StaticWeapon")) || (_itemClass isKindOf "Ship"))) then {
                    if (_hasRecycling) then {
                        _affordable = true;
                    };
                } else {
                    _affordable = true;
                };
            } else {
                if ((_itemClass in KPLIB_b_air_classes) && _hasAir) then {
                    _affordable = true;
                }
            }
        }
    }
};

_affordable