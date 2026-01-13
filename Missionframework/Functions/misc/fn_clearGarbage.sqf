/*
	File: fn_clearGarbage.sqf
	Author: PIG13BR - https://github.com/PiG13BR
	Date: 16/08/2024
	Last Update: 22/12/2025
	License: MIT License - http://www.opensource.org/licenses/MIT
	
	Description:
		Deletes dead units and damaged enemy empty vehicles and weapon holders
	
	Parameter(s):
		-
	
	Returns:
		-
*/

if (!canSuspend) then {[] spawn KPLIB_fnc_clearGarbage};

// Get only enemy side vehicles, damaged and with no crew in it
private _deadVehicles = vehicles select {
	((_x isKindOf "landVehicle") || {_x isKindOf "Air"}) && 
	{(((toLower (typeOf _x)) in KPLIB_o_allVeh_classes) && {!(_x getVariable ["KPLIB_captured", false])}) || {((typeOf _x) in KPLIB_c_vehicles) && {!(_x getVariable ["KPLIB_seized", false])}}} && 
	{damage _x > 0.01} && 
	{({alive _x} count (crew _x)) < 1}
};

// Get weapon holders (don't count/hint these)
private _weaponHolders = (8 allObjects 0) select {_x isKindOf "WeaponHolder"};
if (count _weaponHolders > 0) then {
	deleteVehicle _weaponHolders;
};

// Count dead vehicles and men
private _deadVehNum = count _deadVehicles;
private _deadMenNum = count allDeadMen;

if (_deadVehNum > 0) then {
	{[_x] call KPLIB_fnc_despawnObject}forEach _deadVehicles;
	//deleteVehicle _deadVehicles;
};

sleep 1;

if (_deadMenNum > 0) then {
	deleteVehicle allDeadMen;
};

sleep 1;

[(parseText (format[["<t size='1.3'>", localize "STR_VEHICLES_CLEARED", "</t><br/>%1<br/><br/><t size='1.3'>", localize "STR_UNITS_CLEARED", "</t><br/>%2"] joinString "", _deadVehNum, _deadMenNum])), true, 4] call KPLIB_fnc_hint;
