/*
    File: fn_buildInfantry.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 11/11/2025
    Last update: 12/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Build infantry unit

    Parameter(s)
        _classname - classname of the infantry to build [STRING]
        _player - player that bought the infantry [OBJECT, defaults to player]

    Returns:
        -
*/

params["_classname", ["_player", player, [objNull]]];

private _pos = getPosATL _player;
private _grp = group _player;

private _newUnit = _grp createUnit [_classname, _pos, [], 3, "NONE"];
_newUnit addMPEventHandler ["MPKilled", {
    ["KPLIB_manageKills", _this] call CBA_fnc_localEvent}
];
