params["_grp", "_rallyPoint"];

//["KPLIB_RP_squadDeleteMarker", [_rallyPoint], _grp] call CBA_fnc_targetEvent; // Delete marker
[_rallyPoint] remoteExecCall ["KPLIB_fnc_squadDeleteMarker", _grp, true];

// Create local marker
private _sqRPmk = createMarkerLocal [format["%1_RallyPoint", _grp], _rallyPoint];
_sqRPmk setMarkerTypeLocal "loc_LetterR";
_sqRPmk setMarkerTextLocal format["%1 Rally Point", _grp];
_sqRPmk setMarkerPosLocal _rallyPoint;