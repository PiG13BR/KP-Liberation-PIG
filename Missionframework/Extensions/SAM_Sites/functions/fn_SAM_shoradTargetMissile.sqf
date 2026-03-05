/*
    File: fn_SAM_shoradTargetMissile.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 10/12/2025
    Last Update: 05/03/2026
    License: MIT License - http://www.opensource.org/licenses/MIT
    
    Description:
        Target and try to intercept HARM missile
    
    Parameter(s):
        _shorad - unit to fire at the missile [OBJECT]
        _target - missile target [OBJECT]
        _missile - projectile [OBJECT]
    
    Returns:
        -
*/

params["_shorad", "_target", "_missile"];

// Get fired missile distance 
private _firedDistance = (_shorad distance _missile);

_shorad setVariable ["KPLIB_isTargettingMissile", true];
_shorad disableAI "AUTOTARGET";
_shorad disableAI "TARGET";
_shorad disableAI "FSM";
//_shorad setVariable ["KPLIB_missileFired", _missile];

/* 
    This WUAE is used to track down distance between projectile and the missile.
    If the projectile passes nearby, consider as a hit, delete the missile
*/
[{
    params["_missile", "_firedDistance"];

    // Get bullets passing nearby
    private _validHit = false;

    private _projectile = (_missile nearObjects ["BulletBase", 10]) # 0;
    if (isNil "_projectile") then {continue};

    // Check parent for sanity check, you never know
    private _parent = (getShotParents _projectile) # 0;
    if (toLowerANSI(typeOf _parent) in KPLIB_o_allSAM_classes) then {_validHit = true};

    private _chance = 5;
    // Increase chance of missile interception if custom configuration is enabled, because players can still target radars with HARM, far away.
    if (KPLIB_param_SAMSite == 2 && {_firedDistance > PIG_SAMSite_Setting_maxRange}) then {_chance = _chance * 2}; 

    (_validHit && {random 100 < _chance})|| {!alive _missile}
}, {
    params["_missile"];
    
    if (isNull _missile) exitWith {};

    // Destroy missile by triggering it
    triggerAmmo _missile;
    
}, [_missile, _firedDistance]] call CBA_fnc_waitUntilAndExecute;

// Track missile on each frame
addMissionEventHandler ["EachFrame", {
    _thisArgs params ["_missile", "_shorad"];
    if (_missile distance _shorad < 500) exitWith {removeMissionEventHandler [_thisEvent, _thisEventHandler]};
    
    _shorad doWatch ((getPosATL _missile) vectorAdd _newVector);
}, [_missile, _shorad]];

// Wait to fire
[{
    params["_missile", "_target", "_shorad"];

    _missile distance2D _target < 2000 || {!alive _missile} || {!alive _target}
}, {
    params["_missile", "_target", "_shorad"];

    // Try to fire at missile
    [_missile, _target, _shorad] spawn {
        params["_missile", "_target", "_shorad"];
        while {alive _missile} do {
            if (_missile distance _shorad < 500) exitWith {};
            sleep 0.03;
            _shorad fireAtTarget [_missile, weapons _shorad # 0];
        };
        _shorad setVariable ["KPLIB_isTargettingMissile", false];
        _shorad enableAI "AUTOTARGET";
        _shorad enableAI "TARGET";
        _shorad enableAI "FSM";
    } 
}, [_missile, _target, _shorad]] call CBA_fnc_waitUntilAndExecute;