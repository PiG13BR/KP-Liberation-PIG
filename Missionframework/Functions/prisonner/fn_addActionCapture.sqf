/*
    File: fn_addActionCapture.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 24/11/2025
    Last Update: 24/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Add capture action to the surrendered unit

    Parameter(s):
        _unit - surrendered unit to add capture action [OBJECT]

    Returns:
        -
*/

params["_unit"];

_unit addAction [
    "<t color='#FFFF00'>" + localize "STR_SECONDARY_CAPTURE" + "</t>",
    {

        params["_unit", "_player", "_actionID"];

        ["KPLIB_addAction", _unit] call CBA_fnc_globalEventJIP; // Add action to finish capturing in FOB
        _unit removeAction _actionID;

        _unit setVariable ["KPLIB_prisonner_captured", true, true];
        _unit setVariable ["KPLIB_prisonner_whois", _player, true];

        if (alive _unit) then {
            [[_unit], group _player] remoteExecCall ["joinSilent"];

            _unit setCaptive false;
            _unit enableAI "ANIM";
            _unit enableAI "MOVE";
            sleep 1;
            _unit playmove "AmovPercMstpSsurWnonDnon_AmovPercMstpSnonWnonDnon";
            sleep 2;
            [_unit, ""] remoteExecCall ["switchMove"];

            sleep 1;
            doStop _unit;
            _unit doFollow _player;
            [_unit] remoteExec ["remote_call_prisonner", _unit];
        };
    },
    "",
    -850,
    true,
    true,
    "",
    toString{
        [5] call KPLIB_fnc_hasPermission &&
        {!(_target getVariable ['KPLIB_prisonner_captured', false])} && 
        {isNull objectParent _this} && 
        {side (group _target) != KPLIB_side_player} && 
        {captive _target}
    }
];