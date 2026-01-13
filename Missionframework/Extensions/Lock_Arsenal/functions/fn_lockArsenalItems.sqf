/*
    File: fn_lockArsenalItems.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 04/12/2025
    Last Update: 05/12/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Get lock arsenal preset and apply it if the linked sector wasn't captured.
        The locked items will be removed from the player's arsenal.

    Parameter(s):
        _items - items to add [ARRAY]

    Returns:
        -
*/

// Case sensitive failsafe
private _sectorsPlayer = KPLIB_sectors_player apply {toLowerANSI _x};

// Update arsenal variables with config class
{
    private _sector = _x;
    private _items = _y;

    // Check for enemy sector to lock items
    if !(toLowerANSI(_sector) in _sectorsPlayer) then {
        {
            if (isClass(configFile >> "cfgWeapons" >> _x)) then {
                if (_x isKindOf ["RifleCore", configFile >> "cfgWeapons"] || _x isKindOf ["PistolCore", configFile >> "cfgWeapons"] || _x isKindOf ["LauncherCore", configFile >> "cfgWeapons"]) then {
                    KPLIB_arsenalWeapons deleteAt ((KPLIB_arsenalWeapons apply {toLowerANSI _x}) find (toLowerANSI _x)) 
                } else {
                    if (_x isKindOf ["ItemCore", configFile >> "cfgWeapons"]) then {
                        KPLIB_arsenalItems deleteAt ((KPLIB_arsenalItems apply {toLowerANSI _x}) find (toLowerANSI _x)) 
                    } else {
                        [format["Couldn't check the type for %1", _x], "ARSENAL LOCK"] call KPLIB_fnc_log;
                    }
                };
                continue
            };

            if (isClass(configFile >> "cfgMagazines" >> _x)) then {
                KPLIB_arsenalMagazines deleteAt ((KPLIB_arsenalMagazines apply {toLowerANSI _x}) find (toLowerANSI _x));
                continue
            };

            if (isClass(configFile >> "cfgVehicles" >> _x)) then {
                KPLIB_arsenalBackpacks deleteAt ((KPLIB_arsenalBackpacks apply {toLowerANSI _x}) find (toLowerANSI _x));
                continue
            };
            
            [format["Couldn't check the config class for %1", _x], "ARSENAL LOCK"] call KPLIB_fnc_log;
        }forEach _items;
    };
}forEach KPLIB_sector_arsenalLink;