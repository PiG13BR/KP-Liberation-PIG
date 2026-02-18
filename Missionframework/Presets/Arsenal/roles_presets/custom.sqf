/*
    File: custom.sqf
    Author: PIG13BR (https://github.com/PiG13BR)
    Date: 26/07/2024
    Updated: 17/01/2026

    Description:
        Set up your arsenal inventory based on role selection in this file.
        Make any changes you want here, just don't change the name of variables with KPLIB tags.
    
    Parameter(s):
        _classRole - classname of the player's entity [STRING, defaults as ""]

    Returns:
        -
*/

params[["_classRole", "", [""]]];

// ---------------------------------------------------------- Variabes/classification of equipments to be used for the roles
// The already existed variables are suggestion, you can delete them all or used it, but make sure you configure them with the roles below in this file

// Weapons
_rifles_basic = [
    "CUP_arifle_M16A4_base",
    "CUP_arifle_M16A4_grip",
    "CUP_Famas_F1",
    "CUP_Famas_F1_rail",
    "CUP_Famas_F1_wood",
    "CUP_Famas_F1_Rail_Wood",
    "CUP_CZ_BREN2_762_14",
    "CUP_CZ_BREN2_762_14_Grn",
    "CUP_CZ_BREN2_762_14_Tan",
    "CUP_arifle_X95_Grippod",
    "CUP_arifle_G3A3_ris",
    "CUP_arifle_G3A3_ris_vfg",
    "CUP_arifle_G3A3_modern_ris",
    "CUP_arifle_L85A2",
    "CUP_arifle_L85A2_G",
    "CUP_arifle_Mk17_CQC_Black",
    "CUP_arifle_Mk17_CQC_FG_Black",
    "CUP_arifle_HK_M27",
    "CUP_arifle_HK_M27_VFG",
    "CUP_arifle_Galil_SAR_black",
    "CUP_arifle_Galil_black",
    "CUP_arifle_Galil_556_black",
    "CUP_arifle_DSA_SA58"
];

_rifles_special = [
    ""
];

_rifles_granadier = [
    "CUP_CZ_BREN2_762_14_GL",
    "CUP_arifle_Mk17_CQC_EGLM_black",
    "CUP_arifle_L85A2_GL",
    "CUP_glaunch_M32",
    "CUP_arifle_HK_M27_AG36",
    "CUP_arifle_M16A4_GL",
    "CUP_glaunch_M79",
    "CUP_arifle_Galil_SAR_black",
    "CUP_arifle_Galil_black",
    "CUP_Famas_F1",
    "CUP_Famas_F1_rail",
    "CUP_Famas_F1_wood",
    "CUP_Famas_F1_Rail_Wood",
    "CUP_arifle_G3A3_ris",
    "CUP_arifle_G3A3_ris_vfg",
    "CUP_arifle_G3A3_modern_ris",
    "CUP_arifle_X95_Grippod",
    "CUP_arifle_DSA_SA58_OSW_M203"
];

_lmgs = [
    "CUP_lmg_minimi_railed",
    "CUP_lmg_MG3_rail",
    "CUP_lmg_M240",
    "CUP_lmg_minimipara",
    "CUP_lmg_M240_norail",
    "CUP_arifle_HK_M27",
    "CUP_arifle_HK_M27_VFG",
    "CUP_arifle_L86A2",
    "CUP_lmg_Mk48",
    "CUP_arifle_Galil_556_black"
];

_smgs = [
    "CUP_smg_UZI",
    "CUP_smg_MP5A5_Rail"
];

_rifles_marksman = [
    "CUP_arifle_G3A3_ris_black",
    "CUP_arifle_Mk20",
    "CUP_arifle_L86A2",
    "CUP_arifle_M4_MOE_BW",
    "CUP_arifle_Galil_black",
    "CUP_arifle_DSA_SA58_DMR",
    "CUP_srifle_M107_Base",
    "CUP_srifle_M40A3",
    "CUP_srifle_AWM_wdl",
    "CUP_srifle_M24_blk"
];

_shotguns = [
    "CUP_sgun_M1014",
    "CUP_sgun_M1014_solidstock"
];

_pistols = [
    "CUP_hgun_Colt1911",
    "CUP_hgun_Browning_HP",
    "CUP_hgun_Mk23",
    "CUP_hgun_Glock17",
    "CUP_hgun_Glock17_blk"
];

_ace_metal_detector = [
    ""
];

//Bazookas
_launchers_HAT = [
    "ACE_launch_NLAW_ready_F",
    "CUP_launch_Javelin"
];

_launchers_LAT = [
    "CUP_launch_RPG7V",
    "CUP_launch_MAAWS",
    "CUP_launch_Mk153Mod0"
];

_discard_launchers = [
    "CUP_launch_M72A6",
    "CUP_launch_M136",
    "CUP_launch_HCPF3"
];

_launchers_AA = [
    "CUP_launch_FIM92Stinger_Loaded"
];

// Magazines
_mags = [
    // Rifles
    "CUP_30Rnd_556x45_Stanag",
    "CUP_30Rnd_556x45_Stanag_L85",
    "ACE_30Rnd_556x45_Stanag_M995_AP_mag",
    "CUP_20Rnd_762x51_G3",
    "CUP_20Rnd_TE1_Green_Tracer_762x51_G3",
    "30Rnd_556x45_Stanag_green",
    "CUP_25Rnd_556x45_Famas_Tracer_Green",
    "CUP_25Rnd_556x45_Famas",
    "CUP_30Rnd_762x39_CZ807",
    "CUP_30RND_TE1_Green_Tracer_762x39_CZ807",
    "CUP_8Rnd_12Gauge_Pellets_No00_Buck",
    "CUP_8Rnd_12Gauge_HE",
    "CUP_8Rnd_12Gauge_Slug",
    "CUP_10Rnd_50BW_Mag_M4_M",
    "CUP_20Rnd_TE1_Green_Tracer_762x51_B_SCAR_bkl",
    "CUP_20Rnd_762x51_B_SCAR_bkl",
    "CUP_30Rnd_TE1_Green_Tracer_762x51_1_SCAR",
    "CUP_20Rnd_TE1_Green_Tracer_762x51_B_M110",
    "CUP_35Rnd_556x45_Galil_Mag",
    "CUP_35Rnd_556x45_Green_Tracer_Galil_Mag",
    "CUP_25Rnd_762x51_Green_Tracers_Galil_Mag",
    "CUP_25Rnd_762x51_Galil_Mag",
    "CUP_20Rnd_762x51_FNFAL_M",
    "CUP_20Rnd_TE1_Green_Tracer_762x51_FNFAL_M",
    
    // GL
    "1Rnd_HE_Grenade_shell",
    "1Rnd_Smoke_Grenade_shell",
    "CUP_6Rnd_HE_M203",
    "CUP_6Rnd_Smoke_M203",
    "CUP_1Rnd_HEDP_M203",
    "UGL_FlareWhite_F",
    "UGL_FlareRed_F",
    "CUP_1Rnd_StarCluster_White_M203",
    "ACE_40mm_Flare_ir",

    // SMG
    "30Rnd_9x21_Mag_SMG_02",
    "CUP_30Rnd_9x19_MP5",
    "CUP_32Rnd_9x19_UZI_M",

    // LMG
    "CUP_100Rnd_TE4_LRT4_Green_Tracer_762x51_Belt_M",
    "CUP_100Rnd_TE4_Green_Tracer_556x45_M249",
    "150Rnd_762x51_Box_Tracer",
    "CUP_200Rnd_TE4_Green_Tracer_556x45_L110A1",
    "CUP_60Rnd_556x45_SureFire_Tracer_Green",
    "CUP_60Rnd_556x45_SureFire",
    "CUP_50Rnd_556x45_Galil_Mag",
    "CUP_50Rnd_556x45_Green_Tracer_Galil_Mag",
    "CUP_35Rnd_556x45_Galil_Mag",
    "CUP_35Rnd_556x45_Green_Tracer_Galil_Mag",
    "CUP_30Rnd_556x45_Stanag",
    "CUP_30Rnd_556x45_Stanag_L85",
    "ACE_30Rnd_556x45_Stanag_M995_AP_mag",

    
    // MARKSMAN
    "ACE_10Rnd_762x51_Mag_Tracer_Dim",
    "CUP_5Rnd_86x70_L115A1",
    "CUP_10Rnd_127x99_M107",
    "CUP_20Rnd_TE1_Green_Tracer_762x51_B_M110",
    "CUP_20Rnd_TE1_Green_Tracer_762x51_B_SCAR_bkl",
    "CUP_20Rnd_762x51_B_SCAR_bkl",
    "CUP_30Rnd_556x45_Stanag_L85",
    "CUP_20Rnd_762x51_FNFAL_M",
    "CUP_20Rnd_TE1_Green_Tracer_762x51_FNFAL_M",
    "CUP_5Rnd_762x51_M24",

    // PISTOLS
    "CUP_7Rnd_45ACP_1911",
    "CUP_13Rnd_9x19_Browning_HP",
    "ACE_16Rnd_9x19_mag",
    "CUP_17Rnd_9x19_glock17",
    "CUP_12Rnd_45ACP_mk23",

    
    // LAUNCHERS
    "MRAWS_HEAT_F",
    "MRAWS_HEAT55_F",
    "MRAWS_HE_F",
    "CUP_MAAWS_HEAT_M",
    "CUP_MAAWS_HEDP_M",
    "CUP_SMAW_HEDP_M",
    "CUP_SMAW_HEAA_M",
    "CUP_SMAW_NE_M",
    "CUP_SMAW_Spotting",
    "CUP_OG7_M",
    "CUP_PG7V_M",
    "CUP_PG7VL_M",
    "CUP_PG7VR_M",
    "CUP_Javelin_M",

    // Laser
    "Laserbatteries"
];

// Grenades & explosives
_grenades = [
    "CUP_HandGrenade_L109A2_HE",
    "CUP_HandGrenade_M67",
    "SmokeShell",
    "SmokeShellRed",
    "SmokeShellBlue",
    "SmokeShellOrange",
    "Chemlight_green",
    "ACE_M14",
    "ACE_CTS9",
    "ACE_M84"
];

_explosives = [
    "DemoCharge_Remote_Mag",
    "CUP_PipeBomb_M"
];


// Weapons attachment
_rifles_optics = [
    "CUP_optic_CompM4",
    "CUP_optic_HoloBlack",
    "CUP_optic_G33_HWS_BLK",
    "CUP_optic_AIMM_COMPM4_BLK",
    "CUP_optic_SUSAT",
    "CUP_optic_ACOG_TA01B_Black",
    "CUP_optic_ACOG2",
    "CUP_optic_Elcan_SpecterDR_black",
    "CUP_optic_AIMM_MICROT1_BLK",
    "CUP_optic_MicroT1",
    "CUP_optic_MicroT1_low",
    "CUP_optic_Elcan_SpecterDR_RMR_black",
    "CUP_optic_Elcan_reflex",
    "CUP_optic_Elcan",
    "CUP_optic_HensoldtZO_low",
    "CUP_optic_HensoldtZO",
    "CUP_optic_HensoldtZO_RDS",
    "CUP_optic_SB_11_4x20_PM"
];

_LAT_optics = [
    "CUP_optic_MAAWS_Scope"
];

_marksman_optics = [
    "CUP_optic_LeupoldMk4",
    "CUP_optic_LeupoldMk4_25x50_LRT",
    "CUP_optic_SB_11_4x20_PM"
    
];

_rail_attach = [
    "ACE_DBAL_A3_Green",
    "ACE_DBAL_A3_Red",
    "ACE_SPIR",
    "CUP_acc_ANPEQ_15_Black",
    "CUP_acc_Flashlight",
    "CUP_acc_ANPEQ_15_OD",
    "CUP_acc_ANPEQ_15_Black_Top",
    "CUP_acc_ANPEQ_15_OD_Top",
    "CUP_acc_ANPEQ_15_Flashlight_Black_L",
    "CUP_acc_ANPEQ_15_Flashlight_OD_L"
];

_muzzle_attach = [
    "muzzle_snds_H",
    "muzzle_snds_M",
    "CUP_muzzle_snds_socom762rc",
    "CUP_muzzle_snds_M16",
    "CUP_muzzle_fh_MP5",
    "ACE_muzzle_mzls_B",
    "ACE_muzzle_mzls_H",
    "ACE_muzzle_mzls_L",
    "CUP_muzzle_mfsup_Flashhider_762x51_Black",
    "CUP_muzzle_mfsup_Flashhider_556x45_Black",
    "CUP_muzzle_snds_L85",
    "muzzle_snds_H_MG",
    "CUP_muzzle_snds_FAMAS"
];

_rifles_grip = [
    ""
];

_rifles_bipod = [
    "CUP_bipod_G3",
    "CUP_bipod_G3SG1",
    "CUP_bipod_Harris_1A2_L_BLK"
];

// Uniforms, Vests, helmets, backpacks, facewears
_uniforms = [
    "U_I_CombatUniform",
    "U_I_CombatUniform_shortsleeve",
    "U_BG_Guerilla1_1",
    "U_BG_leader"
];

_uniforms_officer = [
    "U_I_OfficerUniform"
];

_uniforms_sniper = [
    "U_I_FullGhillie_lsh"
];

_uniforms_pilot = [
    "CUP_U_B_USArmy_PilotOverall",
    "U_B_PilotCoveralls",
    "FIR_Fighter_Pilot_JASDF_Nomex3",
    "FIR_Fighter_Pilot_JASDF_Nomex4"
];

_uniforms_crewman = [
    "U_BG_Guerilla1_1"
];

_vests = [
    "CUP_V_PMC_CIRAS_OD_TL",
    "CUP_V_PMC_CIRAS_OD_Patrol",
    "CUP_V_PMC_CIRAS_OD_Empty"
];

_vests_pilot = [
    "CUP_V_B_USArmy_PilotVest",
    "FIR_pilot_vest"
];

_vests_crewman = [
    "CUP_V_PMC_CIRAS_OD_Empty"
];

_helmets = [
    "H_HelmetIA",
    "H_Beret_blk",
    "CUP_H_OpsCore_Covered_AAF_SF"
];

_pilot_helmets = [
    "CUP_H_SPH4_grey",
    "H_PilotHelmetFighter_B",
    "FIR_JHMCS",
    "FIR_JHMCS_II",
    "FIR_JHMCS_Type2"
];

_crewman_helmets = [
    "CUP_H_SLA_TankerHelmet"
];

_caps = [
    "G_Headband_teal_F",
    "H_MilCap_dgtl",
    "H_Booniehat_dgtl",
    "G_Bandanna_blk",
    "H_Booniehat_dgtl",
    "G_Bandanna_oli",
    "H_Beret_blk",
    "H_Cap_headphones",
    "H_Shemag_olive_hs",
    "H_Watchcap_camo"
];

_caps_commander = [
    "H_Beret_Colonel"
];

_sniper_caps = [
    ""
];

_backpacks = [
    "B_AssaultPack_dgtl",
    "CUP_B_AlicePack_OD",
    "CUP_T10_Parachute_backpack",
    "B_Kitbag_rgr",
    "B_Parachute"
];

_backpacks_radio = [
    "tfw_ilbe_whip_wd"
];

_big_backpacks = [
    "B_Carryall_oli",
    "B_Carryall_green_F"
];

_facewears = [
    "G_Aviator",
    "G_Bandanna_aviator",
    "CUP_G_Scarf_Face_Grn",
    "CUP_G_Scarf_Face_Tan",
    "G_Tactical_Clear",
    "G_Armband_NVG_Cross_alt_F",
    "G_Armband_Cross_F",
    "G_Armband_grn_F",
    "G_Armband_grn_alt_F",
    "G_Armband_MP_alt_F",
    "G_Armband_MP_F",
    "G_Armband_pur_F",
    "G_Armband_pur_alt_F",
    "G_Armband_red_alt_F",
    "G_Armband_red_F",
    "G_Armband_MP_alt_F",
    "G_Armband_yel_F",
    "G_Armband_yel_alt_F",
    "G_Armband_hivis_alt_F",
    "G_Armband_hivis_F",
    "G_Armband_hivis2_F",
    "G_Armband_hivis2_alt_F",
    "G_Armband_hivis_F",
    "G_Armband_hivis_F",
    "G_Armband_dblu_F",
    "G_Armband_dblu_alt_F",
    "CUP_G_RUS_Ratnik_Balaclava_Green_1",
    "CUP_G_RUS_Ratnik_Balaclava_Green_2",
    "CUP_G_RUS_Ratnik_Balaclava_Green_3",
    "CUP_G_RUS_Ratnik_Balaclava_Green_4",
    "CUP_G_RUS_Ratnik_Balaclava_Olive_1",
    "CUP_G_RUS_Ratnik_Balaclava_Olive_2",
    "CUP_G_Grn_Scarf_Shades_GPS_Beard",
    "CUP_G_Grn_Scarf_Shades_GPS_Beard_Blonde",
    "CUP_G_Tan_Scarf_Shades_GPS_Beard",
    "CUP_G_Tan_Scarf_Shades_GPS_Beard_Blonde"
];

// Nightvision
_nvgs = [
    "G_Armband_NVG_afia_alt_F",
    "G_Armband_NVG_afia_F",
    "ACE_NVG_Gen1",
    "ACE_NVG_Gen2_Black",
    "ACE_NVG_Gen4_Black_WP",
    "CUP_NVG_PVS15_black_WP",
    "G_Armband_NVG_Cross_alt_F",
    "G_Armband_NVG_Cross_F",
    "G_Armband_NVG_grn_F",
    "G_Armband_NVG_grn_alt_F",
    "G_Armband_NVG_MP_alt_F",
    "G_Armband_NVG_MP_F",
    "G_Armband_NVG_pur_F",
    "G_Armband_NVG_pur_alt_F",
    "G_Armband_NVG_red_alt_F",
    "G_Armband_NVG_red_F",
    "G_Armband_NVG_MP_alt_F",
    "G_Armband_NVG_yel_F",
    "G_Armband_NVG_yel_alt_F",
    "G_Armband_NVG_hivis_alt_F",
    "G_Armband_NVG_hivis_F",
    "G_Armband_NVG_hivis2_F",
    "G_Armband_NVG_hivis2_alt_F",
    "G_Armband_NVG_hivis_F",
    "G_Armband_NVG_hivis_F",
    "G_Armband_NVG_dblu_F",
    "G_Armband_NVG_dblu_alt_F"
];

// Binoculars
_common_binos = [
    "Binocular"
];

_laser_binos = [
    "Laserdesignator"
];

_range_binos = [
    "Rangefinder",
    "ACE_Vector"
];

_drones = [
    "DRNP_AL6P",
    "DRNP_AR2P",
    "DRNP_Drone_mines",
    "ACE_UAVBattery"
];

// Common tools & medic items
_ace_common_tools = [
    "ACE_Fortify",
    "ACE_EntrenchingTool",
    "ACE_Clacker",
    "ACE_Flashlight_XL50",
    "ACE_Tripod",
    "ACE_MapTools",
    "ACE_RangeCard",
    "ACE_microDAGR"
];

_ace_eng_tools = [
    "MineDetector",
    "ToolKit",
    "ACE_wirecutter",
    "ACE_DefusalKit"
];

_ace_common_medical_items = [
    "ACE_packingBandage",
    "ACE_quikclot",
    "ACE_fieldDressing",
    "ACE_elasticBandage",
    "ACE_painkillers",
    "ACE_morphine",
    "ACE_personalAidKit"
];

_ace_medic_items = [
    "ACE_bloodIV_500",
    "ACE_plasmaIV_500",
    "ACE_salineIV_500",
    "ACE_bloodIV_25",
    "ACE_plasmaIV_250",
    "ACE_salineIV_250",
    "ACE_bloodIV",
    "ACE_plasmaIV",
    "ACE_salineIV",
    "ACE_surgicalKit",
    "ACE_tourniquet",
    "ACE_suture",
    "ACE_splint",
    "ACE_adenosine",
    "ACE_epinephrine",
    "ACE_bodyBag"
];

_ace_misc = [
    "ACE_CableTie",
    "ACE_Canteen",
    "ACE_EarPlugs",
    "ACE_IR_Strobe_Item",
    "ACE_UAVBattery",
    "ACE_Altimeter"
];

// Items & Communication
_common_items = [
    "ItemMap",
    "ItemcTabHcam", // cTab 1erGTD
    "ItemGPS",
    "ItemCompass",
    "ItemWatch",
    "tsp_sling"
];

_radio = [ 
    "ACRE_PRC152",
    "ACRE_PRC343",
    "ACRE_VHF30108MAST",
    "ACRE_PRC117F"
];

_cTab_items = [
    "itemcTabMisc", // cTab 1erGTD
    "ItemAndroidMisc" // cTab 1erGTD
];

_uav_terminal = [
    "B_UavTerminal"
];

sleep 1;

// ---------------------------------------------------------- Defined roles classnames
// The playable characters in the editor must match these classnames below
// Make any chances you want here, just make sure you register them in the switch do command below (after "case")
_commander = "B_officer_F";
_sqleader = "B_Soldier_SL_F";
_mg = "B_soldier_AR_F";
_rifleman = "B_Soldier_F";
_engineer = "B_engineer_F";
_medic = "B_medic_F";
_rifleman_launchers = "B_soldier_LAT_F";
_granadier = "B_Soldier_GL_F";
_marksman = "B_soldier_M_F";
_sniper = "B_sniper_F";
_pilot = "B_Helipilot_F";
_crewman = "B_crew_F";
_uav_operator = "B_soldier_UAV_F";

// If the right class is provided, fill the KPLIB arrays with items
switch (_classRole) do {
    case _commander : {
    // Put all weapons here
    KPLIB_arsenalWeapons = (_rifles_basic + _shotguns + _pistols + _discard_launchers);
    // Put all Magazines, and throwable items such as grenades
    KPLIB_arsenalMagazines = (_mags + _grenades);
    // Put here uniforms, vests, facemasks, nvgs, binoculares, medical items, tool items, attachments...
    KPLIB_arsenalItems = (_uniforms_officer + _uniforms + _uniforms_pilot + _vests + _vests_pilot + _helmets + _caps + _pilot_helmets + _facewears + _rifles_optics + _rail_attach + _muzzle_attach + _rifles_grip + _common_binos + _laser_binos + _ace_common_tools + _cTab_items + _ace_common_medical_items + _common_items + _radio + _ace_misc + _nvgs);
    // Put only backpacks here
    KPLIB_arsenalBackpacks = (_backpacks_radio + _backpacks);
    };
    case _sqleader : {
    // Put all weapons here
    KPLIB_arsenalWeapons = (_rifles_basic + _shotguns + _pistols + _discard_launchers);
    // Put all Magazines, and throwable items such as grenades
    KPLIB_arsenalMagazines = (_mags + _grenades);
    // Put here uniforms, vests, facemasks, nvgs, binoculares, medical items, tool items, attachments...
    KPLIB_arsenalItems = (_uniforms + _vests + _helmets + _facewears + _rifles_optics + _rail_attach + _muzzle_attach + _rifles_grip + _nvgs + _common_binos + _laser_binos + _ace_common_tools + _ace_common_medical_items + _common_items + _cTab_items + _radio + _ace_misc + _nvgs);
    // Put only backpacks here
    KPLIB_arsenalBackpacks = (_backpacks_radio + _backpacks);
    };
    case _mg : {
    // Put all weapons here
    KPLIB_arsenalWeapons = (_lmgs);
    // Put all Magazines, and throwable items such as grenades
    KPLIB_arsenalMagazines = (_mags + _grenades);
    // Put here uniforms, vests, facemasks, nvgs, binoculares, medical items, tool items, attachments...
    KPLIB_arsenalItems = (_uniforms + _vests + _helmets + _facewears + _rifles_optics + _rail_attach + _muzzle_attach + _rifles_bipod + _nvgs + _common_binos + _ace_common_tools + _ace_common_medical_items + _common_items + _radio + _ace_misc + _nvgs);
    // Put only backpacks here
    KPLIB_arsenalBackpacks = _backpacks;
    };
    case _rifleman : {
    // Put all weapons here
    KPLIB_arsenalWeapons = (_rifles_basic + _shotguns + _pistols + _discard_launchers);
    // Put all Magazines, and throwable items such as grenades
    KPLIB_arsenalMagazines = (_mags + _grenades);
    // Put here uniforms, vests, facemasks, nvgs, binoculares, medical items, tool items, attachments...
    KPLIB_arsenalItems = (_uniforms + _vests + _helmets + _facewears + _rifles_optics + _rail_attach + _muzzle_attach + _rifles_grip + _nvgs + _common_binos + _ace_common_tools + _ace_common_medical_items + _common_items + _radio + _ace_misc + _nvgs);
    // Put only backpacks here
    KPLIB_arsenalBackpacks = _backpacks;
    };
    case _medic : {
    // Put all weapons here
    KPLIB_arsenalWeapons = (_rifles_basic + _shotguns + _pistols);
    // Put all Magazines, and throwable items such as grenades
    KPLIB_arsenalMagazines = (_mags + _grenades);
    // Put here uniforms, vests, facemasks, nvgs, binoculares, medical items, tool items, attachments...
    KPLIB_arsenalItems = (_uniforms + _vests + _helmets + _facewears + _rifles_optics + _rail_attach + _rifles_grip + _common_binos + _ace_common_tools + _ace_common_medical_items + _common_items + _radio + _ace_misc + _ace_medic_items + _nvgs);
    // Put only backpacks here
    KPLIB_arsenalBackpacks = (_backpacks + _big_backpacks);
    };
    case _engineer : {
    // Put all weapons here
    KPLIB_arsenalWeapons = (_rifles_basic + _shotguns + _pistols);
    // Put all Magazines, and throwable items such as grenades
    KPLIB_arsenalMagazines = (_mags + _grenades + _explosives);
    // Put here uniforms, vests, facemasks, nvgs, binoculares, medical items, tool items, attachments...
    KPLIB_arsenalItems = (_uniforms + _vests + _helmets + _facewears + _rifles_optics + _rail_attach + _rifles_grip + _common_binos + _ace_common_tools + _ace_common_medical_items + _common_items + _radio + _ace_misc + _ace_eng_tools + _nvgs);
    // Put only backpacks here
    KPLIB_arsenalBackpacks = (_backpacks + _big_backpacks);
    };
    case _rifleman_launchers : {
    // Put all weapons here
    KPLIB_arsenalWeapons = (_rifles_basic + _pistols + _discard_launchers + _launchers_LAT + _launchers_HAT + _launchers_AA);
    // Put all Magazines, and throwable items such as grenades
    KPLIB_arsenalMagazines = (_mags + _grenades);
    // Put here uniforms, vests, facemasks, nvgs, binoculares, medical items, tool items, attachments...
    KPLIB_arsenalItems = (_uniforms + _vests + _helmets + _facewears + _rifles_optics + _rail_attach + _rifles_grip + _common_binos + _ace_common_tools + _ace_common_medical_items + _common_items + _radio + _ace_misc + _nvgs);
    // Put only backpacks here
    KPLIB_arsenalBackpacks = _backpacks;
    };
    case _granadier : {
    // Put all weapons here
    KPLIB_arsenalWeapons = (_rifles_granadier + _pistols);
    // Put all Magazines, and throwable items such as grenades
    KPLIB_arsenalMagazines = (_mags + _grenades);
    // Put here uniforms, vests, facemasks, nvgs, binoculares, medical items, tool items, attachments...
    KPLIB_arsenalItems = (_uniforms + _vests + _helmets + _facewears + _rifles_optics + _rail_attach + _rifles_grip + _common_binos + _ace_common_tools + _ace_common_medical_items + _common_items + _radio + _ace_misc + _nvgs);
    // Put only backpacks here
    KPLIB_arsenalBackpacks = _backpacks;
    };
    case _marksman : {
    // Put all weapons here
    KPLIB_arsenalWeapons = (_rifles_marksman + _pistols);
    // Put all Magazines, and throwable items such as grenades
    KPLIB_arsenalMagazines = (_mags + _grenades);
    // Put here uniforms, vests, facemasks, nvgs, binoculares, medical items, tool items, attachments...
    KPLIB_arsenalItems = (_uniforms + _uniforms_sniper + _vests + _helmets +  _sniper_caps + _facewears + _marksman_optics + _rail_attach + _muzzle_attach + _rifles_bipod + _nvgs + _common_binos + _range_binos + _ace_common_tools + _ace_common_medical_items + _common_items + _radio + _ace_misc + _nvgs);
    // Put only backpacks here
    KPLIB_arsenalBackpacks = _backpacks;
    };
    case _sniper : {
    // Put all weapons here
    KPLIB_arsenalWeapons = (_rifles_marksman + _pistols);
    // Put all Magazines, and throwable items such as grenades
    KPLIB_arsenalMagazines = (_mags + _grenades);
    // Put here uniforms, vests, facemasks, nvgs, binoculares, medical items, tool items, attachments...
    KPLIB_arsenalItems = (_uniforms + _uniforms_sniper + _vests + _helmets + _sniper_caps + _facewears + _marksman_optics + _rail_attach + _muzzle_attach + _rifles_bipod + _nvgs + _common_binos + _range_binos +_ace_common_tools + _ace_common_medical_items + _common_items + _radio + _ace_misc + _nvgs);
    // Put only backpacks here
    KPLIB_arsenalBackpacks = _backpacks;
    };
    case _pilot : {
    // Put all weapons here
    KPLIB_arsenalWeapons = (_smgs + _pistols);
    // Put all Magazines, and throwable items such as grenades
    KPLIB_arsenalMagazines = (_mags + _grenades);
    // Put here uniforms, vests, facemasks, nvgs, binoculares, medical items, tool items, attachments...
    KPLIB_arsenalItems = (_uniforms_pilot + _vests_pilot + _pilot_helmets + _facewears + _rifles_optics + _rail_attach + _rifles_grip + _common_binos + _ace_common_tools + _ace_common_medical_items + _common_items + _radio + _cTab_items + _ace_misc + _nvgs);
    // Put only backpacks here
    KPLIB_arsenalBackpacks = (_backpacks + _backpacks_radio);
    };
    case _crewman : {
    // Put all weapons here
    KPLIB_arsenalWeapons = (_smgs + _pistols);
    // Put all Magazines, and throwable items such as grenades
    KPLIB_arsenalMagazines = (_mags + _grenades);
    // Put here uniforms, vests, facemasks, nvgs, binoculares, medical items, tool items, attachments...
    KPLIB_arsenalItems = (_uniforms + _vests + _crewman_helmets + _facewears + _rifles_optics + _rail_attach + _rifles_grip + _nvgs + _common_binos + _ace_common_tools + _ace_common_medical_items + _common_items + _radio + _ace_misc + _cTab_items + _ace_eng_tools + _nvgs);
    // Put only backpacks here
    KPLIB_arsenalBackpacks = (_backpacks + _backpacks_radio);
    };
    case _uav_operator : {
    // Put all weapons here
    KPLIB_arsenalWeapons = (_rifles_basic + _shotguns + _pistols);
    // Put all Magazines, and throwable items such as grenades
    KPLIB_arsenalMagazines = (_mags + _grenades);
    // Put here uniforms, vests, facemasks, nvgs, binoculares, medical items, tool items, attachments...
    KPLIB_arsenalItems = (_uniforms + _vests + _helmets + _facewears + _rifles_optics + _rail_attach + _muzzle_attach + _rifles_grip + _nvgs + _common_binos + _ace_common_tools + _ace_common_medical_items + _common_items + _radio + _ace_misc + _uav_terminal + _cTab_items + + _nvgs + _drones);
    // Put only backpacks here
    KPLIB_arsenalBackpacks = (_backpacks_radio + _backpacks);
    };
    case default {
        ["This classname doesn't match with a configurated classname from roles_arsenal_config.sqf"] call bis_fnc_error;
        KPLIB_arsenalWeapons = [""];
        KPLIB_arsenalMagazines = [""];
        KPLIB_arsenalItems = [""];
        KPLIB_arsenalWeapons = [""];
    }
};

[]