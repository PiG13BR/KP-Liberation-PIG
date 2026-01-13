/*
    Once an airfield sector is captured, an aircraft will and and drop supplies
*/

params[
    ["_aircraftType", "", [""]], 
    ["_airportID", 0, [0]],
    ["_sector", "", [""]],
    ["_pilotType", KPLIB_b_heliPilotUnit, [""]], 
    ["_resources", [[KPLIB_b_crateSupply, 5], [KPLIB_b_crateAmmo, 3], [KPLIB_b_crateFuel, 3]], [[]]]
];

private _spawnPoint = ([KPLIB_sectors_airSpawn, [getMarkerPos _sector], {(markerPos _x) distance _input0}, "ASCEND"] call BIS_fnc_sortBy) select 0;

private _plane = createVehicle [_aircraftType, markerPos _spawnPoint, [], 0, "FLY"];
_plane setDir ((markerPos _spawnPoint) getDir (markerPos _sector));
private _grp = createGroup civilian;

private _pilot = _grp createUnit [_pilotType, markerPos "ghost_spot", [], 0, "NONE"];
_pilot moveInDriver _plane;
_pilot setCaptive true;
_pilot disableAI "TARGET";
_pilot disableAI "AUTOTARGET";

_grp setBehaviour "CARELESS";
_plane setDamage 0;
_pilot allowDamage false;
_plane allowDamage false;
_plane setVehicleLock "LOCKEDPLAYER";

_plane setVariable ["KPLIB_resourcesToDeliver", _resources];
localNamespace setVariable ["KPLIB_sectorToDeliver", _sector];

{
    _x addCuratorEditableObjects [[_plane], true];
}forEach allCurators;

_plane landAt _airportID; // Order to land at Molos airfield

_plane addEventHandler ["LandedStopped", {
	params ["_plane", "_airportID", "_airportObject"];
    deleteVehicleCrew _plane;

    [_plane] call KPLIB_fnc_despawnObject;

    // Spawn crates
    private _resources = _plane getVariable ["KPLIB_resourcesToDeliver", []];

    {
        _x params ["_crate", "_amount"];
        for "_i" from 1 to _amount do {
            [_crate, 100, _plane getPos [8, (getDir _plane) - 180]] call KPLIB_fnc_createCrate;
        };
    }forEach _resources;

    private _sector = localNamespace getVariable ["KPLIB_sectorToDeliver", ""];
    [format["Avião aliado descarregou os suprimentos em %1", markerText _sector]] remoteExec ["systemChat"];
}];

_plane addEventHandler ["Landing", {
	params ["_plane", "_airportID", "_isCarrier"];

    private _sector = localNamespace getVariable ["KPLIB_sectorToDeliver", ""];
    [format["Avião aliado está se aproximando para o pouso no campo em %1", markerText _sector]] remoteExec ["systemChat"];
}];

_plane addEventHandler ["LandingCanceled", {
	params ["_plane", "_airportID", "_isCarrier"];

    ["Aeronave aliada irá tentar aproximar novamente para o pouso"] remoteExec ["systemChat"];
}];