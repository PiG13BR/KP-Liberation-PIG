params ["_newUnit", "_oldUnit"];

if (isNil "KPLIB_respawn_loadout") then {
    removeAllWeapons _newUnit;
    removeAllItems _newUnit;
    removeAllAssignedItems _newUnit;
    removeVest _newUnit;
    removeBackpack _newUnit;
    removeHeadgear _newUnit;
    removeGoggles _newUnit;
    _newUnit linkItem "ItemMap";
    _newUnit linkItem "ItemCompass";
    _newUnit linkItem "ItemWatch";
    _newUnit unlinkItem "ItemRadio";
    //player unlinkItem "ItemGPS";
} else {
    sleep 4;
    [_newUnit, KPLIB_respawn_loadout] call KPLIB_fnc_setLoadout;
};

// Init
if (isNil "KPLIB_initServerDone") then {
    _newUnit enableSimulation false;
    while {isNil "KPLIB_initServerDone" || isNil "KPLIB_init"} do {
        sleep 0.1;
        "KPLIB_start" cutText ["<t size='3'>Loading Liberation...</t>", "BLACK FADED", 2, false, true]
    };

    "KPLIB_start" cutFadeOut 0.1;
    _newUnit enableSimulation true;
};

if !(_newUnit isUniformAllowed KPLIB_b_basic_uniform) then {
_newUnit forceAddUniform KPLIB_b_basic_uniform;
} else {
    _newUnit addUniform KPLIB_b_basic_uniform;
};

[] call KPLIB_fnc_addActionsPlayer;

// Support Module handling
if ([
    false,
    player isEqualTo ([] call KPLIB_fnc_getCommander) || (getPlayerUID player) in KPLIB_whitelist_supportModule,
    true
] select KPLIB_param_supportModule) then {
    waitUntil {!isNil "KPLIB_param_supportModule_req" && !isNil "KPLIB_param_supportModule_arty" && time > 5};

    // Remove link to corpse, if respawned
    if (!isNull _oldUnit) then {
        KPLIB_param_supportModule_req synchronizeObjectsRemove [_oldUnit];
        _oldUnit synchronizeObjectsRemove [KPLIB_param_supportModule_req];
    };

    // Link player to support modules
    [player, KPLIB_param_supportModule_req, KPLIB_param_supportModule_arty] call BIS_fnc_addSupportLink;

    // Init modules, if newly joined and not client host
    if (isNull _oldUnit && !isServer) then {
        [KPLIB_param_supportModule_req] call BIS_fnc_moduleSupportsInitRequester;
        [KPLIB_param_supportModule_arty] call BIS_fnc_moduleSupportsInitProvider;
    };
};

// Opens redeploy menu
[] call KPLIB_fnc_deploy_createMenuRsc;

sleep 5;

// Check if there's already a managed zeus module for this player, if so we can just reassign
private _uid = getPlayerUID _newUnit;
private _oldManagedZeus = missionNamespace getVariable [format["KPLIB_zeus_%1", _uid], objNull];
if (!isNull _oldManagedZeus) exitWith {
    [_newUnit, _oldManagedZeus] remoteExec ["assignCurator", 2];
};