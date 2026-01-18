/*
    File: cup_aaf_deserters.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 20/10/2025
    Last Update: 17/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        AAF Deserters backed by US and British assets

    Needed Mods:
        - ACW
        - CUP Vehicles
        - CUP Units

    Optional Mods:
        -
*/

/*
    --- Support classnames ---
    Each of these should be unique.
    The same classnames for different purposes may cause various unpredictable issues with player actions.
    Or not, just don't try!
*/
KPLIB_b_fobBuilding     = "Land_Cargo_HQ_V1_F";                         // This is the main FOB HQ building.
KPLIB_b_fobBox          = "B_Slingload_01_Cargo_F";                     // This is the FOB as a container.
KPLIB_b_fobTruck        = "Flex_CUP_USA_Truck_box";                     // This is the FOB as a vehicle.
KPLIB_b_arsenal         = "B_supplyCrate_F";                            // This is the virtual arsenal as portable supply crates.

// This is the mobile respawn (and medical) truck.
KPLIB_b_mobileRespawn   = ["CUP_I_LR_Ambulance_AAF", "Flex_CUP_USA_UH60M_Unarmed_FFV_MEV", "CUP_I_M113A3_Med_AAF"];

KPLIB_b_potato01        = "I_Heli_Transport_02_F";                      // This is Potato 01, a multipurpose mobile respawn as a helicopter.
KPLIB_b_crewUnit        = "Flex_CUP_USA_rifleman_lite";                 // This defines the crew for vehicles.
KPLIB_b_heliPilotUnit   = "Flex_CUP_USA_helipilot";                     // This defines the pilot for helicopters.
KPLIB_b_crewStatic      = "Flex_CUP_USA_rifleman";                      // This defines the crew for static weapons.
KPLIB_b_addHeli         = "CUP_I_LR_Transport_AAF";                     // These are the additional helicopters which spawn on the Freedom or at Chimera base.
KPLIB_b_addBoat         = "B_Boat_Transport_01_F";                      // These are the boats which spawn at the stern of the Freedom.
KPLIB_b_logiTruck       = "Flex_CUP_USA_Truck_transport";               // These are the trucks which are used in the logistic convoy system.
KPLIB_b_smallStorage    = "ContainmentArea_02_sand_F";                  // A small storage area for resources.
KPLIB_b_largeStorage    = "ContainmentArea_01_sand_F";                  // A large storage area for resources.
KPLIB_b_logiStation     = "Land_RepairDepot_01_tan_F";                  // The building defined to unlock FOB recycling functionality.
KPLIB_b_airControl      = "Land_Radar_Small_F";                         // The building defined to unlock FOB air vehicle functionality.
KPLIB_b_slotHeli        = "Land_HelipadSquare_F";                       // The helipad used to increase the GLOBAL rotary-wing cap.
KPLIB_b_slotPlane       = "Land_TentHangar_V1_F";                       // The hangar used to increase the GLOBAL fixed-wing cap.
KPLIB_b_crateSupply     = "CargoNet_01_box_F";                          // This defines the supply crates, as in resources.
KPLIB_b_crateAmmo       = "B_CargoNet_01_ammo_F";                       // This defines the ammunition crates.
KPLIB_b_crateFuel       = "CargoNet_01_barrels_F";                      // This defines the fuel crates.
KPLIB_b_supplyDump      = "Land_Cargo20_military_green_F";              // This defines supply dump for the supply menu

// Basic uniform to spawn with
KPLIB_b_basic_uniform = "U_I_CombatUniform_shortsleeve";

/*
    --- Friendly classnames ---
    Each array below represents one of the 7 pages within the build menu.
    Format: ["vehicle_classname",supplies,ammunition,fuel],
    Example: ["B_APC_Tracked_01_AA_F",300,150,150],
    The above example is the NATO IFV-6a Cheetah, it costs 300 supplies, 150 ammunition and 150 fuel to build.
    IMPORTANT: The last element inside each array must have no comma at the end!
*/


KPLIB_b_infantry = [
    ["Flex_CUP_USA_rifleman_lite",15,0,0],                              // Rifleman (Light)
    ["Flex_CUP_USA_rifleman",20,0,0],                                   // Rifleman
    ["Flex_CUP_USA_antitank_light",30,0,0],                             // Rifleman (AT)
    ["Flex_CUP_USA_antitank",35,0,0],                                   // Rifleman (AT)
    ["Flex_CUP_USA_grenadier",25,0,0],                                  // Grenadier
    ["Flex_CUP_USA_machinegunner",25,0,0],                              // Autorifleman
    ["B_HeavyGunner_F",35,0,0],                                         // Heavygunner
    ["Flex_CUP_USA_marksman",30,0,0],                                   // Marksman
    ["B_Sharpshooter_F",40,0,0],                                        // Sharpshooter
    ["Flex_CUP_USA_antitank_missle",50,10,0],                           // AT Specialist
    ["Flex_CUP_USA_antiair",50,10,0],                                   // AA Specialist
    ["Flex_CUP_USA_medic",30,0,0],                                      // Combat Life Saver
    ["Flex_CUP_USA_mechanic",30,0,0],                                   // Engineer
    ["Flex_CUP_USA_pathfinder",20,0,0],                                 // Recon Scout
    ["Flex_CUP_USA_helipilot",10,0,0],                                  // Helicopter Crew
    ["Flex_CUP_USA_helipilot",10,0,0],                                  // Helicopter Pilot
    ["Flex_CUP_USA_pilot",10,0,0]                                       // Pilot
];

KPLIB_b_vehLight = [
    ["Flex_CUP_USA_Quad",50,0,25],                                      // Quad Bike
    ["CUP_I_LR_Transport_AAF",100,0,50],                                // Land Rover 110
    ["CUP_I_LR_MG_AAF",100,50,50],                                      // Land Rover 110 (M2)
    ["CUP_I_LR_SF_HMG_AAF",150,50,50],                                  // Land Rover 110 (SF HMG)
    ["CUP_I_LR_SF_GMG_AAF",150,100,50],                                 // Land Rover 110 (SF HMG)
    ["Flex_CUP_USA_nM1151_Unarmed",100,0,50],                           // Humvee
    ["Flex_CUP_USA_nM1151_ogpk_m2",100,50,50],                          // Humvee (M2)
    ["Flex_CUP_USA_nM1151_ogpk_mk19",100,100,50],                       // Humvee (MK19)
    ["Flex_CUP_USA_MRAP",100,0,50],                                     // MRAP
    ["Flex_CUP_USA_nM1025_SOV_M2",150,50,50],                           // Humvee SOV (M2)
    ["Flex_CUP_USA_nM1025_SOV_Mk19",150,100,50],                        // Humvee SOV (Mk19)
    ["Flex_CUP_USA_Truck_transport",150,0,75],                          // HEMTT Transport
    ["Flex_CUP_USA_Truck_covered",150,0,75],                            // HEMTT Transport (Covered)
    ["Flex_CUP_USA_Truck_cargo",140,0,75],                              // HEMTT Cargo
    ["CUP_I_LR_AA_AAF",100,300,50],                                     // Land Rover 110 (AA)
    ["CUP_B_Ridgback_HMG_GB_W",250,50,75],                              // Ridgeback PPV (HMG)
    ["B_Boat_Transport_01_F",100,0,25],                                 // Assault Boat
    ["B_Boat_Armed_01_minigun_F",200,150,75],                           // Speedboat Minigun
    ["CUP_B_MK10_GB",250,0,100],                                        // LCU Mk.10
    ["CUP_B_LCU1600_USMC",400,0,100],                                   // LCU 1610                               
    ["CUP_B_nM1036_TOW_DF_NATO",400,0,100],                             // Humvee TOW
    ["Flex_CUP_USA_TowingTractor",100,0,50]                             // Towing truck        
];

KPLIB_b_vehHeavy = [
    ["CUP_I_M113A3_AAF",150,75,100],                                    // M113 (M2)
    ["CUP_I_M163_Vulcan_AAF",150,300,100],                              // M163 Vulcan (AA)
    ["CUP_B_M1126_ICV_M2_Woodland", 250, 250, 150],                     // Stryker M1126 (M2)
    ["CUP_B_M1126_ICV_MK19_Woodland", 250, 350, 150],                   // Stryker M1126 (MK19)
    ["CUP_B_FV432_Bulldog_GB_W_RWS",200,75,100],                        // Bulldog
    ["CUP_B_LAV25M240_green",250,150,125],                              // LAV-25 (M240)
    ["CUP_B_FV510_GB_W_SLAT",500,250,175],                              // FV510 Warrior (SLAT)
    ["CUP_B_M1A1FEP_OD_USMC",750,400,300],                              // M1A1 FEP
    ["CUP_B_M1A1EP_TUSK_OD_USMC",1000,400,300],                         // M1A1 FEP (Full TUSK)
    ["CUP_B_Challenger2_Woodland_BAF",1100,500,300],                    // Challanger 2
    ["CUP_B_M2A3Bradley_USA_W", 1250,600,175],                          // M3A3 Bradley IFV  
    ["CUP_B_M3A3BradleyCFV_USA_W",1500,750,175],                        // M3A3 Bradley CFV
    ["CUP_B_M270_HE_BAF_WOOD",800,1750,400]                             // M270 MLRS (HE)
];

KPLIB_b_vehAir = [
    ["CUP_I_Wildcat_Unarmed_Digital_AAF",225,0,150],                    // AW159 Wildcat
    ["CUP_I_Ka60_GL_Digi_AAF",275,200,175],                             // Ka-60 Kasatka (Rockets)
    ["CUP_I_412_Military_Armed_AAF",200,500,125],                       // CH-146 Griffon (Dynamic Loadout)
    ["CUP_I_Mi24_D_Dynamic_AAF",600,500,300],                           // Mi-24D
    ["CUP_I_AH1Z_Dynamic_AAF",750,750,250],                             // AH-1Z
    ["CUP_B_Merlin_HC3_VIV_GB",275,0,175],                              // Merlin HC3 (Cargo)
    ["CUP_B_MH47E_USA",400,0,100],                                      // Chinook MH47E
    ["Flex_CUP_USA_MH6J",300,0,100],                                    // Littlebird MH6J  
    ["Flex_CUP_USA_AH6M",300,300,100],                                  // Littlebird AH6M       
    ["CUP_B_C130J_USMC",200,0,250],                                     // C-130J Super Hercules
    ["CUP_B_C130J_Cargo_USMC",200,0,250],                               // C-130J Super Hercules (Cargo)
    ["Flex_CUP_USA_UAV_MQ9",500,750,200],                               // MQ-9 Reaper
    ["FIR_AV8B_GR9A",800,1000,1000],                                    // Harrier AV-8B (CAS)
    ["FIR_F16C", 2500,2500,1250]                                        // F-16C
];

KPLIB_b_vehStatic = [
    ["Flex_CUP_USA_HMG_high",25,40,0],                                  // M2 HMG (Raised)
    ["Flex_CUP_USA_TOW2",50,100,0],                                     // TOW-2
    ["Flex_CUP_USA_Stinger_AA_pod",50,100,0],                           // Stinger AA pod
    ["Flex_CUP_USA_M252",200,150,0],                                    // M252 Mortar
    ["B_Radar_System_01_F",700,0,0],                                    // AN/MPQ-105 Radar
    ["B_SAM_System_03_F",250,700,0],                                    // MIM-145 Defender
    ["B_AAA_System_01_F",350,500,0],                                    // Praetorian
    ["Flex_CUP_USA_M119",500,500,0]                                     // M119 (Artillery)
];

KPLIB_b_objectsDeco = [
    ["Land_Cargo_House_V1_F",50,0,0],
    ["Land_Cargo_Patrol_V1_F",100,0,0],
    ["Land_Cargo_Tower_V1_F",300,0,0],
    ["Flag_NATO_F",10,0,0],
    ["Flag_Altis_F",10,0,0],
    ["Flag_US_F",10,0,0],
    ["Flag_UK_F",10,0,0],
    ["CamoNet_BLUFOR_F",10,0,0],
    ["CamoNet_BLUFOR_open_F",10,0,0],
    ["CamoNet_BLUFOR_big_F",20,0,0],
    ["Land_PortableLight_single_F",5,0,0],
    ["Land_PortableLight_double_F",5,0,0],
    ["Land_LampSolar_F",5,0,0],
    ["Land_LampHalogen_F",10,0,0],
    ["Land_LampStreet_small_F",5,0,0],
    ["Land_LampAirport_F",25,0,0],
    ["Land_HelipadCircle_F",10,0,0],                                     // Strictly aesthetic - as in it does not increase helicopter cap!
    ["Land_HelipadRescue_F",10,0,0],                                     // Strictly aesthetic - as in it does not increase helicopter cap!
    ["PortableHelipadLight_01_blue_F",1,0,0],
    ["PortableHelipadLight_01_green_F",1,0,0],
    ["PortableHelipadLight_01_red_F",1,0,0],
    ["Land_CampingChair_V1_F",1,0,0],
    ["Land_CampingChair_V2_F",1,0,0],
    ["Land_CampingTable_F",1,0,0],
    ["MapBoard_altis_F",0,0,0],
    ["MapBoard_stratis_F",0,0,0],
    ["MapBoard_seismic_F",0,0,0],
    ["Land_Pallet_MilBoxes_F",0,0,0],
    ["Land_PaperBox_open_empty_F",0,0,0],
    ["Land_PaperBox_open_full_F",0,0,0],
    ["Land_PaperBox_closed_F",0,0,0],
    ["Land_DieselGroundPowerUnit_01_F",10,0,10],
    ["Land_ToolTrolley_02_F",0,0,0],
    ["Land_WeldingTrolley_01_F",0,0,0],
    ["Land_Workbench_01_F",0,0,0],
    ["Land_GasTank_01_blue_F",0,0,0],
    ["Land_GasTank_01_khaki_F",0,0,0],
    ["Land_GasTank_01_yellow_F",0,0,0],
    ["Land_GasTank_02_F",0,0,0],
    ["Land_BarrelWater_F",0,0,0],
    ["Land_BarrelWater_grey_F",0,0,0],
    ["Land_WaterBarrel_F",0,0,0],
    ["Land_WaterTank_F",0,0,0],
    ["Land_BagFence_Round_F",5,0,0],
    ["Land_BagFence_Short_F",5,0,0],
    ["Land_BagFence_Long_F",5,0,0],
    ["Land_BagFence_Corner_F",5,0,0],
    ["Land_BagFence_End_F",5,0,0],
    ["Land_BagBunker_Small_F",10,0,0],
    ["Land_BagBunker_Large_F",50,0,0],
    ["Land_BagBunker_Tower_F",100,0,0],
    ["Land_HBarrier_1_F",10,0,0],
    ["Land_HBarrier_3_F",10,0,0],
    ["Land_HBarrier_5_F",10,0,0],
    ["Land_HBarrier_Big_F",20,0,0],
    ["Land_HBarrierWall4_F",20,0,0],
    ["Land_HBarrierWall6_F",20,0,0],
    ["Land_HBarrierWall_corner_F",10,0,0],
    ["Land_HBarrierWall_corridor_F",10,0,0],
    ["Land_HBarrierTower_F",100,0,0],
    ["Land_CncBarrier_F",10,0,0],
    ["Land_CncBarrier_stripes_F",10,0,0],
    ["Land_CncBarrierMedium_F",10,0,0],
    ["Land_CncBarrierMedium4_F",10,0,0],
    ["Land_Concrete_SmallWall_4m_F",10,0,0],
    ["Land_Concrete_SmallWall_8m_F",10,0,0],
    ["Land_CncShelter_F",0,0,0],
    ["Land_CncWall1_F",0,0,0],
    ["Land_CncWall4_F",0,0,0],
    ["Land_Sign_WarningMilitaryArea_F",0,0,0],
    ["Land_Sign_WarningMilAreaSmall_F",0,0,0],
    ["Land_Sign_WarningMilitaryVehicles_F",0,0,0],
    ["Land_Razorwire_F",5,0,0],
    ["Land_ClutterCutter_large_F",0,0,0]
];

KPLIB_b_vehSupport = [
    [KPLIB_b_arsenal,100,200,0],
    [(KPLIB_b_mobileRespawn select 0),200,0,100],
    [(KPLIB_b_mobileRespawn select 1),200,0,100],
    [KPLIB_b_fobBox,300,500,0],
    [KPLIB_b_fobTruck,300,500,75],
    [KPLIB_b_smallStorage,0,0,0],
    [KPLIB_b_largeStorage,0,0,0],
    [KPLIB_b_logiStation,250,0,0],
    [KPLIB_b_airControl,1000,0,0],
    [KPLIB_b_slotHeli,500,0,0],
    [KPLIB_b_slotPlane,1000,0,0],
    [KPLIB_b_supplyDump, 250,1000,0],                                  // Supply dump
    ["Land_MedicalTent_01_digital_closed_F", 200,0,0],
    ["ACE_medicalSupplyCrate_advanced",50,0,0],
    ["ACE_Box_82mm_Mo_HE",50,40,0],
    ["ACE_Box_82mm_Mo_Smoke",50,10,0],
    ["ACE_Box_82mm_Mo_Illum",50,10,0],
    ["Land_Bomb_Trolley_01_F",0,1000,0],                                // Required to use PiG's pylon manager
    ["Land_Missle_Trolley_02_F",0,1000,0],                              // Required to use PiG's pylon manager
    ["ACE_Wheel",10,0,0],
    ["ACE_Track",10,0,0],
    ["Flex_CUP_USA_Truck_Repair",650,0,75],                             // HEMTT Repair
    ["Flex_CUP_USA_Truck_fuel",150,0,575],                              // HEMTT Fuel
    ["Flex_CUP_USA_Truck_ammo",150,500,75],                             // HEMTT Ammo
    ["B_Slingload_01_Repair_F",575,0,0],                                // Huron Repair
    ["B_Slingload_01_Fuel_F",75,0,575],                                 // Huron Fuel
    ["B_Slingload_01_Ammo_F",75,500,0],                                 // Huron Ammo
    ["CUP_I_M113A3_Repair_AAF",700,0,100],                              // M113 Repair
    ["CUP_I_M113A3_Reammo_AAF",200,500,100]                             // M113 Ammo
];

/*
    --- Squads ---
    Pre-made squads for the commander build menu.
    These shouldn't exceed 10 members.
*/

// Light infantry squad.
KPLIB_b_squadLight = [
    "Flex_CUP_USA_teamleader",
    "Flex_CUP_USA_rifleman",
    "Flex_CUP_USA_rifleman",
    "Flex_CUP_USA_antitank_light",
    "Flex_CUP_USA_grenadier",
    "Flex_CUP_USA_machinegunner",
    "Flex_CUP_USA_marksman",
    "Flex_CUP_USA_medic",
    "Flex_CUP_USA_mechanic"
];

// Heavy infantry squad.
KPLIB_b_squadInf = [
    "Flex_CUP_USA_teamleader",
    "Flex_CUP_USA_rifleman",
    "Flex_CUP_USA_antitank",
    "Flex_CUP_USA_antitank_light",
    "Flex_CUP_USA_grenadier",
    "Flex_CUP_USA_machinegunner",
    "Flex_CUP_USA_machinegunner",
    "Flex_CUP_USA_marksman",
    "Flex_CUP_USA_medic",
    "Flex_CUP_USA_mechanic"
];

// AT specialists squad.
KPLIB_b_squadAT = [
    "Flex_CUP_USA_teamleader",
    "Flex_CUP_USA_rifleman",
    "Flex_CUP_USA_rifleman",
    "Flex_CUP_USA_antitank",
    "Flex_CUP_USA_antitank_missle",
    "Flex_CUP_USA_antitank_missle",
    "Flex_CUP_USA_medic",
    "Flex_CUP_USA_rifleman"
];

// AA specialists squad.
KPLIB_b_squadAA = [
    "Flex_CUP_USA_teamleader",
    "Flex_CUP_USA_rifleman",
    "Flex_CUP_USA_rifleman",
    "Flex_CUP_USA_antiair",
    "Flex_CUP_USA_antiair",
    "Flex_CUP_USA_antiair",
    "Flex_CUP_USA_medic",
    "Flex_CUP_USA_rifleman"
];

// Force recon squad.
KPLIB_b_squadRecon = [
    "Flex_CUP_USA_pathfinder",
    "Flex_CUP_USA_antitank",
    "Flex_CUP_USA_marksman",
    "Flex_CUP_USA_marksman",
    "Flex_CUP_USA_antiair",
    "Flex_CUP_USA_medic",
    "Flex_CUP_USA_mechanic"
];

// Paratroopers squad (The units of this squad will automatically get parachutes on build)
KPLIB_b_squadPara = [
    "Flex_CUP_USA_rifleman",
    "Flex_CUP_USA_rifleman",
    "Flex_CUP_USA_rifleman",
    "Flex_CUP_USA_rifleman",
    "Flex_CUP_USA_rifleman",
    "Flex_CUP_USA_rifleman",
    "Flex_CUP_USA_rifleman",
    "Flex_CUP_USA_rifleman",
    "Flex_CUP_USA_rifleman",
    "Flex_CUP_USA_rifleman"
];

/*
    --- Vehicles to unlock ---
    Classnames below have to be unlocked by capturing military bases.
    Which base locks a vehicle can selected or randomized on the first start of the campaign.
        0: vehicle classname <STRING>
        1: sector which locks the vehicle <STRING>
    Example:
        ["vehicle_classname", "military_1"]
    If an empty string ("") is left in the sector selection, it will be randomized.
*/
KPLIB_b_vehToUnlock = [
    ["CUP_B_Ridgback_HMG_GB_W", "military_1"],
    ["Flex_CUP_USA_M252", "military_22"],
    ["Flex_CUP_USA_M119", "military_16"],
    ["CUP_B_FV510_GB_W_SLAT", "bigtown_1"],
    ["CUP_B_M1A1FEP_OD_USMC", "military_3"],
    ["CUP_B_M1A1EP_TUSK_OD_USMC", "bigtown_2"],
    ["CUP_B_Challenger2_Woodland_BAF", "bigtown_9"],
    ["CUP_B_M270_HE_BAF_WOOD", "bigtown_6"],
    ["CUP_I_Ka60_GL_Digi_AAF", "military_4"],
    ["CUP_I_412_Military_Armed_AAF", "military"],
    ["CUP_I_AH1Z_Dynamic_AAF", "military_6"],
    ["CUP_I_Mi24_D_Dynamic_AAF", "military_10"],
    ["FIR_AV8B_GR9A", "military_8"],
    ["FIR_F16C", "military_14"],
    ["Flex_CUP_USA_UAV_MQ9", "military_5"],
    ["B_Boat_Armed_01_minigun_F", "military_19"],
    ["Flex_CUP_USA_AH6M", "military_7"],
    ["CUP_B_MH47E_USA", "factory_ammo"],
    ["CUP_B_LCU1600_USMC", "factory_fuel_7"]   
];
