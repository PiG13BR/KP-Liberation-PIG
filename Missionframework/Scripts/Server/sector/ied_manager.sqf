params ["_sector", "_radius", "_number"];

if (_number <= 0) exitWith {};

if (KPLIB_asymmetric_debug > 0) then {[format ["ied_manager.sqf for %1 spawned on: %2", markerText _sector, KPLIB_debugSource], "ASYMMETRIC"] remoteExecCall ["KPLIB_fnc_log", 2];};

_number = round _number;
private _spread = 7;

private _ied_type = selectRandom ["iedd_ied_Cardboard","iedd_ied_Cinder","iedd_ied_CanisterFuel","iedd_ied_Metal","iedd_ied_Metal_English","iedd_ied_Barrel","iedd_ied_Barrel_Grey","iedd_ied_CanisterPlastic"];
private _ied_obj = objNull;
private _roadobj = [(markerPos _sector) getPos [random _radius, random 360], _radius, []] call BIS_fnc_nearestRoad;

if (KPLIB_asymmetric_debug > 0) then {[format ["ied_manager.sqf -> spawning IED %1 at %2", _number, markerText _sector], "ASYMMETRIC"] remoteExecCall ["KPLIB_fnc_log", 2];};

if (_number > 0) then {
    [_sector, _radius, _number - 1] spawn ied_manager;
};

if (!(isnull _roadobj)) then {

    _roadpos = getpos _roadobj;
    _ied_obj = createVehicle [_ied_type, _roadpos getPos [_spread, random (360)], [], 0];
    _ied_obj setdir (random 360);

    if (KPLIB_asymmetric_debug > 0) then {[format ["ied_manager.sqf -> IED %1 spawned at %2", _number, markerText _sector], "ASYMMETRIC"] remoteExecCall ["KPLIB_fnc_log", 2];};
} else {
    if (KPLIB_asymmetric_debug > 0) then {[format ["ied_manager.sqf -> _roadobj is Null for IED %1 at %2", _number, markerText _sector], "ASYMMETRIC"] remoteExecCall ["KPLIB_fnc_log", 2];};
};

if ((KPLIB_asymmetric_debug > 0) && !(isNull _roadobj)) then {[format ["ied_manager.sqf -> exited IED %1 loop at %2", _number, markerText _sector], "ASYMMETRIC"] remoteExecCall ["KPLIB_fnc_log", 2];};

sleep 1800;

if (!(isNull _ied_obj)) then {deleteVehicle _ied_obj;};
