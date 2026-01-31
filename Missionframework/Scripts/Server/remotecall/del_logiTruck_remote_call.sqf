if (!isServer) exitWith {};

params ["_index", "_nearfob", "_clientID"];

logiError = 0;

if (((KPLIB_logistics select _index) select 1) <= 0) exitWith {logiError = 1; _clientID publicVariableClient "logiError";};

private _storage_areas = (_nearfob nearobjects KPLIB_range_fob) select {_x getVariable ["KPLIB_fobStorage", false]};

if ((count _storage_areas) == 0) exitWith {
    [localize "STR_LOGISTIC_NOSPACE", true, 3] remoteExec ["KPLIB_fnc_hint", _clientID];
    logiError = 1; 
    _clientID publicVariableClient "logiError";
};

#define SUPPLY_INDEX 0
#define AMMO_INDEX 1
#define FUEL_INDEX 2

private _price_s = 50;
private _price_a = 0;
private _price_f = 50;

private _storages = [];
{
    if ([_x] call KPLIB_fnc_isStorageFull) then {continue}; // Skip iteration

    private _storageLimit = [_x] call KPLIB_fnc_getStorageLimit;
    if (_sum >= _storageLimit) then {continue}; // Skip iteration

    // Pushback storage with space
    _storages pushBack _x;
} forEach _storage_areas;

if (_storages isEqualTo []) exitWith {
    [localize "STR_LOGISTIC_NOSPACE", true, 3] remoteExec ["KPLIB_fnc_hint", _clientID];
    logiError = 1; 
    _clientID publicVariableClient "logiError";
};

{
    private _resources = [_x] call KPLIB_fnc_getStorageValues;
    _resources params ["_supply", "_ammo", "_fuel"];
    private _sum = _supply + _ammo + _fuel;

    private _storageLimit = [_x] call KPLIB_fnc_getStorageLimit;

    if (_price_s > 0) then {
        private _amount = _price_s;
        if (_sum + _amount > _storageLimit) then {
            private _adjust = (_sum + _amount) - _storageLimit;
            _amount = _amount - _adjust; // Only the necessary amount to fill storage
        };
        _resources set [SUPPLY_INDEX, _supply + _amount];

        _price_s = _price_s - _amount
    };

    if (_price_a > 0) then {
        private _amount = _price_a;
        if (_sum + _amount > _storageLimit) then {
            private _adjust = (_sum + _amount) - _storageLimit;
            _amount = _amount - _adjust; // Only the necessary amount to fill storage
        };
        _resources set [AMMO_INDEX, _supply + _amount];

        _price_a = _price_a - _amount
    };

    if (_price_f > 0) then {
        private _amount = _price_f;
        if (_sum + _amount > _storageLimit) then {
            private _adjust = (_sum + _amount) - _storageLimit;
            _amount = _amount - _adjust; // Only the necessary amount to fill storage
        };
        _resources set [FUEL_INDEX, _supply + _amount];

        _price_f = _price_f - _amount
    };

    _x setVariable ["KPLIB_storageResources", _resources, true];

    if ((_price_s == 0) && (_price_a == 0) && (_price_f == 0)) exitWith {};
} forEach _storage_areas;

["KPLIB_recalculateResources", []] call CBA_fnc_serverEvent;

(KPLIB_logistics select _index) set [1, ((KPLIB_logistics select _index) select 1) - 1];
publicVariable "KPLIB_logistics";
