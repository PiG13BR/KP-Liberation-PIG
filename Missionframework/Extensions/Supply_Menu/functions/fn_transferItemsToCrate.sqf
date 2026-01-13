/*
	File: fn_transferItemsToCrate.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 15/09/2025
	Last update: 16/09/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Transfers items to another crate

	Parameters:
        _crateToTransfer - crate to transfer the items in _dataItems [OBJECT, defaults to objNull]
        _supplyCrate - crate where the object comes from [OBJECT, defaults to objNull]
        _dataItem - item or items to add. Can be containers and weapons. Items under the container will be added as well, including weapons with attachs [STRING or ARRAY, defaults to ""]
        _amount - amount of items [NUMBER, defaults to 1]

	Return:
		-
*/

params[["_crateToTransfer", objNull, [objNull]], ["_supplyCrate", objNull, [objNull]], ["_dataItem", "", ["", []]], ["_amount", 1, [0]]];

if (isNull _crateToTransfer) exitWith {["[SUPPLY MENU] Object is null"] call BIS_fnc_error};
if (isNull _supplyCrate) exitWith {["[SUPPLY MENU] Object is null"] call BIS_fnc_error};
if (_dataItem isEqualTo "") exitWith {["[SUPPLY MENU] No data item provided"] call BIS_fnc_error};

if (_dataItem isEqualType []) then {
    private _itemClass = (_dataItem # 0);
    if (isClass(configFile >> "cfgWeapons" >> _itemClass)) then {
        if (_itemClass iskIndOf ["itemCore", configFile >> "CfgWeapons"]) then {
            // Probably a uniform or a vest container (high chance in configs)
            [_crateToTransfer, _itemClass, _amount, true] call CBA_fnc_addItemCargo;
            [_supplyCrate, _itemClass, _amount] call CBA_fnc_removeItemCargo;
            [_itemClass, _dataItem # 1, _crateToTransfer] call KPLIB_fnc_addContainerCargo
        } else {
            // Weapon with attachs
            _crateToTransfer addWeaponWithAttachmentsCargoGlobal [_dataItem, _amount];
            [_supplyCrate, _itemClass, _amount] call CBA_fnc_removeWeaponCargo;
        };
    } else {
        // Backpack container
        [_crateToTransfer, _itemClass, _amount, true] call CBA_fnc_addBackpackCargo;
        [_supplyCrate, _itemClass, _amount] call CBA_fnc_removeBackpackCargo;
        [_itemClass, _dataItem # 1, _crateToTransfer] call KPLIB_fnc_addContainerCargo
    };
} else {
    // classname only
    if ((_dataItem isKindOf ["ItemCore", configFile >> "CfgWeapons"]) || (_dataItem isKindOf ["DetectorCore", configFile >> "CfgWeapons"])) then {
        // Item
        [_supplyCrate, _dataItem, _amount] call CBA_fnc_removeItemCargo;
        [_crateToTransfer, _dataItem, _amount, true] call CBA_fnc_addItemCargo;
    } else {
        if ((_dataItem isKindOf ["Default", configFile >> "cfgWeapons"])) then {
            // Weapon
            [_supplyCrate, _dataItem, _amount] call CBA_fnc_removeWeaponCargo;
            [_crateToTransfer, _dataItem, _amount, true] call CBA_fnc_addWeaponCargo;
        } else {
            if (isClass(configFile >> "CfgGlasses" >> _dataItem)) then {
                [_supplyCrate, _dataItem, _amount] call CBA_fnc_removeItemCargo;
                [_crateToTransfer, _dataItem, _amount, true] call CBA_fnc_addItemCargo;
            } else {
                // Magazine
                [_supplyCrate, _dataItem, _amount] call CBA_fnc_removeMagazineCargo;
                [_crateToTransfer, _dataItem, _amount, true] call CBA_fnc_addMagazineCargo;
            }
        };
    };
};