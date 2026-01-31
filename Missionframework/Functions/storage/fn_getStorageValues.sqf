/*
    File: fn_getStorageValues.sqf
    Author: PiG13BR - https://github.com/KillahPotatoes
    Date: 28/01/2026
    Last Update: 28/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Get amount of resources available in the storage.

    Parameter(s):
        _storage - storage to check its resource values [OBJECT, defaults to objNull]

    Returns:
        Amount of resources in the storage [ARRAY]
*/
params["_storage"];

private _resourcesAmount = _storage getVariable ["KPLIB_storageResources", [0,0,0]];

if (_resourcesAmount isEqualTo []) exitWith {};

_resourcesAmount