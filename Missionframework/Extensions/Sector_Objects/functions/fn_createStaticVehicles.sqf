/*
    File: fn_createStaticVehicles.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 17/12/2024
    Last Update: 27/12/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
       
    Parameter(s):
        _sector - sector to search for structures to spawn trenched vehicles [STRING, defaults to ""]
		_objects - sector objects [ARRAY, defaults to []]

    Returns:
        All static weapons created [ARRAY]
*/

if (!isServer) exitWith {};

params[
	["_sector", "", [""]], 
	["_objects", [], [[]]]
];


private _allVeh = [];
if (_sector isEqualTo "") exitWith {["No sector provided", "WARNING"] call KPLIB_fnc_log; _allVeh};
if (_objects isEqualTo []) exitWith {["No objects in the sector found", "SECTOR"] call KPLIB_fnc_log; _allVeh};
if (KPLIB_o_tankVehicles isEqualTo []) exitWith {_allVeh};

private _sectorpos = markerPos _sector;

// Find garrisons objects
//private _allGarrisons = (nearestObjects [_sectorpos, KPLIB_staticVehConfigs_classes, _radius]) select {alive _x};
private _allGarrisons = _objects select {(typeOf _x) in KPLIB_staticVehConfigs_classes};

private _blacklistGarrisons = (KPLIB_GarrisonsBlacklist_HashMap get _sector);
if (!isNil "_blacklistGarrisons") then {
	{
		{
			_posX = round (parseNumber ((_x # 0) toFixed 2));
			_posY = round (parseNumber ((_x # 1) toFixed 2));
			_posZ = round (parseNumber ((_x # 2) toFixed 2));
			_allGarrisons = _allGarrisons select {!([_posX, _posY, _posZ] isEqualTo [round parseNumber (((getPosATL _x) # 0) toFixed 2), round parseNumber (((getPosATL _x) # 1) toFixed 2), round parseNumber (((getPosATL _x) # 2) toFixed 2)])};
		}forEach _blacklistGarrisons;
	}forEach _allGarrisons;
};

if (count _allGarrisons > 0) then {
	// Loop the garrison objects found
	{
		private _garrison = _x;
		// Loop statics configuration provided in KPLIB_staticsConfigs.sqf
		{
			// Check if the object type matches one of the configuration
			if ((_x # 0 == typeOf _garrison)) then {
				// Count how many positions are available for static weapons by counting the second element of the main array
				private _positions = count (_x # 1);
				if (_positions > 0) then {
					for "_index" from 0 to (_positions - 1) do {
						// The provided _index number in this loop will select each array that contains the necessary values to spawn correctly the static weapon for each relative position provided in the configuration
						private _relPos = (((_x # 1) # _index) # 0); // Get the relativePosition
						private _relDir = (((_x # 1) # _index) # 1); // Get the rotation

						// For the selected type, it will check the static weapons presets
						private _vehClass = selectRandom KPLIB_o_tankVehicles;

                        if (isNil "_vehClass") then {["No fixed vehicle classname found in KPLIB_o_tankVehicles", "WARNING"] call KPLIB_fnc_log; continue};

						_veh = [(_garrison modelToWorld _relPos), _vehClass, (getDir _garrison + (_relDir))] call KPLIB_fnc_spawnStaticVehicle;

						_allVeh pushBack _veh;
					};
				};
			}
		}forEach KPLIB_staticVehConfigs;
	}forEach _allGarrisons;
};

_allVeh