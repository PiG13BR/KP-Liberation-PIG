/*
    When a sector is captured, KPLIB_sectorLiberated event is raised (server side)
    Use this to execute an unique event to a liberated sector
*/

// CBA Add EH
["KPLIB_sectorLiberated", {

    if (isNil "KPLIB_sectorLiberated") then {
        KPLIB_sectorLiberated = [];
        publicVariable "KPLIB_sectorLiberated";
    };

    if (_this in KPLIB_sectorLiberated) exitWith {}; // Do not repeat the event for x sector
    
    // Add sector to the liberated array
    if !(_this in KPLIB_sectorLiberated) then {
        KPLIB_sectorLiberated pushBackUnique _this; 
    };

    [_this] call sector_events;
}] call CBA_fnc_addEventHandler;
