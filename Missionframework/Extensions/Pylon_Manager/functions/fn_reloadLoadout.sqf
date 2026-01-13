/*
	File: fn_reloadLoadout.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 14/10/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Reloads jet's loadout

	Parameter(s):
		_aircraftClass - classname of the aircraft [STRING, defauls to ""]
	
	Returns:
		-
*/

params[["_aircraftClass", "", [""]]];

if (_aircraftClass isEqualTo "") exitWith {};

_originalCount = count PIG_PylonManager_airLoadout;
PIG_PylonManager_airLoadout = [];

for "_i" from 1 to _originalCount do {
        PIG_PylonManager_airLoadout pushBack ""; // Restore default pylon slots
};