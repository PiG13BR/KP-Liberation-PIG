/*
	File: fn_removeItemFromDump.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 15/09/2025
	Last update: 16/09/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Remove item from the virtual supply dump and add to the crate

	Parameters:
        _crateToAdd - crate where the object will be added [OBJECT, defaults to objNull]
        _item - item or items to be removed from the supply dump and added to the crate. [STRING, defaults to ""]
        _amount - amount of items [NUMBER, defaults to 1]

	Return:
		-
*/

params[["_crateToAdd", objNull, [objNull]], ["_item", "", [""]], ["_amount", 1, [0]]];

private _added = false; // Use CBA's return values to check if the item was added in the crate
if (isClass(configFile >> "CfgWeapons" >> _item)) then {
    // Weapons or items
    if ((_item isKindOf ["ItemCore", configFile >> "CfgWeapons"]) || (_item isKindOf ["DetectorCore", configFile >> "CfgWeapons"])) then {
        // Items
        _added = [_crateToAdd, _item, _amount, true] call CBA_fnc_addItemCargo;
    } else {
        if ((_item isKindOf ["Default", configFile >> "cfgWeapons"])) then {
            // Weapon
            _added = [_crateToAdd, _item, _amount, true] call CBA_fnc_addWeaponCargo;
        }
    };
};
if (isClass(configFile >> "CfgMagazines" >> _item)) then {
    // Magazines
    _added = [_crateToAdd, _item, _amount, true] call CBA_fnc_addMagazineCargo;
};
if (isClass(configFile >> "CfgGlasses" >> _item)) then {
    // Glasses
    _added = [_crateToAdd, _item, _amount, true] call CBA_fnc_addItemCargo;
};
if (isClass(configFile >> "cfgVehicles" >> _item)) then {
    // Backpacks
    _added = [_crateToAdd, _item, _amount, true] call CBA_fnc_addBackpackCargo;
};

if (!_added) exitWith {hintSilent localize "STR_SUPPLY_ADD_DENIED_DUMP"};

private _findIndex = KPLIB_supply_VirtualItems findif {(_x # 0) isEqualTo _item};
if (_findIndex == -1) exitWith {["[SUPPLIES MENU] Couldn't find the classname of the item in the presets"] call BIS_fnc_error};

// Only remove amount if the item was add to the crate
private _itemAmount = (KPLIB_supply_VirtualItems # _findIndex) # 1;
if (_itemAmount == -1) exitWith {}; // Exit on infinite amount
private _itemAmountFinal = _itemAmount - _amount;
(KPLIB_supply_VirtualItems # _findIndex) set [1, _itemAmountFinal];