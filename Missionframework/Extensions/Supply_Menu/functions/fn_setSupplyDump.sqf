/*
	File: fn_setSupplyDump.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 08/09/2025
	Last update: 20/09/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Set an object as a supply dump/virtual dump, where the player can access the virtual supply preset through a crate with supply actions added to it.
        [this] call KPLIB_fnc_setSupplyDump

	Parameters:
		_object - object the will serve as a supply dump [OBJECT, defaults to objNull]

	Return:
		-
*/

params[["_object", objNull, [objNull]]];

if (!isServer) exitWith {};

if (isNull _object) exitWith {["[SUPPLIES MENU] Object is null"] call BIS_fnc_error};
if (_object getVariable ["PIG_SUPPLY_isSupplyCarrier", false]) exitWith {["[SUPPLIES MENU] The object is a supply carrier"] call BIS_fnc_error};

// Clear supply dump cargo
clearItemCargoGlobal _object;
clearWeaponCargoGlobal _object;
clearMagazineCargoGlobal _object;
clearBackpackCargoGlobal _object;

_object enableSimulationGlobal false;
_object allowDamage false;

_object setVariable ["PIG_SUPPLY_isSupplyDump", true, true];

// If the supply dump has an inventory, placed items will be added in the virtual supply
_object addEventHandler ["Put", {
	params ["_unit", "_container", "_item"];

    private _amount = 1;

    _containerItems = [everyContainer _container] call KPLIB_fnc_getContainerCargo;

    private _findIndex = -1;
    
    if (_containerItems isEqualTo []) then {
       [_container, _item, _amount] call KPLIB_fnc_addItemToDump;
    } else {
        // Check if the item is part of the containter items
        _findIndex = (_containerItems # 0) findIf {toLowerANSI(_x # 0) isEqualTo (toLowerANSI(_item))};
            if (_findIndex >= 0) then {
            [_container, ((_containerItems # 0) # 0), _amount] call KPLIB_fnc_addItemToDump;
        } else {
            [_container, _item, _amount] call KPLIB_fnc_addItemToDump;
        }
    }
}];