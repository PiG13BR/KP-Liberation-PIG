#include "..\defines.hpp"
/*
    File: fn_deploy_getPositions.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 04/11/2025
    Last Update: 17/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Get all posible deploy positions available and fill the listbox. Updates KPLIB_respawnPositionsList variable.

    Parameter(s):
        _display - redeploy menu display [DISPLAY, defaults to (findDisplay DEPLOY_IDD)]

    Returns:
        -
*/

params[["_display", (findDisplay DEPLOY_IDD)]];

private _deployLbCtrl = _display displayCtrl DEPLOY_LISTBOX;

KPLIB_respawnPositionsList = []; // Clear variable

// Get Operation Base
private _basenamestr = localize "STR_Deploy_BaseName";
KPLIB_respawnPositionsList = [[_basenamestr, getposATL startbase]];

// Get FOBs
{
    KPLIB_respawnPositionsList pushBack [
        format ["FOB %1 - %2", (KPLIB_militaryAlphabet select _forEachIndex), mapGridPosition _x],
        _x
    ];
} forEach KPLIB_sectors_fob;

// Get mobile respawns
if (KPLIB_param_mobileRespawn) then {
    if (KPLIB_respawn_time <= time) then {
        private _respawn_trucks = [] call KPLIB_fnc_getMobileRespawns;

        {
            KPLIB_respawnPositionsList pushBack [
                format ["%1 - %2", localize "STR_RESPAWN_TRUCK",  [_x] call KPLIB_fnc_getMobileRespawnName],
                getPosATL _x,
                _x
            ];
        } forEach _respawn_trucks
    };
};

// Get rally points
private _player = localNamespace getVariable ["KPLIB_playerDeploying", player];

// Squad/group
private _sqRespawn_RP = [group _player] call KPLIB_fnc_getSquadRP;
if !(isNull _sqRespawn_RP) then {
    KPLIB_respawnPositionsList pushBack [
        format["Squad RP - %1", mapGridPosition (getPosATL _sqRespawn_RP)],
        getPosATL _sqRespawn_RP,
        _sqRespawn_RP
    ]
};

// Team/commander rally point
private _teamRespawn_RP = [group _player] call KPLIB_fnc_getTeamRP;
if !(isNull _teamRespawn_RP) then {
    KPLIB_respawnPositionsList pushBack [
        format["Team RP - %1", mapGridPosition (getPosATL _teamRespawn_RP)],
        getPosATL _teamRespawn_RP,
        _teamRespawn_RP
    ]
};

// Add to the listbox
lbClear _deployLbCtrl;
{
    _deployLbCtrl lbAdd (_x select 0);
} foreach KPLIB_respawnPositionsList;

if (lbCurSel _deployLbCtrl == -1) then {
    _deployLbCtrl lbSetCurSel 0;
};


