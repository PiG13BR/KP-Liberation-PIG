/*
    File: fn_recalculateResources.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
    Date: 10/09/2025
    Last update: 30/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT
    
    Description:
        Update resources (supplies, air slots, infantry cap)

    Parameter(s):
        -
    
    Returns:
        -
*/

private _local_base_resource = [];
private _local_supplies_global = 0;
private _local_ammo_global = 0;
private _local_fuel_global = 0;
private _local_heli_slots = 0;
private _local_plane_slots = 0;
private _local_infantry_cap = 50 * KPLIB_param_resourcesMulti;
private _range = KPLIB_range_fob;
private _airport_buildings = [];

{
    private _airportMk = _x;
    if !(_airportMk in KPLIB_sectors_player) then {continue};

    private _airportPos = markerPos _airportMk;
    private _airportArea = markerSize _airportMk;

    _airport_buildings = (_airportPos nearObjects ((_airportArea # 0) + (_airportArea # 1))) select {_x inArea _airportMk};
    _airport_buildings = _airport_buildings select {alive _x};

    private _heliSlots = {(KPLIB_type_heliPads find (typeOf _x) >= 0)} count _airport_buildings;
    private _planeSlots = {(KPLIB_type_hangars find (typeOf _x) >= 0)} count _airport_buildings;

    _local_heli_slots = _local_heli_slots + _heliSlots;
    _local_plane_slots = _local_plane_slots + _planeSlots;

} forEach KPLIB_sectors_airport;

{
    private _basePos = _x;
    if (_x in KPLIB_player_outposts) then {_range = KPLIB_range_outpost} else {_range = KPLIB_range_fob};
    private _base_buildings = _basePos nearobjects _range;
    _base_buildings = _base_buildings select {alive _x};

    private _hasMedBuilding = {(typeOf _x) in KPLIB_medical_facilities;} count _base_buildings;
    if (_hasMedBuilding > 0) then {_hasMedBuilding = true;} else {_hasMedBuilding = false;};
        private _hasRecBuilding = {(typeOf _x) == KPLIB_b_logiStation;} count _base_buildings;
    if (_hasRecBuilding > 0) then {_hasRecBuilding = true;} else {_hasRecBuilding = false;};

    // Fob in airport area. Collect information about the airport area.
    private _inAirport = false;
    {
        private _airportArea = _x;
        if (_basePos inArea _x) exitWith {
            _range = ((markerSize _x)#0 + (markerSize _x)#1);
            _base_buildings = _basePos nearobjects _range;
            _base_buildings = _base_buildings select {_x inArea _airportArea};
            _inAirport = true;
        };
    }forEach KPLIB_sectors_airport;
    
    private _storage_areas = _base_buildings select {_x getVariable ["KPLIB_fobStorage", false] && {((getPosATL _x) # 2) < 1}};
    private _heliSlots = {KPLIB_type_heliPads find (typeOf _x) >= 0 && !(_x in _airport_buildings)} count _base_buildings;
    private _planeSlots = {KPLIB_type_hangars find (typeOf _x) >= 0 && !(_x in _airport_buildings)} count _base_buildings;
    private _hasAirBuilding = {(typeOf _x) == KPLIB_b_airControl;} count _base_buildings;
    if (_hasAirBuilding > 0) then {_hasAirBuilding = true;} else {_hasAirBuilding = false;};
    private _hasBarracks = false;
    private _countBarracks = {(typeOf _x) in KPLIB_type_barracks;} count _base_buildings;
    if (_countBarracks > 1) then {_hasBarracks = true;} else {_hasBarracks = false;};

    private _supplyValue = 0;
    private _ammoValue = 0;
    private _fuelValue = 0;

    {
        private _resources = [_x] call KPLIB_fnc_getStorageValues;
        _resources params ["_supply", "_ammo", "_fuel"];
        _supplyValue = _supplyValue + _supply;
        _ammoValue = _ammoValue + _ammo;
        _fuelValue = _fuelValue + _fuel;
    } forEach _storage_areas;

    _local_base_resource pushBack [_x, _supplyValue, _ammoValue, _fuelValue, _hasAirBuilding, _hasRecBuilding, _hasMedBuilding, _hasBarracks, _inAirport];
    _local_supplies_global = _local_supplies_global + _supplyValue;
    _local_ammo_global = _local_ammo_global + _ammoValue;
    _local_fuel_global = _local_fuel_global + _fuelValue;
    _local_heli_slots = _local_heli_slots + _heliSlots;
    _local_plane_slots = _local_plane_slots + _planeSlots;
    _local_infantry_cap = _local_infantry_cap + ((10 * _countBarracks) * KPLIB_param_resourcesMulti);
} forEach (KPLIB_player_fobs + KPLIB_player_outposts);

// Update KPLIB_production
{
    private _sector = _x;
    private _prodData = KPLIB_production getOrDefaultCall [_sector, {continue}];

    private _storageData = (_prodData # 2);
    if (_storageData isEqualTo []) then {continue};
    private _storagePos = _storageData # 0;
    private _storage = nearestObject [_storagePos, KPLIB_b_smallStorage];
    (_storage call KPLIB_fnc_getStorageValues) params ["_supply", "_ammo", "_fuel"];

    _prodData set [8, _supply];
    _prodData set [9, _ammo];
    _prodData set [10, _fuel];
}forEach KPLIB_sectors_factory - (KPLIB_sectors_all - KPLIB_sectors_player);

KPLIB_base_resources = _local_base_resource;
KPLIB_supplies_global = _local_supplies_global;
KPLIB_ammo_global = _local_ammo_global;
KPLIB_fuel_global = _local_fuel_global;
KPLIB_heli_slots = _local_heli_slots;
KPLIB_plane_slots = _local_plane_slots;
KPLIB_infantry_cap = _local_infantry_cap;

publicVariable "KPLIB_production";