params["_storage"];
private _isFull = false;

private _resources = _storage getVariable ["KPLIB_storageResources", [0,0,0]];
_resources params ["_supplies", "_ammo", "_fuel"];

private _storageLimit = [_storage] call KPLIB_fnc_getStorageLimit;

if ((_supplies + _ammo + _fuel) >= _storageLimit) then {
    _isFull = true
};

_isFull