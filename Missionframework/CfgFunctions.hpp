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

        class battlegroupAttackHeli     {};
        class battlegroupIncoming       {};
        class battlegroupInfantry       {};
        class battlegroupJet            {};
        class battlegroupLandVehicle    {};
        class battlegroupParatroopers   {};
        class battlegroupTransportHeli  {};
        class battlegroupSlingLoadVeh   {};
        class findPlaceToLand           {};
        class findPlaceToParadrop       {};
        class handleLandTransport       {};
        class infantryAttack            {};
        class spawnBattlegroup          {};
        class spawnInfCargo             {};
        class vehicleAttack             {};
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
        class enforceZeusWhitelist      {};
    };
    class Fob {
        file = "Functions\fob";
        
        class addActionsFob             {};
        class addActionsOutpost         {};
        class createFob                 {};
        class createOutpost             {};
        class destroyFob                {};
        class destroyOutpost            {};
        class getBaseName               {};
        class getBaseResources          {};
        class getNearestFob             {};
        class getNearestPlayerBase      {};
        class getNearestBuildPos        {};
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
        class addDefenseWaypoints       {};
        class addObjectInit             {};
        class addRopeAttachEh           {};
        class AHDNC_init                {postInit=1;};
        class AHDNC_perFrame            {};
        class AHDNC_perSecond           {};
        class allowCrewInImmobile       {};
        class applyDefaultPermissions   {};
        class checkClass                {};
        class cleanOpforVehicle         {};
        class cleanUpVehicles           {};
        class clearCargo                {};
        class clearGarbage              {};
        class createClearance           {};
        class createClearanceConfirm    {};
        class despawnGroup              {};
        class despawnObject             {};
        class fullHeal                  {};
        class getAdaptiveVehicle        {};
        class getMilitaryId             {};
        class getNearbyEntities         {};
        class getNearestViVTransport    {};
        class getOpforCap               {};
        class getOpforFactor            {};
        class getResistanceTier         {};
        class getUnitPositionId         {};
        class getUnitsCount             {};
        class hint                      {};
        class hintTowerInfo             {};
        class huronManager              {};
        class lambs_enableReinforcements{};
        class protectObject             {};
        class setLoadableViV            {};
        class skipBriefing              {preInit = 1;};
        class vehPermissions            {};

    };
    class Player {
        file = "Functions\player";

        class addActionsPlayer          {};
        class addPlayerEH               {};
        class enforceCmdrWhitelist      {};
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
        class factoriesBlock            {};
        class factoryBlockedPFH         {};
        class factoryBuildFacility      {};
        class factoryProduceResource    {};
        class factoryProductionInit     {};
        class factoryProductionPFH      {};
        class registerStorageSector     {};
        class selectFactoryToBlock      {};
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
        class getAllStorages            {};
        class hintResourcesFactory      {};
        class hintResourcesFob          {};
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
        class linkItemsToUnlock         {};
        class linkVehToUnlock           {};
        class getSaveData               {};
        class loadSavedGame             {};
        class setSavedPermissions       {};
        class spawnSavedFactoryStorage  {};
        class spawnSavedObject          {};
        class spawnSavedStorage         {};      
    }
    class Sector {
        file = "Functions\sector";

        class activateSector            {};
        class airportCounterAttack      {};
        class deactivateSector          {};
        class findSectorGarrisons       {};
        class fillerAASpawns            {};
        class fillerInfSpawns           {};
        class getBluforObjective        {};
        class getLocationName           {};
        class getNearestBluforObjective {};
        class getNearestSector          {};
        class getNearestMilitaryBase    {};
        class getNearestTower           {};
        class getSectorOwnership        {};
        class getSectorRange            {};
        class initAirportSector         {};
        class initSectors               {};
        class isCapitalActive           {};
        class liberatedSector           {};
        class manageSectorPFH           {};
        class prepareSector             {};
        class replenishFiller           {};
        class sectorAirportSpawns       {};
        class sectorCapitalSpawns       {};
        class sectorCitySpawns          {};
        class sectorCounterAttack       {};
        class sectorFactorySpawns       {};
        class sectorMilitarySpawns      {};
        class sectorTowerSpawns         {};
        class setSectorColors           {};
        class setSectorLinks            {};
        
    };
    class Spawn {
        file = "Functions\spawn";

        class createCrate               {};
        class createCrew                {};
        class createManagedUnit         {};
        class forceStaticCrew           {};
        class getOpforRoadSpawnPoint    {};
        class getOpforSpawnPoint        {};
        class getSquadComp              {};
        class spawnBoatPatrol           {};
        class spawnBuildingGarrison     {};
        class spawnCivilians            {};
        class spawnGarrisonUnit         {};
        class spawnGuerillaGroup        {};
        class spawnGuerInFactory        {};
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

        class overlayManager            {};
        class overlayUpdateResources    {};
        
    };
    class TeamSpeak {
        file = "Extensions\TeamSpeak";

        class TeamSpeakCheck            {};
    };


    #include "Functions\do_build\cfgFunctions.hpp"

    #include "Scripts\Client\CfgFunctions.hpp"
    #include "Scripts\Server\CfgFunctions.hpp"

    // Interfaces
    #include "Interface\Build\cfgFunctions.hpp"
    #include "Interface\Permissions\Build_Permissions\cfgFunctions.hpp"
    #include "Interface\Permissions\General_Permissions\cfgFunctions.hpp"
    #include "Interface\Production\cfgFunctions.hpp"
    #include "Interface\Recycle\cfgFunctions.hpp"
    #include "Interface\Redeploy\cfgFunctions.hpp"
    #include "Interface\Repackage\cfgFunctions.hpp"

    // Extensions
    #include "Extensions\Arty_Framework\cfgFunctions.hpp"
    #include "Extensions\Arty_Menu\cfgFunctions.hpp"
    #include "Extensions\Base_Name\cfgFunctions.hpp"
    #include "Extensions\Clear_Brushes\cfgFunctions.hpp"
    #include "Extensions\Discord_Log\cfgFunctions.hpp"
    #include "Extensions\Drone_Jammer\cfgFunctions.hpp"
    #include "Extensions\Enemy_Fighters\cfgFunctions.hpp"
    #include "Extensions\Enemy_Mines\cfgFunctions.hpp"
    #include "Extensions\Enemy_QRF\cfgFunctions.hpp"
    #include "Extensions\Lock_Arsenal\cfgFunctions.hpp"
    #include "Extensions\Player_Menu\KPPLM\KPPLM_functions.hpp"
    #include "Extensions\Pylon_Armament_Selector\cfgFunctions.hpp"
    #include "Extensions\Rally_Point\cfgFunctions.hpp"
    #include "Extensions\SAM_Sites\cfgFunctions.hpp"
    #include "Extensions\Sector_Objects\cfgFunctions.hpp"
    #include "Extensions\Sector_Events\cfgFunctions.hpp"
    #include "Extensions\Supply_Menu\cfgFunctions.hpp"
};

class KPPLM {
    // Extensions
    #include "Extensions\Player_Menu\KPPLM\KPPLM_functions.hpp"
};