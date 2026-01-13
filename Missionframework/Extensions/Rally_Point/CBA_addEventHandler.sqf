["KPLIB_RP_squadCreateMarker", {
    params["_grp", "_rallyPoint"];

    ["KPLIB_RP_squadDeleteMarker", [_rallyPoint], _grp] call CBA_fnc_targetEvent; // Delete marker

    // Create local marker
    private _sqRPmk = createMarkerLocal [format["%1_RallyPoint", _grp], _rallyPoint];
    _sqRPmk setMarkerTypeLocal "loc_LetterR";
    _sqRPmk setMarkerTextLocal format["%1 Rally Point", _grp];
    _sqRPmk setMarkerPosLocal _rallyPoint;
}] call CBA_fnc_addEventHandler;

["KPLIB_RP_squadDeleteMarker", {
    params["_rallyPoint"];

    // Delete local marker
    private _grp = _rallyPoint getVariable ["KPLIB_RP_rallyPointSquad", _grpNull];
    if (!isNull _grp) then {
        private _markerName = format["%1_RallyPoint", _grp];
        deleteMarkerLocal _markerName;
    };
}] call CBA_fnc_addEventHandler;