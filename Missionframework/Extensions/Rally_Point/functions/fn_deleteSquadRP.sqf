/*
    File: fn_deleteSquadRP.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 09/11/2025
    Last update: 09/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Deletes squad's rally point

    Parameter(s)
        _grp - squad related to the rally point object
        _rallyPoint - rally point object [OBJECT, defaults to objNull]

    Returns:
        -
*/
params["_grp", ["_rallyPoint", objNull, [objNull]]];

if (isNull _rallyPoint) then {_rallyPoint = [_grp] call KPLIB_fnc_getSquadRP;};

if (!isNull _rallyPoint) then {
    // Delete rally point
    deleteVehicle _rallyPoint;
    
    // Delete local marker
    ["KPLIB_RP_squadDeleteMarker", [_rallyPoint], _grp] call CBA_fnc_targetEvent;
};

