/*
    File: fn_addPlayerEH.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 13/11/2025
    Last Update: 19/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Auto-saving PFH

    Parameter(s):
        _player - player to add EH [OBJECT, defaults to player]

    Returns:
        -
*/

params[["_player", player, [objNull]]];

if (isDedicated) exitWith {};

// Remove/unassign item if not present in the player's allowed arsenal
private _slotItemHandle = _player addEventHandler ["SlotItemChanged", {
	params ["_unit", "_name", "_slot", "_assigned", "_weapon"];

    if (_assigned && {(KPLIB_arsenalAllowed find (toLowerANSI _name)) < 0 && {(_name find "TFAR") < 0}}) then { 
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

// For weapons
/*
_player addEventHandler ["WeaponChanged", {
	params ["_player", "_oldWeapon", "_newWeapon", "_oldMode", "_newMode", "_oldMuzzle", "_newMuzzle", "_turretIndex"];

    if (_newWeapon isEqualTo "") exitWith {};

    if ((KPLIB_arsenalAllowed findIf {_x == (toLowerANSI _newWeapon)}) < 0) then {
        private _action = _player addAction [localize "STR_INVENTORY_CANNOT_USE_WEAPON", 
            { 
                params["_player"]; 
                if ((!weaponLowered _player) || {((currentMuzzle _player) isNotEqualTo '')}) then { 
                    cutText [format [localize "STR_INVENTORY_CANNOT_USE_WEAPON", getText(configFile >> "cfgWeapons" >> (currentWeapon _player) >> "displayName")],'PLAIN',0.2]; 
                }; 
            }, 
            nil, 
            -99, 
            false, 
            true, 
            'defaultAction', 
            toString {focusOn isEqualTo _originalTarget}
        ]; 
        _player setVariable ["KPLIB_cannotUseWeaponAction", _action];
    } else {
        _player removeAction (_player getVariable ["KPLIB_cannotUseWeaponAction", -1])
    }
}];
*/
// Block players from entering heavy enemy veh
_player addEventHandler ["GetInMan", {
    params ["_unit", "_role", "_vehicle", "_turret"];

    private _type = typeOf _vehicle;
    if ((toLowerANSI _type) in KPLIB_o_allVeh_classes && {(_type isKindOf "Tank") || {_type isKindOf "Wheeled_Apc_F"}}) then {
        _unit action ["Eject", _vehicle];
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
_player addEventHandler ["GetInMan", {[_this select 2] call kp_vehicle_permissions;}];

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
_player addEventHandler ["SeatSwitchedMan", {[_this select 2] call kp_vehicle_permissions;}];
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

// Main map display EH for locked arsenal
if (count KPLIB_sector_arsenalLink > 0) then {
    [{
        !isNull (findDisplay 46)
    }, {
        ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["MouseButtonClick", {
            params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
            
            // Hint arsenal unlockable items by clicking on the marker
            private _mapSign = ctrlMapMouseOver _control;
            if ((_mapSign # 0) isEqualTo "marker") then {
            getMousePosition params ["_mouseX", "_mouseY"];
            private _mousePos = (_control ctrlMapScreenToWorld [_mouseX, _mouseY]);
            private _sector = [300, _mousePos] call KPLIB_fnc_getNearestSector;
                if (_mapSign # 1 == (format["arsenalunlockmarker%1", _sector])) then {
                    private _items = KPLIB_sector_arsenalLink get _sector;
                    _items = _items apply {
                        private _name = "";
                        if (isClass(configFile >> "cfgWeapons" >> _x)) then {
                            _name = getText(configFile >> "cfgWeapons" >> _x >> "displayName");
                        };

                        if (isClass(configFile >> "cfgMagazines" >> _x)) then {
                            _name = getText(configFile >> "cfgMagazines" >> _x >> "displayName");
                        };

                        if (isClass(configFile >> "cfgVehicles" >> _x)) then {
                            _name = getText(configFile >> "cfgVehicles" >> _x >> "displayName");
                        };
                        _name
                    }; 
                    [parseText (format[["<t size='1.5'>", localize "STR_ARSENAL_UNLOCK_LIST", "</t><br/>", "%1", "<br/>"] joinString "", _items joinString "<br/>"]), true, 7] call KPLIB_fnc_hint;
                };
            };
        }];
    }] call CBA_fnc_waitUntilAndExecute;
};