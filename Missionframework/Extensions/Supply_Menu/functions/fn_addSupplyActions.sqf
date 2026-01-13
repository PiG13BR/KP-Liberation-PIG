#include "..\defines.hpp"
/*
	File: fn_addSupplyActions.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 06/09/2025
	Last update: 03/01/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Add actions to a crate that is going to handle supply transfering and also responsable to grant access to the virtual supply.
		Object's init field:
			[this] call KPLIB_fnc_addSupplyActions; 

		Global calls:
			["PIG_SUPPLY_supplyActions", [_object], true] call CBA_fnc_globalEventJIP;

	Parameters:
		_crate - crate to add actions [OBJECT, defaults to objNull]

	Return:
		-
*/

params[["_crate", objNull, [objNull]]];

if (isNull _crate) exitWith {["[SUPPLY MENU] Object is null"] call BIS_fnc_error};
if !(_crate isKindOF "ReammoBox_F") exitWith {["[SUPPLY MENU] Object is not a container"] call BIS_fnc_error};

_crate setVariable ["PIG_SUPPLY_isSupplyCarrier", true, true];

if (KPLIB_ace) then {
	// Set object carryable
	[_crate, true, [0, 1, 1], 0, PIG_SupplyMenu_Setting_ignoreWeight, true] call ace_dragging_fnc_setCarryable;

	// Transfer cargo
	_actionTransfer = [
		"PIG_SUPPLY_transferCargoAction", // Action name <STRING>
		localize "STR_SUPPLY_TRANSFER_TITLE", // Name of the action shown in the menu <STRING>
		"Extensions\Supply_Menu\icons\exchange.paa", // Icon file path or Array of icon file path and hex color ("" for default icon) <STRING or ARRAY>
		{
			private _suppliesNearby = (((_target nearSupplies MIN_DIST_CRATE) select {_x isKindOf "ReammoBox_F"}) - [_target]);
			_suppliesNearby = _suppliesNearby apply { [_x distance _target, _x] };
			_suppliesNearby sort true;
			_supplyNearby = (_suppliesNearby # 0) # 1;
			[_target, _supplyNearby, _player] call KPLIB_fnc_transferCargoManager
		}, // Statement <CODE>
		{
			count(((_target nearSupplies MIN_DIST_CRATE) select {_x isKindOf "ReammoBox_F" && !(_x getVariable ["PIG_SUPPLY_isSupplyDump", false])}) - [_target]) > 0 
			&& {(isNull (_player getVariable ["PIG_SUPPLY_crateCarried", objNull]))} 
			&& {!(_target getVariable ["PIG_SUPPLY_beignCarried", false])}
		}, // Condition <CODE>
		{}, // Insert children code <CODE> (default: {})
		[], // Action parameters <ANY> (default: [])
		[0, 0, 0], // Position (Position array, Position code or Selection Name) <ARRAY or CODE or STRING> (default: {[0, 0, 0]})
		3 // Distance <NUMBER> (default: 2)
		//[false, false, false, false, false], // Other parameters [showDisabled,enableInside,canCollapse,runOnHover,doNotCheckLOS] <ARRAY> (default: all false)
		//{} // Modifier function <CODE> (default: {})
	] call ace_interact_menu_fnc_createAction;

	// Supply Dump (virtual dump)
	_actionDump = [
		"PIG_SUPPLY_supplyDumpAction", // Action name <STRING>
		localize "STR_SUPPLY_DUMP_TITLE", // Name of the action shown in the menu <STRING>
		"Extensions\Supply_Menu\icons\box-open.paa", // Icon file path or Array of icon file path and hex color ("" for default icon) <STRING or ARRAY>
		{
			[_target, _player] call KPLIB_fnc_virtualSupplyManager;
		}, // Statement <CODE>
		{
			count(((_target nearObjects MIN_DIST_DUMP) select {_x getVariable ["PIG_SUPPLY_isSupplyDump", false]}) - [_target]) > 0 
			&& {(isNull (_player getVariable ["PIG_SUPPLY_crateCarried", objNull]))} 
			&& {!(_target getVariable ["PIG_SUPPLY_beignCarried", false])}
		}, // Condition <CODE>
		{}, // Insert children code <CODE> (default: {})
		[], // Action parameters <ANY> (default: [])
		[0, 0, 0], // Position (Position array, Position code or Selection Name) <ARRAY or CODE or STRING> (default: {[0, 0, 0]})
		3 // Distance <NUMBER> (default: 2)
		//[false, false, false, false, false], // Other parameters [showDisabled,enableInside,canCollapse,runOnHover,doNotCheckLOS] <ARRAY> (default: all false)
		//{} // Modifier function <CODE> (default: {})
	] call ace_interact_menu_fnc_createAction;
	[
		_crate, // Object the action should be assigned to <OBJECT>
		0, // Type of action, 0 for actions, 1 for self-actions <NUMBER>
		["ACE_MainActions"], // Parent path of the new action <ARRAY> (Example: `["ACE_SelfActions", "ACE_Equipment"]`)
		_actionDump // Action <ARRAY>
	] call ace_interact_menu_fnc_addActionToObject;

	[
		_crate, // Object the action should be assigned to <OBJECT>
		0, // Type of action, 0 for actions, 1 for self-actions <NUMBER>
		["ACE_MainActions"], // Parent path of the new action <ARRAY> (Example: `["ACE_SelfActions", "ACE_Equipment"]`)
		_actionTransfer // Action <ARRAY>
	] call ace_interact_menu_fnc_addActionToObject;

} else {
	// Supply Dump (virtual dump)
	_crate addAction [["<img size='1.5' image='Extensions\Supply_Menu\icons\exchange.paa'/>","<t color='#00FF55' size='1.2'>", " " , localize "STR_SUPPLY_DUMP_TITLE", "</t>"] joinString "", 
		{
			params ["_target", "_caller", "_actionId", "_arguments"];
			[_target, _caller] call KPLIB_fnc_virtualSupplyManager;
		}, nil, -400, true, true, "", 
		toString{
			count(((_target nearObjects 10) select {_x getVariable ["PIG_SUPPLY_isSupplyDump", false]}) - [_target]) > 0 
			&& {(isNull (_this getVariable ["PIG_SUPPLY_crateCarried", objNull]))} 
			&& {!(_target getVariable ["PIG_SUPPLY_beignCarried", false])}
	}, 5];

	// Transfer cargo
	_crate addAction [["<img size='1.5' image='Extensions\Supply_Menu\icons\exchange.paa'/>","<t color='#00FF55' size='1.2'>", " " , "EXCHANGE CARGO", "</t>"] joinString "", 
		{
			params ["_target", "_caller", "_actionId", "_arguments"];
			private _suppliesNearby = (((_target nearSupplies 5) select {_x isKindOf "ReammoBox_F"}) - [_target]);
			_suppliesNearby = _suppliesNearby apply { [_x distance _target, _x] };
			_suppliesNearby sort true;
			_supplyNearby = (_suppliesNearby # 0) # 1;
			[_target, _supplyNearby, _caller] call KPLIB_fnc_transferCargoManager
		}, nil, -400, true, true, "", 
		toString{
			count(((_target nearSupplies 5) select {_x isKindOf "ReammoBox_F"}) - [_target]) > 0 
			&& {(isNull (_this getVariable ["PIG_SUPPLY_crateCarried", objNull]))} 
			&& {!(_target getVariable ["PIG_SUPPLY_beignCarried", false])}
	}, 5];

	// Drop action
	_crate addAction [["<img size='1.5' image='Extensions\Supply_Menu\icons\carry-box.paa'/>","<t color='#FFFF00'>", " " , "CARRY", "</t>"] joinString "",
		{
			params ["_crate", "_player"];
			_crate attachTo [_player, [0, 2, 1]];
			_player setVariable ["PIG_SUPPLY_crateCarried", _crate];
			_crate setVariable ["PIG_SUPPLY_beignCarried", true];

			// Drop action
			_player addAction [["<img size='1.5' image='Extensions\Supply_Menu\icons\arrow-down.paa'/>","<t color='#FFFF00'>", " " , "DROP", "</t>"] joinString "",
				{
					params ["_player", "", "_actionID"];
					private _crate = _player getVariable ["PIG_SUPPLY_crateCarried", objNull];

					private _crateSize = (sizeOf (typeOf _crate)) * 1.5;
					private _nearObjects = (_crate nearEntities [["Man", "Air", "Car", "Tank"], _crateSize]) - [_crate, _player];
					if (_nearObjects isNotEqualTo []) exitWith {
						hintSilent format [localize "STR_SUPPLY_PLACEMENT_IMPOSSIBLE", count _nearObjects, _crateSize toFixed 0];
					};

					_player setVariable ["PIG_SUPPLY_crateCarried", objNull];
					_crate setVariable ["PIG_SUPPLY_beignCarried", false];
					detach _crate;
					_crate awake true;

					_player removeAction _actionID
				},
				nil,
				-403,
				true,
				false,
				"",
				toString {
					alive _this 
					&& {isNull (objectParent _this)} 
					&& {!isNull (_this getVariable ["PIG_SUPPLY_crateCarried", objNull])}
				}
			];
		},
		"", -401, true, false, "",
		toString {
			isNull objectParent _this 
			&& {(isNull (_this getVariable ["PIG_SUPPLY_crateCarried", objNull])) 
			&& !(_target getVariable ["PIG_SUPPLY_beignCarried", false])}
			&& (load _target < PIG_SupplyMenu_Setting_weightCoef)
		},
	5]
};

