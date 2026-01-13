/*
    File: fn_hint.sqf
    Author: commy2 (original author, ace3), PiG13BR (Modifications for KP Liberation).
    Date: 23/11/2025
    Last update: 23/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Ace 3 functions that display a message (ace_common_fnc_displayText) modificated for liberation.

    Parameter(s):
        _text - text to show [STRING]
        _sound - play a clicking sound [BOOL, defaults to false]
        _delay - How long before hiding the message in seconds [NUMBER, defaults to 2]
        _priority - Priority, higher priority messages will override lesser important ones [NUMBER, defaults to 0]

    Returns:
        -
*/

params ["_text", ["_sound", false], ["_delay", 2], ["_priority", 0]];

if (isNil "KPLIB_lastHint") then {
    KPLIB_lastHint = [0, 0];
};

if !(typeName _text in ["STRING", "TEXT"]) then {_text = str _text};

KPLIB_lastHint params ["_lastHintTime", "_lastHintPriority"];

private _time = CBA_missionTime;

if (_time > _lastHintTime + _delay || {_priority >= _lastHintPriority}) then {
    hintSilent _text;
    if (_sound) then {playSound "Liberation_Click"};
    KPLIB_lastHint set [0, _time];
    KPLIB_lastHint set [1, _priority];

    [{if ((_this select 0) == KPLIB_lastHint select 0) then {hintSilent ""};}, [_time], _delay, 0] call CBA_fnc_waitAndExecute;
};