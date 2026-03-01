/*
    Description:
        Spawns guerilla groups in factory
*/
params["_factory"];

private _sectorPos = markerPos _factory;
private _allUnits = [];

// Patrols
for "_i" from 0 to 2 do {
    private _guerGroup = [_sectorPos, 4 + (random 3)] call KPLIB_fnc_spawnGuerillaGroup;

    if (KPLIB_LAMBS) then {
        [_guerGroup, _sectorPos, KPLIB_range_sectorCapture * 0.5, 4 + ceil(random 4), [], true] call lambs_wp_fnc_taskPatrol;
    } else {
        [_guerGroup, _sectorPos] spawn add_defense_waypoints;
    };

    _allUnits append (units _guerGroup);
};

// Find buildings to garrison. Ignore those in KPLIP_ignoreGarrisonBuildings
private _allBuildings = (nearestObjects [_sectorPos, ["House", "Strategic", "Ruins"], KPLIB_range_sectorCapture]) select {alive _x && !((toLowerANSI (typeOf _x)) in (KPLIP_ignoreGarrisonBuildings apply {toLowerANSI _x}))};
// Filter buildings with decent amount of building positions
_allBuildings = _allBuildings select {count ([_x] call CBA_fnc_buildingPositions) > 3};

// Get buildings with more floors
private _highBuildings = _allBuildings select {
    private _buildingPos = [_x] call CBA_fnc_buildingPositions;
    
    (_buildingPos findIf {(_x # 2) >= 6}) >= 0
};
_allBuildings append _highBuildings; // Append these buildings to multiply chances

for "_i" from 1 to 2 do {
    // Get a random building
    if (_allBuildings isEqualTo []) exitWith {};

    private _buildingToGarrison = _allBuildings deleteAt (_allBuildings find (selectRandom _allBuildings));

    // Get all building positions
    private _buildingPositions = [_buildingToGarrison] call CBA_fnc_buildingPositions;

    if (_buildingPositions isEqualTo []) exitWith {grpNull};

    // Sort indoor positions
    _buildingPositions = _buildingPositions select {
        private _pos = AGLToASL _x;
        lineIntersects [_pos, _pos vectorAdd [0, 0, 6]]
    };

    private _guerGroup = [_sectorPos, count _buildingPositions] call KPLIB_fnc_spawnGuerillaGroup;
    _allUnits append (units _guerGroup);

    {
        private _unit = _x;
        private _pos = _buildingPositions deleteAt (_buildingPositions find (selectRandom _buildingPositions));
        if (isNil "_pos") exitWith {}; // Exit

        private _posATL = (ASLToATL (AGLToASL _pos));
        _unit setPosATL _posATL;
        _unit setDir (_buildingToGarrison getDir _posATL);
        _unit doWatch (_buildingToGarrison getPos [200, (_buildingToGarrison getDir _posATL)]);
        _unit disableAI "PATH";
        _unit setVariable ["KPLIB_garrisoned", true]; // Set garrison status

        // Avoid prone (only if garrisoned)
        _unit addEventHandler ["AnimChanged", {
            params ["_unit", "_anim"];
            if !(_unit getVariable ["KPLIB_garrisoned", false]) exitWith {_unit removeEventHandler [_thisEvent, _thisEventHandler]};

            if (unitPos _unit == "Down") then {_unit setUnitPos "UP"};
        }];

        _unit addEventHandler ["Hit", {
            params ["_unit"];
            _unit enableAI "PATH";
            _unit setVariable ["KPLIB_garrisoned", false];
            _unit setCombatBehaviour "COMBAT";
        }];
        _unit addEventHandler ["Fired", {
            params ["_unit"];
            _unit setCombatBehaviour "COMBAT";
        }];
        _unit addEventHandler ["FiredNear", {
            params ["_unit"];
            _unit setCombatBehaviour "COMBAT";
        }];
        _unit addEventHandler ["Suppressed", {
            params ["_unit"];
            _unit setCombatBehaviour "COMBAT";
        }];

    }forEach (units _guerGroup);
};

_allUnits