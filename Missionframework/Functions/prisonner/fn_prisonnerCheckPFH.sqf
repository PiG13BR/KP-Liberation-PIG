params["_prisonner"];

[{
    params["_unit", "_handler"];

    // Dead unit exit
    if (!alive _unit) exitWith {[_handler] call CBA_fnc_removePerFrameHandler;};

    // Pow delivered exit
    if (_unit getVariable ["KPLIB_powDelivered", false]) exitWith {[_handler] call CBA_fnc_removePerFrameHandler;};

    private _nearUnits = ((ASLToAGL (getPosASL _unit)) nearEntities ["CAManBase", 100]);
    private _isNearBlufor = (_nearUnits findIf {(side _x == KPLIB_side_player) && ( _unit distance _x < 100)}) >= 0;

    // No blufor units nearby exit
    if (!_isNearBlufor) exitWith {
        [_unit] call KPLIB_fnc_prisonnerEscape;
        [group _unit] call KPLIB_fnc_despawnGroup;
        [_handler] call CBA_fnc_removePerFrameHandler
    };
}, 10, _prisonner] call CBA_fnc_addPerFrameHandler;