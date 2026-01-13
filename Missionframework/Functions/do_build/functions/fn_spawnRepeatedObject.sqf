/*
    File: fn_spawnRepeatedObject.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 03/09/2025
    Last update: 12/01/2026

    Description:
        Functions like fn_spawnPreplaceObject.sqf, but get some information about the copied object

    Parameter(s)
        _objectToRepeat - repeated object to build [OBJECT, defaults to objNull]
        _player - player who invocated the repeat building action [OBJECT, defaults to player]

    Returns:
        -
*/

params[["_objectToRepeat", objNull, [objNull]], ["_player", player, [objNull]]];

if (isNull _objectToRepeat) exitWith {["Object to build is null"] call BIS_fnc_error};

// Get information about object
private _objZCoords = localNamespace getVariable ["KPLIB_BUILD_objectElevation", 1];
private _objYCoords = localNamespace getVariable ["KPLIB_BUILD_objectYCoord", 3];
private _objectClass = typeOf _objectToRepeat;
private _dirObject = getDir _objectToRepeat;

// Substract resources from storages
private _itemToBuild = localNamespace getVariable ["KPLIB_BUILD_itemToBuild", []]; // Save building array
private _buildType = localNamespace getVariable ["KPLIB_BUILD_buildType", 1];
["KPLIB_subtractResources", [_itemToBuild, _buildType]] call CBA_fnc_serverEvent;

// Create preplaced object (locally)
private _object = createVehicleLocal [_objectClass, markerPos "spawn_ghost_structure"]; // Placeholder object and in a placeholder spawn pos
_object allowdamage false;
_object setVehicleLock "LOCKED";
// Crate simple object of it
private _simpleObject = [
    _objectClass, 
    (getPosWorld _object), 
    (getDir _object), 
    false, 
    false, 
    true // LOCAL!
] call BIS_fnc_createSimpleObject;
if (!isNull _simpleObject) then {deleteVehicle _object; _object = _simpleObject;}; // If creation not fails, delete the preplaced object and replace _object variable 

// Clear cargo
[_object] call KPLIB_fnc_clearCargo;

// Attach object to player
_object setPosATL [((getPosATL _objectToRepeat) # 0), ((getPosATL _objectToRepeat) # 1), (getPosATL _objectToRepeat) # 2]; // Correct altitude position for the object
private _objZCoords = abs((_object worldToModel ASLToAGL(getPosASL _player)) # 2); // Get model relative height position and convert to a positive value
_object attachTo [_player, [0, _objYCoords, _objZCoords]];
_object setDir (_dirObject - (_player getDir _object)); // Set direction relative

_object enableSimulationGlobal false;

_player setVariable ["KPLIB_BUILD_preplacedObject", _object];
localNamespace setVariable ["KPLIB_BUILD_objectElevation", _objZCoords];
localNamespace setVariable ["KPLIB_BUILD_objectYCoord", _objYCoords];

// Create spheres
private _posFOB = [getPosATL _player] call KPLIB_fnc_getNearestFob;
[_posFOB, _player] call KPLIB_fnc_spawnSpheresArea;
//[_object, _posFOB, _player] call KPLIB_fnc_spawnSpheresObject;
[_object, _player, _posFOB] call KPLIB_fnc_buildEachFrame;

// Add build actions
[_object, _player] call KPLIB_fnc_addBuildActions;