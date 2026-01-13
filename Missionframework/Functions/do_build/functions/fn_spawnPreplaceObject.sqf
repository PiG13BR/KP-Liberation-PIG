#include "..\defines.hpp"
/*
    File: fn_spawnPreplaceObject.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 28/08/2025
    Last update: 12/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawn a local object to be used as a placeholder

    Parameter(s)
        _objectClass - object classname [STRING, defaults to ""]
        _player - player that the object is going to attach to [OBJECT, defaults to player] 

    Returns:
        -
*/

params[["_objectClass", "", [""]], ["_player", player, [objNull]]];

if (_objectClass isEqualTo "") exitWith {["No classname provided"] call BIS_fnc_error};

// Create preplaced object (locally)
private _object = createVehicleLocal [_objectClass, markerPos "ghost_spot"]; // Placeholder object and in a placeholder spawn pos
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

/*
// (Failsafe) Deny players to have acess to a crate's inventory
private _inventoryEH = _player addEventHandler ["InventoryOpened", {
    params ["_unit", "_primaryContainer", "_secondaryContainer"];
    if !(_primaryContainer isKindOf "WeaponHolder") then {
        true; // Close inventory
    }
}];
_player setVariable ["KPLIB_BUILD_playerEH", [["InventoryOpened", _inventoryEH]]];
*/

// Attach object to player
_object setPosATL [((getPosATL _player) # 0) + 10, ((getPosATL _player) # 1) + 10, (getPosATL _player) # 2]; // Correct altitude position for the object
private _objZCoords = abs((_object worldToModel ASLToAGL(getPosASL _player)) # 2); // Get model relative height position and convert to a positive value
private _objYCoords = 3;
if (_object isKindOf "StaticWeapon") then {
    _objYCoords = ceil(boundingBoxReal _object # 2) * 0.8; // Draw static weapons closer
} else {
    _objYCoords = ceil(boundingBoxReal _object # 2) * 1.3;
};
_object attachTo [_player, [0, _objYCoords, _objZCoords]];

_object enableSimulationGlobal false;

_player setVariable ["KPLIB_BUILD_preplacedObject", _object];
localNamespace setVariable ["KPLIB_BUILD_objectElevation", _objZCoords];
localNamespace setVariable ["KPLIB_BUILD_objectYCoord", _objYCoords];

// Create spheres
private _buildType = localNamespace getVariable ["KPLIB_BUILD_buildType", 1];
private _buildCenterPos = [getPosATL _player] call KPLIB_fnc_getNearestFob; // Get FOB Pos

if (_buildType == BUILDTYPE_FACTORY_STORAGE) then {
    // For storage building, get the nearest sector
    _buildCenterPos = markerPos ([100] call KPLIB_fnc_getNearestSector);
};

if (_buildType != BUILDTYPE_FOB) then {
    // Buildings
    [_buildCenterPos, _player] call KPLIB_fnc_spawnSpheresArea;
} else {
    // Fob
    _buildCenterPos = getPosATL _player;
};

//[_object, _buildCenterPos, _player] call KPLIB_fnc_spawnSpheresObject;
[_object, _player, _buildCenterPos] call KPLIB_fnc_buildEachFrame;

// Add build actions
[_object, _player] call KPLIB_fnc_addBuildActions;