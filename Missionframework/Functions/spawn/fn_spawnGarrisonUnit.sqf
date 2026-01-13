/*
    File: fn_spawnGarrisonUnit.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 2024-12-18
    Last Update: 2024-12-18
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Trenches Idea

    Parameter(s):
        _relPos - relative position to a object [POSITION, PositionRelative]
        _group
		_class - classname of the static weapon to spawn [STRING]
		_relDir - relative direction to a object [NUMBER]
        _stance

    Returns:
        
*/

params ["_relPos", "_group", "_class", "_relDir", "_stance"];

private _unit = _group createUnit [_class, _relPos, [], 0, "CAN_COLLIDE"];

_unit allowDamage false;
_unit enableSimulation false;

// Disable pathing, allow rotation
_unit disableAI "PATH";

// Try to set the correct direction for the unit
_unit setFormDir _relDir;
_unit setDir _relDir;
_unit setPosATL _relPos;
_unit setUnitPos _stance;
doStop _unit;
_unit forceSpeed 0;

// Try to maintain the same stance
[_unit, "AnimChanged", {
    params ["_unit", "_anim"];
    _stances = (["UP", "DOWN", "MIDDLE"] - [_thisArgs]);
    if (unitPos _unit in _stances) then {
        _unit setUnitPos _thisArgs;
    };
    if (!alive _unit) then {
        _unit removeEventHandler ["AnimChanged", _thisID];
    };
}, _stance] call CBA_fnc_addBISEventHandler;

_unit addMPEventHandler ["MPKilled", {
    params ["_unit", "_killer"];
    ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;

}];

_unit allowDamage true;
_unit enableSimulation true;

_unit