/*
    File: fn_removeArsenalItems.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 04/12/2025
    Last Update: 05/12/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Remove items from arsenal midgame

    Parameter(s):
        _items - items to add [ARRAY]

    Returns:
        -
*/
params["_items"];

private _weaponsToLock = [];
private _itemsToLock = [];
private _magazinesToLock = [];
private _backpackToLock = [];
{
    if (isClass(configFile >> "cfgWeapons" >> _x)) then {
        if (_x isKindOf ["RifleCore", configFile >> "cfgWeapons"] || _x isKindOf ["PistolCore", configFile >> "cfgWeapons"] || _x isKindOf ["LauncherCore", configFile >> "cfgWeapons"]) then {
            _weaponsToLock pushBack _x;
            KPLIB_arsenalAllowed pushBack (toLowerANSI _x);
        } else {
            if (_x isKindOf ["ItemCore", configFile >> "cfgWeapons"]) then {
                _itemsToLock pushBack _x;
                KPLIB_arsenalAllowed pushBack (toLowerANSI _x);
            } else {
                [format["Couldn't check the type for %1", _x], "REMOVE ARSENAL"] call KPLIB_fnc_log;
            }
        };
        continue
    };

    if (isClass(configFile >> "cfgMagazines" >> _x)) then {
        _magazinesToLock pushBack _x;
        KPLIB_arsenalAllowed pushBack (toLowerANSI _x);
        continue
    };

    if (isClass(configFile >> "cfgVehicles" >> _x)) then {
        _backpackToLock pushBack _x;
        
        continue
    };
    
    [format["Couldn't check the config class for %1", _x], "REMOVE ARSENAL"] call KPLIB_fnc_log;
    
}forEach _items;

[missionNamespace, _weaponsToLock] call BIS_fnc_removeVirtualWeaponCargo;
{
    KPLIB_arsenalAllowed deleteAt (KPLIB_arsenalAllowed find _x);
}forEach (_weaponsToLock apply {toLowerANSI _x});

[missionNamespace, _itemsToLock] call BIS_fnc_removeVirtualItemCargo;
{
    KPLIB_arsenalAllowed deleteAt (KPLIB_arsenalAllowed find _x);
}forEach (_itemsToLock apply {toLowerANSI _x});

[missionNamespace, _magazinesToLock] call BIS_fnc_removeVirtualMagazineCargo;
{
    KPLIB_arsenalAllowed deleteAt (KPLIB_arsenalAllowed find _x);
}forEach (_magazinesToLock apply {toLowerANSI _x});

[missionNamespace, _backpackToLock] call BIS_fnc_removeVirtualBackpackCargo;
{
    KPLIB_arsenalAllowed deleteAt (KPLIB_arsenalAllowed find _x);
}forEach (_backpackToLock apply {toLowerANSI _x});

if (KPLIB_ace && KPLIB_param_arsenalType) then {[player, _weaponsToLock + _itemsToLock + _magazinesToLock + _backpackToLock, false] call ace_arsenal_fnc_removeVirtualItems;};