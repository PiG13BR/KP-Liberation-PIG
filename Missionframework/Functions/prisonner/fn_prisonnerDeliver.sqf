/*
    File: fn_prisonnerDeliver.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 24/11/2025
    Last Update: 24/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Deliver pow to the nearest FOB and gain intel points

    Parameter(s):
        _unit - cuffed unit to add deliver pow action [OBJECT]
        _force_surrender - true to force surrender [BOOL, defaults to false]

    Returns:
        [BOOL]
*/

params[["_unit", objNull, [objNull]]];

if (isNull _unit) exitWith {false};

_unit setVariable ["KPLIB_powDelivered", true, true];

// Join civilian side
private _grp = createGroup [KPLIB_side_civilian, true];
[_unit] joinSilent _grp;

// Check for handcuffs
if (KPLIB_ace) then {
    private _isCuffed = _unit getVariable ["ace_captives_isHandcuffed", false];
    if (_isCuffed) then {
        ["ace_captives_setHandcuffed", [_unit, false], _unit] call CBA_fnc_targetEvent;
    } else {
        ["ace_captives_setSurrendered", [_unit, false], _unit] call CBA_fnc_targetEvent;
    };
};

// Play sit down on ground animation
_unit playmove "AmovPercMstpSnonWnonDnon_AmovPsitMstpSnonWnonDnon_ground";
_unit disableAI "ANIM";
_unit disableAI "MOVE";

[{
    params["_unit"];

    [_unit, "AidlPsitMstpSnonWnonDnon_ground00"] remoteExecCall ["switchMove"];
    //[_unit] remoteExec ["prisonner_remote_call", 2]; // Gain intel points
    ["KPLIB_intelYieldPow", _unit] call CBA_fnc_serverEvent;

}, _unit, 5] call CBA_fnc_waitAndExecute;

// Despawn
[group _unit] call KPLIB_fnc_despawnGroup;

true