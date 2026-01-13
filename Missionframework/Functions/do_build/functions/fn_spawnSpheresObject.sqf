/*
    File: fn_spawnShepresLocal.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 28/08/2025
    Last update: 26/09/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Creates spheres around the placeholder build object, locally

    Parameter(s)
        _object - placeholder object create by fn_spawnPreplaceObject.sqf [OBJECT, defaults to objNull] 
        _fobPos - fob position [POSITION, defaults to [0,0,0]]
        _player - player that is moving the placeholder object [OBJECT, defaults to player]

    Returns:
        -
*/
params[["_object", objNull, [objNull]], ["_fobPos", [0,0,0], [[]]], ["_player", player, [ObjNull]]];

if (isNull _object) exitWith {};
if (!local _object || {!local _player}) exitWith {};
if (_fobPos isEqualTo [0,0,0]) exitWith {};

private _object_spheres = [];

private _dist = 0.6 * (boundingBoxReal _object # 2);
if (_dist < 5) then {_dist = 5};

for "_i" from 1 to 30 do {
    _object_spheres pushBack ("Sign_Sphere100cm_F" createVehicleLocal [0, 0, 0]);
};

{
    _x setObjectTexture [0, "#(rgb,8,8,3)color(0,1,0,1)"]; 
    _x setPos (_object getPos [_dist, 12 * _forEachIndex]);
    _x attachTo [_object];
} foreach _object_spheres;

_object setVariable ["KPLIB_BUILD_objectSpheres", _object_spheres]; // Save spheres and its relative position
_object setVariable ["KPLIB_BUILD_canBuild", true];
_object setVariable ["KPLIB_BUILD_isObjectInArea", true];


// Check for object collition or out of build area, and change the color of the spheres
if !(isNil "KPLIB_doBuild_eachFrame") then {
    removeMissionEventHandler ["EachFrame", KPLIB_doBuild_eachFrame]
};

[_object, _player, _fobPos] call KPLIB_fnc_buildEachFrame;