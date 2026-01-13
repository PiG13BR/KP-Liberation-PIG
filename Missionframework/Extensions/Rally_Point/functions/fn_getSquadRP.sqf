/*
    File: fn_getSquadRP.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 28/10/2025
    Last update: 08/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Get group's rally point object

    Parameter(s)
        _grp - group to get rally point [GROUP, defaults to grpNull]

    Returns:
        Squad Rally Point [OBJECT]
*/
params[["_grp", grpNull, [grpNull]]];

if (isNull _grp) exitWith {};

_grp getVariable ["KPLIB_RP_squadRallyPoint", objNull] // Return