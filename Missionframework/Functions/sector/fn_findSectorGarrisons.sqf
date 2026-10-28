/*
    File: fn_findSectorGarrisons.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 02/12/2025
    Last Update: 27/10/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Find buildings to garrison.

    Parameter(s):
        _sector - sector to add garrisons [STRING]
        _garrisonsCount - garrisons to add (how many buildings to garrison) [NUMBER, defaults to 4]
        _radius - sector capture radius [NUMBER or ARRAY, defaults to KPLIB_range_sectorCapture]
        _infType - infantry type to spawn [STRING, defaults to "army"]
        
    Returns:
        -
*/
params[
    "_sector",
    ["_garrisonsCount", 4, [0]], 
    ["_radius", KPLIB_range_sectorCapture, [0, []]], 
    ["_infType", "army", [""]]
];

private _sectorPos = markerPos _sector;

// Find buildings to garrison. Ignore those in KPLIP_ignoreGarrisonBuildings
private _allBuildings = [];
if (_sector in KPLIB_sectors_airport) then {
    _allBuildings = (nearestObjects [_sectorPos, ["House", "Strategic", "Ruins"], ((_radius # 0) + (_radius # 1))]) select {alive _x && (_x inArea _sector) && !((toLowerANSI (typeOf _x)) in (KPLIP_ignoreGarrisonBuildings apply {toLowerANSI _x}))};
} else {
    _allBuildings = (nearestObjects [_sectorPos, ["House", "Strategic", "Ruins"], _radius]) select {alive _x && !((toLowerANSI (typeOf _x)) in (KPLIP_ignoreGarrisonBuildings apply {toLowerANSI _x}))};
};

// Filter buildings with decent amount of building positions
private _towers = _allBuildings select {(typeOf _x) in KPLIB_guardTowers || (typeOf _x) in KPLIB_guardTowers_marksman}; // Get guard towers
_allBuildings = _allBuildings select {count ([_x] call CBA_fnc_buildingPositions) > 3};

if (KPLIB_sectorspawn_debug > 0) then {
    [format ["Sector %1 (%2) - garrison units count: %3", (markerText _sector), _sector, _garrisonsCount], "SECTORSPAWN"] remoteExecCall ["KPLIB_fnc_log", 2];
};

// Get buildings with more floors
private _highBuildings = _allBuildings select {
    private _buildingPos = [_x] call CBA_fnc_buildingPositions;
    
    (_buildingPos findIf {(_x # 2) >= 6}) >= 0
};
_allBuildings append _highBuildings; // Append these buildings to multiply chances

private _garrisonedUnits = [];
for "_i" from 1 to _garrisonsCount do {
    // Get a random building
    if (_allBuildings isEqualTo []) exitWith {};

    private _buildingToGarrison = _allBuildings deleteAt (_allBuildings find (selectRandom _allBuildings));

    private _grp = [_buildingToGarrison, _infType, KPLIB_dynamicSim] call KPLIB_fnc_spawnBuildingGarrison;
    _garrisonedUnits append (units _grp);
};

private _grpTower = createGroup [KPLIB_side_enemy, true]; // Create group for guard towers
for "_i" from 1 to (count _towers) do {
    // Get a random building
    if (_towers isEqualTo []) exitWith {};

    private _buildingToGarrison = _towers deleteAt (_towers find (selectRandom _towers));

    private _grp = [_buildingToGarrison, _infType, KPLIB_dynamicSim] call KPLIB_fnc_spawnBuildingGarrison;
    _garrisonedUnits append (units _grp);

    // Change group
    (units _grp) join _grpTower
};

_garrisonedUnits