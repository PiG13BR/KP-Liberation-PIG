/*
    File: fn_logistic_init.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 07/08/2026
    Last Update: 26/09/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Start logistics framework at game start

    Parameter(s):
        -

    Returns:
        -
*/

KPLIB_convoy_ambush_inProgress = false;
KPLIB_convoy_ambush_check = 0;

{
    private _logiID = _x;
    _logiID call KPLIB_fnc_logistic_startManager;
}forEach KPLIB_logistics