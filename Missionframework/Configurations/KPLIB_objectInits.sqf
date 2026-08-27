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

    // Add ViV and build action to Outpost box
    [
        [KPLIB_b_outpostBox],
        {
            [{
                time > 60
            }, {
                params ["_outpostBox"];

                ["KPLIB_outpostActions", [_outpostBox]] call CBA_fnc_globalEventJIP
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

    // Add Outpost building damage handler override and repack action
    [
        [KPLIB_b_outpostBuilding],
        {
            _this addEventHandler ["HandleDamage", {0}];
            [{
                time > 60
            }, {
                params ["_outpost"];

                ["KPLIB_outpostActions", [_outpost]] call CBA_fnc_globalEventJIP
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
        KPLIB_vehicleRepairSources,
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

    // Take controls action permission
    [
        ["Air"],
        {
            _this addEventHandler ["ControlsShifted", {
                params ["_vehicle", "_activeCoPilot", "_oldController"];
                if (local _activeCoPilot) then {
                    private _vehicleClass = toLowerANSI (typeOf _vehicle);
                    private _permToCheck = switch (true) do {
                        case (_vehicleClass in KPLIB_typeHeliClasses) : {
                            2
                        };
                        case (_vehicleClass in KPLIB_typePlaneClasses) : {
                            3
                        };
                        default {-1}
                    };

                    if ((_oldController != _activeCoPilot || (_oldController == objNull)) && !([_permToCheck] call KPLIB_fnc_hasPermission)) then {
                        _activeCoPilot action ["SuspendVehicleControl", _vehicle];
                        [localize "STR_PERMISSION_TAKE_CONTROL_FAILED", true, 4] call KPLIB_fnc_hint;
                    };
                }
            }];
        },
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
                
                if (side (group _gunner) == KPLIB_side_player) then {
                    private _unitPos = getPosATL _unit;

                    // Check artillery fired ammo
                    if (getNumber(configFile >> "CfgAmmo" >> _ammo >> "artilleryLock") < 1) exitWith {};

                    // Check if the enemy artillery is available
                    if (isNil "KPLIB_o_artilleryUnits") exitWith {};
                    if (KPLIB_o_artilleryUnits isEqualTo []) exitWith {};
                    // Add Deleted EH to the projectile. When explodes, run the counter artillery script
                    [_projectile, "Explode", {
                        params ["_projectile", "_pos", "_velocity"];
                        _thisArgs params ["_unit", "_unitPos"]; 
                        ["KPLIB_counterArtillery", [_unit, _unitPos, _pos]] call CBA_fnc_localEvent;
                    }, [_unit, _unitPos]] call CBA_fnc_addBISEventHandler;

                    // Add EH for shells that creates submunitions
                    _unit setVariable ["KPLIB_count_subMunition", 0]; // To avoid calling the counter script multiple times
                    [_projectile, "SubmunitionCreated", {
                        params ["_projectile", "_submunitionProjectile", "_pos", "_velocity"];
                        _thisArgs params ["_unit", "_unitPos"]; 

                        _countSubMunition = (_thisArgs getVariable "KPLIB_count_subMunition");
                        _countSubMunition = _countSubMunition + 1;

                        if (_countSubMunition > 1) exitWith {};
                        
                        ["KPLIB_counterArtillery", [_unit, _unitPos, _pos]] call CBA_fnc_localEvent;
                    }, [_unit, _unitPos]] call CBA_fnc_addBISEventHandler;
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
            if (!(KPLIB_param_autodanger) && {(side (group _this)) isEqualTo KPLIB_side_player}) then {
                _this disableAI "AUTOCOMBAT";
            };
            _this allowFleeing 0;
        },
        true
    ],
    
    // AI Night accessories
    [
        ["CAManBase"],
        {
            if (side (group _this) == KPLIB_side_enemy) then {
                switch (KPLIB_param_nightAccessories) do {
                    case 1 : {
                        // Add flashlight
                        _this addPrimaryWeaponItem KPLIB_o_flashlightAcc;             
                        _this enableGunLights "Auto";
                    };
                    case 2 : {
                        // Add nightvision
                        _this linkItem KPLIB_o_nightVision;
                    };
                    case 3 : {
                        // Add nightvision + laser
                        _this linkItem KPLIB_o_nightVision;
                        _this addPrimaryWeaponItem KPLIB_o_laserAcc;
                        (group _this) addEventHandler ["CombatModeChanged", {
                            params ["_group", "_newMode"];

                            if (_newMode == "COMBAT") then {
                                _group enableIRLasers true
                            } else {
                                _group enableIRLasers false
                            };
                        }];
                    };
                    default {};
                };
            };
            if (side (group _this) == KPLIB_side_player) then {
                switch (KPLIB_param_nightAccessories) do {
                    case 1 : {
                        // Add flashlight
                        _this addPrimaryWeaponItem KPLIB_b_flashlightAcc;             
                        _this enableGunLights "Auto";
                    };
                    case 2 : {
                        // Add nightvision
                        _this linkItem KPLIB_b_nightVision;
                    };
                    case 3 : {
                        // Add nightvision + laser
                        _this linkItem KPLIB_b_nightVision;
                        _this addPrimaryWeaponItem KPLIB_b_laserAcc;
                        _this enableIRLasers true;
                        if (leader (group _this) == _this) then {
                            (group _this) addEventHandler ["CombatModeChanged", {
                                params ["_group", "_newMode"];

                                if (_newMode == "COMBAT") then {
                                    _group enableIRLasers true
                                } else {
                                    _group enableIRLasers false
                                };
                            }];
                        }
                    };
                    default {};
                };
            };
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
        },
        true
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

    // Add fuel canister to all vehicles
    [
        ["Tank","APC","IFV","Car"],
        {
            if (KPLIB_ace) then {
                private _canister = createVehicle ["Land_CanisterFuel_F", getPosATL _this, [], 10, "NONE"];
                [_canister, 0] call ace_cargo_fnc_setSize;
                private _loaded = [_canister, _this, true] call ace_cargo_fnc_loadItem;
                if !(_loaded) then {
                    // Try again. For some reason, it doesn't work right away with enemy vehicles.
                    [_this, _canister] spawn {
                        params["_veh", "_canister"];
                        sleep 5;
                        private _loaded = [_canister, _veh, true] call ace_cargo_fnc_loadItem;
                        if !(_loaded) then {
                            deleteVehicle _canister
                        };
                    }
                };
            };
        },
        true
    ],

    // Pylon Armament Selector
    [
        KPLIB_b_air_classes,
        {
            if (KPLIB_ace) then {
                [{
                    time > 60
                }, {
                    params["_air"];

                    ["KPLIB_addActionPAS", _air] call CBA_fnc_globalEventJIP;
                }, [_this]] call CBA_fnc_waitUntilAndExecute;
            };
        }
    ],

    // Get in/get out air assets detection
    [
        KPLIB_b_air_classes + [KPLIB_b_potato01],
        {
            if (KPLIB_param_enemyFighters) then {
                _this addEventHandler ["GetIn", {
                    params ["_vehicle", "_role", "_unit", "_turret"];
                    
                    if ((_role == "driver") && {side (group _unit) == KPLIB_side_player}) then {
                        if (isNil "KPLIB_bluforAircrafts") then {
                            KPLIB_bluforAircrafts = [];
                            publicVariable "KPLIB_bluforAircrafts";
                        };

                        KPLIB_bluforAircrafts pushBack _vehicle;
                        publicVariable "KPLIB_bluforAircrafts";
                    };
                }];

                _this addEventHandler ["GetOut", {
                    params ["_vehicle", "_role", "_unit", "_turret", "_isEject"];
                    _vehicle setVariable ["KPLIB_playerInAircraft", false];
                    KPLIB_bluforAircrafts deleteAt (KPLIB_bluforAircrafts find _vehicle);
                    publicVariable "KPLIB_bluforAircrafts";
                }];

                _this addEventHandler ["Killed", {
                    params ["_plane", "_killer", "_instigator", "_useEffects"];
                    _plane setVariable ["KPLIB_playerInAircraft", nil];
                    KPLIB_bluforAircrafts deleteAt (KPLIB_bluforAircrafts find _plane);
                    publicVariable "KPLIB_bluforAircrafts";
                }]; 
            }
        }
    ],

    // Potato 01 respawn
    [
        [KPLIB_b_potato01],
        {
            _this setVariable ["ace_medical_isMedicalVehicle", true, true];
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
        KPLIB_radarType,
        {
            _this setVehicleRadar 1;
            _this setVehicleReceiveRemoteTargets true;
            _this setVehicleReportRemoteTargets true;
            (group _this) setBehaviourStrong "AWARE";
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
        },
        true
    ],
    
    // Trolley missiles carry actions 
    [
        ["Land_Missle_Trolley_02_F", "Land_Bomb_Trolley_01_F"],
        {
            [{
                time > 60
            }, {
                params["_object"];

                ["KPLIB_addObjectCarryAction", _object] call CBA_fnc_globalEventJIP;
            }, [_this]] call CBA_fnc_waitUntilAndExecute;
        }
    ],

    // Remove not whitelisted magazines from pylons on custom PAS preset
    [
        KPLIB_b_air_classes + [KPLIB_b_potato01],
        {
            if (KPLIB_ace) then {
                if (count PIG_PAS_customPreset > 0) then {
                    private _checkPreset = PIG_PAS_customPreset apply {toLowerANSI _x};
                    {
                        private _pylonIndex = _x # 0;
                        private _turret = _x # 2;
                        private _magazine = _x # 3;

                        if !((toLowerANSI _magazine) in _checkPreset) then {
                            ["PAS_setPylonArmament", [_this, _pylonIndex, "", _turret]] call CBA_fnc_globalEvent;
                        };
                    }forEach (getAllPylonsInfo _this);
                }
            }
        }
    ],

    // Add ace rearm scripted loadout for tanks
    [
        ["Tank"],
        {
            if (KPLIB_ace) then {
                _this setVariable ["ace_rearm_scriptedLoadout", true, true];
            };
        },
        true
    ],

    // Add airport build action to repair sources
    [
        KPLIB_vehicleRepairSources,
        {
            [{
                time > 60
            }, {
                params["_repairSource"];

                ["KPLIB_addBuildAirportAction", _repairSource] call CBA_fnc_globalEventJIP;
            }, [_this]] call CBA_fnc_waitUntilAndExecute;
        }
    ],

    // Add repair action (repair source nearby required)
    [
        KPLIB_b_deco_classes,
        {
            [{
                time > 60
            }, {
                params["_object"];

                ["KPLIB_addRepairAction", _object] call CBA_fnc_globalEventJIP;
            }, [_this]] call CBA_fnc_waitUntilAndExecute;
        }
    ],

    // Add explosion EH
    [
        [KPLIB_b_smallStorage, KPLIB_b_largeStorage, KPLIB_b_transStorage, KPLIB_b_supplyDump, "Land_Missle_Trolley_02_F", "Land_Bomb_Trolley_01_F"],
        {
            ["KPLIB_addExplosionEH", _this] call CBA_fnc_globalEventJIP
        }
    ]
];