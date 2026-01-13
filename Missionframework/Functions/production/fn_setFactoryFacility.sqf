/*
    File: fn_setFactoryFacility.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 19/11/2025
    Last Update: 19/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Set facility production for each factory and update factory markers at game start 

    Parameter(s):
        -

    Returns:
        -
*/

if !(count KPLIB_production_markers > 0) then {
    // Set up production facility at factories marker at game start
    {
        private _sector = _x;
        private _facility = [];
        
        switch (true) do {
            case ((_x find "supply") >= 0) : {_facility = [true,false,false]};
            case ((_x find "ammo") >= 0) : {_facility = [false,true,false]};
            case ((_x find "fuel") >= 0) : {_facility = [false,false,true]};
            default {_facility = selectRandom [[true,false,false], [false,true,false], [false,false,true]];};
        };
        KPLIB_production_markers set [_sector, [_facility # 0, _facility # 1, _facility # 2, markerText _sector]];
    } forEach KPLIB_sectors_factory;

    publicVariable "KPLIB_production_markers";
};

// Update all factory markers at game start
{
    private _sector = _x;
    
    private _markerText = (_y # 3) + " [";
    if (_y # 0) then {_markerText = _markerText + "S";}; // Can produce supply
    if (_y # 1) then {_markerText = _markerText + "A";}; // Can produce ammo
    if (_y # 2) then {_markerText = _markerText + "F";}; // Can produce fuel
    _markerText = _markerText + "]";

    _sector setMarkerText _markerText;
}forEach KPLIB_production_markers;