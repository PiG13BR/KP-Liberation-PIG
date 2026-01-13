/*
    File: fn_build_updateAirSlots.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 10/11/2025
    Last Update: 12/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Update air slots text

    Parameter(s):
        _labelCapTextCtrl - text control where air slots are shown [CONTROL]

    Returns:
        -
*/
params["_labelCapTextCtrl"];

_labelCapTextCtrl ctrlSetStructuredText formatText [
    "%1/%2 %3 - %4/%5 %6 - %7/%8 %9",
    unitcap,
    ([] call KPLIB_fnc_getLocalCap),
    image "\a3\Ui_F_Curator\Data\Displays\RscDisplayCurator\modeGroups_ca.paa",
    KPLIB_heli_count,
    KPLIB_heli_slots,
    image "\A3\air_f_beta\Heli_Transport_01\Data\UI\Map_Heli_Transport_01_base_CA.paa",
    KPLIB_plane_count,
    KPLIB_plane_slots,
    image "\A3\Air_F_EPC\Plane_CAS_01\Data\UI\Map_Plane_CAS_01_CA.paa"
];