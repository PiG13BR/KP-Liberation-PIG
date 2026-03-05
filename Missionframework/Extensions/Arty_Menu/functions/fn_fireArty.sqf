/* 
	File: fn_fireArty.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 02-07-2024
	Last Update: 04-03-2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Manages the artillery fire system:
			- Get the classname of the artillery
			- Checks if the artillery is busy
			- Checks if the artillery is in range
			- Create target markers
			- Fire the artillery
			- Deletes the related target markers as soon the first rounds lands

	Parameter(s):
		_arty - artillery piece [OBJECT, defaults to objNull]
		_targetPos - target position [POSITION ARRAY, defaults to [0,0,0]]
		_magazine - magazine classname [STRING, defaults to ""]
		_rounds - number of rounds to fire [NUMBER, defaults to 5]

	Returns:
		-

	[arty1, "targetPos_refer", "32Rnd_155mm_Mo_shells", 3] spawn KPLIB_fnc_fireArty;
*/

params[["_arty", objNull, [objNull]], ["_targetPos", [0,0,0], [[]], [2,3]], ["_magazine", "", [""]], ["_rounds", 5, [0]]];

if (isNull _arty) exitWith {["[ARTILLERY MENU] Artillery is null"] call BIS_fnc_error};
if (_targetPos isEqualTo [0,0,0]) exitWith {["[ARTILLERY MENU] Provide a target position"] call BIS_fnc_error};
if (_magazine isEqualTo "") exitWith {["[ARTILLERY MENU] No magazine classname provided"] call BIS_fnc_error};

private _artyClass = typeOf _arty;
private _nameArty = getText(configFile >> "CfgVehicles" >> _artyClass >> "displayName");

if ((gunner _arty) getVariable ["KPLIB_ARTY_isGunnerBusy", false]) exitWith {[localize "STR_ARTY_BUSY", true, 3] call KPLIB_fnc_hint};

// Check if the target is in artillery range
private _isInRange = _targetPos inRangeOfArtillery [[_arty], _magazine];
if !(_isInRange) exitWith {[localize "STR_ARTY_RANGE", true, 3] call KPLIB_fnc_hint};

(gunner _arty) setVariable ["KPLIB_ARTY_isGunnerBusy", true, true];

// Make always a different name for the markers
private _markerName = format["arty_icon_%1", _targetPos];
private _markerBorderName = format["arty_border_%1", _targetPos];

// Get the ETA of the impact (in seconds)
_eta = _arty getArtilleryETA [_targetPos, _magazine];
_eta = round(floor (_eta));

//Create a border marker
_markerBorder = createMarker [_markerBorderName, _targetPos];
_markerBorder setMarkerShape "ELLIPSE";
_markerBorder setMarkerBrush "BDiagonal";
_markerBorder setMarkerSize [75,75];
_markerBorder setMarkerColor "colorRED";

// Create a artillery target marker
_markerIcon = createMarker [_markerName, _targetPos];
_markerIcon setMarkerType "hd_objective";
_markerIcon setMarkerColor "colorRED";
_markerIcon setMarkerShape "ICON";
_markerIcon setMarkerText format[localize "STR_ARTY_MARKER_FIRE", str _nameArty, _eta];

private _weaponTurret = (_arty weaponsTurret [0]) select 0;
private _reloadTime = getNumber(ConfigFile >> "CfgWeapons" >> _weaponTurret >> "magazineReloadTime");
if (_reloadTime < 1) then {_reloadTime = 1};

[_arty, _targetPos, _magazine, _rounds, _reloadTime, _eta, _markerIcon, _markerBorder] spawn {
	params["_arty", "_targetPos", "_magazine", "_rounds", "_reloadTime", "_eta", "_markerIcon", "_markerBorder"];
	sleep 1 + (random 4);

	// Actually fire the artillery
	for "_i" from 1 to _rounds do {
		if (local _arty) then {
			_arty doArtilleryFire [_targetPos, _magazine, 1];
		} else {
			[_arty, [_targetPos, _magazine, 1]] remoteExec ["doArtilleryFire", owner _arty];
		};
		sleep (3 + _reloadTime)
	};

	(gunner _arty) setVariable ["KPLIB_ARTY_isGunnerBusy", false, true];

	sleep _eta;

	deleteMarker _markerIcon;
	deleteMarker _markerBorder;
};