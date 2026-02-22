scriptName "huron_manager";

waitUntil {!isNil "KPLIB_saveLoaded"};
waitUntil {KPLIB_saveLoaded};

KPLIB_potato01 = objNull;

// Detect possible Potato 01 from loaded save data
private _savedPotato = vehicles select {(toLowerANSI (typeOf _x)) isEqualTo (toLowerANSI KPLIB_b_potato01)};
if !(_savedPotato isEqualTo []) then {
    KPLIB_potato01 = _savedPotato select 0;
};

// Spawn new huron if not loaded or destroyed
if !(alive KPLIB_potato01) then {
    KPLIB_potato01 = KPLIB_b_potato01 createVehicle [(getposATL huronspawn) select 0, (getposATL huronspawn) select 1, ((getposATL huronspawn) select 2) + 0.2];
    KPLIB_potato01 enableSimulationGlobal false;
    KPLIB_potato01 allowdamage false;
    KPLIB_potato01 setDir (getDir huronspawn);
    KPLIB_potato01 setPosATL (getposATL huronspawn);
    KPLIB_potato01 setDamage 0;
    sleep 0.5;
    KPLIB_potato01 enableSimulationGlobal true;
    KPLIB_potato01 setDamage 0;
    KPLIB_potato01 allowdamage true;
    [KPLIB_potato01] call KPLIB_fnc_addObjectInit;
};
[KPLIB_potato01] call KPLIB_fnc_clearCargo;
KPLIB_potato01 setVariable ["ace_medical_isMedicalVehicle", true, true];
publicVariable "KPLIB_potato01";

KPLIB_potato01 respawnVehicle [KPLIB_potatoRespawnDelay, -1, true, true];

KPLIB_potato01 addEventHandler ["Respawn", {
	params ["_unit", "_corpse"];

    ["Potato 01 respawned at Operation Base", "POTATO"] call KPLIB_fnc_log;

    _unit spawn {
        KPLIB_potato01 = _this;
        _this allowdamage false; 
        _this setDir (getDir huronspawn); 
        _this setPosATL (getposATL huronspawn); 
        _this setDamage 0; 
        sleep 0.5; 
        _this enableSimulationGlobal true; 
        _this setDamage 0; 
        _this allowdamage true; 
        [_this] call KPLIB_fnc_addObjectInit; 
    }
}];