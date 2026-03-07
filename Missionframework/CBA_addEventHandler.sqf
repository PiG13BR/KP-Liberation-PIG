if (isServer) then {
    // Server events
    #include "Scripts\Server\CBA_addEventHandler.sqf"
};

if (!isDedicated && hasInterface) then {
    #include "Scripts\Client\CBA_addEventHandler.sqf"
};

#include "Scripts\Shared\CBA_addEventHandler.sqf"
#include "Functions\do_build\CBA_addEventHandler.sqf"

// Extensions
if (KPLIB_param_enemyArtillery) then {
    #include "Extensions\Arty_Framework\CBA_addEventHandler.sqf";
};

if (KPLIB_param_lockArsenal > 0) then {
    #include "Extensions\Lock_Arsenal\CBA_addEventHandler.sqf";
};

if (KPLIB_param_rallyPoint && KPLIB_ace) then {
    #include "Extensions\Rally_Point\CBA_addEventHandler.sqf";
};

if (KPLIB_param_ArtyMenu && KPLIB_ace) then {
    #include "Extensions\Arty_Menu\CBA_addEventHandler.sqf";
};

if (KPLIB_param_sectorEvents > 0) then {
    #include "Extensions\Sector_Events\CBA_addEventHandler.sqf";
};

if (KPLIB_param_enemyFighters) then {
    #include "Extensions\Enemy_Fighters\CBA_addEventHandler.sqf";
};

#include "Extensions\Sector_Objects\CBA_addEventHandler.sqf"