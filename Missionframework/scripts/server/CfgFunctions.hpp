class server_highcommand {
    file = "Scripts\Server\highcommand";

    class highcommand                   {ext = ".fsm";};
};

class server_sector {
    file = "Scripts\Server\sector";

    class sectorMonitor                 {ext = ".fsm";};
    class spawnSectorCrates             {};
    class spawnSectorIntel              {};
};

class server_support {
    file = "Scripts\Server\support";

    class createSuppModules             {};
};

class server_civ_rep {
    file = "Scripts\Server\civrep\fnc";

    class cr_changeCR {};
    class cr_getBuildings {};
    class cr_liberatedSector {};
    class cr_woundedCivs {};
    class cr_woundedAnim {};
};

class server_civ_informant {
    file = "Scripts\Server\civinformant\tasks";

    class civinfo_task {};
};

class server_asymmetric {
    file = "Scripts\Server\asymmetric\functions";

    class asymSectorAmbush {};
    class logisticConvoyAmbush {};
    class manageAsymIED {};
    class sectorGuerrilla {};
};