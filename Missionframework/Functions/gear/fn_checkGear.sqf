/*
    File: fn_checkGear.sqf
    Author: ThomasAngel (Original by KP Liberation Dev Team - https://github.com/KillahPotatoes), PiG13BR - https://github.com/PiG13BBR
    Steam: https://steamcommunity.com/id/Thomasangel/
    Github: https://github.com/rekterakathom
    Date: 2021-12-27
    Last Update: 2026-01-21
    Description:
        Completely rewritten version of the original checkGear by KillahPotatoes.
        Identical functionality.
        Checks the players gear for blacklisted items.
        Found items are removed from the loadout.
        Furthermore a hint with the found items is displayed to the player
        while a server log entry is created for the admin.
    Parameter(s):
        -
    Returns:
        Player checked without findings [BOOL]
*/

private _removedItems = [];
private _uniqueUnitItems = uniqueUnitItems [player];
private _allowedItems = KPLIB_arsenalAllowed;

// Loop through all units items and remove non-allowed items.
{
    private _currentElement = toLowerANSI _x;
    if !(_currentElement in _allowedItems) then {
        if (([_x] call KPLIB_fnc_isRadio)) exitWith {};
        _removedItems pushBack _x;
        switch _x do {
            case (headgear player): {removeHeadgear player};
            case (goggles player): {removeGoggles player};
            case (uniform player): {removeUniform player};
            case (vest player): {removeVest player};
            case (backpack player): {removeBackpack player};
            default {player removeItems _x}
        };

        // Weapons cross check
        {
            if (_currentElement == _x) then {player removeWeapon _x};
        }forEach (weapons player);
    };
} forEach _uniqueUnitItems;

// Check weapon items
private _weapons = (weapons player);
if (_weapons isNotEqualTo []) then {
    {   
        private _acc = player weaponAccessories _x;
        {
            private _currentElement = toLowerANSI _x;

            if !(_currentElement in _allowedItems) then {
                player removePrimaryWeaponItem _currentElement;
            };   
        }forEach _acc;
    }forEach _weapons;
};

// Show hint and log list, if something was found
if (_removedItems isNotEqualTo []) exitWith {
    [format ["Found %1 at player %2", _removedItems, name player], "BLACKLIST"] remoteExecCall ["KPLIB_fnc_log", 2];
    [format [localize "STR_BLACKLISTED_ITEM_FOUND", _removedItems joinString "\n"], true, 6] call KPLIB_fnc_hint;
    false
};

true