/*
    File: fn_SAM_incomingMissile.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 05/12/2025
    Last Update: 10/12/2025
    License: MIT License - http://www.opensource.org/licenses/MIT
    
    Description:
        Set "incomingMissile" EH for radar and SHORADS to try to defeat HARM missiles
    
    Parameter(s):
        _radar - radar to add event handler [OBJECT]
		_shorads - SHORADS available [ARRAY, defaults to []]
    
    Returns:
        [BOOL]
*/

params["_radar", ["_shorads", []]];

if (_shorads isEqualTo []) exitWith {false};

[
	_radar, "IncomingMissile", 
	{
		params ["_target", "_ammo", "_vehicle", "_instigator", "_missile"];
		private _shorad = _thisArgs;
		
		//if (_vehicle isKindOf "Air" && {side _vehicle == KPLIB_side_player}) then {
			// Check for valid missile (HARM)
			private _config = configFile >> "CfgAmmo" >> _ammo >> "Components" >> "SensorsManagerComponent" >> "Components";
			private _subClasses = _config call BIS_fnc_getCfgSubClasses;

			if (_subClasses findIf {getText(_config >> _x >> "componentType") == "PassiveRadarSensorComponent"} < 0) exitWith {};

			// Check for available shorads
			_shorad = _shorad select {alive _x && {alive (gunner _x)} && {unitReady _x} && {!(_x getVariable ["KPLIB_isTargettingMissile", false])}};

			if (_shorad isEqualTo []) exitWith {};

			if (count _shorad > 1) then {_shorad = selectRandom _shorad} else {_shorad = _shorad # 0};

			[_shorad, _target, _missile] call KPLIB_fnc_SAM_shoradTargetMissile;
		//}
	}, 
	_shorads
] call CBA_fnc_addBISEventHandler;

// Add EH to the shoards themselves
{
	[
		_x, "IncomingMissile", 
		{
			params ["_target", "_ammo", "_vehicle", "_instigator", "_missile"];
			
			//if (_vehicle isKindOf "Air" && {side _vehicle == KPLIB_side_player}) then {
				// Check for valid missile (HARM)
				private _config = configFile >> "CfgAmmo" >> _ammo >> "Components" >> "SensorsManagerComponent" >> "Components";
				private _subClasses = _config call BIS_fnc_getCfgSubClasses;

				if (_subClasses findIf {getText(_config >> _x >> "componentType") == "PassiveRadarSensorComponent"} < 0) exitWith {};

				// Check for available shorads
				if (_target getVariable ["KPLIB_isTargettingMissile", false] || {!unitReady _target}) exitWith {};

				[_target, _target, _missile] call KPLIB_fnc_SAM_shoradTargetMissile;
			//}
		},
		[]
	] call CBA_fnc_addBISEventHandler;
}forEach _shorads;
true