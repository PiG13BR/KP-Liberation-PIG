params["_factories"];

private _factory = "";
private _possibleFactories = [];
{
    if (_x in KPLIB_blockedFactories) then {continue};
    if (_x in KPLIB_sectors_active) then {continue};

    // Check for players nearby
    if (([markerPos _x, 2000, KPLIB_side_player] call KPLIB_fnc_getUnitsCount) > 0) then {continue};

    // Avoid factories near the front
    if ((KPLIB_sectors_all - KPLIB_sectors_player) findIf {((markerPos _current) distance2D (markerPos _x)) < 2000} > 0) then {continue};

    _possibleFactories pushBack _x;
}forEach _factories;

if (_possibleFactories isEqualTo []) exitWith {["Couldn't find factories to be seized", "WARNING"] call KPLIB_fnc_log; _factory};

_factory = selectRandom _possibleFactories;

_factory