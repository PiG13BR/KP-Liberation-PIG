params["_rallyPoint"];

// Delete local marker
private _grp = _rallyPoint getVariable ["KPLIB_RP_rallyPointSquad", _grpNull];
if (!isNull _grp) then {
    private _markerName = format["%1_RallyPoint", _grp];
    deleteMarkerLocal _markerName;
};