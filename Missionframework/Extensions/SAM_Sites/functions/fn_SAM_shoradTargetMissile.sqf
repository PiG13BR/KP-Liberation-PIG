/*
    File: fn_SAM_shoradTargetMissile.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 10/12/2025
    Last Update: 22/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT
    
    Description:
        Target and try to intercept incoming missile
    
    Parameter(s):
        _shorad - unit to fire at the missile [OBJECT]
        _target - missile target [OBJECT]
        _missile - projectile [OBJECT]
    
    Returns:
        -
*/

params["_shorad", "_target", "_missile"];

// Chance to destroy the missile if a projectile fired by the AA passes by
#define CHANCE_TO_DESTROY 10
// Define the proximity of the projectile fired by the anti-air to count as a valid hit
#define PROJECTILE_PROXIMITY 13
// Minimum distance between the missile and its target to enable the shorad to fire at
#define FIRE_SHORAD_MIN_DISTANCE 3000

// Get fired missile distance 
private _firedDistance = (_shorad distance _missile);

_shorad setVariable ["KPLIB_isTargettingMissile", true];
_shorad disableAI "AUTOTARGET";
_shorad disableAI "TARGET";
_shorad disableAI "FSM";

/* 
    This WUAE is used to track down distance between projectile and the missile.
    If the projectile passes nearby, consider as a hit, delete the missile
*/
[{
    params["_missile", "_firedDistance"];

    // Get bullets passing nearby
    private _validHit = false;

    private _projectile = (_missile nearObjects ["BulletBase", PROJECTILE_PROXIMITY]) # 0;

    if (isNil "_projectile") then {continue};

    // Check parent for sanity check, you never know
    private _parent = (getShotParents _projectile) # 0;
    if (toLowerANSI(typeOf _parent) in KPLIB_o_allSAM_classes) then {_validHit = true};

    private _chance = CHANCE_TO_DESTROY;
    // Increase chance of missile interception if custom configuration is enabled, because players can still target radars with HARM, far away.
    if (KPLIB_param_SAMSite == 2 && {_firedDistance > PIG_SAMSite_Setting_maxRange}) then {_chance = _chance * 2}; 

    (_validHit && {random 100 < _chance})|| {!alive _missile}
}, {
    params["_missile"];
    
    if (isNull _missile) exitWith {};

    // Destroy missile by triggering it
    if (local _missile) then {
        triggerAmmo _missile;
    } else {
        [_missile] remoteExec ["triggerAmmo"];
    };
}, [_missile, _firedDistance]] call CBA_fnc_waitUntilAndExecute;

// Get shorad magazine ammo typical speed
private _weapon = (weapons _shorad) select {
    _x isKindOf ["CannonCore", configFile >> "CfgWeapons"]
};
_weapon = _weapon # 0;
private _magazines = getArray(configFile >> "cfgWeapons" >> _weapon >> "magazines");
_magazines = _magazines select {
    private _ammo = getText(configFile >> "cfgMagazines" >> _magazine >> "ammo");
    _ammo isKindOf ["BulletBase", configFile >> "cfgAmmo"]
};
private _ammo = (_magazines apply (getText(configFile >> "cfgMagazines" >> _magazine >> "ammo"))) # 0;
private _bulletSpeed = getNumber(configFile >> "CfgAmmo" >> _ammo >> "typicalSpeed");

// Track missile on each frame
[{
    params["_args", "_handle"];
    _args params ["_missile", "_shorad", "_bulletSpeed"];
    private _distance = _missile distance _shorad;
    if (_distance < 500 || !alive _missile) exitWith {[_handle] call CBA_fnc_removePerFrameHandler;};

    private _pos = getPosATL _missile;
    private _time = (_distance / _bulletSpeed) * 0.75; 

    _pos = _pos vectorAdd ( 
        (velocity _missile) vectorMultiply _time 
    ); 

    //drawIcon3D ["\a3\ui_f\data\IGUI\Cfg\Radar\radar_ca.paa", [0, 0, 1, 1], _pos, 5, 5, 0, "POS TO FIRE"];
	//drawIcon3D ["z\diwako_dui\addons\indicators\ui\indicators\diamond.paa", [1, 0, 0, 1], getPos _missile , 3, 3, 0, "MISSILE"];

    if (local _shorad) then {
        _shorad doWatch _pos;
    } else {
        [_shorad, _pos] remoteExec ["doWatch", _shorad];
    };

}, 0, [_missile, _shorad, _bulletSpeed]] call CBA_fnc_addPerFrameHandler;


// Wait to fire
[{
    params["_missile", "_target", "_shorad"];

    _missile distance2D _target < FIRE_SHORAD_MIN_DISTANCE || {!alive _missile} || {!alive _target}
}, {
    params["_missile", "_target", "_shorad"];

    // Try to fire at missile
    [_missile, _target, _shorad] spawn {
        params["_missile", "_target", "_shorad"];
        private _weaponToFire = (weapons _shorad) select {
            _x isKindOf ["CannonCore", configFile >> "CfgWeapons"]
        };
        _weaponToFire = _weaponToFire # 0;
        while {alive _missile} do {
            if (_missile distance _shorad < 500) exitWith {};
            sleep 0.03;
            _shorad fireAtTarget [_missile, _weaponToFire];
        };
        _shorad setVariable ["KPLIB_isTargettingMissile", false];
        _shorad enableAI "AUTOTARGET";
        _shorad enableAI "TARGET";
        _shorad enableAI "FSM";
    } 
}, [_missile, _target, _shorad]] call CBA_fnc_waitUntilAndExecute;