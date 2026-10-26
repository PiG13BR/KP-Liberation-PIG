/*
	File: fn_removeTurretWeapons.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/06/2026
	Last Update: 07/10/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Remove remnant weapons from the setPylonLoadout command.
		This is a workaround for shitty mods

	Parameter(s):
		_aircraft - aircraft to remove remnant weapons [OBJECT]
		_pylonIndex - pylon index to remove the weapon [NUMBER]
		_turret - turret to remove the weapon [ARRAY]
	
	Returns:
		-
*/
params["_aircraft", "_pylonIndex", "_turret"];

// Get all pylon weapons
private _allPylonWeapons = (getPylonMagazines _aircraft) apply {
	getText(configFile >> "CfgMagazines" >> _x >> "pylonWeapon")
};

private _blacklistWeapons = [_aircraft] call KPLIB_fnc_getCfgWeapons;

_blacklistWeapons append _allPylonWeapons;
_blacklistWeapons = _blacklistWeapons apply {toLowerANSI _x};

private _leftovers = (_aircraft weaponsTurret _turret) select {!(toLowerANSI _x in _blacklistWeapons)};

private _pylonWeaponToRemove = _allPylonWeapons param [_pylonIndex - 1, ""];

// Failsafe: avoid removing weapons from upper pylons indexes
_allPylonWeapons = _allPylonWeapons select {_x == toLowerANSI _pylonWeaponToRemove};
if (count _allPylonWeapons > 1) exitWith {};

{
	private _weapon = _x;
	if (_weapon == "") then {continue};
	if (_aircraft turretLocal _turret) then {
		_aircraft removeWeaponTurret [_weapon, _turret]; 
	};
}forEach (_leftovers + [_pylonWeaponToRemove]);
