# SECTOR OBJECTS AND STATIC WEAPONS

## DESCRIPTION
- This framework handles objects near sectors, spawned in the editor. It saves and delete them from the startgame.
- This is aimed for the mission maker to make unique sectors.
- The objects will spawn once the sector is activated (if it was not captured by the players), and will despawn if the sector is deactivated.
- It also manages the spawning of static weapons/vehicles for configurated buildings in `KPLIB_staticsConfigs.sqf`. Once the object spawned in a sector, a script detects if the building can spawn static weapons or static vehicles.
- The objects and static weapons are managed by the sector script itself.

## DISCLAIMER
- The first sketch of this framework was designed to get all spawned objects near a sector automatically, and you could put those buildings in a blacklist to stop from beign deleted at game start. But further tests with this model, showed me some flaws, like spawning double objects (with this method a sector can spawn another sector's object) and putting them into a blacklist was just bad. So I think it's just easy (with less posible problems) if you want some object to be in the scenario, you just spawn them, and if you want the framework to manage them and spawn static weapons, you have to put them in the whitelist.

## HOW TO
- To register a structure in the map, you must put in its init this line:
    - `[this] call KPLIB_fnc_registerSectorObject`.
- Only objects close enough to sectors will be registered (KPLIB_objectsGrabber_radius). If the object isn't near any sectors, it will not be registered, and it will be deleted from the map.
- Objects classnames under KPLIB_staticsConfigs.sqf have an option to disable static weapons/vehicles from spawning it.
    - `[this, false] call KPLIB_fnc_registerSectorObject`.
- The deletion of the registered object in the beginning of the mission can be disabled. In this case, a different variable will manage those objects. This is crucial to able the spawning of static weapons/vehicles in those buildings once the sectors activates:
    - `[this, true, false] call KPLIB_fnc_registerSectorObject`.
- As default, map objects classnames that matches those in `KPLIB_staticsConfigs.sqf` will NOT spawn any static weapon nor vehicles. In theory, you can call the function in those map structures by getting the object data type by using Game Logic and the command nearObjects/nearObject.