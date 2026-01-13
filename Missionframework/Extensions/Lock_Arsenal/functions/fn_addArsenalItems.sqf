/*
    File: fn_addArsenalItems.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 04/12/2025
    Last Update: 05/12/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Add items to arsenal midgame

    Parameter(s):
        _items - items to add [ARRAY]

    Returns:
        -
*/
params["_items"];

private _weaponsToUnlock = [];
private _itemsToUnlock = [];
private _magazinesToUnlock = [];
private _backpackToUnlock = [];
{
    if (isClass(configFile >> "cfgWeapons" >> _x)) then {
        if (_x isKindOf ["RifleCore", configFile >> "cfgWeapons"] || _x isKindOf ["PistolCore", configFile >> "cfgWeapons"] || _x isKindOf ["LauncherCore", configFile >> "cfgWeapons"]) then {
            _weaponsToUnlock pushBack _x;
            KPLIB_arsenalAllowed pushBack (toLowerANSI _x);
        } else {
            if (_x isKindOf ["ItemCore", configFile >> "cfgWeapons"]) then {
                _itemsToUnlock pushBack _x;
                KPLIB_arsenalAllowed pushBack (toLowerANSI _x);
            } else {
                [format["Couldn't check the type for %1", _x], "ADD ARSENAL"] call KPLIB_fnc_log;
            }
        };
        continue
    };

    if (isClass(configFile >> "cfgMagazines" >> _x)) then {
        _magazinesToUnlock pushBack _x;
        KPLIB_arsenalAllowed pushBack (toLowerANSI _x);
        continue
    };

    if (isClass(configFile >> "cfgVehicles" >> _x)) then {
        _backpackToUnlock pushBack _x;
        
        continue
    };
    
    [format["Couldn't check the config class for %1", _x], "ADD ARSENAL"] call KPLIB_fnc_log;
}forEach _items;

[missionNamespace, _weaponsToUnlock] call BIS_fnc_addVirtualWeaponCargo;
KPLIB_arsenalAllowed append (_weaponsToUnlock apply {toLowerANSI _x});

[missionNamespace, _itemsToUnlock] call BIS_fnc_addVirtualItemCargo;
KPLIB_arsenalAllowed append (_itemsToUnlock apply {toLowerANSI _x});

[missionNamespace, _magazinesToUnlock] call BIS_fnc_addVirtualMagazineCargo;
KPLIB_arsenalAllowed append (_magazinesToUnlock apply {toLowerANSI _x});

[missionNamespace, _backpackToUnlock] call BIS_fnc_addVirtualBackpackCargo;
KPLIB_arsenalAllowed append (_backpackToUnlock apply {toLowerANSI _x});
if (KPLIB_ace && KPLIB_param_arsenalType) then {[player, KPLIB_arsenalAllowed, false] call ace_arsenal_fnc_addVirtualItems;};