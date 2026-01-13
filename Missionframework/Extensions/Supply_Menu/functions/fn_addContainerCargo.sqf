/*
	File: fn_addContainerCargo.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 13/09/2025
	Last update: 16/09/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Add items to a container object inside a crate

	Parameters:
		_containerClass - type of container to add items [STRING, defaults to ""]
        _itemsToAdd - items in array to add to the container [ARRAY, defaults to [[],[],[]]]
        _createToAdd - crate where the container is [OBJECT, defaults to objNull]

	Return:
		-
*/

params[["_containerClass", "", [""]], ["_itemsToAdd", [[],[],[]]], ["_crateToAdd", objNull, [objNull]]];

if (_containerClass isEqualTo "") exitWith {["[SUPPLY MENU] No container class provided"] call BIS_fnc_error};
if (_itemsToAdd isEqualTo [[],[],[]]) exitWith {}; // Exit on empty items to load
if (isNull _crateToAdd) exitWith {["[SUPPLY MENU] Object is null"] call BIS_fnc_error};

private _containers = everyContainer _crateToAdd; // Get all container in the crate

// Find a class match
private _find = _containers findIf {toLowerANSI(_x # 0) isEqualTo (toLowerANSI _containerClass)};
if (_find != -1) then {
    _containerObject = ((_containers # _find) # 1);
    {
        _elements = _x;
        {
           private _itemData = _x # 0;
           private _amount = _x # 1;
           // systemChat format ["%1, %2", _itemData, _amount];
            if (_itemData isEqualType []) then {
                // Weapons with attach
                _containerObject addWeaponWithAttachmentsCargoGlobal [_itemData, _amount];
            } else {
                // classname only
            if ((_itemData isKindOf ["ItemCore", configFile >> "CfgWeapons"]) || (_itemData isKindOf ["DetectorCore", configFile >> "CfgWeapons"])) then {
                // Item
                [_containerObject, _itemData, _amount, true] call CBA_fnc_addItemCargo;
            } else {
                if ((_itemData isKindOf ["Default", configFile >> "cfgWeapons"])) then {
                        // Weapon
                        [_containerObject, _itemData, _amount, true] call CBA_fnc_addWeaponCargo;
                    } else {
                        if (isClass(configFile >> "CfgGlasses" >> _itemData)) then {
                            [_containerObject, _itemData, _amount, true] call CBA_fnc_addItemCargo;
                        } else {
                            // Magazine
                            [_containerObject, _itemData, _amount, true] call CBA_fnc_addMagazineCargo;
                        }
                    };
                };
            };
        }forEach _elements;
    }forEach _itemsToAdd;
};