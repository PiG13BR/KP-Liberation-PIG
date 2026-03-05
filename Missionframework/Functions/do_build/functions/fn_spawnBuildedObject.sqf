#include "..\defines.hpp"
/*
    File: fn_spawnBuildedObject.sqf
    Author: PiG13BR (https://github.com/PiG13BR), FernandimModelador https://github.com/FernandimModelador
    Date: 28/08/2025
    Last update: 04/03/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns the actual object builded from the build menu (server side)

    Parameter(s)
        _objectClass - preplaced local object class [SRING, defaults to "]
        _player - player that placed the object [OBJECT, defaults to objNull]

    Returns:
        object created [OBJECT]
*/

params[
    ["_objectClass", "", [""]], 
    ["_objPos", [0,0,0], [[]]], 
    ["_objDir", 0, [0]], 
    ["_vector", true, [FALSE]],
    ["_buildType", -1, [0]],
    ["_withCrew", false, [FALSE]],
    ["_player", player, [objNull]]
];

if (!isServer) exitWith {objNull};
if (_objectClass isEqualTo "") exitWith {objNull};

// Create the actual object
private _objectSpawned = createVehicle [_objectClass, _objPos];
_objectSpawned setPosATL _objPos;
_objectSpawned setDir _objDir;
_objectSpawned awake true;

if (_vector) then {
    _objectSpawned setVectorUp [0,0,1];
} else {
    _objectSpawned setVectorUp surfaceNormal position _objectSpawned;
};

// Add object init
if (_buildType != BUILDTYPE_FOB && {_buildType != BUILDTYPE_FACTORY_STORAGE}) then {
    [_objectSpawned] call KPLIB_fnc_addObjectInit;
};

// Clear cargo
[_objectSpawned] call KPLIB_fnc_clearCargo;

if ((toLowerANSI _objectClass) in KPLIB_o_allVeh_classes) then {
    _objectSpawned setVariable ["KPLIB_captured", true, true];
};
if (_objectClass in KPLIB_c_vehicles) then {
    _objectSpawned setVariable ["KPLIB_seized", true, true];
};

// Add crew
if ((unitIsUAV _objectSpawned) || _withCrew) then {
    [_objectSpawned] call KPLIB_fnc_forceBluforCrew;
};

// Get build type
if(_buildType != BUILDTYPE_BUILDING && {_buildType != BUILDTYPE_FOB} && {_buildType != BUILDTYPE_FACTORY_STORAGE}) then {
    _objectSpawned addMPEventHandler ["MPKilled", {
        params ["_unit", "_killer"];
        ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
    }];

    {
        _x addMPEventHandler ["MPKilled", {
            params ["_unit", "_killer"];
            ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
        }];
    } foreach (crew _objectSpawned);
};

// Log
["KPLIB_generateLog", 
    [
        format ["player %1 builded an object (%2) in position %3", name _player, getText(configFile >> "cfgVehicles" >> _objectClass >> "displayName"), (getPosATL _objectSpawned)],
        "BUILD"
    ]
] call CBA_fnc_serverEvent;

// Hint
[localize "STR_CONFIRM_HINT", false, 3] remoteExecCall ["KPLIB_fnc_hint", _player];

// FOB Builded
if(_buildType == BUILDTYPE_FOB) then {
    _objectSpawned setVectorUp [0,0,1]; // VectorUp

    ["KPLIB_fobBuilded", [_objectSpawned, false]] call CBA_fnc_serverEvent;
};

// Factory storage builded
if(_buildType == BUILDTYPE_FACTORY_STORAGE) then {
    ["KPLIB_factoryStorageBuilded", _objectSpawned] call CBA_fnc_serverEvent;
};

_objectSpawned