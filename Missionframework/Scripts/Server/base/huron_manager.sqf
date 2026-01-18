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
    KPLIB_potato01 = (typeOf KPLIB_b_potato01) createVehicle [(getposATL huronspawn) select 0, (getposATL huronspawn) select 1, ((getposATL huronspawn) select 2) + 0.2];
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

KPLIB_fnc_addKilledEH_potato = {
    params["_potato"];

    _potato addEventHandler ["Killed", {
        params["_vehicle"];

        [_vehicle] spawn {
            sleep KPLIB_potatoRespawnDelay;

            params["_vehicle"];
            // Delete wreck, if near startbase
            if (_vehicle distance startbase < 500) then {
                deletevehicle _vehicle;
            };

            KPLIB_potato01 = (typeOf _vehicle) createVehicle [(getposATL huronspawn) select 0, (getposATL huronspawn) select 1, ((getposATL huronspawn) select 2) + 0.2];
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

            [KPLIB_potato01] call KPLIB_fnc_clearCargo;
            KPLIB_potato01 setVariable ["ace_medical_isMedicalVehicle", true, true];
            publicVariable "KPLIB_potato01";

            stats_potato_respawns = stats_potato_respawns + 1;

            [KPLIB_potato01] call KPLIB_fnc_addKilledEH_potato;
        };
        _vehicle removeEventHandler [_thisEvent, _thisEventHandler];
    }];
};
publicVariable "KPLIB_fnc_addKilledEH_potato";

[KPLIB_potato01] call KPLIB_fnc_addKilledEH_potato;