#include "..\defines.hpp"
/*
	File: fn_updateVirtualItems.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 15/09/2025
	Last update: 01/01/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Update list of virtual items (originally from preset)

	Parameters:
		_control - control where the items will be showed [CONTROL, defaults to (displayCtrl IDC_L_CONTAINER_LISTNBOX)]

	Return:
		-
*/

params[["_control", (displayCtrl IDC_L_CONTAINER_LISTNBOX), [controlNull]]];

if (_control isEqualTo controlNull) then {_control = (displayCtrl IDC_L_CONTAINER_LISTNBOX)};

private _crateAllItems = [];
// Get crate items
private _allItems = [] call KPLIB_fnc_loadVirtualPreset;
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
    case "Acc" : {
        _crateAllItems = [_acc];
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
        private _amount = str(_x # 1);
        if (_amount isEqualTo "-1") then {_amount = "∞"}; // Infinite

        private _name = "";
        private _picture = "";
        private _dataToSave = _x;
        private _tooltip = "";
        
        if (isClass(configFile >> "CfgWeapons" >> _item)) then {
            // Weapons
            _name = getText (configfile >> "CfgWeapons" >> _item >> "displayName");
            _picture = getText (configFile >> "CfgWeapons" >> _item >> "picture");
            _tooltip = getText(configFile >> "CfgWeapons" >> _item >> "descriptionShort");
        };
        if (isClass(configFile >> "CfgMagazines" >> _item)) then {
            // Magazines
            _name = getText (configfile >> "CfgMagazines" >> _item >> "displayName");
            _picture = getText (configFile >> "CfgMagazines" >> _item >> "picture");
            _tooltip = getText(configFile >> "CfgMagazines" >> _item >> "descriptionShort");
        };
        if (isClass(configFile >> "CfgGlasses" >> _item)) then {
            // Glasses
            _name = getText (configfile >> "CfgGlasses" >> _item >> "displayName");
            _picture = getText (configFile >> "CfgGlasses" >> _item >> "picture");
            _tooltip = getText(configFile >> "CfgGlasses" >> _item >> "descriptionShort");
        };
        if (isClass(configFile >> "cfgVehicles" >> _item)) then {
            // Backpacks
            _name = getText (configfile >> "CfgVehicles" >> _item >> "displayName");
            _picture = getText (configFile >> "CfgVehicles" >> _item >> "picture");
            _tooltip = getText(configFile >> "CfgVehicles" >> _item >> "descriptionShort"); 
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

        private _rowIndex = _control lnbAddRow ["", _name, (_amount)];
        _control lnbSetPicture [[_rowIndex, _itemsPics], _picture];
        _control lnbSetTooltip [[_rowIndex, 0], _tooltip];

        if (_amount == str 0) then {
            _control lnbSetColor [[_rowIndex, _itemsColumn], [1,0,0,1]];
            _control lnbSetColor [[_rowIndex, _itemsAmountColumn], [1,0,0,1]] 
        };

        // Save data
        _control lnbSetData [[_rowIndex, _itemsColumn], str(_dataToSave)];
    }forEach _elements;     
}forEach (_crateAllItems);
_control lbSetCurSel _selectedCurSel;