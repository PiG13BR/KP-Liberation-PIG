#include "..\defines.hpp";
/*
    File: fn_deploy_handleLb.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 04/11/2025
    Last Update: 17/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handles deploy position's listbox

    Parameter(s):
        _args - Listbox passed arguments [ARRAY]

    Returns:
        -
*/
params ["_args"];
_args params ["_control", "_lbCurSel", "_lbSelection"];

private _display = findDisplay DEPLOY_IDD;
private _deployButtonCtrl = _display displayCtrl DEPLOY_BUTTON;
private _deployMapCtrl = _display displayCtrl DEPLOY_MAP;

private _objectpos = [0,0,0];
_objectpos = ((KPLIB_respawnPositionsList select _lbCurSel) select 1);

if (_objPos isEqualTo [0,0,0]) exitWith {};

respawn_object setPosATL ((KPLIB_respawnPositionsList select _lbCurSel) select 1);
private _startdist = 120;
private _enddist = 120;
private _alti = 35;

private _basenamestr = localize "STR_Deploy_BaseName";
if (((KPLIB_respawnPositionsList select _lbCurSel) select 0) == _basenamestr) then {
    _startdist = 200;
    _enddist = 300;
    _alti = 30;
};

// Loop to check for enemies nearby and update the list
if (!isNil "KPLIB_REDEPLOY_pfhandle") then {[KPLIB_REDEPLOY_pfhandle] call CBA_fnc_removePerFrameHandler;}; // Delete previous PFH
[_objectpos, _deployButtonCtrl] call KPLIB_fnc_deploy_PFH;

"spawn_marker" setMarkerPosLocal (getpos respawn_object);
ctrlMapAnimClear _deployMapCtrl;
private _transition_map_pos = getpos respawn_object;
private _fullscreen_map_offset = 4000;
if(fullmap % 2 == 1) then {
    _transition_map_pos = [(_transition_map_pos select 0) - _fullscreen_map_offset,  (_transition_map_pos select 1) + (_fullscreen_map_offset * 0.75), 0];
};
_deployMapCtrl ctrlMapAnimAdd [0, 0.3,_transition_map_pos];
ctrlMapAnimCommit _deployMapCtrl;

respawn_camera camSetPos [(getpos respawn_object select 0) - 70, (getpos respawn_object select 1) + _startdist, (getpos respawn_object select 2) + _alti];
respawn_camera camcommit 0;
respawn_camera camSetPos [(getpos respawn_object select 0) - 70, (getpos respawn_object select 1) - _enddist, (getpos respawn_object select 2) + _alti];
respawn_camera camcommit 90;

// Map ctrl related
_frame_pos = _display displayCtrl DEPLOY_RECYCLEBG;
_standard_map_pos = ctrlPosition _deployMapCtrl;

if (_old_fullmap != fullmap) then {
    _old_fullmap = fullmap;
    if (fullmap % 2 == 1) then {
        _deployMapCtrl ctrlSetPosition [ (_frame_pos select 0) + (_frame_pos select 2), (_frame_pos select 1), (0.6 * safezoneW), (_frame_pos select 3)];
    } else {
        _deployMapCtrl ctrlSetPosition _standard_map_pos;
    };
    _deployMapCtrl ctrlCommit 0.2;
};