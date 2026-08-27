/*
    File: fn_addPlayerEH.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 13/11/2025
    Last Update: 26/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Add player event handlers

    Parameter(s):
        _player - player to add EH [OBJECT, defaults to player]

    Returns:
        -
*/

params[["_player", player, [objNull]]];

if (isDedicated) exitWith {};

// Remove/unassign item if not present in the player's allowed arsenal
_player addEventHandler ["SlotItemChanged", {
	params ["_unit", "_name", "_slot", "_assigned", "_weapon"];

    // Ace DBAL compat
    if ((toLowerANSI _name) find "ace_dbal_a3" >= 0) then {_name = "ace_dbal_a3"};

    // Immersion cigs
    if (isClass (configFile >> "CfgPatches" >> "cigs_main")) then {
        if ((toLowerANSI _name) find "cigs" >= 0) then {_name = "cigs"};
    };

    if (_assigned && {((KPLIB_arsenalAllowed findIf {_x find (toLowerANSI _name) >= 0}) < 0) && {(_name find "TFAR") < 0}}) then { 
        if (_weapon isNotEqualTo "") then {
            // Some weapon acc 
            _unit removePrimaryWeaponItem _name; // Just remove it
            private _canLoad = [_unit, _name] call CBA_fnc_canAddItem;
            if !(_canLoad) then {
                [_unit, _name, false] call CBA_fnc_addItem; // Add it back
            };
        } else {
            // Item
            _unit unassignItem _name;
        };

        [format [localize "STR_INVENTORY_CANNOT_USE_ITEM", getText(configFile >> "cfgWeapons" >> _name >> "displayName")], true, 3] call KPLIB_fnc_hint
    };
}];

// Block players from entering heavy enemy veh
_player addEventHandler ["GetInMan", {
    params ["_unit", "_role", "_vehicle", "_turret"];

    private _type = typeOf _vehicle;
    if ((toLowerANSI _type) in KPLIB_o_allVeh_classes && {(_type isKindOf "Tank") || {_type isKindOf "Wheeled_Apc_F"} || {_type isKindOf "Air"}}) then {
        moveOut _unit;
        [localize "STR_VEHICLE_CANNOT_ENTER", true, 3] call KPLIB_fnc_hint;
    };
}];

/*
    KP Liberation EH (from init_client.sqf)
*/
_player addMPEventHandler ["MPKilled", {
    params ["_unit", "_killer"];
    ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
}];
if (KPLIB_param_fuelconsumption) then {
    _player addEventHandler ["GetInMan", {[_this select 2] spawn kp_fuel_consumption;}];
};
_player addEventHandler ["GetInMan", {[_this select 2, _this select 0] call KPLIB_fnc_setVehicleSeized;}];
_player addEventHandler ["GetInMan", {[_this select 2] call KPLIB_fnc_setVehicleCaptured;}];

// Permission
_player addEventHandler ["GetInMan", {[_this # 0, _this # 2] call KPLIB_fnc_vehPermissions;}];
_player addEventHandler ["SeatSwitchedMan", {[_this # 0, _this # 2] call KPLIB_fnc_vehPermissions;}];

// Generate log from players entering valuable vehicles
_player addEventHandler ["GetInMan", {
    params ["_unit", "_role", "_vehicle"];

    if (_role == "cargo") exitWith {};
    
    if (toLowerANSI (typeOf _vehicle) in KPLIB_b_heavy_classes || toLowerANSI (typeOf _vehicle) in KPLIB_b_air_classes) then {
        ["KPLIB_generateLog", 
            [
                format ["Player %1 entered vehicle class %3 in %2 role", name _unit, _role, typeOf _vehicle],
                "VEHICLE LOG"
            ]
        ] call CBA_fnc_serverEvent;
    };
}];

_player addEventHandler ["GetInMan", {
    params ["_player"];
    // prevent players from getting into vehicles while carrying
    if (isNull (_player getVariable ["KPLIB_carriedObject", objNull])) exitWith {};
    moveOut _player;
}];
_player addEventHandler ["HandleRating", {if ((_this select 1) < 0) then {0};}];

// Drop any crates if killed 
_player addEventHandler ["Killed", {
    params["_player"];

    private _crate = _player getVariable ["KPLIB_carriedObject", objNull];

    if (!isNull _crate) then {
        _crate setVariable ["KPLIB_beignCarried", false, true];
        ["KPLIB_crateCollisionChange", [_crate, true]] call CBA_fnc_globalEventJIP;
        detach _crate;
        _crate awake true;
        _crate enableRopeAttach true;
    }
}];

// Disable stamina, if selected in parameter
if (!KPLIB_param_fatigue) then {
    _player enableStamina false;
    _player addEventHandler ["Respawn", {params["_player"]; _player enableStamina false;}];
};

// Reduce aim precision coefficient, if selected in parameter
if (!KPLIB_param_weaponSway) then {
    _player setCustomAimCoef 0.1;
    _player addEventHandler ["Respawn", {params["_player"]; _player setCustomAimCoef 0.1;}];
};

// Show what arsenal items can be unlocked by capturing the sector by clicking on the Arsenal+ marker
if (count KPLIB_sector_arsenalLink > 0) then {
    addMissionEventHandler ["MapSingleClick", {
        params["", "_pos"];

        private _control = (findDisplay 12) displayCtrl 51;
        private _mapSign = ctrlMapMouseOver _control;
        if ((_mapSign # 0) isEqualTo "marker") then {
            getMousePosition params ["_mouseX", "_mouseY"];
            private _mousePos = (_control ctrlMapScreenToWorld [_mouseX, _mouseY]);
            private _sector = [300, _mousePos] call KPLIB_fnc_getNearestSector;
            if ((_mapSign # 1) == (format["arsenalunlockmarker_%1", _sector])) then {
                [_sector] call KPLIB_fnc_hintLockedItems;
            };
        };
    }];
};

// Hint FOB and factory's resources
addMissionEventHandler ["MapSingleClick", {
    params["", "_pos"];

    private _control = (findDisplay 12) displayCtrl 51;
    private _mapSign = ctrlMapMouseOver _control;
    if ((_mapSign # 0) isEqualTo "marker") then {
        getMousePosition params ["_mouseX", "_mouseY"];
        private _mousePos = (_control ctrlMapScreenToWorld [_mouseX, _mouseY]);
        if ((_mapSign # 1) find "factory" == 0) then {
            private _sector = [300, _mousePos] call KPLIB_fnc_getNearestSector;
            if ((_sector in KPLIB_sectors_factory) && (_sector in KPLIB_sectors_player)) then {
                if (_sector in KPLIB_blockedFactories) exitWith {};
                [_sector] call KPLIB_fnc_hintResourcesFactory;
            };
        };
        if ((_mapSign # 1) find "fobmarker" >= 0) then {
            private _fob = [_mousePos] call KPLIB_fnc_getNearestFob;
            [_fob] call KPLIB_fnc_hintResourcesFob;
        };
    };
}];

// Show tower's info
addMissionEventHandler ["MapSingleClick", {
    params["", "_pos"];

    if (localNamespace getVariable ["KPLIB_towerInfoCooldown", false]) exitWith {};

    private _sector = [50, _pos] call KPLIB_fnc_getNearestSector;
    if (!(_sector in KPLIB_sectors_tower) || (_sector in KPLIB_sectors_player)) exitWith {};

    [_sector] call KPLIB_fnc_hintTowerInfo;
}];