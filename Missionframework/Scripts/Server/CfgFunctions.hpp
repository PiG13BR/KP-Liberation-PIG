class server_highcommand {
    file = "Scripts\Server\highcommand";

    class highcommand                   {ext = ".fsm";};
};

class server_sector {
    file = "Scripts\Server\sector";

    class destroyFob                    {};
    class sectorMonitor                 {ext = ".fsm";};
    class spawnSectorCrates             {};
    class spawnSectorIntel              {};
};

class server_support {
    file = "Scripts\Server\support";

    class createSuppModules             {};
};