/*
    File: fn_addActionDeliver.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 24/11/2025
    Last Update: 24/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Add deliver pow action to a cuffed unit.

    Parameter(s):
        _unit - cuffed unit to add deliver pow action [OBJECT]

    Returns:
        -
*/

params["_unit"];

private _actionID = _unit addAction [
    "<t color='#A800FC'>" + localize "STR_DELIVER_POW" + "</t>",
    {
        params["_unit", "_player", "_actionID"];

        private _delivered = [_unit] call KPLIB_fnc_prisonnerDeliver;
        if (_delivered) then {_unit removeAction _actionID};
    },
    "",
    -850,
    true,
    true,
    "",
    toString{
        [5] call KPLIB_fnc_hasPermission &&
        {KPLIB_sectors_fob isNotEqualTo [] && 
        {(_target distance2D ([getPosATL _target] call KPLIB_fnc_getNearestFob)) < 30}} && 
        {isNull objectParent _this} && 
        {side (group _target) != KPLIB_side_player} && 
        {captive _target}
    }
];
_unit setVariable ["KPLIB_actionID_Capture", _actionID];