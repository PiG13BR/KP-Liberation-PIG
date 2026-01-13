params ["_sector", "_count"];

if (_count <= 0) exitWith {};

if (KPLIB_asymmetric_debug > 0) then {[format ["manage_asymIED.sqf for %1 spawned on: %2", markerText _sector, KPLIB_debugSource], "ASYMMETRIC"] remoteExecCall ["KPLIB_fnc_log", 2];};

waitUntil {sleep 1; _sector in KPLIB_asymmetric_sectors};

if (KPLIB_asymmetric_debug > 0) then {[format ["manage_asymIED.sqf -> spawning IED %1 at %2", _count, markerText _sector], "ASYMMETRIC"] remoteExecCall ["KPLIB_fnc_log", 2];};

private _spread = 7;

private _ied_type = selectRandom ["iedd_ied_Cardboard","iedd_ied_Cinder","iedd_ied_CanisterFuel","iedd_ied_Metal","iedd_ied_Metal_English","iedd_ied_Barrel","iedd_ied_Barrel_Grey","iedd_ied_CanisterPlastic"];
private _ied_obj = objNull;
private _roadobj = [(markerPos (_sector) getPos [random (200), random (360)]), 200, []] call BIS_fnc_nearestRoad;


if (_count > 0) then {
    [_sector, _count - 1] spawn manage_asymIED;
};

if (!(isnull _roadobj)) then {
    private _roadpos = getpos _roadobj;
    _ied_obj = createVehicle [_ied_type, _roadpos getPos [_spread, random (360)], [], 0];
    _ied_obj setdir (random 360);

    if (KPLIB_asymmetric_debug > 0) then {[format ["manage_asymIED.sqf -> IED %1 spawned at %2", _count, markerText _sector], "ASYMMETRIC"] remoteExecCall ["KPLIB_fnc_log", 2];};
} else {
    if (KPLIB_asymmetric_debug > 0) then {[format ["manage_asymIED.sqf -> _roadobj is Null for IED %1 at %2", _count, markerText _sector], "ASYMMETRIC"] remoteExecCall ["KPLIB_fnc_log", 2];};
};

if ((KPLIB_asymmetric_debug > 0) && !(isNull _roadobj)) then {[format ["manage_asymIED.sqf -> exit IED %1 loop at %2", _count, markerText _sector], "ASYMMETRIC"] remoteExecCall ["KPLIB_fnc_log", 2];};

sleep 60;

if (!(isNull _ied_obj)) then {deleteVehicle _ied_obj;};
