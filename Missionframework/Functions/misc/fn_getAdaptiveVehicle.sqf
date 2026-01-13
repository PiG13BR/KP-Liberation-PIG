/*
    File: fn_getAdaptiveVehicle.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2019-11-25
    Last Update: 2025-12-01
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Provides a vehicle classname depending on the combat readiness.

    Parameter(s):
        NONE

    Returns:
        Vehicle classname [STRING]
*/

private _adaptativeVeh = selectRandom ([KPLIB_o_armyVehicles, KPLIB_o_armyVehiclesLight] select (KPLIB_enemyReadiness < 40));

private _selected = false;
private _randomchance = 0;

if (armor_weight > 40 && !_selected) then {
    private _randomchance = (armor_weight - 50) * 1.4;
    if ((random 100) < _randomchance) then {
        _selected = true;
        _adaptativeVeh = selectRandom KPLIB_o_tankVehicles;
    };
};

if (air_weight > 40 && !_selected) then {
    private _randomchance = (air_weight - 40) * 1.4;
    if ((random 100) < _randomchance) then {
        _selected = true;
        _adaptativeVeh = selectRandom KPLIB_o_antiAirVehicles;
    };
};

_adaptativeVeh