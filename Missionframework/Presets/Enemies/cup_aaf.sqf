/*
    File: cup_aaf.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 07/11/2025
    Last Update: 13/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        CUP AAF (ACW)

    Needed Mods:
        - CUP AAF (ACW)

    Optional Mods:
        - None
*/

// Enemy infantry classes
KPLIB_o_officer = "Flex_CUP_AAF_teamleader";                            // Officer
KPLIB_o_squadLeader = "Flex_CUP_AAF_teamleader";                        // Squad Leader
KPLIB_o_teamLeader = "Flex_CUP_AAF_teamleader";                         // Team Leader
KPLIB_o_sentry = "Flex_CUP_AAF_rifleman_lite";                          // Rifleman (Lite)
KPLIB_o_rifleman = "Flex_CUP_AAF_rifleman";                             // Rifleman
KPLIB_o_riflemanLAT = "Flex_CUP_AAF_antitank_light";                    // Rifleman (LAT)
KPLIB_o_grenadier = "Flex_CUP_AAF_grenadier";                           // Grenadier
KPLIB_o_machinegunner = "Flex_CUP_AAF_machinegunner";                   // Autorifleman
KPLIB_o_heavyGunner = "Flex_CUP_AAF_machinegunner";                     // Heavy Gunner
KPLIB_o_marksman = "Flex_CUP_AAF_marksman";                             // Marksman
KPLIB_o_sharpshooter = "Flex_CUP_AAF_marksman";                         // Sharpshooter
KPLIB_o_sniper = "Flex_CUP_AAF_sniper";                                 // Sniper
KPLIB_o_atSpecialist = "Flex_CUP_AAF_antitank_missle";                  // AT Specialist
KPLIB_o_aaSpecialist = "Flex_CUP_AAF_antiair";                          // AA Specialist
KPLIB_o_medic = "Flex_CUP_AAF_medic";                                   // Combat Life Saver
KPLIB_o_engineer = "Flex_CUP_AAF_mechanic";                             // Engineer
KPLIB_o_paratrooper = "Flex_CUP_AAF_paratrooper";                       // Paratrooper
KPLIB_o_crewman = "Flex_CUP_AAF_crew";                                  // Crewman
KPLIB_o_jetPilot = "Flex_CUP_AAF_helipilot";                            // Helicopter Pilot
KPLIB_o_heliPilot = "Flex_CUP_AAF_pilot";                               // Jet Pilot
KPLIB_o_boatCrew = "Flex_CUP_AAF_sailor";                               // Boat Crewman

KPLIB_o_parachuteType = "CUP_T10_Parachute_backpack";                   // Parachute type for the paratroopers

// Enemy vehicles used by secondary objectives.
KPLIB_o_mrap = "Flex_CUP_AAF_Tigr_233011";                              // Iveco LMV
KPLIB_o_mrapArmed = "Flex_CUP_AAF_Tigr_233114_KORD";                    // Iveco LMV (KORD)
KPLIB_o_transportHeli = "Flex_CUP_AAF_Heli_Unarmed";                    // AW159 Taru (Bench)
KPLIB_o_transportTruck = "Flex_CUP_AAF_Truck_Covered";                  // Kamaz Transport (Covered)
KPLIB_o_transportTruckAmmo = "Flex_CUP_AAF_Truck_Transport";            // Kamaz Transport (Open) -> Has to be able to transport resource crates!
KPLIB_o_fuelTruck = "Flex_CUP_AAF_Truck_Fuel";                          // Kamaz Fuel
KPLIB_o_ammoTruck = "Flex_CUP_AAF_Truck_Ammo";                          // Kamaz Ammo
KPLIB_o_fuelContainer = "Land_Pod_Heli_Transport_04_fuel_F";            // Taru Fuel Pod
KPLIB_o_ammoContainer = "Land_Pod_Heli_Transport_04_ammo_F";            // Taru Ammo Pod
KPLIB_o_flag = "Flag_AAF_F";                                            // Flag
KPLIB_o_convoyScout = KPLIB_o_mrapArmed;                                // Convoy scout vehicle. Lead convoy vehicle.
KPLIB_o_convoyTroop = KPLIB_o_transportTruck;                           // Convoy troop transport
KPLIB_o_convoyObjective = KPLIB_o_transportTruckAmmo;                   // Has to be able to transport resource crates!
KPLIB_o_convoyMiddleVehicles = [];                                      // Convoy middle vehicles
KPLIB_o_convoyEscort = "Flex_CUP_AAF_M113A3";                           // Convoy last vehicle.


/* Adding a value to these arrays below will add them to a one out of however many in the array, random pick chance.
Therefore, adding the same value twice or three times means they are more likely to be chosen more often. */

/* Militia infantry. Lightweight soldier classnames the game will pick from randomly as sector defenders.
Think of them like garrison or military police forces, which are more meant to control the local population instead of fighting enemy armies. */
KPLIB_o_militiaInfantry = [
    KPLIB_o_sentry,                                                     // Rifleman (Lite)
    KPLIB_o_sentry,                                                     // Rifleman (Lite)
    KPLIB_o_rifleman,                                                   // Rifleman
    KPLIB_o_rifleman,                                                   // Rifleman
    KPLIB_o_riflemanLAT,                                                // Rifleman (AT)
    KPLIB_o_riflemanLAT,                                                // Rifleman (AT)
    KPLIB_o_machinegunner,                                              // Autorifleman
    KPLIB_o_machinegunner,                                              // Autorifleman
    KPLIB_o_medic                                                       // Medic
];

// Militia vehicles. Lightweight vehicle classnames the game will pick from randomly as sector defenders. Can also be empty for only infantry milita.
KPLIB_o_militiaVehicles = [
    "Flex_CUP_AAF_LR_MG"                                                  // Land Rover 110 (M2)
];

// All enemy vehicles that can spawn as sector defenders and patrols at high enemy combat readiness (aggression levels).
KPLIB_o_armyVehicles = [
    KPLIB_o_mrapArmed,                                                  // Iveco LMV (KORD)
    "Flex_CUP_AAF_BTR80A",                                              // BTR-80A
    "Flex_CUP_AAF_BTR80A",                                              // BTR-80A
    "Flex_CUP_AAF_Warrior",                                             // Warrior
    "Flex_CUP_AAF_ZSU23",                                               // ZSU-23-4
    "Flex_CUP_AAF_Leopard_1A3",                                         // Leopard 1A3
    "Flex_CUP_AAF_Leopard2A6"                                           // Leopard 2A6
];

// All enemy vehicles that can spawn as sector defenders and patrols but at a lower enemy combat readiness (aggression levels).
KPLIB_o_armyVehiclesLight = [
    KPLIB_o_mrapArmed,                                                  // Iveco LMV (KORD)
    KPLIB_o_mrapArmed,                                                  // Iveco LMV (KORD)
    "Flex_CUP_AAF_M113A3",                                              // M113 (M2)
    "Flex_CUP_AAF_M113A3",                                              // M113 (M2)
    "Flex_CUP_AAF_BTR80A"                                               // BTR-80A
];

// All enemy anti-air vehicles
KPLIB_o_antiAirVehicles = [
    "Flex_CUP_AAF_ZSU23"
];

// All enemy tank vehicles
KPLIB_o_tankVehicles = [
    "Flex_CUP_AAF_Leopard_1A3",
    "Flex_CUP_AAF_Leopard_1A3",
    "Flex_CUP_AAF_Leopard2A6"
];

// All enemy vehicles that can spawn as battlegroups, either assaulting or as reinforcements, at high enemy combat readiness (aggression levels).
KPLIB_o_battleGrpVehicles = [
    KPLIB_o_mrapArmed,                                                  // Iveco LMV (KORD)
    "Flex_CUP_AAF_M113A3",                                              // M113 (M2)
    "Flex_CUP_AAF_M113A3",                                              // M113 (M2)
    "Flex_CUP_AAF_BTR80A",                                              // BTR-80A
    "Flex_CUP_AAF_BTR80A",                                              // BTR-80A
    "Flex_CUP_AAF_Warrior",                                             // Warrior
    "Flex_CUP_AAF_Truck_Transport",                                     // Kamaz Transport
    KPLIB_o_transportTruck,                                             // Kamaz Transport (Covered)
    "Flex_CUP_AAF_LR_SF_HMG",                                           // Land Rover 110 (SF HMG)
    "Flex_CUP_AAF_LR_SF_GMG",                                           // Land Rover 110 (SF GMG)
    "Flex_CUP_AAF_ZSU23",                                               // ZSU-23-4
    "Flex_CUP_AAF_Leopard_1A3",                                         // Leopard 1A3
    "Flex_CUP_AAF_Leopard2A6",                                          // Leopard 2A6
    "Flex_CUP_AAF_C130J",                                               // C-130J
    "Flex_CUP_AAF_Merlin_HC3_Armed",                                    // Merlin HC3 (Armed)
    KPLIB_o_transportHeli,                                              // AW159 Wildcat
    "Flex_CUP_AAF_Mi24_Mk3"                                             // Mi-24 Superhind Mk.3
];

// All enemy vehicles that can spawn as battlegroups, either assaulting or as reinforcements, at lower enemy combat readiness (aggression levels).
KPLIB_o_battleGrpVehiclesLight = [
    KPLIB_o_mrapArmed,                                                  // Iveco LMV (KORD)
    KPLIB_o_mrapArmed,                                                  // Iveco LMV (KORD)
    "Flex_CUP_AAF_Truck_Transport",                                     // Kamaz Transport
    "Flex_CUP_AAF_M113A3",                                              // M113 (M2)
    "Flex_CUP_AAF_BTR80A",                                              // BTR-80A
    KPLIB_o_transportHeli,                                              // AW159 Wildcat
    "Flex_CUP_AAF_C130J",                                               // C-130J
    "Flex_CUP_AAF_Merlin_HC3_Armed"                                     // Merlin HC3 (Armed)
];

/* All vehicles that spawn within battlegroups (see the above 2 arrays)
If something in this array can't hold all 8 soldiers then buggy behaviours may occur. */
KPLIB_o_troopTransports = [
    "Flex_CUP_AAF_Truck_Transport",                                     // Kamaz Transport
    KPLIB_o_transportTruck,                                             // Kamaz Transport (Covered)
    KPLIB_o_transportHeli,                                              // AW159 Wildcat
    "Flex_CUP_AAF_Merlin_HC3_Armed",                                    // Merlin HC3 (Armed)
    "Flex_CUP_AAF_C130J",                                               // C-130J
    "Flex_CUP_AAF_M113A3",                                              // M113 (M2)
    "Flex_CUP_AAF_BTR80A"                                               // BTR-80A
];

// Enemy rotary-wings that will need to spawn in flight.
KPLIB_o_helicopters = [
    KPLIB_o_transportHeli,                                              // AW159 Wildcat
    "Flex_CUP_AAF_Merlin_HC3_Armed"                                     // Merlin HC3 (Armed)
];

// Enemy attack rotary-wings
KPLIB_o_attackHelicopters = [
    "Flex_CUP_AAF_Mi24_Mk3"                                             // Mi-24 Superhind Mk.3
];

// Planes for enemy paratroopers
KPLIB_o_paradropPlanes = [
    "Flex_CUP_AAF_C130J"                                                // C-130J
];

// Enemy fixed-wings that will need to spawn in the air.
KPLIB_o_planes = [
    "Flex_CUP_AAF_Plane_Fighter",                                       // A-159 ALCA
    "Flex_CUP_AAF_Fighter"                                              // JAS 39 Gripen
];

// Enemy dedicated fighter fixed-wings (WIP)
KPLIB_o_fighters = [
    "Flex_CUP_AAF_Fighter"
];

// Enemy static weapons.
// Static HMG (Only raised)
KPLIB_o_statics_H_HMG = [
    "Flex_CUP_AAF_HMG_high"
];

// Static HMG (Only lowered)
KPLIB_o_statics_L_HMG = [
    "Flex_CUP_AAF_HMG_low"
];

// Static GMG (Only raised)
KPLIB_o_statics_H_GMG = [
    "Flex_CUP_AAF_HMG_high"
];

// Static GMG (Only lowered)
KPLIB_o_statics_L_GMG = [
    "Flex_CUP_AAF_MK19_TriPod"
];

// Static AT 
KPLIB_o_statics_AT = [
    "Flex_CUP_AAF_Kornet"
];

// Static AA
KPLIB_o_statics_AA = [
    "Flex_CUP_AAF_Stinger_AA_pod",
    "Flex_CUP_AAF_ZU23"
];

// Enemy SAM radars only
KPLIB_o_SAM_radars = [
    "O_Radar_System_02_F"
];

// Enemy SAM launchers only
KPLIB_o_SAM_launchers = [
    "O_SAM_System_04_F"
];

// Enemy SAM SHORAD
KPLIB_o_SAM_SHORAD = [
    "CUP_O_2S6_RU"
];

// Enemy boats that can spawn on sectors near water
KPLIB_o_boats = [
    "Flex_CUP_AAF_RHIB",
    "Flex_CUP_AAF_RHIB2Turret"
];

/*
    Enemy artilley units. For MLRS, please add classname to KPLIB_o_artilleryMRLS as well.
    Use the export_artyPreset.sqf file to get the classnames in order)
*/
KPLIB_o_artilleryLight = [
    [
        "Flex_CUP_AAF_Mortar",                                           // L16A2 81mm Mortar
        // Available ammunition for this Artillery (DEFAULT AMMUNITON IS REQUIRED!)
        [
            
            "8Rnd_82mm_Mo_shells",                                       // Default Ammunition - Generally HE
            "8Rnd_82mm_Mo_Smoke_white",                                  // Smoke
            "8Rnd_82mm_Mo_Flare_white",                                  // Flare
            "",                                                          // Cluster
            ""                                                           // Laser Guided
        ]
    ]                                                     
];

KPLIB_o_artilleryHeavy = [
    [
        // Artillery
        "Flex_CUP_AAF_D30",                                                // D-30
        // Available ammunition for this Artillery (DEFAULT AMMUNITON IS REQUIRED!)
        [
            
            "CUP_30Rnd_122mmHE_D30_M",                                    // Default Ammunition - Generally HE
            "CUP_30Rnd_122mmSMOKE_D30_M",                                 // Smoke
            "CUP_30Rnd_122mmILLUM_D30_M",                                 // Flare
            "",                                                           // Cluster
            "CUP_30Rnd_122mmLASER_D30_M"                                  // LG
        ]
    ],
    [
        // Artillery
        "Flex_CUP_AAF_Truck_MRL",                                          // KamAZ MRL
        // Available ammunition for this Artillery (DEFAULT AMMUNITON IS REQUIRED!)
        [
            
            "12Rnd_230mm_rockets",                                        // Default Ammunition - Generally HE
            "",                                                           // Smoke
            "",                                                           // Flare
            "",                                                           // Cluster
            ""                                                            // LG
        ]
    ]
];

// MRLS Artillery
KPLIB_o_artilleryMRLS = ["Flex_CUP_AAF_Truck_MRL"];