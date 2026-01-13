#include "..\defines.hpp"
/*
	File: fn_transferCargoManager.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 06/09/2025
	Last update: 01/01/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Opens and manages the transfer cargo menu

	Parameters:
		_rightCrate - crate where the action was opened (right listbox) [OBJECT, defaults to objnNull]
        _supplyCrate - crate to interact with / to transfer items to and from it (left listbox) [OBJECT, defaults to objNull]
        _player - the player that opened the menu [OBJECT, defaults to player]

	Return:
		-
*/

params[
    ["_rightCrate", objNull, [objNull]],
    ["_supplyCrate", objNull, [objNull]], 
    ["_player", player, [objNull]]
];


if (isNull _rightCrate) exitWith {["[SUPPLY MENU] Object is null"] call BIS_fnc_error};
if (isNull _supplyCrate) exitWith {["[SUPPLY MENU] Object is null"] call BIS_fnc_error};
if ((local _player) && {_rightCrate getVariable ["PIG_SUPPLY_isEditing", false] || {_supplyCrate getVariable ["PIG_SUPPLY_isEditing", false]}}) exitWith {hintSilent localize "STR_SUPPLY_EDITING_CRATE"}; // Exit on client trying to edit the same crate

// Create GUI
createDialog "PIG_RscSupplyMenu";

// Get controls
private _menuDisplay = (findDisplay IDD_SUPPLY_MENU);
private _leftCrateLnb = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
private _rightCrateLnb = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
private _addButton = (displayCtrl IDC_SUPPLY_MENU_ADD_BUTTON);
private _removeButton = (displayCtrl IDC_SUPPLY_MENU_REMOVE_BUTTON);
private _editControl = (displayCtrl IDC_SUPPLY_MENU_EDIT);
private _closeButton = (displayCtrl IDC_SUPPLY_MENU_CLOSE_BUTTON);
private _rightLnbText = (displayCtrl 89106);
private _leftLnbText = (displayCtrl 89103);
private _rightProgress = (displayCtrl IDC_R_CONTAINER_SLIDER);
private _leftProgress = (displayCtrl IDC_L_CONTAINER_SLIDER);

// Update cargo load bar
PIG_SUPPLY_updateProgressBar = {
    params[["_crate", objNull, [objNull]], ["_control", controlNull, [controlNull]]];

    private _load = load _crate;
    if (_load > 1) then {_load == 1};
    _control progressSetPosition _load;
};

[_supplyCrate, _leftProgress] call PIG_SUPPLY_updateProgressBar;
[_rightCrate, _rightProgress] call PIG_SUPPLY_updateProgressBar;

// Display name of the crates
private _displayNameCrateRight = getText(configFile >> "cfgVehicles" >> typeOf _rightCrate >> "displayName");
private _displayNameCrateLeft = getText(configFile >> "cfgVehicles" >> typeOf _supplyCrate >> "displayName");
_rightLnbText ctrlSetText format[localize "STR_SUPPLY_YOUR_CRATE", _displayNameCrateRight];
_leftLnbText ctrlSetText _displayNameCrateLeft;

_editControl ctrlSetText "1"; // Set default value for edit control

// Set variables
_menuDisplay setVariable ["PIG_SUPPLY_rightCrate", _rightCrate];
_menuDisplay setVariable ["PIG_SUPPLY_supplyCrate", _supplyCrate];
_rightCrate setVariable ["PIG_SUPPLY_isEditing", true, true];
_supplyCrate setVariable ["PIG_SUPPLY_isEditing", true, true];

// Create columns for listNBoxes
// Supply Items lnb
private _supplyItemsPics = _leftCrateLnb lnbAddColumn COLUMN_IMAGE_POS;
_leftCrateLnb  setVariable ["PIG_SUPPLY_PicColumn", _supplyItemsPics];
private _supplyItemsColumn = _leftCrateLnb lnbAddColumn COLUMN_TEXT_POS;
_leftCrateLnb  setVariable ["PIG_SUPPLY_ItemColumn", _supplyItemsColumn];
private _supplyAmountColumn = _leftCrateLnb lnbAddColumn COLUMN_AMOUNT_POS;
_leftCrateLnb setVariable ["PIG_SUPPLY_AmountColumn", _supplyAmountColumn];
// Crate's items lnb
private _crateItemsPics = _rightCrateLnb lnbAddColumn COLUMN_IMAGE_POS;
_rightCrateLnb  setVariable ["PIG_SUPPLY_PicColumn", _crateItemsPics];
private _crateItemsColumn = _rightCrateLnb lnbAddColumn COLUMN_TEXT_POS;
_rightCrateLnb  setVariable ["PIG_SUPPLY_ItemColumn", _crateItemsColumn];
private _crateItemsAmountColumn = _rightCrateLnb lnbAddColumn COLUMN_AMOUNT_POS;
_rightCrateLnb setVariable ["PIG_SUPPLY_AmountColumn", _crateItemsAmountColumn];

[_supplyCrate, _leftCrateLnb] call KPLIB_fnc_updateCrateItems;
[_rightCrate, _rightCrateLnb] call KPLIB_fnc_updateCrateItems;

// Create arrows
private _arrowCrate = createVehicleLocal ["Sign_Arrow_Large_Blue_F", _rightCrate];
private _arrowSupplyCrate = createVehicleLocal ["Sign_Arrow_Large_Green_F", _supplyCrate];

_menuDisplay setVariable ["PIG_SUPPLY_crateArrows", [_arrowCrate, _arrowSupplyCrate]];

private _offset = [0,0,0.7];

private _pos_crate = _rightCrate modelToWorld _offset;
_arrowCrate setPosATL _pos_crate;
private _pos_supplyCrate = _supplyCrate modelToWorld _offset;
_arrowSupplyCrate setPosATL _pos_supplyCrate;

// Supplying Crate > Crate
_addButton ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];

    // Get Lb sel
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    
    private _lbCurSel = lbCursel _lnbLeft;
    if (_lbCurSel == -1) exitWith {}; // Exit on non selected lb item

    // Get data
    private _dataItem = _lnbLeft lnbData [_lbCurSel, (_lnbLeft getVariable ["PIG_SUPPLY_ItemColumn", 1])]; // Classname

    private _supplyCrate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    private _crateToTransfer = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_rightCrate", objNull];
    private _amount = parseNumber(ctrlText (displayCtrl IDC_SUPPLY_MENU_EDIT));

    if (load _crateToTransfer >= 1) exitWith {hintSilent localize "STR_SUPPLY_CRATE_FULL"};

    _dataItem = parseSimpleArray _dataItem; // Get rid of strings
    _valueCount = (_dataItem # 1); // Get amount
    _dataItem = (_dataItem # 0); // Get rid of the outter array or get class directly
    
    if (_amount > _valueCount) then {_amount = _valueCount}; // Correct amount
    
    [_crateToTransfer, _supplyCrate, _dataItem, _amount] call KPLIB_fnc_transferItemsToCrate;

    [_supplyCrate, _lnbLeft] call KPLIB_fnc_updateCrateItems; // Update crate's list
    [_crateToTransfer, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list

    private _rightProgress = (displayCtrl IDC_R_CONTAINER_SLIDER);
    private _leftProgress = (displayCtrl IDC_L_CONTAINER_SLIDER);
    [_supplyCrate, _leftProgress] call PIG_SUPPLY_updateProgressBar;
    [_crateToTransfer, _rightProgress] call PIG_SUPPLY_updateProgressBar;
    
}];

// Reversed move. Supplying Crate < Crate
_removeButton ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];

    // Get Lb sel
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _lbCurSel = lbCursel _lnbRight;

    if (_lbCurSel == -1) exitWith {}; // Exit on non selected lb item
    
    private _dataItem = _lnbRight lnbData [_lbCurSel, (_lnbRight getVariable "PIG_SUPPLY_ItemColumn")]; // Magazine column
    private _valueAmmoCount = _lnbRight lnbValue [_lbCurSel, (_lnbRight getVariable "PIG_SUPPLY_AmountColumn")]; // Ammo count

    private _supplyCrate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_rightCrate", objNull];
    private _crateToTransfer = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    private _amount = parseNumber(ctrlText (displayCtrl IDC_SUPPLY_MENU_EDIT));

   if (load _crateToTransfer >= 1) exitWith {systemChat "Crate is Full"};

    _dataItem = parseSimpleArray _dataItem; // Get rid of strings
    _valueCount = (_dataItem # 1); // Get amount
    _dataItem = (_dataItem # 0); // Get rid of the outter array or get class directly
    
    if (_amount > _valueCount) then {_amount = _valueCount}; // Correct amount
    
    [_crateToTransfer, _supplyCrate, _dataItem, _amount] call KPLIB_fnc_transferItemsToCrate;

    [_supplyCrate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
    [_crateToTransfer, _lnbLeft] call KPLIB_fnc_updateCrateItems; // Update crate's list

    private _rightProgress = (displayCtrl IDC_R_CONTAINER_SLIDER);
    private _leftProgress = (displayCtrl IDC_L_CONTAINER_SLIDER);
    [_supplyCrate, _rightProgress] call PIG_SUPPLY_updateProgressBar;
    [_crateToTransfer, _leftProgress] call PIG_SUPPLY_updateProgressBar;
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
    private _supplyCrate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_rightCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "All"];
    
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
    [_supplyCrate, _lnbLeft] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterWeapons ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _supplyCrate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_rightCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Weapons"];
    
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
    [_supplyCrate, _lnbLeft] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterMagazines ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _supplyCrate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_rightCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Magazines"];
    
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
    [_supplyCrate, _lnbLeft] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterLaunchers ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _supplyCrate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_rightCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Launchers"];
    
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
    [_supplyCrate, _lnbLeft] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterThrowables ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _supplyCrate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_rightCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Throwables"];
    
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
    [_supplyCrate, _lnbLeft] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterExplosives ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _supplyCrate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_rightCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Explosives"];
    
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
    [_supplyCrate, _lnbLeft] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterMedical ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _supplyCrate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_rightCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Medical"];
    
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
    [_supplyCrate, _lnbLeft] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterTools ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _supplyCrate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_rightCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Tools"];
    
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
    [_supplyCrate, _lnbLeft] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterHeadgear ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _supplyCrate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_rightCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Headgear"];
    
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
    [_supplyCrate, _lnbLeft] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterUniforms ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _supplyCrate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_rightCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Uniforms"];
    
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
    [_supplyCrate, _lnbLeft] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterVests ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _supplyCrate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_rightCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Vests"];
    
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
    [_supplyCrate, _lnbLeft] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterBackpacks ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _supplyCrate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_rightCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Backpacks"];
    
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
    [_supplyCrate, _lnbLeft] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterBinos ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _supplyCrate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_rightCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Binos"];
    
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
    [_supplyCrate, _lnbLeft] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterRadios ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _supplyCrate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_rightCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Radios"];
    
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
    [_supplyCrate, _lnbLeft] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterAcc ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _supplyCrate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_rightCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Acc"];
    
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
    [_supplyCrate, _lnbLeft] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

_filterMisc ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    private _lnbLeft = (displayCtrl IDC_L_CONTAINER_LISTNBOX);
    private _lnbRight = (displayCtrl IDC_R_CONTAINER_LISTNBOX);
    private _supplyCrate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    private _crate = (findDisplay IDD_SUPPLY_MENU) getVariable ["PIG_SUPPLY_rightCrate", objNull];
    (findDisplay IDD_SUPPLY_MENU) setVariable ["PIG_SUPPLY_filterOption", "Misc"];
    
    [_crate, _lnbRight] call KPLIB_fnc_updateCrateItems; // Update crate's list
    [_supplyCrate, _lnbLeft] call KPLIB_fnc_updateCrateItems; // Update crate's list
}];

// Close button
_closeButton ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];
    closeDialog 0;
}];

// Unloading GUI
_menuDisplay displayAddEventHandler ["Unload", {
    params ["_display", "_exitCode"];

    private _crate = _display getVariable ["PIG_SUPPLY_rightCrate", objNull];
    private _supplyCrate = _display getVariable ["PIG_SUPPLY_supplyCrate", objNull];
    _crate setVariable ["PIG_SUPPLY_isEditing", false, true];
    _supplyCrate setVariable ["PIG_SUPPLY_isEditing", false, true];
    {deleteVehicle _x}forEach (_display getVariable ["PIG_SUPPLY_crateArrows", []]);
}]; 