if (KPLIB_param_SectorEvents) then {
    sector_events = compile preprocessFileLineNumbers "Extensions\Sector_Events\events\custom.sqf";
};

// Exit on event not found
if (isNil "sector_events") exitWith {[format["No sector events found for %1", worldName], "SECTOR EVENTS"] call KPLIB_fnc_log};

[format["Sector events registered for %1", worldName], "SECTOR EVENTS"] call KPLIB_fnc_log;