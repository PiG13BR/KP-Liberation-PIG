/*
	File: fn_loadVirtualPreset.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 14/09/2025
	Last update: 16/09/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Loads in order all items from preset

	Parameters:
		-

	Return:
		-
*/

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

{
	private _class = (_x # 0);
	private _amount = (_x # 1);

	// Weapon Filter
	if (_class isKindOf ["Rifle", configFile >> "cfgWeapons"] || _class isKindOf ["PistolCore", configFile >> "cfgWeapons"]) then {_weapons pushBackUnique _x};

	// Magazines filter
	if (isClass(configFile >> "cfgMagazines" >> _class)) then {
		private _ammo = getText(configFile >> "cfgMagazines" >> _class >> "ammo");
		if (_ammo isKindOf "BulletCore" || {_ammo isKindOf "MissileCore"} || {_ammo isKindOf "RocketCore"} || {_ammo isKindOf "GrenadeCore"} || {_ammo isKindOf "SmokeShell"} || {(toLowerANSI _class) isEqualTo "laserbatteries"}) then {_magazines pushBackUnique _x};
	};

    // Launcher Filter
    if (_class isKindOf ["LauncherCore", configFile >> "cfgWeapons"]) then {_launchers pushBackUnique _x};

    // Accessories
    if ("InventoryOpticsItem_Base_F" in ([configFile >> "cfgWeapons" >> _class >> "ItemInfo", true] call BIS_fnc_returnParents) || {"InventoryMuzzleItem_Base_F" in ([configFile >> "cfgWeapons" >> _class >> "ItemInfo", true] call BIS_fnc_returnParents)} || {"InventoryUnderItem_Base_F" in ([configFile >> "cfgWeapons" >> _class >> "ItemInfo", true] call BIS_fnc_returnParents)} || {"InventoryFlashLightItem_Base_F" in ([configFile >> "cfgWeapons" >> _class >> "ItemInfo", true] call BIS_fnc_returnParents)}) then {_acc pushBackUnique _x};
    diag_log format ["Accessories: %1", _acc];

    // Throwables Filter
    if (isClass(configFile >> "cfgMagazines" >> _class)) then {
        private _ammo = getText(configFile >> "cfgMagazines" >> _class >> "ammo");
        if (_class isKindOf ["HandGrenade", configFile >> "cfgMagazines"] || {getText(configFile >> "cfgMagazines" >> _class >> "ammo") isEqualTo "GrenadeHand"} || {_ammo isKindOf "IRStrobeBase"}) then {_throwables pushBackUnique _x};
    };

    // Explosives/mines Filter
    if (getText(configFile >> "cfgMagazines" >> _class >> "ammo") isKindOf "TimeBombCore") then {_explosives pushBackUnique _x};

    // Tools filter
    if ((toLowerANSI _class) isEqualTo "toolkit" || {_class isKindOF ["DetectorCore", configFile >> "cfgWeapons"]} || {(getNumber(configFile >> "CfgWeapons" >> _class >> "ACE_isTool")) > 0}) then {_tools pushBackUnique _x};

    // Medical filter
    if ((toLowerANSI _class) in ["medikit", "firstaidkit"] || {getNumber(configFile >> "CfgWeapons" >> _class >> "ACE_isMedicalItem") > 0}) then {_medical pushBackUnique _x};
    
    // Helmets Filter 
    if (_class isKindOf ["HelmetBase", configFile >> "cfgWeapons"] || {"HeadgearItem" in ([configFile >> "cfgWeapons" >> _class >> "ItemInfo", true] call BIS_fnc_returnParents)} || {isClass(configFile >> "CfgGlasses" >> _class)} || {_class isKindOf ["NVGoggles", configFile >> "cfgWeapons"]}) then {_headgear pushBackUnique _x};

    // Uniforms container
    if (_class isKindOf ["Uniform_Base", configFile >> "cfgWeapons"] || {"UniformItem" in ([configFile >> "cfgWeapons" >> _class >> "ItemInfo", true] call BIS_fnc_returnParents)}) then {_uniforms pushBackUnique _x};
    
    // Vests container
    if (_class isKindOf ["Vest_Camo_Base", configFile >> "cfgWeapons"] || {_class isKindOf ["Vest_NoCamo_Base", configFile >> "cfgWeapons"]} || {_class isKindOf ["V_Plain_base_F", configFile >> "cfgWeapons"]} || {"VestItem" in ([configFile >> "cfgWeapons" >> _class >> "ItemInfo", true] call BIS_fnc_returnParents)}) then {_vests pushBackUnique _x};
    
    // Backpack
    // Get backpack container
    if (_class isKindOf "Bag_Base") then {_backpacks pushBackUnique _x};
    
    // Binos filter
    if (_class isKindOf ["Binocular", configFile >> "cfgWeapons"]) then {_binos pushBackUnique _x};
    
    // Radios
    if (_class isKindOf ["ItemRadio", configFile >> "cfgWeapons"] || {_class isKindOf ["ACRE_BaseRadio", configFile >> "cfgWeapons"]} || {(toLowerANSI _class) isEqualTo "itemradio"} || {(toLowerANSI _class) isEqualTo "itemcompass"} || {(toLowerANSI _class) isEqualTo "itemgps"} || {(toLowerANSI _class) isEqualTo "itemmap"} || {(toLowerANSI _class) isEqualTo "itemgps"} || {_class isKindOf ["UavTerminal_base", configFile >> "cfgWeapons"]}) then {_radios pushBackUnique _x};
    
    // All items
    _misc pushBackUnique _x;

}forEach KPLIB_supply_VirtualItems;

// Check for misc items
{
    private _elements = _x;
    {
        _misc deleteAt (_misc find _x);
    }forEach _elements;
}forEach [_weapons, _magazines, _launchers, _acc, _throwables , _explosives, _tools, _medical, _headgear, _uniforms, _vests, _backpacks, _binos, _radios];

/*
diag_log format ["Weapons: %1", _weapons];
diag_log format ["Magazines: %1", _magazines];
diag_log format ["Launchers: %1", _launchers];
diag_log format ["Throwables : %1", _throwables];
diag_log format ["Explosives: %1", _explosives];
diag_log format ["Tools: %1", _tools];
diag_log format ["Medical: %1", _medical];
diag_log format ["Helmets: %1", _headgear];
diag_log format ["Uniforms: %1", _uniforms];
diag_log format ["Vests: %1", _vests];
diag_log format["Backpacks: %1", _backpacks];
diag_log format ["Binoculars: %1", _binos];
diag_log format["Radios: %1", _radios];
diag_log format ["Misc: %1", _misc];
*/

[_weapons, _magazines, _launchers, _acc, _throwables , _explosives, _tools, _medical, _headgear, _uniforms, _vests, _backpacks, _binos, _radios, _misc]