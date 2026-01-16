/*
	File: fn_addParadropAction.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 08/12/2025
	Last update: 08/12/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Add paradrop crate action in air vehicles. Hold action was added instead of a normal addAction to avoid miss clicks.

	Parameters:
		_transport - transport vehicle to add action [OBJECT, defaults to objNull]

	Return:
		[BOOL]
*/

params["_transport"];

if !(_transport isKindOf "Air") exitWith {false};

[
    _transport,
    ["<t color='#FFFF00'>", localize "STR_ACTION_PARADROP", "</t><img size='2' image='Images\ui_parachutebox.paa'/>"] joinString "",
    "a3\ui_f\data\gui\cfg\communicationmenu\supplydrop_ca.paa", "a3\ui_f\data\gui\cfg\communicationmenu\supplydrop_ca.paa",
    toString {
        // Condition to show
        alive _target &&
        {driver _target == _this} &&
        {_target getVariable ["KPLIB_CARGO_loadedCargo", []] isNotEqualTo []} &&
        {_target getVariable ["KPLIB_CARGO_isTransportVeh", false]} &&
        {isEngineOn _target && {(getPosATL _target # 2) > 20}}
    }, toString {
        private _minSpeed = 100;
        private _maxSpeed = 200;
        private _minAlt = 50;
        private _maxAlt = 120;
        if (_target isKindOf "Plane") then {
            _minSpeed = 150;
            _maxSpeed = 300;
            _minAlt = 150;
            _maxAlt = 300;
        };

        // Condition progress
        (speed _target > _minSpeed && {speed _target < _maxSpeed}) && {getPosATL _target # 2 > _minAlt && {getPosATL _target # 2 < _maxAlt}}
    },
    {},
    {},
    {
        // Execute
        params["_vehicle", "_player"];

        // Paradrop
        [_vehicle, _player] call KPLIB_fnc_doParadropCrate;
    },
    {
        // Interruption
        private _minSpeed = 100;
        private _maxSpeed = 200;
        private _minAlt = 50;
        private _maxAlt = 120;
        if (_target isKindOf "Plane") then {
            _minSpeed = 150;
            _maxSpeed = 300;
            _minAlt = 150;
            _maxAlt = 300;
        };

        // Hint paradrop advice
        [parseText (format[["<t size='1.5'>", localize "STR_PARADROP_ALTHINT", "</t><br/>", "%1", "<br/><br/>", "<t size='1.5'>", localize "STR_PARADROP_SPEEDHINT", "</t><br/>", "%2"] joinString "", [_minAlt, "-", _maxAlt, "m"] joinString " ", [_minSpeed, "-", _maxSpeed, "km/h"] joinString " "]), true, 7] call KPLIB_fnc_hint;
    },
    [], 1, 500, false, false, false
] call BIS_fnc_holdActionAdd;

true