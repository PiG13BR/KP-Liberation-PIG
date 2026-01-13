#include "..\defines.hpp"
/*
    File: fn_buildEachFrame.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 11/11/2025
    Last update: 12/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Create EachFrame MEH to check distance/collision for the preplaced object

    Parameter(s)
        _object - preplaced object [OBJECT, defaults to objNull]
        _player - player who object is attached too [OBJECT, defaults to player]
        _centerPos - Center building position [POSITION, defaults to [0,0,0]]

    Returns:
        -
*/

params[["_object", objNull, [objnull]], ["_player", player, [objNull]], ["_centerPos", [0,0,0], []]];

if (isNull _object) exitWith {};
if (_centerPos isEqualTo [0,0,0]) exitWith {};

if !(isNil "KPLIB_doBuild_eachFrame") then {
    removeMissionEventHandler ["EachFrame", KPLIB_doBuild_eachFrame]
};

private _buildType = localNamespace getVariable ["KPLIB_BUILD_buildType", 1]; // Get build type (look for FOB build type)

KPLIB_doBuild_eachFrame = addMissionEventHandler ["EachFrame", { 
    
    _thisArgs params ["_object", "_player", "_posCenter", "_maxDist", "_typeNumber"];

    private _spheres = _object getVariable ["KPLIB_BUILD_objectSpheres", []];
    private _areaSpheres = localNamespace getVariable ["KPLIB_BUILD_areaSpheres", []];
    private _objectSize = (boundingBoxReal _object # 2) * 1.05;
    private _nearObjects = nearestObjects [_object, ["AllVehicles", "Things", "ThingX", "Building", "Ruins"], _objectSize, false] - [_object, _player] - _areaSpheres; 
    private _distanceFromFob = _object distance2D _posCenter;

    /*
    private _dist = 0.6 * (boundingBoxReal _object # 2);
    if (_dist < 5) then { _dist = 5 };
    {	
        _x setPos (_object getPos [_dist, 12 * _forEachIndex]);
        _x attachTo [_object];
    }forEach _spheres;
    */

    // Check if the building can be placed and set a variable to it
    if (((_distanceFromFob > _maxDist) && {_typeNumber != BUILDTYPE_FOB}) || {((surfaceIsWater (getPosASL _object))) && !((typeOf _object) in boats_names)} || {_nearObjects isNotEqualTo [] && !((typeOf _object) in KPLIB_collisionIgnoreObjects)}) then {
        _object setVariable ["KPLIB_BUILD_canBuild", false]; // Change value
        if ((_distanceFromFob > _maxDist)  && {_typeNumber != BUILDTYPE_FOB}) then {_object setVariable ["KPLIB_BUILD_isObjectInArea", false]} else {_object setVariable ["KPLIB_BUILD_isObjectInArea", true]}; // Change value

        _object hideObject true; // Hide object
        drawIcon3D
        [
            "a3\3den\data\displays\display3den\panelright\modemarkers_ca.paa",
            [1, 0, 0, 1], 
            ASLToAGL getPosASLVisual _object, 
            1, 
            1, 
            0, 
            "Cannot Build", 
            1, 
            0.05, 
            "PuristaMedium"
        ];
    } else {
        _object setVariable ["KPLIB_BUILD_canBuild", true]; // Change value
        _object setVariable ["KPLIB_BUILD_isObjectInArea", true]; // Change value
        if (isObjectHidden _object) then {_object hideObject false}; // Show object
    };
}, [_object, _player, _centerPos, KPLIB_range_fob, _buildType]];