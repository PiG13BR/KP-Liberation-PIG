/*
	File: fn_addItemToDump.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 15/09/2025
	Last update: 16/09/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Add item to the virtual supply dump and remove the item from the origin

	Parameters:
		_crateToRemove - crate where the object is in and will be removed [OBJECT, defaults to objNull]
        _item - item or items to add. Can be a weapon with attachs or items inside a container (hard coded pattern) [STRING or ARRAY, defaults to ""]
        _amount - amount of items to add [NUMBER, defaults to 1]

	Return:
		-
*/

params[["_crateToRemove", objNull, [objNull]], ["_item", "", ["", []]], ["_amount", 1, [0]]];

private _removed = false;
if (_item isEqualType []) then {
    // Array
    private _itemClass = _item # 0; // Get class to check it in configs
    if (isClass(configFile >> "cfgWeapons" >> _itemClass)) then {
        // Weapons with attach / vests / uniforms
        if (_itemClass iskIndOf ["itemCore", configFile >> "CfgWeapons"]) then {
            // Probably a uniform or a vest container (high chance in configs)
            diag_log format ["UNIFORM/VEST CONTAINER CLASS: %1", _itemClass];
            _removed = [_crateToRemove, _itemClass, _amount] call CBA_fnc_removeItemCargo;

            if (_removed) then {
                [_item, _amount] call KPLIB_fnc_containersToVirtual;
            }
        } else {
            // Weapon with attachs (weaponsItems' return)
            _removed = [_crateToRemove, _itemClass, _amount] call CBA_fnc_removeWeaponCargo;
            if (_removed) then {
                private _accItem = "";
                private _opticItem = "";
                private _muzzleItem = "";
                {
                    diag_log format ["WEAPON ACCESSORIES: %1", _x];

                    private _attachData = _x;
                    if (_x isEqualType []) then {
                        private _magClass = _attachData # 0;
                        // Array - Magazines (primary and secondary)
                        if (isClass(configFile >> "cfgMagazines" >> _magClass)) then {
                            //_removed = [_crateToRemove, _x, 1] call CBA_fnc_removeMagazineCargo;
                                private _findIndex = KPLIB_supply_VirtualItems findif {(_x # 0) isEqualTo _magClass};
                                if ((_findIndex == -1) && {_magClass isNotEqualTo ""}) then {
                                    // pushBackUnique element
                                    diag_log format ["NEW ADD: %1", _magClass];
                                    KPLIB_supply_VirtualItems pushBackUnique [_magClass, 1];
                                } else {
                                    // Already existis in preset, add it
                                    diag_log format ["ALREADY EXIST: %1", _magClass];

                                    private _itemAmount = (KPLIB_supply_VirtualItems # _findIndex) # 1;
                                    if (_itemAmount == -1) exitWith {}; // Exit on infinite amount
                                    private _itemAmountFinal = _itemAmount + _amount;
                                    (KPLIB_supply_VirtualItems # _findIndex) set [1, _itemAmountFinal];

                                };
                            continue
                        };
                    } else {
                        // String
                        // Check for config linked items. Check variables for the next iterations
                        if (isClass(configFile >> "CfgWeapons" >> _attachData >> "LinkedItems")) then {
                            _accItem = toLowerANSI(getText(configFile >> "CfgWeapons" >> _attachData >> "LinkedItems" >> "LinkedItemsAcc" >> "item"));
                            _opticItem = toLowerANSI(getText(configFile >> "CfgWeapons" >> _attachData >> "LinkedItems" >> "LinkedItemsOptic" >> "item"));
                            _muzzleItem = toLowerANSI(getText(configFile >> "CfgWeapons" >> _attachData >> "LinkedItems" >> "LinkedItemsMuzzle" >> "item"));
                            diag_log format ["ACC: %1, OPTIC: %2, MUZZLE: %3", _accItem, _opticItem, _muzzleItem];
                        };

                        if (toLowerANSI(_attachData) isEqualTo _accItem || {toLowerANSI(_attachData) isEqualTo _opticItem} || {toLowerANSI(_attachData) isEqualTo _muzzleItem}) then {diag_log format ["SKIPED ACC: %1", _attachData]; continue}; // Ignore linked items already in the weapon

                        private _findIndex = KPLIB_supply_VirtualItems findif {(_x # 0) isEqualTo _attachData};
                        if (_findIndex == -1) then {
                            // pushBackUnique element
                            diag_log format ["NEW ADD: %1", _attachData];
                            KPLIB_supply_VirtualItems pushBackUnique [_attachData, 1];
                        } else {
                            // Already existis in preset, add it
                            diag_log format ["ALREADY EXIST: %1", _attachData];

                            private _itemAmount = (KPLIB_supply_VirtualItems # _findIndex) # 1;
                            if (_itemAmount == -1) exitWith {}; // Exit on infinite amount
                            private _itemAmountFinal = _itemAmount + _amount;
                            (KPLIB_supply_VirtualItems # _findIndex) set [1, _itemAmountFinal];

                        };
                    }
                }forEach _item;
            }
        }
    } else {
        // Backpack
        diag_log format ["BACKPACK CONTAINER CLASS: %1", _itemClass];
        _removed = [_crateToRemove, _itemClass, _amount] call CBA_fnc_removeBackpackCargo;

        if (_removed) then {
            [_item, _amount] call KPLIB_fnc_containersToVirtual;
        }
    }

} else {
    // String
    if ((_item isKindOf ["ItemCore", configFile >> "CfgWeapons"]) || (_item isKindOf ["DetectorCore", configFile >> "CfgWeapons"])) then {
        // Item
        _removed = [_crateToRemove, _item, _amount] call CBA_fnc_removeItemCargo;
    } else {
        if ((_item isKindOf ["Default", configFile >> "cfgWeapons"])) then {
            // Weapon
            _removed = [_crateToRemove, _item, _amount] call CBA_fnc_removeWeaponCargo;
            } else {
            if (isClass(configFile >> "CfgGlasses" >> _item)) then {
                _removed = [_crateToRemove, _item, _amount] call CBA_fnc_removeItemCargo;
            } else {
                // Magazine
                _removed = [_crateToRemove, _item, _amount] call CBA_fnc_removeMagazineCargo;
            }
        };
    }; 

    if (_removed) then {
        private _findIndex = KPLIB_supply_VirtualItems findif {(_x # 0) isEqualTo _item};
        if (_findIndex == -1) then {
            // pushBackUnique element
            diag_log format ["NEW ADD: %1", _item];
            KPLIB_supply_VirtualItems pushBackUnique [_item, 1];
        } else {
            // Already existis in preset, add it
            diag_log format ["ALREADY EXIST: %1", _item];

            private _itemAmount = (KPLIB_supply_VirtualItems # _findIndex) # 1;
            if (_itemAmount == -1) exitWith {}; // Exit on infinite amount
            private _itemAmountFinal = _itemAmount + _amount;
            (KPLIB_supply_VirtualItems # _findIndex) set [1, _itemAmountFinal];
        };
    }
}