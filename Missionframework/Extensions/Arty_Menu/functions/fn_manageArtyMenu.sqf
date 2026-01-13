#include "..\defines.hpp"
/*  
    File: fn_manageArtyMenu.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 02/07/2024
    Last Update: 27/11/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Get all the information about the artillery units to fill the list boxes of the artillery menu
    
    Parameter(s):
        -

    Return(s):
        -
*/
params[["_display", (findDisplay IDD_ARTY_MENU)]];

if (missionNameSpace getVariable ["KPLIB_ARTY_usingDisplay", false]) exitWith {[localize "STR_ARTY_OCUPIED", true, 3] call KPLIB_fnc_hint;  _display closeDisplay 1};
missionNameSpace setVariable ["KPLIB_ARTY_usingDisplay", true, true];

// Controls
private _mapControl = _display displayCtrl IDC_MAP_CONTROL;
private _artyComboBox = _display displayCtrl IDC_ARTY_COMBOBOX;
private _ammoComboBox = _display displayCtrl IDC_AMMO_COMBOBOX;
private _fireButton = _display displayCtrl IDC_BUTTON_FIRE;

// Always clear the main list box
lbClear _artyComboBox;

// Update the artillery list. Check if the unit is alive and has crew on it.
KPLIB_ARTY_supportList = KPLIB_ARTY_supportList select {(alive _x) && (count (fullCrew [_x, "gunner", false]) != 0)};
publicVariable "KPLIB_ARTY_supportList";

// Check if there are artillery vehicles inside the KPLIB_ARTY_supportList
if (count KPLIB_ARTY_supportList == 0) exitWith {
	[localize "STR_NOARTY_AVAILABLE", true, 3] call KPLIB_fnc_hint;
};

// Get the name of each artillery in KPLIB_ARTY_supportList and add to the first list box
{	
	_type = typeOf _x;
	// Filter the list with only artillery units. Those units have "artilleryScanner = 1" under CfgVehicles;
	if ((getNumber(configfile >> "CfgVehicles" >> _type >> "artilleryScanner") > 0)) then {
		private _name = getText(configFile >> "CfgVehicles" >> _type >> "displayName");
		_name = _name + " " + "(" + (groupID (group _x)) + ")"; // Update with the group ID
		_artyComboBox lbAdd _name;
		// Store list box data
		_artyComboBox lbSetData [_forEachIndex, _type];
	};

}forEach KPLIB_ARTY_supportList;

// Artillery position marker
createMarkerLocal ["KPLIB_ARTY_artyMarker", [99999,99999,0]];
"KPLIB_ARTY_artyMarker" setMarkerTypeLocal "b_art";
"KPLIB_ARTY_artyMarker" setMarkerColorLocal "ColorBLUFOR";
"KPLIB_ARTY_artyMarker" setMarkerSize [1.2, 1.2]; // Make it a little bigger

_fireButton ctrlEnable false; // Disable fire button as default

// Add control event handler to the artillery list box
_artyComboBox ctrlAddEventHandler ["LBSelChanged",{
	params ["_control", "_lbCurSel", "_lbSelection"];

	private _display = findDisplay IDD_ARTY_MENU;
	private _artyComboBox = _display displayCtrl IDC_ARTY_COMBOBOX;
	private _ammoComboBox = _display displayCtrl IDC_AMMO_COMBOBOX;

	// Clear the second list box
	lbClear _ammoComboBox;

	// Get artillery list box data
	private _arty = _artyComboBox lbData _lbCurSel;

	// Ace ammo handling on
	if (_arty isKindOf "StaticMortar" && {!isNil "ace_mk6mortar_useAmmoHandling"} && {ace_mk6mortar_useAmmoHandling}) exitWith {
		[localize "STR_ARTY_AMMO_HANDLING_ERROR", true, 3] call KPLIB_fnc_hint;
	};

	// Get the selected artillery object and store it in a variable to be used later
	private _gun = (KPLIB_ARTY_supportList select {typeOf _x == _arty}) # 0;
	"KPLIB_ARTY_artyMarker" setMarkerPosLocal (_gun);
	"KPLIB_ARTY_artyMarker" setMarkerText (getText (configFile >> "CfgVehicles" >> typeOf _gun >> "displayName")) + " " + "(" + (groupId (group _gun)) + ")";
	_control setVariable ["KPLIB_ARTY_gunSelected", _gun];

	// Get artillery ammo
	private _ammo = getArtilleryAmmo [_gun];

	// Add the name of the available magazines to the second list box
	{
		private _name = getText(configFile >> "CfgMagazines" >> _x >> "displayName");
		_ammoComboBox lbAdd _name;
		_ammoComboBox lbSetData [_forEachIndex,_x];
	}forEach _ammo;
}];

// Add control event handler for the ammo list box
_ammoComboBox ctrlAddEventHandler ["LBSelChanged",{
	params ["_control", "_lbCurSel", "_lbSelection"];

	private _display = findDisplay IDD_ARTY_MENU;
	private _artyComboBox = _display displayCtrl IDC_ARTY_COMBOBOX;
	private _roundsComboBox = _display displayCtrl IDC_ROUNDS_COMBOBOX;

	// Clear the third list box
	lbClear _roundsComboBox;

	// Get the artillery object from the stored variable
	private _arty = _artyComboBox getVariable ["KPLIB_ARTY_gunSelected", objNull];
	if (isNull _arty) exitWith {};

	// Check avaiable magazines and how many rounds per magazine
	private _magArray = magazinesAmmo _arty;
	// Select only rounds left for the selected magazine (The order of the _magArray respects the order of the list box)
	// If some magazine is empty, the array in _magArray will be deleted.
	private _rounds = (_magArray select _lbCurSel) select 1;
	private _allRounds = [];

	// Add how many rounds the player can select for the magazine selected in the second list box. From 1 to the number of rounds.
	for "_i" from 1 to _rounds do {
		_roundsComboBox lbAdd (str _i);
		_allRounds pushBack (_i);
	};
	
	// Store the data to be used later
	{
		_roundsComboBox lbSetValue [_forEachIndex, _x];
	}forEach _allRounds;

}];

// Add on mouse button down EH for the control map
_mapControl ctrlAddEventHandler ["MouseButtonDown", { 
	params ["_displayOrControl", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
	if (_button == 0) then {
		getMousePosition params ["_mouseX", "_mouseY"];
		
		private _targetPos = (_displayOrControl ctrlMapScreenToWorld [_mouseX, _mouseY]);
		_displayOrControl setVariable ["KPLIB_ARTY_fireArtyPos", _targetPos];

		private _createMarker = createMarkerLocal ["KPLIB_ARTY_targetMarker", _targetPos];
		"KPLIB_ARTY_targetMarker" setMarkerTypeLocal "hd_objective";
		"KPLIB_ARTY_targetMarker" setMarkerTextLocal (localize "STR_ARTY_MARKER_TARGET");
		"KPLIB_ARTY_targetMarker" setMarkerPosLocal _targetPos;
	}
}];

// Draw EH fires per frame. Use this to draw lines in the map and check list boxes selections.
_mapControl ctrlAddEventHandler ["Draw",{
	params ["_controlOrDisplay"];

	private _display = findDisplay IDD_ARTY_MENU;
	private _artyComboBox = _display displayCtrl IDC_ARTY_COMBOBOX;
	private _ammoComboBox = _display displayCtrl IDC_AMMO_COMBOBOX;
	private _roundsComboBox = _display displayCtrl IDC_ROUNDS_COMBOBOX;
	private _fireButton = _display displayCtrl IDC_BUTTON_FIRE;

	private _pos = _controlOrDisplay getVariable ["KPLIB_ARTY_fireArtyPos", [0,0,0]];
	if (_pos isEqualTo [0,0,0]) exitWith {};

	private _gun = _artyComboBox getVariable ["KPLIB_ARTY_gunSelected", objNull];
	if (isNull _gun) exitWith {};
	private _ranges = [(typeOf _gun), _ammoComboBox lbData (lbCurSel _ammoComboBox)] call KPLIB_fnc_getArtilleryRanges;
	_ranges params ["_min", "_max"];
	
	if ((!isNil "_pos") && {!isNull _gun}) then {
		// Draws line from artillery gun to target position
		_controlOrDisplay drawLine [getPos _gun, _pos, [0, 0, 0, 1]];

		// Draws an ellipse that represents min range for the artillery gun
		_controlOrDisplay drawEllipse [
			_gun, _min, _min, 0, [0, 0, 0, 1], ""
		];
		// Draws an ellipse that represents max range for the artillery gun
		_controlOrDisplay drawEllipse [
			_gun, _max, _max, 0, [0, 0, 0, 1], ""
		];
	};

	private _inRange = false;
	// Check range
	if (((_pos distance2d _gun) < _min) || {(_pos distance2d _gun) > _max}) then {
		_inRange = false;
	} else {
		_inRange = true;
	};

	private _listBoxesSel = false;
	// Check list boxes selections
	if ((lbCurSel _artyComboBox == -1) || {lbCurSel _ammoComboBox == -1} || {lbCurSel _roundsComboBox == -1}) then {
		_listBoxesSel = false;
	} else {
		// All list boxes a value selected
		_listBoxesSel = true;
	};

	// Disable/enable fire button
	if (_inRange && {_listBoxesSel}) then {
		_fireButton ctrlEnable true; // Enable fire button
		_fireButton ctrlSetTooltip "";
	} else {
		_fireButton ctrlEnable false; // Disable fire button
		_fireButton ctrlSetTooltip "Fire Disabled/Not in range";
	};
}];

// Fire button
_fireButton ctrlAddEventHandler ["ButtonClick",{
	params ["_control"];

	private _display = findDisplay IDD_ARTY_MENU;
	private _artyComboBox = _display displayCtrl IDC_ARTY_COMBOBOX;
	private _ammoComboBox = _display displayCtrl IDC_AMMO_COMBOBOX;
	private _roundsComboBox = _display displayCtrl IDC_ROUNDS_COMBOBOX;
	private _mapControl = _display displayCtrl IDC_MAP_CONTROL;

	// Check if the artillery is selected
	private _indexArty = lbCurSel _artyComboBox;
	if (_indexArty == -1) exitWith {[localize "STR_SELECT_ARTY", true, 3] call KPLIB_fnc_hint;};
	// Get the selected artillery object
	private _arty = _artyComboBox getVariable ["KPLIB_ARTY_gunSelected", objNull];

	// Check if the ammunition is selected
	private _indexAmmo = lbCurSel _ammoComboBox;
	if (_indexAmmo == -1) exitWith {[localize "STR_SELECT_AMMO", true, 3] call KPLIB_fnc_hint;};
	// Get the selected artillery ammo
	_ammo = _ammoComboBox lbData _indexAmmo; 

	// Check how many rounds
	private _indexRound = lbCurSel _roundsComboBox;
	if (_indexRound == -1) exitWith {[localize "STR_SELECT_ROUNDS", true, 3] call KPLIB_fnc_hint;};
	// Get the selected rounds
	_rounds = _roundsComboBox lbValue _indexRound;

	// Check if the player clicked on the map
	private _pos = _mapControl getVariable ["KPLIB_ARTY_fireArtyPos", [0,0,0]];
	if (_pos isEqualTo [0,0,0]) exitWith {[localize "STR_SELECT_POSITION", true, 3] call KPLIB_fnc_hint;};
	// Get marker position and it's elevation (Legion)
	private _targetPos = getMarkerPos ["KPLIB_ARTY_targetMarker", true];

	//[_arty, _targetPos, _ammo, _rounds] remoteExec ["KPLIB_fnc_fireArty", 2];
	["KPLIB_ArtyMenu_FireArty", [_arty, _targetPos, _ammo, _rounds]] call CBA_fnc_serverEvent;

	// Delete the placeholder target marker
	deleteMarkerLocal "KPLIB_ARTY_targetMarker";

	// Clear pos variable
	_mapControl setVariable ["KPLIB_ARTY_fireArtyPos", nil];
}];

// On Display/Dialog closed
_display displayAddEventHandler ["Unload",{
	params ["_display", "_closedChildDisplay", "_exitCode"];

	private _artyComboBox = _display displayCtrl IDC_ARTY_COMBOBOX;
	private _mapControl = _display displayCtrl IDC_MAP_CONTROL;

	// Clear variables
	_mapControl setVariable ["KPLIB_ARTY_fireArtyPos", nil];
	_artyComboBox setVariable ['KPLIB_ARTY_gunSelected', nil];
	deleteMarkerLocal 'KPLIB_ARTY_artyMarker'; 
	deleteMarkerLocal 'KPLIB_ARTY_targetMarker';

	missionNameSpace  setVariable ["KPLIB_ARTY_usingDisplay", false, true];
}];

