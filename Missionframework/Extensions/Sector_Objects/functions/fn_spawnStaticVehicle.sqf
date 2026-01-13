/*
    File: fn_spawnStaticVehicle.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 18/12/2024
    Last Update: 28/12/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:

    Parameter(s):
        _relPos - relative position to a object [POSITION, PositionRelative]
		_class - classname of the static weapon to spawn [STRING]
		_relDir - relative direction to a object [NUMBER]

    Returns:
        
*/

params ["_relPos", "_class", "_relDir"];

_vehicle = createVehicle [_class, _relPos, [], 0, "CAN_COLLIDE"];
_vehicle allowdamage false;
_vehicle enableSimulation false;
_vehicle allowCrewInImmobile true;
_vehicle setDir _relDir;
_vehicle setVectorUp surfaceNormal getPosASL _vehicle;
_crewGrp = [_vehicle] call KPLIB_fnc_createCrew;
_vehicle deleteVehicleCrew (driver _vehicle);
_vehicle setTurretLimits [[0], -30, 30, -10, 10]; // Limit turret's movement
{
    _x setSkill ["spotDistance", 1];
    _x setSkill ["aimingAccuracy", 0.5];
    _x setSkill ["aimingSpeed", 1];
    _x setSkill ["spotTime", 1]; 
}forEach crew _vehicle;

{
    
	_x addMPEventHandler ["MPKilled", {
		params ["_unit", "_killer"];
		["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
        if (_unit == gunner (vehicle _unit)) then {
            if (count (crew (vehicle _unit)) > 0) then {
                _nextGunner = selectRandom (crew (vehicle _unit));
                moveOut _nextGunner;
                _nextGunner moveInGunner (vehicle _unit);
            }
        };
	}];
} forEach (units _crewGrp);

_vehicle addMPEventHandler ["MPKilled", {
    params ["_unit", "_killer"];
    ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;

}];

[_vehicle] call KPLIB_fnc_clearCargo;
[_vehicle] call KPLIB_fnc_addObjectInit;

_vehicle allowdamage true;
_vehicle enableSimulation true;

_vehicle