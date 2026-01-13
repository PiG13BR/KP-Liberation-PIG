// FOB Builded
["KPLIB_fobBuilded", {
    params["_newFob", "_create_fob_building"];
    
    [{
        params["_newFob", "_create_fob_building"];

        _newFob allowDamage false; 
        private _newFobPos = getPosATL _newFob;
        [_newFobPos, _create_fob_building] spawn build_fob_remote_call;
    }, [_newFob, _create_fob_building]] call CBA_fnc_execNextFrame;

}] call CBA_fnc_addEventHandler;

// Build object (server event)
["KPLIB_buildObject",{
    params["_objectClass", "_objPos", "_objDir", "_vector", "_buildType", "_withCrew", "_player", ["_repeat", false]];

    private _newObject = _this call KPLIB_fnc_spawnBuildedObject;

    if (_repeat) then {
        // Repeat building process
        ["KPLIB_repeatBuild", [_newObject, _player], _player] call CBA_fnc_targetEvent;
    }
}] call CBA_fnc_addEventHandler;

// Repeat build (target event)
["KPLIB_repeatBuild", {
    params["_repeatObject", "_player"];

    [_repeatObject, _player] call KPLIB_fnc_spawnRepeatedObject;

    // Call camera assist again if it's on
    if !(isNull (_player getVariable ["KPLIB_BUILD_camera", objNull])) then {
        [_player] call KPLIB_fnc_buildCameraAssist;
    };
}] call CBA_fnc_addEventHandler;

// Factory storage builded
["KPLIB_factoryStorageBuilded", { 
    _this call KPLIB_fnc_registerStorageSector;
}] call CBA_fnc_addEventHandler;