/*
    File: fn_spawnRepeatedObject.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 03/09/2025
    Last update: 12/04/2026

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
private _objectClass = typeOf _objectToRepeat;
private _objZCoords = localNamespace getVariable ["KPLIB_BUILD_objectElevation", 0];
private _objYCoords = localNamespace getVariable ["KPLIB_BUILD_objectYCoord", 3];
//private _dirObject = getDir _objectToRepeat;
private _dirObject = localNamespace getVariable ["KPLIB_BUILD_objectRotation", 0];
private _snap = localNamespace getVariable ["KPLIB_BUILD_snapToGround", false];
private _heightMode = localNamespace getVariable ["KPLIB_BUILD_heightMode", false];
private _yMode = localNamespace getVariable ["KPLIB_BUILD_yMode", false];

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

localNamespace setVariable ["KPLIB_BUILD_preplacedObject", _object];
localNamespace setVariable ["KPLIB_BUILD_objectElevation", _objZCoords];
localNamespace setVariable ["KPLIB_BUILD_objectYCoord", _objYCoords];
localNamespace setVariable ["KPLIB_BUILD_snapToGround", _snap];
localNamespace setVariable ["KPLIB_BUILD_heightMode", _heightMode];
localNamespace setVariable ["KPLIB_BUILD_yMode", _yMode];

// Create spheres
private _posFOB = [getPosATL _player] call KPLIB_fnc_getNearestFob;
[_posFOB, _player] call KPLIB_fnc_spawnSpheresArea;
//[_object, _posFOB, _player] call KPLIB_fnc_spawnSpheresObject;
[{_this call KPLIB_fnc_buildEachFrame}, [_object, _player, _posFOB]] call CBA_fnc_execNextFrame;

private _hiddenSelection = getArray(configFile >> "CfgVehicles" >> _objectClass >> "hiddenSelections");
{
    _object setObjectMaterial [_x, "\a3\data_f\default.rvmat"];
    _object setObjectTexture [_x, "#(rgb,8,8,3)color(0,1,0,1)"];
}forEach _hiddenSelection;

// Add build actions
//[_object, _player] call KPLIB_fnc_addBuildActions;