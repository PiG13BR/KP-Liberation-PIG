/*
    Specific object init codes depending on classnames.

    Format:
    [
        Array of classnames as strings <ARRAY>,
        Code to apply <CODE>,
        Allow inheritance <BOOL> (default false)
    ]
    _this is the reference to the object with the classname

    Example:
        KPLIB_objectInits = [
            [
                ["O_soldierU_F"],
                {systemChat "CSAT urban soldier was spawned!"}
            ],
            [
                ["CAManBase"],
                {systemChat format ["Some human named '%1' was spawned!", name _this]},
                true
            ]
        ];
*/

KPLIB_objectInits = [
    // Set logo on white flag
    [
        ["Flag_White_F"],
        {_this setFlagTexture "Images\flag_kp_co.paa";}
    ],

    // Add helipads to zeus, as they can't be recycled after built
    [
        ["Helipad_base_F", "LAND_uns_Heli_pad", "Helipad", "LAND_uns_evac_pad", "LAND_uns_Heli_H"],
        {{[_x, [[_this], true]] remoteExecCall ["addCuratorEditableObjects", 2]} forEach allCurators;},
        true
    ],

    // Add ViV and build action to FOB box/truck
    [
        [KPLIB_b_fobBox, KPLIB_b_fobTruck],
        {
            [{
                time > 60
            }, {
                params ["_fobBox"];

                ["KPLIB_fobActions", [_fobBox]] call CBA_fnc_globalEventJIP
            }, [_this]] call CBA_fnc_waitUntilAndExecute;      
        }
    ],

    // Add FOB building damage handler override and repack action
    [
        [KPLIB_b_fobBuilding],
        {
            _this addEventHandler ["HandleDamage", {0}];
            [{
                time > 60
            }, {
                params ["_fob"];

                ["KPLIB_fobActions", [_fob]] call CBA_fnc_globalEventJIP
            }, [_this]] call CBA_fnc_waitUntilAndExecute;
        }
    ],

    // Add ViV action to Arsenal crate
    [
        [KPLIB_b_arsenal],
        {
            [_this] spawn {
                params ["_arsenal"];
                waitUntil {sleep 0.1; time > 2};
                [_arsenal] remoteExecCall ["KPLIB_fnc_setLoadableViV", 0, _arsenal];
            };
        }
    ],

    // Add storage type variable to built storage areas (only for FOB built/loaded ones)
    [
        [KPLIB_b_smallStorage, KPLIB_b_largeStorage, KPLIB_b_transStorage],
        {
            [{
                time > 60
            }, {
                params["_storage"];

                _storage setVariable ["KPLIB_fobStorage", true, true];
                _storage allowDamage false;
                if (KPLIB_ace) then {
                    [this, -1] call ace_cargo_fnc_setSize;
                };
                if ((typeOf _storage) == KPLIB_b_transStorage) then {
                    if (local _storage) then {
                        _storage setMass 700
                    } else {
                        [_storage, 700] remoteExec ["setMass"]
                    };
                };
                ["KPLIB_addActionsStorage", [_storage]] call CBA_fnc_globalEventJIP
            }, [_this]] call CBA_fnc_waitUntilAndExecute;
        }
    ],
    
    // disable inventory action and ACE rename of resource crates
    [
        KPLIB_crates,
        {
            _this lockInventory true;
            if (KPLIB_ace) then {
                [_this, true, [0, 1.5, 0], 0] remoteExec ["ace_dragging_fnc_setCarryable"];
                _this setVariable ["ace_cargo_noRename", true];
            };
        }
    ],

    // Add ACE variables to corresponding building/vehicle types
    [
        KPLIB_repair_facilities + [KPLIB_b_logiStation],
        {_this setVariable ["ace_isRepairFacility", 1, true];}
    ],
    [
        vehicle_repair_sources,
        {_this setVariable ["ace_isRepairVehicle", 1, true];}
    ],
    [
        vehicle_rearm_sources,
        {_this setVariable ["ace_rearm_isSupplyVehicle", true, true];}
    ],
    [
        KPLIB_medical_facilities,
        {_this setVariable ["ace_medical_isMedicalFacility", true, true];}
    ],
    [
        KPLIB_medical_vehicles,
        {_this setVariable ["ace_medical_isMedicalVehicle", true, true];}
    ],

    // Add ACE refuel function to corresponding building/vehicle types when ace fuelCargo config is missing
    [
        vehicle_refuel_sources,
        {
            [_this] spawn {
                params ["_fuelTruck"];
                waitUntil {sleep 0.1; time > 2};
                if (getNumber (configfile >> "CfgVehicles" >> (typeOf _fuelTruck) >> "ace_refuel_fuelCargo") <= 0) then {
                    [_fuelTruck, 3000] remoteExecCall ["ace_refuel_fnc_makeSource", 0, _fuelTruck];
                };
            };
        }
    ],

    // Hide Cover on big GM trucks
    [
        ["gm_ge_army_kat1_454_cargo", "gm_ge_army_kat1_454_cargo_win"],
        {_this animateSource ["cover_unhide", 0, true];}
    ],

    // Make sure a slingloaded object is local to the helicopter pilot (avoid desync and rope break)
    [
        ["Helicopter"],
        {if (isServer) then {[_this] call KPLIB_fnc_addRopeAttachEh;} else {[_this] remoteExecCall ["KPLIB_fnc_addRopeAttachEh", 2];};},
        true
    ],

    
    // Artillery Framework and Artillery Menu
    [
        KPLIB_param_supportModule_artyVeh,
        {     
            // Register arty piece
            _this addEventHandler ["GetIn", {
                params ["_vehicle", "_role", "_unit", "_turret"];
                if ((!isNull (gunner _vehicle)) && (side _unit == KPLIB_side_player) && {!isPlayer _unit}) then {
                    [_vehicle] call KPLIB_fnc_registerArtyPiece;
                }
            }];
            // ---------------------------------------------------------- COUNTER-ARTILLERY MANAGEMENT
            _this addEventHandler ["Fired", {
                params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
                
                if (side _gunner == KPLIB_side_player) then {

                    // Check artillery fired ammo
                    if (getNumber(configFile >> "CfgAmmo" >> _ammo >> "artilleryLock") < 1) exitWith {};

                    // Check if the enemy artillery is available
                    if (isNil "KPLIB_o_artilleryUnits") exitWith {};
                    if (KPLIB_o_artilleryUnits isEqualTo []) exitWith {};
                    // Add Deleted EH to the projectile. When explodes, run the counter artillery script
                    [_projectile, "Explode", {
                        params ["_projectile", "_pos", "_velocity"];
                        ["KPLIB_counterArtillery", [_thisArgs, _pos]] call CBA_fnc_localEvent;
                    }, _unit] call CBA_fnc_addBISEventHandler;

                    // Add EH for shells that creates submunitions
                    _unit setVariable ["KPLIB_count_subMunition", 0]; // To avoid calling the counter script multiple times
                    [_projectile, "SubmunitionCreated", {
                        params ["_projectile", "_submunitionProjectile", "_pos", "_velocity"];
                        _countSubMunition = (_thisArgs getVariable "KPLIB_count_subMunition");
                        _countSubMunition = _countSubMunition + 1;

                        if (_countSubMunition > 1) exitWith {};
                        
                        ["KPLIB_counterArtillery", [_thisArgs, _pos]] call CBA_fnc_localEvent;
                    }, _unit] call CBA_fnc_addBISEventHandler;
                };
            }];
        }
    ],

    // add fullheal action to huron/taru medical container (mobile fullHeal)
    [
        ["B_Slingload_01_Medevac_F", "Land_Pod_Heli_Transport_04_medevac_F"],
        {
            [_this] spawn {
                params ["_medvacbox"];
                waitUntil {sleep 0.1; time > 2};
                [_medvacbox] remoteExecCall ["KPLIB_fnc_addActionsFullHeal", 0, _medvacbox];
            };
        }
    ],

    // Add KPLQ Radio to static radios
    [
        ["Land_FMradio_F", "Land_SurvivalRadio_F", "CUP_radio_b", "Radio", "Radio_Old"],
        {
            if (KPLIB_klpq) then {
                [_this] spawn {
                    params ["_radio"];
                    waitUntil {sleep 0.1; time > 2};
                    [_radio, false] remoteExecCall ["klpq_musicRadio_fnc_addRadio", 0, _radio];
                };
            };
        }
    ],

    // Set MH47 Probe
    [
        ["CUP_B_MH47E_USA"],
        {
            [_this,nil,["Hide_Probe",1]] call BIS_fnc_initVehicle;
        }
    ],

    // Disable autocombat (if set in parameters) and fleeing
    [
        ["CAManBase"],
        {
            if (!(KPLIB_param_autodanger) && {(side _this) isEqualTo KPLIB_side_player}) then {
                _this disableAI "AUTOCOMBAT";
            };
            _this allowFleeing 0;
        },
        true
    ],

    // Set transport cargo/crates config
    [
        KPLIB_transport_classes,
        {
            [{
                time > 60
            }, {
                params["_transport"];

                _transport call KPLIB_fnc_setCargoVehConfig;
            }, [_this]] call CBA_fnc_waitUntilAndExecute;
        }
    ],

    // Crates
    [
        [KPLIB_b_crateAmmo, KPLIB_b_crateFuel, KPLIB_b_crateSupply],
        {
            // Ace cargo framework
            if (KPLIB_ace) then {
                [_this, false, [0, 1, 1], 0, false, true] call ace_dragging_fnc_setCarryable; // Disable ace carrying
                [_this, -1] call ace_cargo_fnc_setSize; // Disable ace cargo for this crate
                _this setVariable ["ace_cargo_noRename", true];
            };
            // Add actions only if not attach to something (like a storage)
            [{
                time > 60
            }, {
                params["_crate"];

                ["KPLIB_addActionsCrate", _crate] call CBA_fnc_globalEventJIP;
            }, [_this]] call CBA_fnc_waitUntilAndExecute;

        }
    ],

    // Do unflip
    [
        ["Tank","APC","IFV","Car"],
        {
            [{
                time > 60
            }, {
                params["_veh"];

                ["KPLIB_addUnflipAction", _veh] call CBA_fnc_globalEventJIP;
            }, [_this]] call CBA_fnc_waitUntilAndExecute;
        }
    ],

    // Do recycle
    [
        (KPLIB_b_allVeh_classes + KPLIB_o_allVeh_classes + KPLIB_b_deco_classes + KPLIB_storageBuildings + KPLIB_upgradeBuildings + KPLIB_ace_crates),
        {
            [{
                time > 60
            }, {
                params["_object"];

                ["KPLIB_addRecycleAction", _object] call CBA_fnc_globalEventJIP;
            }, [_this]] call CBA_fnc_waitUntilAndExecute;      
        }
    ],

    // Pylon Manager
    [
        KPLIB_b_air_classes + [KPLIB_b_potato01],
        {
            if (KPLIB_ace) then {
                [{
                    time > 60
                }, {
                    params["_air"];

                    ["KPLIB_addActionPylonManager", _air] call CBA_fnc_globalEventJIP;
                }, [_this]] call CBA_fnc_waitUntilAndExecute;
            };

            if (KPLIB_param_enemyFighters) then {
                _this addEventHandler ["GetIn", {
                    params ["_vehicle", "_role", "_unit", "_turret"];
                    
                    if ((_role == "driver") && {side _unit == KPLIB_side_player}) then {
                        if (isNil "KPLIB_playerAircrafts") then {
                            KPLIB_playerAircrafts = [];
                            publicVariable "KPLIB_playerAircrafts";
                        };

                        KPLIB_playerAircrafts pushBack _vehicle;
                        [_vehicle] call KPLIB_fnc_enemyAirScheduler;
                    };
                }];

                _this addEventHandler ["GetOut", {
                    params ["_vehicle", "_role", "_unit", "_turret", "_isEject"];
                    _vehicle setVariable ["KPLIB_playerInAircraft", false];
                    KPLIB_playerAircrafts deleteAt (KPLIB_playerAircrafts find _vehicle);
                }];

                _this addEventHandler ["Killed", {
                    params ["_unit", "_killer", "_instigator", "_useEffects"];
                    _unit setVariable ["KPLIB_playerInAircraft", nil];
                    KPLIB_playerAircrafts deleteAt (KPLIB_playerAircrafts find _unit);
                }]; 
            }
        }
    ],

    [
        KPLIB_intelObjectClasses,
        {
            ["KPLIB_addActionIntel", _this] call CBA_fnc_globalEventJIP;
        }
    ],

    // Supply Dump
    [
        [KPLIB_b_supplyDump],
        {
            [{
                time > 60
            }, {
                params["_dump"];

                ["KPLIB_registerSupplyDump", _dump] call CBA_fnc_globalEventJIP;
            }, [_this]] call CBA_fnc_waitUntilAndExecute;
        }
    ],

    // Crate supply carriers/fillers
    [
        KPLIB_supply_cratesClasses,
        {
            [{
                time > 60
            }, {
                params["_crate"];

                ["KPLIB_addActionSupplyCrates", _crate] call CBA_fnc_globalEventJIP;
            }, [_this]] call CBA_fnc_waitUntilAndExecute;
        }
    ],

    // Radars
    [
        ["B_SAM_System_03_F","B_AAA_System_01_F", "B_Radar_System_01_F"],
        {
            _this setVehicleRadar 1;
        }
    ],

    // Service containers
    [
        ["Land_Pod_Heli_Transport_04_ammo_F", "Land_Pod_Heli_Transport_04_fuel_F", "Land_Pod_Heli_Transport_04_repair_F", "B_Slingload_01_Repair_F", "B_Slingload_01_Fuel_F", "B_Slingload_01_Ammo_F"],
        {
            _this setMass 1500
        }
    ],

    // Turn on receive remote targets for air units
    [
        ["Air"],
        {
            _this setVehicleReceiveRemoteTargets true
        }
    ],

    // Fortify
    [
        [KPLIB_b_fortify_small],
        {
            [KPLIB_side_player, 0, [["Land_BagFence_Long_F", 5], ["Land_SandbagBarricade_01_half_F", 5], ["Land_Razorwire_F", 5], ["Land_Rampart_F", 5]]] call ace_fortify_fnc_registerObjects;
            _this addItemCargoGlobal ["ACE_FortifyToken", 50]; // 250$
            [KPLIB_side_player, 0, false] call ace_fortify_fnc_updateBudget;
            ace_fortify_locations pushBack [_this, 50, 50, 0, false];
        }
    ],
    [
        [KPLIB_b_fortify_medium],
        {
            [KPLIB_side_player, 0, [["Land_BagFence_Long_F", 5], ["Land_SandbagBarricade_01_half_F", 5], ["Land_Razorwire_F", 5], ["Land_Rampart_F", 5], ["Land_SandbagBarricade_01_hole_F", 50], ["Land_BagBunker_Small_F", 50], ["Land_bagBunker_Large_F", 50], ["Land_DragonsTeeth_01_4x2_new_F", 50]]] call ace_fortify_fnc_registerObjects;
            _this addItemCargoGlobal ["ACE_FortifyToken", 60]; // 300$
            [KPLIB_side_player, 0, false] call ace_fortify_fnc_updateBudget;
            ace_fortify_locations pushBack [_this, 50, 50, 0, false];
        }
    ]
];