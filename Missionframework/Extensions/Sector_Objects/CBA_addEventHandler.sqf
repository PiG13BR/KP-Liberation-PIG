// Create sectors objects
["KPLIB_createSectorObjects", {
    params["_sector"];

    if (isNil "KPLIB_sectorsObjectsToManage") then {KPLIB_sectorsObjectsToManage = createHashMap};

    private _objects = [_sector] call KPLIB_fnc_createSectorObjects;
    [format["Sector: %1, Objects Count: %2", _sector, count _objects], "SECTOR OBJECTS CREATION"] call KPLIB_fnc_log;
    
    // Check for not deleted registered objects
    private _initObjects = [];
    if (_sector in KPLIB_sectorMapObject_hashMap) then {
        _initObjects = KPLIB_sectorMapObject_hashMap get _sector;
    };

    _objects = _objects + _initObjects;
    // Create static weapons
    private _staticWeapons = [_sector, _objects] call KPLIB_fnc_createStaticWeapons;

    // Create static vehicle
    private _staticVehicles = [_sector, _objects] call KPLIB_fnc_createStaticVehicles;

    // Add all sectors objects into hashmaps to be deleted later
    {
        if (_sector in KPLIB_sectorsObjectsToManage) then {
            private _objectsArray = KPLIB_sectorsObjectsToManage get _sector;
            _objectsArray pushBack _x;
            KPLIB_sectorsObjectsToManage set [_sector, _objectsArray]
        } else {
            KPLIB_sectorsObjectsToManage set [_sector, [_x]]
        }
    }forEach (_objects + _staticWeapons + _staticVehicles);
}] call CBA_fnc_addEventHandler;

// Delete sector objects
["KPLIB_DeleteSectorObjects", {
    params["_sector"];

    private _sectorObjects = KPLIB_sectorsObjectsToManage getOrDefault [_sector, []];
    if (_sectorObjects isEqualTo []) exitWith {};
    {
        if (count (crew _x) <= 0) then {
            [_x] call KPLIB_fnc_despawnObject;
        } else {
            [group _x] call KPLIB_fnc_despawnGroup;
            [_x] call KPLIB_fnc_despawnObject;
        };
    }forEach _sectorObjects;

    KPLIB_sectorsObjectsToManage deleteAt _sector // Clear sector key
}] call CBA_fnc_addEventHandler;

