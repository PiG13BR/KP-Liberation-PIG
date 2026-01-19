params ["_newUnit", "_oldUnit"];

waitUntil {!isNil "KPLIB_init" && !isNil "KPLIB_initServerDone"};

if !(_newUnit isUniformAllowed KPLIB_b_basic_uniform) then {
_newUnit forceAddUniform KPLIB_b_basic_uniform;
} else {
    _newUnit addUniform KPLIB_b_basic_uniform;
};

/*
if ((uniform _oldUnit) isEqualTo "" ) then {
    if !(_newUnit isUniformAllowed KPLIB_b_basic_uniform) then {
    _newUnit forceAddUniform KPLIB_b_basic_uniform;
    } else {
        _newUnit addUniform KPLIB_b_basic_uniform;
    };
} else {
    removeUniform _newUnit;
    if !(_newUnit isUniformAllowed (uniform _oldUnit)) then {
    _newUnit forceAddUniform (uniform _oldUnit);
    } else {
        _newUnit addUniform (uniform _oldUnit);
    };
};
*/

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