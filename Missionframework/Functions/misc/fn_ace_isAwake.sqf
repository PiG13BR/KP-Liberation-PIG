/*
	File: fn_ace_IsAwake.sqf
	Author: PiG13BR - https://github.com/PiG13BBR
	Date: 11/10/2024
    Last Update: 02/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Check unit unconscious state (ACE)

	Parameter(s):
		_unit - unit to check its state [OBJECT - Infantry unit]
	
	Returns:
		State of the unit [BOOL]
*/

params ["_unit"];

private _isAwake = true;

if (KPLIB_ace && {bis_reviveParam_mode == 0}) exitWith {
	[_unit] call ace_common_fnc_isAwake;
};

_isAwake