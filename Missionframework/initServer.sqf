waitUntil {!isNil "KPLIB_postInit"};

KPLIB_respawn_marker = "respawn";
publicVariable "KPLIB_respawn_marker";

if (isDedicated) then {KPLIB_debugSource = "Server";} else {KPLIB_debugSource = name player;};

setViewDistance 1600;

// Execute fnc_reviveInit again (by default it executes in postInit)
if ((isNil {player getVariable "bis_revive_ehHandleHeal"} || isDedicated) && !(bis_reviveParam_mode == 0)) then {
    [] call bis_fnc_reviveInit;
};

if !(KPLIB_param_playerMenu) then {
    // Dynamic groups
    ["Initialize"] call BIS_fnc_dynamicGroups;	
};

// OAB Start
if (OAB_isOPFORFriendly) then {
    addMissionEventHandler ["EntityKilled", {
        params ["_unit", "_killer", "_instigator", "_useEffects"];

        if ((side (group _killer) == KPLIB_side_player) && (side (group _unit) == KPLIB_side_enemy)) then {
            KPLIB_side_player setFriend [KPLIB_side_enemy, 0];
            KPLIB_side_enemy setFriend [KPLIB_side_player, 0];
            OAB_isOPFORFriendly = false;
            publicVariable "OAB_isOPFORFriendly";
            [] call KPLIB_fnc_doSave;
            removeMissionEventHandler [_thisEvent, _thisEventHandler];
        }
    }];
};

KPLIB_initServerDone = true;
publicVariable "KPLIB_initServerDone";

// OAB
addMissionEventHandler ["EntityCreated", {
	params ["_entity"];
    
    if !(_entity isKindOf "CAManBase") exitWith {};

    if (side (group _entity) == KPLIB_side_enemy) then {
        _entity addItem "NVGoggles";
        _entity assignItem "NVGoggles";
    };
    
    if ((typeOf _entity == KPLIB_o_squadLeader) || (typeOf _entity == KPLIB_o_officer) || (typeOf _entity == KPLIB_o_rifleman) || (typeOf _entity == KPLIB_o_grenadier) || (typeOf _entity == KPLIB_o_paratrooper)) then {
        {_entity removePrimaryWeaponItem _x}forEach (primaryWeaponItems _entity);
        {_entity addPrimaryWeaponItem _x} forEach ["CUP_optic_HensoldtZO_RDS", "CUP_acc_LLM_od"];
    };
}];

removeAllMissionEventHandlers "GroupCreated";
addMissionEventHandler ["GroupCreated", {
	params ["_group"];

    if (side _group != KPLIB_side_enemy) exitWith {};

    _group addEventHandler ["CombatModeChanged", {
        params ["_group", "_newMode"];

        if (_newMode == "COMBAT") then {
            _group enableIRLasers true
        } else {
            _group enableIRLasers false
        };
    }];
}];

// OAB
while {KPLIB_endgame == 0} do {
    sleep 1;
    [
        // ["task",value]
        ["UpdateDetails","KP Liberation 0.97.0pig"],
        ["UpdateState",""],
        ["UpdateLargeImageKey","oab_-_v0_2"],
        ["UpdateSmallImageKey",""],
        ["UpdatePartySize",count playableUnits],
        ["UpdatePartyMax",getNumber(missionConfigFile >> "Header" >> "maxPlayers")]
    ] call (missionNameSpace getVariable ["DiscordRichPresence_fnc_update",{}]);
};