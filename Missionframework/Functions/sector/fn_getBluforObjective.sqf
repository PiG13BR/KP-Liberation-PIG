/*
    File: fn_getBluforObjective.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 05/11/2025
    Last Update: 05/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Gets a random blufor objective position.

    Parameter(s):
        _pos - Position if the nearest blufor objective to this should be selected [POSITION, defaults to [0, 0, 0]]

    Returns:
        Blufor objetive position [POSITION]
*/

params [
    ["_pos", [0, 0, 0], [[]], [2, 3]]
];

private _possibleBluforObjectives = [];

private _objectivesToCheck = KPLIB_sectors_fob + ((KPLIB_sectors_player - KPLIB_sectors_outpost) apply {markerPos _x});

{
    private _valid = true;
    private _current = _x;
    private _distances = [];

    // Make sure that there is an opfor sector near player's sector
    if ((KPLIB_sectors_all - KPLIB_sectors_player) findIf {(_current distance2D (markerPos _x)) < 2000} < 0) then {
        _valid = false;
    };

    // Add distance and marker name to possible spawn, if still valid
    if (_valid) then {
        _possibleBluforObjectives pushBack _current;
    };
}forEach _objectivesToCheck;

// Return empty string, if no possible spawn point was found
if (_possibleBluforObjectives isEqualTo []) exitWith {["No objective to attack found", "WARNING"] call KPLIB_fnc_log; [0, 0, 0]};

// Return nearest blufor objective to given position, if provided
if (_pos isNotEqualTo [0, 0, 0]) exitWith {
    ([_possibleBluforObjectives, [_pos] , {_input0 distance _x} , "ASCEND"] call BIS_fnc_sortBy) select 0
};

// Return random blufor objective
(selectRandom _possibleBluforObjectives)