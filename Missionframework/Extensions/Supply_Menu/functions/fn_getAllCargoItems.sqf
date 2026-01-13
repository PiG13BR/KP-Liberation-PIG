/*
	File: fn_getAllCargoItems.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 10/09/2025
	Last update: 23/09/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Get all items available in the crate and order them. Non classified items will be left in the misc array.

	Parameters:
		_crate - crate where the items are [OBJECT, defaults to objNull]

	Return:
		-
*/
params[["_crate", objNull, [objNull]]];

if (isNull _crate) exitWith {["[SUPPLY MENU] Object is null"] call BIS_fnc_error};

private _weapons = [];
private _magazines = [];
private _launchers = [];
private _acc = [];
private _throwables  = [];
private _explosives = [];
private _tools = [];
private _medical = [];
private _headgear = [];
private _uniforms = [];
private _vests = [];
private _backpacks = [];
private _binos = [];
private _radios = [];
private _misc = [];

// Get all cargo data. Reorder arrays for sanity purpose. I can return the class and the count inside the same array.

// Get weapons with attachs.
private _weaponCargo = getWeaponCargo _crate;
private _weaponsWithAttach = (weaponsItemsCargo _crate);
//_weaponsWithAttach = _weaponsWithAttach arrayIntersect _weaponsWithAttach; // Intersect the arrays.
private _weaponsClassCount = [];
{
    private _data = _x;
    private _wpClass = (_x # 0);
    private _index = (_weaponsClassCount findIf {(_x # 0) isEqualTo _data});
    if (_index < 0) then {
        //_weaponsClassCount pushBack [_x, (_weaponCargo # 1) # _forEachIndex]
        _weaponsClassCount pushBack [_x, 1]
    } else {
        private _amount =  (_weaponsClassCount # _index) # 1;
        _amount = _amount + 1;
        (_weaponsClassCount # _index) set [1, _amount];
    };
}forEach _weaponsWithAttach;

// Get magazine cargo
private _magazineCargo = getMagazineCargo _crate;
private _magazinesClassCount = [];
{_magazinesClassCount pushBack [_x, (_magazineCargo # 1) # _forEachIndex]}forEach (_magazineCargo # 0);

// Get item cargo
private _itemCargo = getItemCargo _crate;
private _itemsClassCount = [];
{_itemsClassCount pushBack [_x, (_itemCargo # 1) # _forEachIndex]}forEach (_itemCargo # 0);
// // diag_log format["All items cargo:%1", _itemCargo];

// Weapon Filter
_weapons = _weaponsClassCount select {
    _x params ["_weaponItems"];
    _weaponItems params ["_class"];
    if (_class isKindOf ["Rifle", configFile >> "cfgWeapons"] || _class isKindOf ["PistolCore", configFile >> "cfgWeapons"]) then {true} else {false}
}; 
// // diag_log format ["Weapons: %1", _weapons];

// Magazines filter
_magazines = _magazinesClassCount select {
    _x params ["_class"];
    private _ammo = getText(configFile >> "cfgMagazines" >> _class >> "ammo");
    if (_ammo isKindOf "BulletCore" || {_ammo isKindOf "MissileCore"} || {_ammo isKindOf "RocketCore"} || {_ammo isKindOf "GrenadeCore"} || {_ammo isKindOf "SmokeShell"} || {(toLowerANSI _class) isEqualTo "laserbatteries"}) then {true} else {false}
};
// diag_log format ["Magazines: %1", _magazines];

// Launcher Filter
_launchers = _weaponsClassCount select {
    _x params ["_weaponItems"];
    _weaponItems params ["_class"];
    if (_class isKindOf ["LauncherCore", configFile >> "cfgWeapons"]) then {true} else {false}
};
// // diag_log format ["Launchers: %1", _launchers];

// Accessories
_acc = _itemsClassCount select {
    _x params ["_class"];
    if ("InventoryOpticsItem_Base_F" in ([configFile >> "cfgWeapons" >> _class >> "ItemInfo", true] call BIS_fnc_returnParents) || {"InventoryMuzzleItem_Base_F" in ([configFile >> "cfgWeapons" >> _class >> "ItemInfo", true] call BIS_fnc_returnParents)} || {"InventoryUnderItem_Base_F" in ([configFile >> "cfgWeapons" >> _class >> "ItemInfo", true] call BIS_fnc_returnParents)} || {"InventoryFlashLightItem_Base_F" in ([configFile >> "cfgWeapons" >> _class >> "ItemInfo", true] call BIS_fnc_returnParents)}) then {true} else {false}
};
// diag_log format ["Accessories: %1", _acc];

// Throwables Filter "GrenadeHand"
_throwables  = _magazinesClassCount select {
    _x params ["_class"];
    private _ammo = getText(configFile >> "cfgMagazines" >> _class >> "ammo");
    if (_class isKindOf ["HandGrenade", configFile >> "cfgMagazines"] || {_ammo isEqualTo "GrenadeHand"} || {_ammo isKindOf "IRStrobeBase"}) then {true} else {false}
};
// diag_log format ["Throwables : %1", _throwables ];

// Explosives/mines Filter
_explosives = _magazinesClassCount select {
    _x params ["_class"];
    if (getText(configFile >> "cfgMagazines" >> _class >> "ammo") isKindOf "TimeBombCore") then {true} else {false}
};
// diag_log format ["Explosives: %1", _explosives];

// Tools filter
_tools = _itemsClassCount select {
    _x params ["_class"];
    if ((toLowerANSI _class) isEqualTo "toolkit" || {_class isKindOF ["DetectorCore", configFile >> "cfgWeapons"]} || {(getNumber(configFile >> "CfgWeapons" >> _class >> "ACE_isTool")) > 0}) then {true} else {false}
};
// diag_log format ["Tools: %1", _tools];

// Medical filter
_medical = _itemsClassCount select {
    _x params ["_class"];
    if ((toLowerANSI _class) in ["medikit", "firstaidkit"] || {getNumber(configFile >> "CfgWeapons" >> _class >> "ACE_isMedicalItem") > 0}) then {true} else {false}
};
// diag_log format ["Medical: %1", _medical];

// Helmets Filter 
_headgear = _itemsClassCount select {
    _x params ["_class"];
    if (_class isKindOf ["HelmetBase", configFile >> "cfgWeapons"] || {"HeadgearItem" in ([configFile >> "cfgWeapons" >> (_x # 0) >> "ItemInfo", true] call BIS_fnc_returnParents)} || {isClass(configFile >> "CfgGlasses" >> _class)} || {_class isKindOf ["NVGoggles", configFile >> "cfgWeapons"]}) then {true} else {false}
};
// diag_log format ["Helmets: %1", _headgear];

// Uniforms container
_uniformsContainer = (everyContainer _crate) select {(_x # 0) isKindOf ["Uniform_Base", configFile >> "cfgWeapons"] || {"UniformItem" in ([configFile >> "cfgWeapons" >> (_x # 0) >> "ItemInfo", true] call BIS_fnc_returnParents)}};
_uniforms = [_uniformsContainer] call KPLIB_fnc_getContainerCargo;
// diag_log format ["Uniforms: %1", _uniforms];

// Vests container
_vestsContainer = (everyContainer _crate) select {(_x # 0) isKindOf ["Vest_Camo_Base", configFile >> "cfgWeapons"] || {(_x # 0) isKindOf ["Vest_NoCamo_Base", configFile >> "cfgWeapons"]} || {(_x # 0) isKindOf ["V_Plain_base_F", configFile >> "cfgWeapons"]} || {"VestItem" in ([configFile >> "cfgWeapons" >> (_x # 0) >> "ItemInfo", true] call BIS_fnc_returnParents)}};
_vests = [_vestsContainer] call KPLIB_fnc_getContainerCargo;
// diag_log format ["Vests: %1", _vests];

// Backpack
// Get backpack container
private _backpacksContainer = (everyContainer _crate) select {(_x # 0) isKindOf "Bag_Base"};
_backpacks = [_backpacksContainer] call KPLIB_fnc_getContainerCargo;
// diag_log format["Backpacks: %1", _backpacks];

// Binos filter
_binos = _weaponsClassCount select {
    _x params ["_weaponItems"];
    _weaponItems params ["_class"];
    if (_class isKindOf ["Binocular", configFile >> "cfgWeapons"]) then {true} else {false}
};
// diag_log format ["Binoculars: %1", _binos];

// Radios
_radios = _itemsClassCount select {
    _x params ["_class"];
    if (_class isKindOf ["ItemRadio", configFile >> "cfgWeapons"] || {_class isKindOf ["ACRE_BaseRadio", configFile >> "cfgWeapons"]} || {(toLowerANSI _class) isEqualTo "itemradio"} || {(toLowerANSI _class) isEqualTo "itemcompass"} || {(toLowerANSI _class) isEqualTo "itemgps"} || {(toLowerANSI _class) isEqualTo "itemmap"} || {(toLowerANSI _class) isEqualTo "itemgps"} || {_class isKindOf ["UavTerminal_base", configFile >> "cfgWeapons"]}) then {true} else {false}
};
// diag_log format["Radios: %1", _radios];

// Misc / Non-classified
{
    _itemsClassCount deleteAt (_itemsClassCount find _x);
}forEach (_medical + _tools + _headgear + _radios + _acc);
{
    _class = (_x # 0) # 0;
    _itemsClassCount deleteAt (_itemsClassCount findIf {(_x # 0) == _class});
}forEach (_uniforms  + _backpacks + _vests);
_misc = _itemsClassCount + ((_magazinesClassCount) - _explosives - _throwables - _magazines); // What is left
// diag_log format ["Misc: %1", _misc];

// Optics/muzzles "InventoryOpticsItem_Base_F" in ([configFile >> "cfgWeapons" >> _class >> "ItemInfo", true] call BIS_fnc_returnParents) || {"InventoryMuzzleItem_Base_F" in ([configFile >> "cfgWeapons" >> _class >> "ItemInfo", true] call BIS_fnc_returnParents)} || {"InventoryUnderItem_Base_F" in ([configFile >> "cfgWeapons" >> _class >> "ItemInfo", true] call BIS_fnc_returnParents)} || {"InventoryFlashLightItem_Base_F" in ([configFile >> "cfgWeapons" >> _class >> "ItemInfo", true] call BIS_fnc_returnParents)}

[_weapons, _magazines, _launchers, _acc, _throwables , _explosives, _tools, _medical, _headgear, _uniforms, _vests, _backpacks, _binos, _radios, _misc]