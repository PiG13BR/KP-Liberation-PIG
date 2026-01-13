/*
	File: fn_getAllPylonsPos.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 16/10/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Fill empty pylons to get relative position with getAllPylonsInfo command
        This will be used to draw 3D icons

	Parameter(s):
		_vehicle - vehicle to check pylons pos [OBJECT]
	
	Returns:
		All pylons' positions [ARRAY]
*/

params["_vehicle"];

// Get pylons paths
private _pylonPaths = configProperties [(configOf _vehicle) >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"];
private _truePylons = [];
{
    if (getArray (_x >> "hardpoints") isEqualTo []) then { continue }; // Ignore dummy pylons
    _truePylons pushBackUnique (toLowerANSI(configName _x));
}forEach _pylonPaths;

private _allInfo = getAllPylonsInfo _vehicle;
private _onlyEmpty = _allInfo select {((_x # 3) == "") && {toLowerANSI(_x # 1) in _truePylons}};

// Fill only empty pylons
{_vehicle setPylonLoadout [(_x # 1), "PylonRack_4Rnd_LG_scalpel", true];}forEach _onlyEmpty;

_allInfo = getAllPylonsInfo _vehicle; // Get info again
_allPylonsPos = [];

{
    if (_x # 3 == "") then {continue};
    _index = _allPylonsPos pushBack [(_x # 1)];
    (_allPylonsPos # _index) pushBack ((_x # 6) # 0)
}forEach _allInfo;

{
    // Reset pylons
    _vehicle setPylonLoadout [(_x # 1), ""];
}forEach _onlyEmpty;

_allPylonsPos