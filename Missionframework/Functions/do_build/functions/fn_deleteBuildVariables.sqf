/*
    File: fn_deleteBuildVariables.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 11/11/2025
    Last update: 12/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Delete variables once building is finished or cancelled

    Parameter(s)
        _player - player object that cancelled or finished building [OBJECT, defaults to player]

    Returns:
        -
*/
params[["_player", player, [objNull]]];

_player setVariable ["KPLIB_BUILD_preplacedObject", nil];
localNamespace setVariable ["KPLIB_BUILD_vector", nil];
localNamespace setVariable ["KPLIB_BUILD_player", nil];
localNamespace setVariable ["KPLIB_BUILD_itemToBuild", nil];
localNamespace setVariable ["KPLIB_BUILD_buildType", nil];
localNamespace setVariable ["KPLIB_BUILD_requireCrew", nil];