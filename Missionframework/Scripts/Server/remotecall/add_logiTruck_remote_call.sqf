if (!isServer) exitWith {};

params ["_index", "_nearfob", "_clientID", "_supplies", "_ammo", "_fuel"];

logiError = 0;

private _storage_areas = (_nearfob nearobjects KPLIB_range_fob) select {_x getVariable ["KPLIB_fobStorage", false]};

if ((count _storage_areas) == 0) exitWith {
    [localize "STR_LOGISTIC_CANTAFFORD", true, 3] remoteExec ["KPLIB_fnc_hint", _clientID];
    logiError = 1; 
    _clientID publicVariableClient "logiError";
};

#define SUPPLY_INDEX 0
#define AMMO_INDEX 1
#define FUEL_INDEX 2

private _price_s = 100;
private _price_a = 0;
private _price_f = 100;

if ((_price_s > _supplies) || (_price_a > _ammo) || (_price_f > _fuel)) exitWith {
    [localize "STR_LOGISTIC_CANTAFFORD", true, 3] remoteExec ["KPLIB_fnc_hint", _clientID];
    logiError = 1; 
    _clientID publicVariableClient "logiError";
};

{
    private _resources = [_x] call KPLIB_fnc_getStorageValues;
    _resources params ["_supply", "_ammo", "_fuel"];

    if ((_price_s > 0) && (_supply >= _price_s)) then {
        private _amount = _price_s;
        _resources set [SUPPLY_INDEX, _supply - _amount];
        _price_s = _price_s - _amount
    };

    if ((_price_a > 0) && (_ammo >= _price_a)) then {
        private _amount = _price_a;
        _resources set [AMMO_INDEX, _ammo - _amount];
        _price_a = _price_a - _amount
    };

    if ((_price_f > 0) && (_fuel >= _price_f)) then {
        private _amount = _price_f;
        _resources set [FUEL_INDEX, _fuel - _amount];
        _price_f = _price_f - _amount
    };

    _x setVariable ["KPLIB_storageResources", _resources, true];

    if ((_price_s == 0) && (_price_a == 0) && (_price_f == 0)) exitWith {};

} forEach _storage_areas;

["KPLIB_recalculateResources", []] call CBA_fnc_serverEvent;

(KPLIB_logistics select _index) set [1, ((KPLIB_logistics select _index) select 1) + 1];
publicVariable "KPLIB_logistics";
