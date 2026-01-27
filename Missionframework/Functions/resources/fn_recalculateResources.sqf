/*
    File: fn_recalculateResources.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
    Date: 10/09/2025
    Last update: 30/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT
    
    Description:
        Update resources (supplies, air slots, infantry cap)

    Parameter(s):
        -
    
    Returns:
        -
*/

private _local_fob_resources = [];
private _local_supplies_global = 0;
private _local_ammo_global = 0;
private _local_fuel_global = 0;
private _local_heli_slots = 0;
private _local_plane_slots = 0;
private _local_infantry_cap = 50 * KPLIB_param_resourcesMulti;

{
    private _fob_buildings = _x nearobjects KPLIB_range_fob;
    private _storage_areas = _fob_buildings select {_x getVariable ["KPLIB_fobStorage", false]};
    //private _heliSlots = {(typeOf _x) == KPLIB_b_slotHeli;} count _fob_buildings;
     private _heliSlots = {KPLIB_type_heliPads find (typeOf _x) >= 0} count _fob_buildings;
    //private _planeSlots = {(typeOf _x) == KPLIB_b_slotPlane;} count _fob_buildings;
    private _planeSlots = {KPLIB_type_hangars find (typeOf _x) >= 0} count _fob_buildings;
    private _hasAirBuilding = {(typeOf _x) == KPLIB_b_airControl;} count _fob_buildings;
    if (_hasAirBuilding > 0) then {_hasAirBuilding = true;} else {_hasAirBuilding = false;};
    private _hasRecBuilding = {(typeOf _x) == KPLIB_b_logiStation;} count _fob_buildings;
    if (_hasRecBuilding > 0) then {_hasRecBuilding = true;} else {_hasRecBuilding = false;};
    private _hasMedBuilding = {(typeOf _x) in KPLIB_medical_facilities;} count _fob_buildings;
    if (_hasMedBuilding > 0) then {_hasMedBuilding = true;} else {_hasMedBuilding = false;};

    private _supplyValue = 0;
    private _ammoValue = 0;
    private _fuelValue = 0;

    {
        {
            switch ((typeOf _x)) do {
                case KPLIB_b_crateSupply: {_supplyValue = _supplyValue + (_x getVariable ["KPLIB_crateValue",0]);};
                case KPLIB_b_crateAmmo: {_ammoValue = _ammoValue + (_x getVariable ["KPLIB_crateValue",0]);};
                case KPLIB_b_crateFuel: {_fuelValue = _fuelValue + (_x getVariable ["KPLIB_crateValue",0]);};
                default {[format ["Invalid object (%1) at storage area", (typeOf _x)], "ERROR"] call KPLIB_fnc_log;};
            };
        } forEach (attachedObjects _x);
    } forEach _storage_areas;

    _local_fob_resources pushBack [_x, _supplyValue, _ammoValue, _fuelValue, _hasAirBuilding, _hasRecBuilding, _hasMedBuilding];
    _local_supplies_global = _local_supplies_global + _supplyValue;
    _local_ammo_global = _local_ammo_global + _ammoValue;
    _local_fuel_global = _local_fuel_global + _fuelValue;
    _local_heli_slots = _local_heli_slots + _heliSlots;
    _local_plane_slots = _local_plane_slots + _planeSlots;
} forEach KPLIB_sectors_fob;

{
    if ( _x in KPLIB_sectors_city ) then {
        _local_infantry_cap = _local_infantry_cap + (10 * KPLIB_param_resourcesMulti);
    };
} foreach KPLIB_sectors_player;

KPLIB_fob_resources = _local_fob_resources;
KPLIB_supplies_global = _local_supplies_global;
KPLIB_ammo_global = _local_ammo_global;
KPLIB_fuel_global = _local_fuel_global;
KPLIB_heli_slots = _local_heli_slots;
KPLIB_plane_slots = _local_plane_slots;
infantry_cap = _local_infantry_cap;