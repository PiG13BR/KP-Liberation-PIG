#include "..\defines.hpp"
/*
	File: fn_virtualSupplyManager.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 14/09/2025
	Last update: 01/01/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Opens and manages the virtual supply dump

	Parameters:
		_grabberCrate - crate where items from the supply dump will be added
        _player - player that opened the virtual supply dump.

	Return:
		-
*/

params[["_grabberCrate", objNull, [objNull]],["_player", player, [objNull]]];

if (KPLIB_supply_VirtualItems isEqualTo []) exitWith {["[SUPPLIES MENU] No virtual items available"] call BIS_fnc_error};

if (isNull _grabberCrate) exitWith {["[SUPPLY MENU] Object is null"] call BIS_fnc_error};
if ((local _player) && {_grabberCrate getVariable ["PIG_SUPPLY_isEditing", false]}) exitWith {hintSilent localize "STR_SUPPLY_EDITING_CRATE"}; // Exit on client trying to edit the same crate

// Set up variables to the player
localNamespace setVariable ["PIG_SUPPLY_playerInMenu", _player];
if (isNil "PIG_SUPPLY_playersInVirtualSupply") then {
    PIG_SUPPLY_playersInVirtualSupply = [];
    publicVariable "PIG_SUPPLY_playersInVirtualSupply";
};

PIG_SUPPLY_playersInVirtualSupply pushBackUnique _player; // Pushback player to this array
publicVariable "PIG_SUPPLY_playersInVirtualSupply"; // Publish to all clients

// Create GUI
createDialog "PIG_RscSupplyMenu";

// Get controls
private _menuDisplay = (findDisplay IDD_SUPPLY_MENU);
private _virtualSupplyLnb = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
private _crateLnb = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
private _addButton = (displayCtrl IDC_SUPPLY_MENU_ADD_BUTTON);
private _removeButton = (displayCtrl IDC_SUPPLY_MENU_REMOVE_BUTTON);
private _editControl = (displayCtrl IDC_SUPPLY_MENU_EDIT);
private _closeButton = (displayCtrl IDC_SUPPLY_MENU_CLOSE_BUTTON);
private _rightLnbText = (displayCtrl 89106);
private _leftLnbText = (displayCtrl 89103);
private _rightProgress = (displayCtrl IDC_R_CONTAINER_SLIDER);
private _leftProgress = (displayCtrl IDC_L_CONTAINER_SLIDER);

_leftProgress ctrlShow false; // Hide cargo load bar for the supply dump controls

// Update cargo load bar
PIG_SUPPLY_updateProgressBar = {
    params[["_crate", objNull, [objNull]], ["_control", controlNull, [controlNull]]];

    private _load = load _crate;
    if (_load > 1) then {_load == 1};
    _control progressSetPosition _load;
};

[_grabberCrate, _rightProgress] call PIG_SUPPLY_updateProgressBar;

// Display name of the crates
private _displayNameCrateRight = getText(configFile >> "cfgVehicles" >> typeOf _grabberCrate >> "displayName");
_rightLnbText ctrlSetText format[localize "STR_SUPPLY_YOUR_CRATE", _displayNameCrateRight];
_leftLnbText ctrlSetText (localize "STR_SUPPLY_DUMP_TITLE");

_editControl ctrlSetText "1"; // Set default value for edit control

// Set variables
_menuDisplay setVariable ["PIG_SUPPLY_grabberCrate", _grabberCrate];
_grabberCrate setVariable ["PIG_SUPPLY_isEditing", true, true];

// Create columns for listNBoxes
// Supply Items lnb
private _supplyItemsPics = _virtualSupplyLnb lnbAddColumn 0;
_virtualSupplyLnb  setVariable ["PIG_SUPPLY_PicColumn", _supplyItemsPics];
private _supplyItemsColumn = _virtualSupplyLnb lnbAddColumn 0.15;
_virtualSupplyLnb  setVariable ["PIG_SUPPLY_ItemColumn", _supplyItemsColumn];
private _supplyAmountColumn = _virtualSupplyLnb lnbAddColumn 0.9;
_virtualSupplyLnb setVariable ["PIG_SUPPLY_AmountColumn", _supplyAmountColumn];
// Crate's items lnb
private _crateItemsPics = _crateLnb lnbAddColumn 0;
_crateLnb  setVariable ["PIG_SUPPLY_PicColumn", _crateItemsPics];
private _crateItemsColumn = _crateLnb lnbAddColumn 0.15;
_crateLnb  setVariable ["PIG_SUPPLY_ItemColumn", _crateItemsColumn];
private _crateItemsAmountColumn = _crateLnb lnbAddColumn 0.9;
_crateLnb setVariable ["PIG_SUPPLY_AmountColumn", _crateItemsAmountColumn];

[_virtualSupplyLnb] call KPLIB_fnc_updateVirtualItems;
[_grabberCrate, _crateLnb] call KPLIB_fnc_updateCrateItems;

/*
// Supply Dump > Crate
_addButton ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];

    // Get Lb sel
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _lbCurSel = lbCursel _lnbLeft;
    if (_lbCurSel == -1) exitWith {}; // Exit on non selected lb item

    // Get data
    private _dataItem = _lnbLeft lnbData [_lbCurSel, (_lnbLeft getVariable ["PIG_SUPPLY_ItemColumn", 1])]; // Classname

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    private _amount = parseNumber(ctrlText (displayCtrl IDC_SUPPLY_MENU_EDIT));

    if (load _crate >= 1) exitWith {hintSilent localize "STR_SUPPLY_CRATE_FULL"};

    _dataItem = parseSimpleArray _dataItem; // Get rid of strings
    _valueCount = (_dataItem # 1); // Get amount
    _dataItem = (_dataItem # 0); // Get class
    
   
    if ((_amount > _valueCount) && {_valueCount != -1}) then {_amount = _valueCount}; // Correct amount
    
    if (_amount isEqualTo 0) exitWith {hintSilent localize "STR_SUPPLY_NO_MORE_ITEMS"};

    [_crate, _dataItem, _amount] call KPLIB_fnc_removeItemFromDump;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list

    // Update supply dump items for all players accessing it.
    ["PIG_SUPPLY_updateMenu", [], PIG_SUPPLY_playersInVirtualSupply] call CBA_fnc_targetEvent;

    private _rightProgress = (displayCtrl IDC_R_CONTAINER_SLIDER);
    [_crate, _rightProgress] call PIG_SUPPLY_updateProgressBar;
}];
*/

_addButton ctrlAddEventHandler ["MouseButtonClick", {
    params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

    // Get Lb sel
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _lbCurSel = lbCursel _lnbLeft;
    if (_lbCurSel == -1) exitWith {}; // Exit on non selected lb item

    // Get data
    private _dataItem = _lnbLeft lnbData [_lbCurSel, (_lnbLeft getVariable ["PIG_SUPPLY_ItemColumn", 1])]; // Classname

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    private _amount = parseNumber(ctrlText (displayCtrl IDC_SUPPLY_MENU_EDIT));

    if (_shift) then {_amount = 10}; // If shift is pressed, amount is always 10

    if (load _crate >= 1) exitWith {hintSilent localize "STR_SUPPLY_CRATE_FULL"};

    _dataItem = parseSimpleArray _dataItem; // Get rid of strings
    _valueCount = (_dataItem # 1); // Get amount
    _dataItem = (_dataItem # 0); // Get class
    
   
    if ((_amount > _valueCount) && {_valueCount != -1}) then {_amount = _valueCount}; // Correct amount
    
    if (_amount isEqualTo 0) exitWith {hintSilent localize "STR_SUPPLY_NO_MORE_ITEMS"};

    [_crate, _dataItem, _amount] call KPLIB_fnc_removeItemFromDump;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list

    // Update supply dump items for all players accessing it.
    ["PIG_SUPPLY_updateMenu", [], PIG_SUPPLY_playersInVirtualSupply] call CBA_fnc_targetEvent;

    private _rightProgress = (displayCtrl IDC_R_CONTAINER_SLIDER);
    [_crate, _rightProgress] call PIG_SUPPLY_updateProgressBar;

}];

/*
// Supply dump < crate
_removeButton ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];

    // Get Lb sel
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _lbCurSel = lbCursel _lnbRight;

    if (_lbCurSel == -1) exitWith {}; // Exit on non selected lb item
    
    private _dataItem = _lnbRight lnbData [_lbCurSel, (_lnbRight getVariable "PIG_SUPPLY_ItemColumn")]; // Magazine column
    private _valueAmmoCount = _lnbRight lnbValue [_lbCurSel, (_lnbRight getVariable "PIG_SUPPLY_AmountColumn")]; // Ammo count

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    private _amount = parseNumber(ctrlText (displayCtrl IDC_SUPPLY_MENU_EDIT));

   if (load _crate >= 1) exitWith {hintSilent localize "STR_SUPPLY_CRATE_FULL"};

    _dataItem = parseSimpleArray _dataItem; // Get rid of strings
    _valueCount = (_dataItem # 1); // Get amount
    _dataItem = (_dataItem # 0); // Get rid of the outter array or get class directly
    
    if (_amount > _valueCount) then {_amount = _valueCount}; // Correct amount

    [_crate, _dataItem, _amount] call KPLIB_fnc_addItemToDump;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list

    // Update supply dump items for all players accessing it.
    ["PIG_SUPPLY_updateMenu", [], PIG_SUPPLY_playersInVirtualSupply] call CBA_fnc_targetEvent;

    private _rightProgress = (displayCtrl IDC_R_CONTAINER_SLIDER);
    [_crate, _rightProgress] call PIG_SUPPLY_updateProgressBar;
}];
*/
_removeButton ctrlAddEventHandler ["MouseButtonClick", {
    params ["_control", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

    // Get Lb sel
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _lbCurSel = lbCursel _lnbRight;

    if (_lbCurSel == -1) exitWith {}; // Exit on non selected lb item
    
    private _dataItem = _lnbRight lnbData [_lbCurSel, (_lnbRight getVariable "PIG_SUPPLY_ItemColumn")]; // Magazine column
    private _valueAmmoCount = _lnbRight lnbValue [_lbCurSel, (_lnbRight getVariable "PIG_SUPPLY_AmountColumn")]; // Ammo count

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    private _amount = parseNumber(ctrlText (displayCtrl IDC_SUPPLY_MENU_EDIT));

    if (_shift) then {_amount = 10}; // If shift is pressed, amount is always 10

   if (load _crate >= 1) exitWith {hintSilent localize "STR_SUPPLY_CRATE_FULL"};

    _dataItem = parseSimpleArray _dataItem; // Get rid of strings
    _valueCount = (_dataItem # 1); // Get amount
    _dataItem = (_dataItem # 0); // Get rid of the outter array or get class directly
    
    if (_amount > _valueCount) then {_amount = _valueCount}; // Correct amount

    [_crate, _dataItem, _amount] call KPLIB_fnc_addItemToDump;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list

    // Update supply dump items for all players accessing it.
    ["PIG_SUPPLY_updateMenu", [], PIG_SUPPLY_playersInVirtualSupply] call CBA_fnc_targetEvent;

    private _rightProgress = (displayCtrl IDC_R_CONTAINER_SLIDER);
    [_crate, _rightProgress] call PIG_SUPPLY_updateProgressBar;

}];

// Filter buttons
private _filterAll = (displayCtrl IDC_FILTER_ALL_BUTTON);
private _filterWeapons = (displayCtrl IDC_FILTER_WEAPONS_BUTTON);
private _filterMagazines = (displayCtrl IDC_FILTER_MAGAZINES_BUTTON);
private _filterLaunchers = (displayCtrl IDC_FILTER_LAUNCHERS_BUTTON);
private _filterAcc = (displayCtrl IDC_FILTER_ACC_BUTTON); // Weapons accessories
private _filterThrowables = (displayCtrl IDC_FILTER_THROWABLES_BUTTON);
private _filterExplosives = (displayCtrl IDC_FILTER_EXPLOSIVES_BUTTON);
private _filterTools = (displayCtrl IDC_FILTER_TOOLS_BUTTON);
private _filterMedical = (displayCtrl IDC_FILTER_MEDICAL_BUTTON);
private _filterHeadgear = (displayCtrl IDC_FILTER_HEADGEAR_BUTTON);
private _filterUniforms = (displayCtrl IDC_FILTER_UNIFORMS_BUTTON);
private _filterVests = (displayCtrl IDC_FILTER_VESTS_BUTTON);
private _filterBackpacks = (displayCtrl IDC_FILTER_BACKPACKS_BUTTON);
private _filterBinos = (displayCtrl IDC_FILTER_BINOCULARS_BUTTON);
private _filterRadios = (displayCtrl IDC_FILTER_RADIOS_BUTTON);
private _filterMisc = (displayCtrl IDC_FILTER_MISC_BUTTON);

_filterAll ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];

    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "All"];
    [_lnbLeft] call KPLIB_fnc_updateVirtualItems;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterWeapons ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Weapons"];
    [_lnbLeft] call KPLIB_fnc_updateVirtualItems;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterMagazines ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Magazines"];
    [_lnbLeft] call KPLIB_fnc_updateVirtualItems;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterLaunchers ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Launchers"];
    [_lnbLeft] call KPLIB_fnc_updateVirtualItems;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterAcc ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Acc"];
    [_lnbLeft] call KPLIB_fnc_updateVirtualItems;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems;// Update crate's list
}];

_filterThrowables ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Throwables"];
    [_lnbLeft] call KPLIB_fnc_updateVirtualItems;
}];

_filterExplosives ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Explosives"];
    [_lnbLeft] call KPLIB_fnc_updateVirtualItems;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterMedical ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Medical"];

    [_lnbLeft] call KPLIB_fnc_updateVirtualItems;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterTools ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Tools"];
    [_lnbLeft] call KPLIB_fnc_updateVirtualItems;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterHeadgear ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Headgear"];
    [_lnbLeft] call KPLIB_fnc_updateVirtualItems;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterUniforms ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Uniforms"];
    [_lnbLeft] call KPLIB_fnc_updateVirtualItems;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterVests ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Vests"];
    [_lnbLeft] call KPLIB_fnc_updateVirtualItems;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterBackpacks ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Backpacks"];
    [_lnbLeft] call KPLIB_fnc_updateVirtualItems;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterBinos ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Binos"];
    [_lnbLeft] call KPLIB_fnc_updateVirtualItems;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterRadios ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Radios"];
    [_lnbLeft] call KPLIB_fnc_updateVirtualItems;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterMisc ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);

    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Misc"];
    [_lnbLeft] call KPLIB_fnc_updateVirtualItems;
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_closeButton ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    closeDialog 0;
}];

// Unloading GUI
_menuDisplay displayAddEventHandler ["Unload", {
    params ["_display", "_exitCode"];

    private _player = localNamespace getVariable ["PIG_SUPPLY_playerInMenu", objNull];

    PIG_SUPPLY_playersInVirtualSupply deleteAt (PIG_SUPPLY_playersInVirtualSupply find _player);
    publicVariable "PIG_SUPPLY_playersInVirtualSupply";

    private _crate = _display getVariable ["PIG_SUPPLY_grabberCrate", objNull];
    _crate setVariable ["PIG_SUPPLY_isEditing", false, true];
}];