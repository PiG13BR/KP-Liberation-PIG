#include "..\defines.hpp"
/*
	File: fn_updateCrateItems.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 13/09/2025
	Last update: 01/01/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Update available crate's items for the list box.
        Ideally, this function must be remote executed.

	Parameters:
		_crate - crate to check for items inside of it [OBJECT, defaults to objNull]
        _control - control where the list of items will be showed [CONTROL, defaults to controlNull]

	Return:
		-
*/

params[["_crate", objNull, [objNull]], ["_control", controlNull, [controlNull]]];

if (isNull _crate) exitWith {["[SUPPLY MENU] Object is null"] call BIS_fnc_error};

private _crateAllItems = [];
// Get crate items
private _allItems = [_crate] call KPLIB_fnc_getAllCargoItems;
_allItems params ['_weapons', '_magazines', '_launchers', '_acc', '_throwables', '_explosives', '_tools',  '_medical', '_headgear', '_uniforms', '_vests', '_backpacks', '_binos', '_radios', '_misc'];

// Get last selected filter option
private _filterOption = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_filterOption", "All"];

// Get columns
private _itemsPics =_control getVariable ["PIG_SUPPLY_PicColumn", 0];
private _itemsColumn = _control getVariable ["PIG_SUPPLY_ItemColumn", 0.07];
private _itemsAmountColumn = _control getVariable ["PIG_SUPPLY_AmountColumn", 0.82];
private _selectedCurSel = lbCurSel _control;

lnbClear _control;

// Filter check
private _crateAllItems = [];

switch _filterOption do {
    case "All" : {
        _crateAllItems = _allItems;
    };
    case "Weapons" : {
        _crateAllItems = [_weapons];
    };
    case "Magazines" : {
        _crateAllItems = [_magazines];
    };
    case "Launchers" : {
        _crateAllItems = [_launchers];
    };
    case "Acc" : {
        _crateAllItems = [_acc];
    };
    case "Throwables" : {
        _crateAllItems = [_throwables];
    };
    case "Explosives" : {
        _crateAllItems = [_explosives];
    };
    case "Tools" : {
        _crateAllItems = [_tools];
    };
    case "Medical" : {
        _crateAllItems = [_medical];
    };
    case "Headgear" : {
        _crateAllItems = [_headgear];
    };
    case "Uniforms" : {
        _crateAllItems = [_uniforms];
    };
    case "Vests" : {
        _crateAllItems = [_vests];
    };
    case "Backpacks" : {
        _crateAllItems = [_backpacks];
    };
    case "Binos" : {
        _crateAllItems = [_binos];
    };
    case "Radios" : {
        _crateAllItems = [_radios];
    };
    case "Misc" : {
        _crateAllItems = [_misc];
    };
};

// Fill lnb
private _weaponIndex = 0;
{   
    // Iterate each array
    private _elements = _x;
    {
        private _item = _x # 0;
        private _amount = _x # 1;
        //diag_log format["%1, %2", _item, _amount];

        private _name = "";
        private _picture = "";
        private _dataToSave = _x;
        private _tooltip = "";

        if (_item isEqualType []) then {
        // Array
        private _class = _item # 0;
            if (isClass(configFile >> "cfgWeapons" >> _class)) then {
                // Weapon with attachs and vests/uniforms container
                _name = getText (configfile >> "CfgWeapons" >> _class >> "displayName");
                _picture = getText (configFile >> "CfgWeapons" >> _class >> "picture"); 
                _tooltip = getText(configFile >> "CfgWeapons" >> _class >> "descriptionShort");     
            } else {
                // Backpack container 
                _name = getText (configfile >> "CfgVehicles" >> _class >> "displayName");
                _picture = getText (configFile >> "CfgVehicles" >> _class >> "picture");
                _tooltip = getText(configFile >> "CfgVehicles" >> _class >> "descriptionShort");  
            }
        } else {
            // Classname (string)
                if (isClass(configFile >> "CfgWeapons" >> _item)) then {
                _name = getText (configfile >> "CfgWeapons" >> _item >> "displayName");
                _picture = getText (configFile >> "CfgWeapons" >> _item >> "picture");
                _tooltip = getText(configFile >> "CfgWeapons" >> _item >> "descriptionShort");
            };
            if (isClass(configFile >> "CfgMagazines" >> _item)) then {
                _name = getText (configfile >> "CfgMagazines" >> _item >> "displayName");
                _picture = getText (configFile >> "CfgMagazines" >> _item >> "picture");
                _tooltip = getText(configFile >> "CfgMagazines" >> _item >> "descriptionShort");
            };
            if (isClass(configFile >> "CfgGlasses" >> _item)) then {
                _name = getText (configfile >> "CfgGlasses" >> _item >> "displayName");
                _picture = getText (configFile >> "CfgGlasses" >> _item >> "picture");
                _tooltip = getText(configFile >> "CfgGlasses" >> _item >> "descriptionShort");
            };
        };
        
        // Some descriptions has <br/> <br />, replace it with a space
        if (_tooltip regexMatch ".*<br />.*") then {
            while {_tooltip regexMatch ".*<br />.*"} do {
                _tooltip = _tooltip regexReplace ["<br />/i", " "];
            };
        };
        if (_tooltip regexMatch ".*<br/>.*") then {
            while {_tooltip regexMatch ".*<br/>.*"} do {
                _tooltip = _tooltip regexReplace ["<br/>/i", " "];
            };
        };

        if (_name isEqualTo "") then {_name = _item};
        private _rowIndex = _control lnbAddRow ["", _name, str(_amount)];
        _control lnbSetPicture [[_rowIndex, _itemsPics], _picture];
        _control lnbSetTooltip [[_rowIndex, 0], _tooltip];
        // Save data
        _control lnbSetData [[_rowIndex, _itemsColumn], str(_dataToSave)];
    }forEach _elements;     
}forEach (_crateAllItems);

_control lbSetCurSel _selectedCurSel;