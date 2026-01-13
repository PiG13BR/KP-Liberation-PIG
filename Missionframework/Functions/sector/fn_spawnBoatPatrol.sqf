/*
    Boat spawn prototype
    ToDo: Add EH "Hit" and make the ai turns to where the shot came from from >> some scheduler with BIS_fnc_inAngleSector
*/

params["_sector"];

private _boatCrewGrp = createGroup KPLIB_side_enemy;
private _sectorPos = markerPos _sector;
private _waterPos = [[[_sectorPos, KPLIB_range_sectorCapture * 1.5]], [], {(_this isFlatEmpty [-1, -1, -1, -1, 2, false]) isNotEqualTo []}] call BIS_fnc_randomPos;
if (_waterPos isNotEqualTo [0,0]) then {
    private _boatVeh = (selectRandom KPLIB_o_boats) createVehicle _waterPos;
    [_boatVeh, KPLIB_side_enemy, _boatCrewGrp] call KPLIB_fnc_createCrew;

    private _lastPos = _waterPos;
    for "_i" from 0 to 2 do {
        private _waterPos = [[[_sectorPos, KPLIB_range_sectorCapture * 3]], [], {(_this isFlatEmpty [-1, -1, -1, -1, 2, false]) isNotEqualTo [] && (_lastPos distance2D _this >= 200)}] call BIS_fnc_randomPos;
        if (_waterPos isEqualTo [0,0]) exitWith {};
        _lastPos = _waterPos;
        private _wp = _boatCrewGrp addWaypoint [_waterPos, 0];
        if (_i < 2) then {
            _wp setWaypointType "MOVE";
            _wp setWaypointType "LIMITED";
            _wp setWaypointCompletionRadius 50;
            _wp setWaypointTimeout [10, 15, 20];
        } else {
            // Cycle
            _wp setWaypointType "CYCLE";
            _wp setWaypointCompletionRadius 50;
            _wp setWaypointTimeout [10, 15, 20];
        }
    };
};

units _boatCrewGrp