class KPLIB {

    class Blufor {
        file = "Functions\blufor";

        class getBluforRatio            {};
        class getGroupType              {};
        class getLocalCap               {};
        class getMobileRespawns         {};
        class getMobileRespawnName      {};
        class isClassUAV                {};
        class potatoScan                {};
        class setVehicleCaptured        {};
        class setVehicleSeized          {};
        
    };
    class Battlegroup {
        file = "Functions\battlegroup";

        class battlegroupAttack         {};
        class battlegroupAttackHeli     {};
        class battlegroupIncoming       {};
        class battlegroupInfantry       {};
        class battlegroupJet            {};
        class battlegroupLandVehicle    {};
        class battlegroupParatroopers   {};
        class battlegroupTransportHeli  {};
        class handleLandTransport       {};
        class spawnBattlegroup          {};
        class spawnInfCargo             {};
    };
    class Cargo {
        file = "Functions\cargo";

        class addParadropAction         {};
        class doLoadCrate               {};
        class doParadropCrate           {};
        class doUnloadCrate             {};
        class setCargoVehConfig         {};
    };
    class Curator {
        file = "Functions\curator";

        class handlePlacedZeusObject    {};
    };
    class Fob {
        file = "Functions\fob";
        class addActionsFob             {};
        class getFobName                {};
        class getFobResources           {};
        class getNearestFob             {};
        class setFobMass                {};

    };
    class Gear {
        file = "Functions\gear";

        class checkGear                 {};
        class checkWeaponCargo          {};
        class crawlAllItems             {};
        class getLoadout                {};
        class getWeaponComponents       {};
        class isRadio                   {};
        class setLoadout                {};
        class swapInventory             {};
    };
    class Misc {
        file = "Functions\misc";

        class ace_isAwake               {};
        class addActionsFullHeal        {};
        class addObjectInit             {};
        class addRopeAttachEh           {};
        class allowCrewInImmobile       {};
        class checkClass                {};
        class cleanOpforVehicle         {};
        class clearCargo                {};
        class clearGarbage              {};
        class createClearance           {};
        class createClearanceConfirm    {};
        class despawnGroup              {};
        class despawnObject             {};
        class fullHeal                  {};
        class getAdaptiveVehicle        {};
        class getMilitaryId             {};
        class getNearestViVTransport    {};
        class getOpforCap               {};
        class getOpforFactor            {};
        class getResistanceTier         {};
        class getUnitPositionId         {};
        class getUnitsCount             {};
        class hint                      {};
        class lambs_enableReinforcements{};
        class protectObject             {};
        class setLoadableViV            {};
        class skipBriefing              {preInit = 1;};

    };
    class Player {
        file = "Functions\player";

        class addActionsPlayer          {};
        class addPlayerEH               {};
        class getNearbyPlayers          {};
        class getCommander              {};
        class getPlayerCount            {};
        class hasPermission             {};

    };
    class Prisonner {
        file = "Functions\prisonner";

        class addActionCapture          {};
        class addActionDeliver          {};
        class prisonnerCheckPFH         {};
        class prisonnerDeliver          {};
        class prisonnerEscape           {};
        class setCapturable             {};
    };
    class Production {
        file = "Functions\production";

        class addFactoryProduction      {};
        class changeFactoryProduction   {};
        class factoryBuildFacility      {};
        class factoryProduceResource    {};
        class factoryProductionInit     {};
        class factoryProductionPFH      {};
        class registerStorageSector     {};
        class setFactoryFacility        {};
        class updateProductionValues    {};
    };
    class Civilian_Reputation {
        file = "Functions\reputation";

        class crAddAceAction            {};
        class crGetMulti                {};
        class crGlobalMsg               {}; 
    };
    class Resources {
        file = "Functions\resources";

        class addActionsCrate           {};
        class doRecycle                 {};
        class recalculateResources      {};
        class recalculateResourcesInit  {};
        class recalculateResourcesPFH   {};
        class recycleResources          {};
        class restoreResources          {};
        class subtractResources         {};
    };
    class Save {
        file = "Functions\Save";

        class autoSavePFH               {};
        class doSave                    {};
        class getSaveableParam          {};
        class getSaveData               {};
        class loadSavedGame             {};
    }
    class Sector {
        file = "Functions\sector";

        class activateSector            {};
        class deactivateSector          {};
        class findSectorGarrisons       {};
        class getBluforObjective        {};
        class getLocationName           {};
        class getNearestBase            {};
        class getNearestBluforObjective {};
        class getNearestSector          {};
        class getNearestTower           {};
        class getSectorOwnership        {};
        class getSectorRange            {};
        class initSectors               {};
        class isCapitalActive           {};
        class liberatedSector           {};
        class manageSectorPFH           {};
        class prepareSector             {};
        class replenishOutpost          {};
        class sectorCapitalSpawns       {};
        class sectorCitySpawns          {};
        class sectorFactorySpawns       {};
        class sectorOutpostSpawns       {};
        class sectorMilitarySpawns      {};
        class sectorTowerSpawns         {};
        class spawnBoatPatrol           {};
        
    };
    class Spawn {
        file = "Functions\spawn";

        class createCrate               {};
        class createCrew                {};
        class createManagedUnit         {};
        class forceBluforCrew           {};
        class getOpforRoadSpawnPoint    {};
        class getOpforSpawnPoint        {};
        class getSquadComp              {};
        class spawnBuildingGarrison     {};
        class spawnCivilians            {};
        class spawnGarrisonUnit         {};
        class spawnGuerillaGroup        {};
        class spawnMilitiaCrew          {};
        class spawnRegularSquad         {};
        class spawnVehicle              {};

    };
    class Storage {
        file = "Functions\storage";

        class addActionsStorage         {};
        class checkCrateValue           {};
        class crateFromStorage          {};
        class crateToStorage            {};
        class fillStorage               {};
        class getCrateHeight            {};
        class getStorageLimit           {};
        class getStorageValues          {};
        class isStorageFull             {};
        class sortStorage               {};

    };
    class System {
        file = "Functions\system";
        
        class log                       {};
        class secondsToTimer            {};
        class setDiscordState           {};
        class getLessLoadedHC           {};
        class taskCreation              {};
    }; 
    class functions_ui {
        file = "Functions\ui";

        class overlayUpdateResources    {};
    };

    #include "Functions\do_build\cfgFunctions.hpp"

    #include "Scripts\Client\CfgFunctions.hpp"
    #include "Scripts\Server\CfgFunctions.hpp"

    // Interfaces
    #include "Interface\Build\cfgFunctions.hpp"
    #include "Interface\Production\cfgFunctions.hpp"
    #include "Interface\Recycle\cfgFunctions.hpp"
    #include "Interface\Redeploy\cfgFunctions.hpp"

    // Extensions
    #include "Extensions\Arty_Framework\cfgFunctions.hpp"
    #include "Extensions\Arty_Menu\cfgFunctions.hpp"
    #include "Extensions\Clear_Brushes\cfgFunctions.hpp"
    #include "Extensions\Lock_Arsenal\cfgFunctions.hpp"
    #include "Extensions\Player_Menu\KPPLM\KPPLM_functions.hpp"
    #include "Extensions\Pylon_Manager\cfgFunctions.hpp"
    #include "Extensions\Rally_Point\cfgFunctions.hpp"
    #include "Extensions\SAM_Sites\cfgFunctions.hpp"
    #include "Extensions\Sector_Objects\cfgFunctions.hpp"
    #include "Extensions\Sector_Events\cfgFunctions.hpp"
    #include "Extensions\Supply_Menu\cfgFunctions.hpp"
};