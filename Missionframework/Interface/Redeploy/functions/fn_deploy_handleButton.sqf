#include "..\defines.hpp"
/*
    File: fn_deploy_handleButton.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 04/11/2025
    Last Update: 17/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Deploy button pressed. Move the players to the selected location and closes the display.

    Parameter(s):
        -

    Returns:
        -
*/

// Controls
private _display = findDisplay DEPLOY_IDD;
private _deployLbCtrl = _display displayCtrl DEPLOY_LISTBOX;
private _loadoutsComboCtrl = _display displayCtrl DEPLOY_LOADOUTS_COMBO;
private _player = localNamespace getVariable ["KPLIB_playerDeploying", player];
private _redeployOrigin = getPosATL _player;

private _lbCurSel = lbCurSel _deployLbCtrl;
private _spawn_str = (KPLIB_respawnPositionsList select _lbCurSel) select 0;
private _destPos = [0,0,0];

if (count (KPLIB_respawnPositionsList select _lbCurSel) == 3) then {
    // Rally Point or Mobile respawn
    private _respawnObject = (KPLIB_respawnPositionsList select _lbCurSel) select 2;
    _destPos = (getPosATL _respawnObject);

    if (KPLIB_b_mobileRespawns find (typeOf _respawnObject) >= 0) then {
        _player setposATL (_respawnObject getPos [5 + (random 3), random 360]);
        _player setDir (random 360);
        KPLIB_respawn_mobile_done = true;
    } else {
        // Rally Point
        _player setposATL (_respawnObject getPos [2 + (random 3), random 360]);
        _player setDir (random 360);
    };
} else {
    // Fob or base
    _destPos = ((KPLIB_respawnPositionsList select _lbCurSel) select 1);
    _player setposATL [((_destPos select 0) + 5) - (random 10),((_destPos select 1) + 5) - (random 10),(_destPos select 2)];
    _player setDir (random 360);
};

if (_destPos isEqualTo [0,0,0]) exitWith {};

// Respawn cost
if (KPLIB_param_respawnCost > 0 && {KPLIB_sectors_FOB isNotEqualTo []}) then {
    // Ignore cost if there are barracks in the FOB
    if ([_destPos] call KPLIB_fnc_deploy_barracksNearby) exitWith {}; 
    
    private _nearestFob = [_destPos] call KPLIB_fnc_getNearestFob;

    // Check for the nearest fob distance and compare destination and origin positions distance
    if (((_destPos distance2D _nearestFob) < KPLIB_distance_fob) && {(_redeployOrigin distance2D _destPos) > KPLIB_range_fob}) then {
        // Respawn cost
        private _supplies = KPLIB_param_respawnCost;
        private _ammo = KPLIB_param_respawnCost;
        private _fuel = KPLIB_param_respawnCost;

        ["KPLIB_subtractResources_Deploy", [[_supplies, _ammo, _fuel], _nearestFob]] call CBA_fnc_serverEvent;
    };
};

// Loadout
if ((lbCurSel _loadoutsComboCtrl) > 0) then {
    private _loadouts_data = localNamespace getVariable ["KPLIB_loadoustData", []];
    private _selectedLoadout = _loadouts_data select ((lbCurSel _loadoutsComboCtrl) - 1);
    if (KPLIB_ace && KPLIB_param_arsenalType) then {
        [_player, _selectedLoadout select 1, KPLIB_fill_mags] call CBA_fnc_setLoadout;
    } else {
        [_player, [profileNamespace, _selectedLoadout]] call BIS_fnc_loadInventory;
    };
};

_display closeDisplay 1;
[_spawn_str] spawn spawn_camera;