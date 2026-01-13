/*
    File: fn_build_updateResourcesCtrl.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 10/11/2025
    Last Update: 12/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Update controls where the available resources are visible

    Parameter(s):
        _suppliesTextCtrl - supplies text control [CONTROL]
        _ammoTextCtrl - ammo text control [CONTROL]
        _fuelTextCtrl - fuel text control [CONTROL]

    Returns:
        -
*/
params["_suppliesTextCtrl", "_ammoTextCtrl", "_fuelTextCtrl"];

_suppliesTextCtrl ctrlSetText format ["%1 : %2", localize "STR_MANPOWER", (floor KPLIB_supplies)];
_ammoTextCtrl ctrlSetText format ["%1 : %2", localize "STR_AMMO", (floor KPLIB_ammo)];
_fuelTextCtrl ctrlSetText format ["%1 : %2", localize "STR_FUEL", (floor KPLIB_fuel)];
