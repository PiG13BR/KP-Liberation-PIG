/*
	File: fn_containersToVirtual.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 15/09/2025
	Last update: 16/09/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Manages what happens to a container object/class if is transfered to the supply dump

	Parameters:
		_containerData - array of items, including the container's type
        _amount - amount of containers

	Return:
		-
*/

params[["_containerData", [], [[]]], ["_amount", 1, [0]]];

if (_containerData isEqualTo []) exitWith {};

// Get class and container
private _containterItems = _containerData;
private _item = _containterItems deleteAt 0;

// Container class
private _findIndex = KPLIB_supply_VirtualItems findif {(_x # 0) isEqualTo _item};
if ((_findIndex == -1) && {_item isNotEqualTo ""}) then {
    // pushBackUnique element
    // diag_log format ["NEW ADD: %1", _item];
    KPLIB_supply_VirtualItems pushBackUnique [_item, 1];
} else {
    // Already existis in preset, add it
    // diag_log format ["ALREADY EXIST: %1", _item];

    private _itemAmount = (KPLIB_supply_VirtualItems # _findIndex) # 1;
    if (_itemAmount == -1) exitWith {}; // Exit on infinite amount
    private _itemAmountFinal = _itemAmount + _amount;
    (KPLIB_supply_VirtualItems # _findIndex) set [1, _itemAmountFinal];
};

// Container Items
{
    if (_x isEqualTo [[],[],[]]) exitWith {}; // Skip iteration on empty bag
    private _itemsArray = _x;
    {
        // diag_log format ["CONTAINER ITEMS: %1", _x];
        private _classItem = _x # 0;
        private _amount = _x # 1;

        if (_classItem isEqualType []) then {
            // Weapon with attachs
            private _accItem = "";
            private _opticItem = "";
            private _muzzleItem = "";
            {
                // diag_log format ["WEAPON ACCESSORIES: %1", _x];

                private _attachData = _x;
                if (_x isEqualType []) then {
                    private _magClass = _attachData # 0;
                    // Array - Magazines (primary and secondary)
                    if (isClass(configFile >> "cfgMagazines" >> _magClass)) then {
                            private _findIndex = KPLIB_supply_VirtualItems findif {(_x # 0) isEqualTo _magClass};
                            if ((_findIndex == -1) && {_magClass isNotEqualTo ""}) then {
                                // pushBackUnique element
                                // diag_log format ["NEW ADD: %1", _magClass];
                                KPLIB_supply_VirtualItems pushBackUnique [_magClass, 1];
                            } else {
                                // Already existis in preset, add it
                                // diag_log format ["ALREADY EXIST: %1", _magClass];

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
                        // diag_log format ["ACC: %1, OPTIC: %2, MUZZLE: %3", _accItem, _opticItem, _muzzleItem];
                    };

                    if (toLowerANSI(_attachData) isEqualTo _accItem || {toLowerANSI(_attachData) isEqualTo _opticItem} || {toLowerANSI(_attachData) isEqualTo _muzzleItem}) then {diag_log format ["SKIPED ACC: %1", _attachData]; continue}; // Ignore linked items already in the weapon

                    private _findIndex = KPLIB_supply_VirtualItems findif {(_x # 0) isEqualTo _attachData};
                    if (_findIndex == -1) then {
                        // pushBackUnique element
                        // diag_log format ["NEW ADD: %1", _attachData];
                        KPLIB_supply_VirtualItems pushBackUnique [_attachData, 1];
                    } else {
                        // Already existis in preset, add it
                        // diag_log format ["ALREADY EXIST: %1", _attachData];

                        private _itemAmount = (KPLIB_supply_VirtualItems # _findIndex) # 1;
                        if (_itemAmount == -1) exitWith {}; // Exit on infinite amount
                        private _itemAmountFinal = _itemAmount + _amount;
                        (KPLIB_supply_VirtualItems # _findIndex) set [1, _itemAmountFinal];
                    };
                }
            }forEach _classItem;
        } else {
            // String
            private _findIndex = KPLIB_supply_VirtualItems findif {(_x # 0) isEqualTo _classItem};
            if (_findIndex == -1) then {
                // pushBackUnique element
                // diag_log format ["NEW ADD: %1", _classItem];
                KPLIB_supply_VirtualItems pushBackUnique [_classItem, 1];
            } else {
                // Already existis in preset, add it
                // diag_log format ["ALREADY EXIST: %1", _classItem];

                private _itemAmount = (KPLIB_supply_VirtualItems # _findIndex) # 1;
                if (_itemAmount == -1) exitWith {}; // Exit on infinite amount
                private _itemAmountFinal = _itemAmount + _amount;
                (KPLIB_supply_VirtualItems # _findIndex) set [1, _itemAmountFinal];
            };
        }
    }forEach _itemsArray;
}forEach _containterItems # 0;
