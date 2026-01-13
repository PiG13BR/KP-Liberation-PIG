/*
    File: fn_buildSquad.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 11/11/2025
    Last update: 12/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Build squad composition

    Parameter(s)
        _squadClasses - array of classnames of infantry units [ARRAY, defaults to []]

    Returns:
        -
*/
params[["_squadClasses",[],[[]]]];

if (_squadClasses isEqualTo []) exitWith {};

private _pos = getPosATL player;
private _grp = createGroup KPLIB_side_player;
_grp setGroupId [format ["%1 %2", KPLIB_b_squadNames select buildindex, groupId _grp]];

private _idx = 0;
{
    private _unitrank = "private";
    private _newUnit = objNull;

    if(_idx == 0) then {_unitrank = "sergeant";};
    if(_idx == 1) then {_unitrank = "corporal";};

    if (_squadClasses isEqualTo KPLIB_b_squadPara) then {
        _newUnit = _grp createUnit [_x, _pos, [], 3, "NONE"];
        removeBackpackGlobal _newUnit;
        _newUnit addBackpackGlobal "B_parachute";
    } else {
        _newUnit = _grp createUnit [_x, _pos, [], 3, "NONE"];
    };

    _newUnit setUnitRank _unitrank;
    _newUnit addMPEventHandler ["MPKilled", {
        ["KPLIB_manageKills", _this] call CBA_fnc_localEvent}
    ];

    _idx = _idx + 1;

} foreach _squadClasses;

_grp setBehaviour "AWARE";