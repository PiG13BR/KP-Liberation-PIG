/*
    File: fn_addActionsPlayer.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2020-04-13
    Last Update: 2026-02-07
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Adds Liberation player actions to the given player.

    Parameter(s):
        _player - Player to add the actions to [OBJECT, defaults to player]

    Returns:
        Function reached the end [BOOL]
*/

params [
    ["_player", player, [objNull]]
];

if !(isPlayer _player) exitWith {["No player given"] call BIS_fnc_error; false};

if (isNil "KPLIB_resources_global") then {KPLIB_resources_global = false;};

// Tutorial
_player addAction [
    ["<t color='#80FF80'>", localize "STR_TUTO_ACTION", "</t>"] joinString "",
    {howtoplay = 1;},
    nil,
    -700,
    false,
    true,
    "",
    "
        alive _originalTarget
        && {_originalTarget getVariable ['KPLIB_isNearStart', false]}
    "
];

// HALO
_player addAction [
    ["<t color='#80FF80'>", localize "STR_HALO_ACTION", "</t><img size='2' image='Images\ui_redeploy.paa'/>"] joinString "",
    "Scripts\Client\spawn\do_halo.sqf",
    nil,
    -710,
    false,
    true,
    "",
    "
        KPLIB_param_halo > 0
        && {isNull (objectParent _originalTarget)}
        && {alive _originalTarget}
        && {
            _originalTarget getVariable ['KPLIB_fobDist', 99999] < 20
            || {_originalTarget getVariable ['KPLIB_isNearStart', false]}
        }
        && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])}
    "
];

// Redeploy
_player addAction [
    ["<t color='#80FF80'>", localize "STR_DEPLOY_ACTION", "</t><img size='2' image='Images\ui_redeploy.paa'/>"] joinString "",
    {[] call KPLIB_fnc_deploy_createMenuRsc},
    nil,
    -720,
    false,
    true,
    "",
    toString {
        isNull (objectParent _originalTarget)
        && {alive _originalTarget}
        && {
            _originalTarget getVariable ['KPLIB_fobDist', 99999] < 20
            || {_originalTarget getVariable ['KPLIB_isNearMobRespawn', false]}
            || {_originalTarget getVariable ['KPLIB_isNearStart', false]}
        }
        && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])} &&
        {isNull (_this getVariable ["KPLIB_carriedObject", objNull])}
    }
];

// Squad management
_player addAction [
    ["<t color='#80FF80'>", localize "STR_SQUAD_MANAGEMENT_ACTION", "</t><img size='2' image='\a3\Ui_F_Curator\Data\Displays\RscDisplayCurator\modeGroups_ca.paa'/>"] joinString "",
    "Scripts\Client\ui\squad_management.sqf",
    nil,
    -730,
    false,
    true,
    "",
    "
        isNull (objectParent _originalTarget)
        && {alive _originalTarget}
        && {!((units group _originalTarget) isEqualTo [_originalTarget])}
        && {(leader group _originalTarget) isEqualTo _originalTarget}
        && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])}
    "
];

// Arsenal
_player addAction [
    ["<t color='#FFFF00'>", localize "STR_ARSENAL_ACTION", "</t><img size='2' image='Images\ui_arsenal.paa'/>"] joinString "",
    "Scripts\Client\actions\open_arsenal.sqf",
    nil,
    -740,
    false,
    true,
    "",
    toString {
        isNull (objectParent _originalTarget)
        && {alive _originalTarget}
        && {
            _originalTarget getVariable ['KPLIB_b_supplyDump', false]
            || {_originalTarget getVariable ['KPLIB_isNearArsenal', false]}
            || {_originalTarget getVariable ['KPLIB_isNearMobRespawn', false]}
            || {_originalTarget getVariable ['KPLIB_isNearStart', false]}
            || {_originalTarget getVariable ['KPLIB_isNearDump', false]}
        }
        && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])} &&
        {isNull (_this getVariable ["KPLIB_carriedObject", objNull])}
    }
];

// Build
_player addAction [
    ["<t color='#FFFF00'>", localize "STR_BUILD_ACTION", "</t><img size='2' image='Images\ui_build.paa'/>"] joinString "",
    {[] call KPLIB_fnc_build_createMenuRsc},
    nil,
    -750,
    false,
    true,
    "",
    toString {
        isNull (objectParent _originalTarget)
        && {alive _originalTarget}
        && {_originalTarget getVariable ['KPLIB_fobDist', 99999] < (KPLIB_range_fob * 0.8)}
        && {
            _originalTarget getVariable ['KPLIB_hasDirectAccess', false]
            || {[3] call KPLIB_fnc_hasPermission}
        }
        && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])} &&
        {isNull (_this getVariable ["KPLIB_carriedObject", objNull])}
    }
];

// Secondary missions
_player addAction [
    ["<t color='#FFFF00'>", localize "STR_SECONDARY_OBJECTIVES", "</t>"] joinString "",
    "Scripts\Client\ui\secondary_ui.sqf",
    nil,
    -760,
    false,
    true,
    "",
    "
        isNull (objectParent _originalTarget)
        && {alive _originalTarget}
        && {
            _originalTarget getVariable ['KPLIB_fobDist', 99999] < 20
            || {_originalTarget getVariable ['KPLIB_isNearStart', false]}
        }
        && {
            _originalTarget getVariable ['KPLIB_hasDirectAccess', false]
            || {[5] call KPLIB_fnc_hasPermission}
        }
        && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])}
    "
];

// Build sector storage
_player addAction [
    ["<t color='#FFFF00'>", localize "STR_SECSTORAGEBUILD_ACTION", "</t>"] joinString "",
    {call KPLIB_fnc_doSectorBuild},
    [],
    -770,
    false,
    true,
    "",
    toString{
        !(_originalTarget getVariable ['KPLIB_nearProd', []] isEqualTo [])
        && {isNull (objectParent _originalTarget)}
        && {alive _originalTarget}
        && {
            _originalTarget getVariable ['KPLIB_hasDirectAccess', false]
            || {[3] call KPLIB_fnc_hasPermission}
        }
        && {((_originalTarget getVariable ['KPLIB_nearProd', []]) # 2) isEqualTo []}
        && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])}
        && {!(([KPLIB_range_sectorCapture, getPosATL _originalTarget] call KPLIB_fnc_getNearestSector) in KPLIB_blockedFactories)}
        && {isNull (_this getVariable ["KPLIB_carriedObject", objNull])}
    }
];

// Build supply facility
_player addAction [
    ["<t color='#FFFF00'>", localize "STR_SECSUPPLYBUILD_ACTION", "</t>"] joinString "",
        {
        params["_player"];

        private _sector = [100, getPos _player] call KPLIB_fnc_getNearestSector;
        if (_sector in KPLIB_production) then {
            ["KPLIB_factoryBuildFacility", [_sector, "SUPPLY", clientOwner]] call CBA_fnc_serverEvent
        };
    },
    [],
    -780,
    false,
    true,
    "",
    toString {
        !(_originalTarget getVariable ['KPLIB_nearProd', []] isEqualTo [])
        && {isNull (objectParent _originalTarget)}
        && {alive _originalTarget}
        && {
            _originalTarget getVariable ['KPLIB_hasDirectAccess', false]
            || {[3] call KPLIB_fnc_hasPermission}
        }
        && {!(((_originalTarget getVariable ['KPLIB_nearProd', []]) # 2) isEqualTo [])}
        && {!((_originalTarget getVariable ['KPLIB_nearProd', []]) # 3)}
        && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])}
    }
];

// Build ammo facility
_player addAction [
    ["<t color='#FFFF00'>", localize "STR_SECAMMOBUILD_ACTION", "</t>"] joinString "",
    {
        params["_player"];

        private _sector = [100, getPos _player] call KPLIB_fnc_getNearestSector;
        if (_sector in KPLIB_production) then {
            ["KPLIB_factoryBuildFacility", [_sector, "AMMO", clientOwner]] call CBA_fnc_serverEvent
        };
    },
    [],
    -790,
    false,
    true,
    "",
    toString {
        !(_originalTarget getVariable ['KPLIB_nearProd', []] isEqualTo [])
        && {isNull (objectParent _originalTarget)}
        && {alive _originalTarget}
        && {
            _originalTarget getVariable ['KPLIB_hasDirectAccess', false]
            || {[3] call KPLIB_fnc_hasPermission}
        }
        && {!(((_originalTarget getVariable ['KPLIB_nearProd', []]) # 2) isEqualTo [])}
        && {!((_originalTarget getVariable ['KPLIB_nearProd', []]) # 4)}
        && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])}
    }
];

// Build fuel facility
_player addAction [
    ["<t color='#FFFF00'>", localize "STR_SECFUELBUILD_ACTION", "</t>"] joinString "",
    {
        params["_player"];

        private _sector = [100, getPos _player] call KPLIB_fnc_getNearestSector;
        if (_sector in KPLIB_production) then {
            ["KPLIB_factoryBuildFacility", [_sector, "FUEL", clientOwner]] call CBA_fnc_serverEvent
        };
    },
    [],
    -800,
    false,
    true,
    "",
    ToString {
        !(_originalTarget getVariable ['KPLIB_nearProd', []] isEqualTo [])
        && {isNull (objectParent _originalTarget)}
        && {alive _originalTarget}
        && {
            _originalTarget getVariable ['KPLIB_hasDirectAccess', false]
            || {[3] call KPLIB_fnc_hasPermission}
        }
        && {!(((_originalTarget getVariable ['KPLIB_nearProd', []]) # 2) isEqualTo [])}
        && {!((_originalTarget getVariable ['KPLIB_nearProd', []]) # 5)}
        && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])}
    }
];

// Switch global/local resources
_player addAction [
    ["<t color='#FFFF00'>", localize "STR_RESOURCE_GLOBAL_ACTION", "</t>"] joinString "",
    {KPLIB_resources_global = !KPLIB_resources_global},
    nil,
    -810,
    false,
    true,
    "",
    "
        alive _originalTarget
        && {_originalTarget getVariable ['KPLIB_fobDist', 99999] < (KPLIB_range_fob * 0.8)}
        && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])}
    "
];

// Production
_player addAction [
    ["<t color='#FF8000'>", localize "STR_PRODUCTION_ACTION", "</t>"] joinString "",
    {[] call KPLIB_fnc_production_createMenuRsc},
    nil,
    -820,
    false,
    true,
    "",
    toString {
        _originalTarget getVariable ['KPLIB_hasDirectAccess', false]
        && {isNull (objectParent _originalTarget)}
        && {alive _originalTarget}
        && {!(count KPLIB_production < 1)}
        && {
            _originalTarget getVariable ['KPLIB_fobDist', 99999] < (KPLIB_range_fob * 0.8)
            || {!(_originalTarget getVariable ['KPLIB_nearProd', []] isEqualTo [])}
        }
        && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])}
    }
];

if (KPLIB_param_logistic) then {
    // Logistic
    _player addAction [
        ["<t color='#FF8000'>", localize "STR_LOGISTIC_ACTION", "</t>"] joinString "",
        "Scripts\Client\commander\open_logistic.sqf",
        nil,
        -830,
        false,
        true,
        "",
        toString {
            _originalTarget getVariable ['KPLIB_hasDirectAccess', false]
            && {isNull (objectParent _originalTarget)}
            && {alive _originalTarget}
            && {_originalTarget getVariable ['KPLIB_fobDist', 99999] < (KPLIB_range_fob * 0.8)}
            && {!(
                KPLIB_sectors_fob isEqualTo []
                || (count KPLIB_production < 1)
            )}
            && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])}
        }
    ];
};

// Permissions
_player addAction [
    ["<t color='#FF8000'>", localize "STR_COMMANDER_ACTION", "</t><img size='2' image='\a3\Ui_F_Curator\Data\Displays\RscDisplayCurator\modeGroups_ca.paa'/>"] joinString "",
    "Scripts\Client\commander\open_permissions.sqf",
    nil,
    -840,
    false,
    true,
    "",
    "
        KPLIB_param_permissions
        && {_originalTarget getVariable ['KPLIB_hasDirectAccess', false]}
        && {alive _originalTarget}
        && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])}
    "
];

// Create small FOB clearance
_player addAction [
    ["<t color='#FFFF00'>", localize "STR_CLEARANCE_ACTION", "</t>"] joinString "",
    {[player getVariable ["KPLIB_fobPos", [0, 0, 0]], KPLIB_range_fob * 0.4, true] call KPLIB_fnc_createClearanceConfirm;},
    nil,
    -850,
    false,
    true,
    "",
    "
        _originalTarget getVariable ['KPLIB_hasDirectAccess', false]
        && {isNull (objectParent _originalTarget)}
        && {alive _originalTarget}
        && {_originalTarget getVariable ['KPLIB_fobDist', 99999] < (KPLIB_range_fob * 0.4)}
        && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])}
    "
];

// Create big FOB clearance
_player addAction [
    ["<t color='#FFFF00'>", localize "STR_BIG_CLEARANCE_ACTION", "</t>"] joinString "",
    {[player getVariable ["KPLIB_fobPos", [0, 0, 0]], KPLIB_range_fob * 0.8, true] call KPLIB_fnc_createClearanceConfirm;},
    nil,
    -851,
    false,
    true,
    "",
    "
        _originalTarget getVariable ['KPLIB_hasDirectAccess', false]
        && {isNull (objectParent _originalTarget)}
        && {alive _originalTarget}
        && {_originalTarget getVariable ['KPLIB_fobDist', 99999] < (KPLIB_range_fob * 0.8)}
        && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])}
    "
];

// Time Skip and Clear Fog
_player addAction [
    ["<t color='#0080FF'>", localize "STR_FOB_TW_ACTION_OPEN", "</t>"] joinString "",
    "Scripts\Client\actions\control_TimeWeather.sqf",
    nil,
    -855,
    false,
    true,
    "",
    "
        KPLIB_param_timeweather
        && _originalTarget getVariable ['KPLIB_hasDirectAccess', false]
        && {isNull (objectParent _originalTarget)}
        && {alive _originalTarget}
        && {_originalTarget getVariable ['KPLIB_fobDist', 99999] < (KPLIB_range_fob * 0.8)}
        && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])}
    "
];

// Full Heal
_player addAction [
    ["<t color='#80FF80'>", localize "STR_FULLHEAL_ACTION", "</t> <img size='2' image='Images\ui_fullheal.paa'/>"] joinString "",
    {[player getVariable ["KPLIB_fobPos", [0, 0, 0]], KPLIB_range_fob * 0.9, player] call KPLIB_fnc_fullheal;},
    nil,
    -690,
    false,
    true,
    "",
    "
        KPLIB_param_fullHeal
        && KPLIB_medical_facilities_near
        && {isNull (objectParent _originalTarget)}
        && {alive _originalTarget}
        && {_originalTarget getVariable ['KPLIB_fobDist', 99999] < (KPLIB_range_fob * 0.5)}
        && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])}
    "
];

// Clear gargabe
if (player == ([] call KPLIB_fnc_getCommander)) then {
_player addAction [
    ["<t color='#FF0000'>", localize "STR_CLEARGARBAGE_ACTION", "</t><img size='2' image='a3\3den\data\displays\display3den\panelleft\entitylist_delete_ca.paa'/>"] joinString "",
    {[] spawn KPLIB_fnc_clearGarbage;},
    nil,
    -860,
    false,
    true,
    "",
    "
        isNull (objectParent _originalTarget)
        && {alive _originalTarget}
        && {
            _originalTarget getVariable ['KPLIB_fobDist', 99999] < 20
            || {_originalTarget getVariable ['KPLIB_isNearStart', false]}
        }
        && {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])}
    "
    ];
};

true
