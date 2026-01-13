#include "..\defines.hpp"
/*
    File: fn_deploy_getArsenalLoadout.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 04/11/2025
    Last Update: 17/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Get arsenal loadouts

    Parameter(s):
        -

    Returns:
        Arsenal Loadouts [ARRAY]
*/

// Get loadouts either from ACE or BI arsenals
private _loadouts_data = [];
if (KPLIB_ace && KPLIB_param_arsenalType) then {
    _loadouts_data = +(profileNamespace getVariable ["ace_arsenal_saved_loadouts", []]);
} else {
    private _saved_loadouts = +(profileNamespace getVariable "bis_fnc_saveInventory_data");
    _loadouts_data = [];
    private _counter = 0;
    if (!isNil "_saved_loadouts") then {
        {
            if (_counter % 2 == 0) then {
                _loadouts_data pushback _x;
            };
            _counter = _counter + 1;
        } forEach _saved_loadouts;
    };
};

_loadouts_data