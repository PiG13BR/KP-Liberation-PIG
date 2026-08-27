/*
    File: fn_linkItemsToUnlock.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 29/07/2026
    Last Update: 26/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Link items to designated sectors

    Parameter(s):
        -

    Returns:
        -
*/

// Arsenal lock Crosscheck
KPLIB_sector_arsenalLink = KPLIB_sector_arsenalLink select {
    _x params ["_marker", "_items"];
    ((KPLIB_b_lockedArsenal apply {_x#0}) find _marker >= 0)
    && {_marker in KPLIB_sectors_all}
};

private _lockedArsenalCount = count KPLIB_sector_arsenalLink;
if ((_lockedArsenalCount < (count KPLIB_sectors_all)) && (_lockedArsenalCount < (count KPLIB_b_lockedArsenal))) then {

    private _assignedSector = [];
    private _nextArsenal = "";
    private _nextSector = "";

    /*
    private _assignedArsenal = KPLIB_sector_arsenalLink apply {
        _assignedArsenal pushBack (_x select 0);
        (_x select 1);
    };
    */

    // Add new entries, when there are elite vehicles and military sectors are not yet assigned 
    {
        _x params ["_nextSector", "_nextArsenal"];

        if (_nextSector isEqualTo "") then {
            // Select a random base
            _nextSector = selectRandom ((KPLIB_sectors_military) - _assignedSector);
            _assignedSector pushBack _nextSector;
        } else {
            _assignedSector pushBack _nextSector;
        };

        KPLIB_sector_arsenalLink pushBack [_nextSector, _nextArsenal];
    }forEach KPLIB_b_lockedArsenal;

    ["Additional sectors or unlockable arsenal detected and assigned", "SAVE"] call KPLIB_fnc_log;
};

_lockedArsenalHash = createHashMapFromArray [];

{
    _lockedArsenalHash set [_x # 0, _x # 1];
}forEach KPLIB_sector_arsenalLink;

// It's now a hashmap
KPLIB_sector_arsenalLink = _lockedArsenalHash;

[format["Sectors with arsenal link: %1", (keys KPLIB_sector_arsenalLink) apply {markerText _x}], "ARSENAL LINK"] call KPLIB_fnc_log;