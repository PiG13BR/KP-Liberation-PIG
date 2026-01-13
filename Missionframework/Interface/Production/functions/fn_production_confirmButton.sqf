/*
    File: fn_production_confirmButton.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 15/11/2025
    Last Update: 15/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handles the confirm button. Changes the production.

    Parameter(s):
        -

    Returns:
        -
*/

// Changes production
private _newProduction = localNameSpace getVariable ["KPLIB_production_new", 0];
private _sector = localNamespace getVariable ["KPLIB_production_SectorSelected", ""];

if (_sector isNotEqualTo "") then {
    ["KPLIB_changeFactoryProduction", [_sector, _newProduction, clientOwner]] call CBA_fnc_serverEvent;
};
