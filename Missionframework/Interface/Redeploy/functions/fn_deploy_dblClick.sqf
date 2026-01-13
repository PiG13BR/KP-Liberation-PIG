#include "..\defines.hpp";
/*
    File: fn_deploy_createMenuRsc.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 04/11/2025
    Last Update: 17/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Create liberation deploy Rsc

    Parameter(s):
        -

    Returns:
        -
*/
params ["_control"];

private _display = findDisplay DEPLOY_IDD;
private _deployButtonCtrl = _display displayCtrl DEPLOY_BUTTON;

if (ctrlEnabled _deployButtonCtrl) then {
    [] call KPLIB_fnc_deploy_handleButton;
};