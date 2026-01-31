/*
    File: custom.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2017-10-07
    Last Update: 2020-05-25
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Custom (default FIA) resistance preset.

    Needed Mods:
        - None

    Optional Mods:
        - None
*/

/* Classnames of the guerilla faction which is friendly or hostile, depending on the civil reputation
Standard loadout of the units will be replaced with a scripted one, which depends on the guerilla strength, after spawn */
KPLIB_r_units = [
    "I_G_Soldier_AR_F",
    "I_G_engineer_F",
    "I_G_officer_F",
    "I_G_medic_F",
    "I_G_Soldier_F",
    "I_G_Soldier_LAT_F",
    "I_G_Soldier_M_F",
    "I_G_Soldier_SL_F"
];

// Armed vehicles
KPLIB_r_vehicles = [
    "I_G_Offroad_01_armed_F",
    "I_G_Offroad_01_AT_F"
];

/* Guerilla Equipment
There are 3 tiers for every category. If the strength of the guerillas will increase, they'll have higher tier equipment. */

/* Weapons - You've to add the weapons as array like
["Weaponclassname","Magazineclassname","magazine amount","optic","tripod"]
You can leave optic and tripod empty with "" */
KPLIB_r_weapons_1 = [
    ["CUP_arifle_M16A1","CUP_20Rnd_556x45_Stanag_Tracer_Green",5,"",""],
    ["CUP_smg_UZI","CUP_30Rnd_9x19_UZI",6,"",""],
    ["CUP_smg_UZI","CUP_30Rnd_9x19_UZI",6,"",""],
    ["CUP_smg_UZI","CUP_30Rnd_9x19_UZI",6,"",""],
    ["CUP_launch_M72A6_Special_Loaded","",1,""],
    ["CUP_srifle_LeeEnfield","CUP_10x_303_M",10,"",""],
    ["CUP_srifle_LeeEnfield","CUP_10x_303_M",10,"",""],
    ["CUP_srifle_LeeEnfield","CUP_10x_303_M",10,"",""],
    ["CUP_srifle_LeeEnfield","CUP_10x_303_M",10,"",""],
    ["CUP_srifle_M14","CUP_20Rnd_762x51_DMR",6,"",""],
    ["CUP_smg_M3A1","CUP_30rnd_45ACP_M3A1_BLK_M",6,"",""],
    ["CUP_srifle_M14","CUP_20Rnd_762x51_DMR",6,"",""],
    ["CUP_smg_M3A1","CUP_30rnd_45ACP_M3A1_BLK_M",6,"",""],
    ["CUP_arifle_RPK74","75Rnd_762x39_AK12_Mag_F",4,"",""]
];

KPLIB_r_weapons_2 = [
    ["CUP_arifle_M16A1","CUP_30Rnd_556x45_Stanag_Tracer_Green",5,"",""],
    ["CUP_arifle_M16A1","CUP_30Rnd_556x45_Stanag_Tracer_Green",5,"",""],
    ["CUP_arifle_Colt727","CUP_30Rnd_556x45_Stanag_Tracer_Green",6,"",""],
    ["CUP_arifle_G3A3_ris","ACE_20Rnd_762x51_Mag_Tracer_Dim",5,"",""],
    ["CUP_arifle_AKS","30Rnd_762x39_Mag_Green_F",6,"",""],
    ["CUP_arifle_Gewehr1","CUP_20Rnd_762x51_FNFAL_M",6,"",""],
    ["CUP_arifle_FNFAL5061_wooden","CUP_20Rnd_762x51_FNFAL_M",5,"",""],
    ["CUP_arifle_Galil_556_black","CUP_35Rnd_556x45_Galil_Mag",5,"",""],
    ["CUP_arifle_Galil_556_black","CUP_35Rnd_556x45_Galil_Mag",5,"",""],
    ["CUP_lmg_M60","CUP_100Rnd_TE4_LRT4_Green_Tracer_762x51_Belt_M",5,"",""],
    ["CUP_glaunch_M79","CUP_1Rnd_HE_M203",20,"",""],
    ["CUP_launch_M72A6_Special_Loaded","",1,""]
];

KPLIB_r_weapons_3 = [
    ["CUP_arifle_Gewehr1","CUP_20Rnd_762x51_FNFAL_M",6,"",""],
    ["CUP_arifle_M16A4_Base","CUP_30Rnd_556x45_Stanag_Tracer_Green",6,"CUP_optic_CompM4",""],
    ["CUP_lmg_M60","CUP_100Rnd_TE4_LRT4_Green_Tracer_762x51_Belt_M",5,"",""],
    ["CUP_glaunch_M79","CUP_1Rnd_HE_M203",20,"",""],
    ["CUP_arifle_M4A1_black","CUP_30Rnd_556x45_Stanag_Tracer_Green",6,"CUP_optic_CompM4",""],
    ["CUP_arifle_M4A1_black","CUP_30Rnd_556x45_Stanag_Tracer_Green",6,"CUP_optic_CompM4",""],
    ["CUP_arifle_Galil_556_black","CUP_35Rnd_556x45_Galil_Mag",5,"",""],
    ["CUP_launch_M72A6_Special_Loaded","", 1,"",""],
    ["CUP_launch_M72A6_Special_Loaded","", 1,"",""],
    ["CUP_launch_M72A6_Special_Loaded","", 1,"",""]
];

// Uniforms
KPLIB_r_uniforms_1 = [
    "U_C_Poloshirt_blue",
    "U_C_Poloshirt_burgundy",
    "U_C_Poloshirt_salmon",
    "U_C_Poloshirt_redwhite",
    "U_C_Poloshirt_stripped",
    "U_C_Poloshirt_tricolour",
    "U_C_Poor_1",
    "U_C_Man_casual_1_F",
    "U_C_Man_casual_2_F",
    "U_C_Man_casual_3_F",
    "U_C_Man_casual_4_F",
    "U_C_Man_casual_5_F",
    "U_C_Man_casual_6_F",
    "U_Marshal"
];

KPLIB_r_uniforms_2 = [
    "U_I_C_Soldier_Bandit_1_F",
    "U_I_C_Soldier_Bandit_2_F",
    "U_I_C_Soldier_Bandit_3_F",
    "U_I_C_Soldier_Bandit_4_F",
    "U_I_C_Soldier_Bandit_5_F",
    "U_BG_Guerilla2_1",
    "U_BG_Guerilla2_2",
    "U_BG_Guerilla2_3",
    "U_BG_Guerilla3_1",
    "U_C_HunterBody_grn",
    "U_C_Mechanic_01_F",
    "U_I_C_Soldier_Para_5_F",
    "U_I_G_resistanceLeader_F",
    "CUP_U_I_BDUv2_dirty_DPM",
    "CUP_U_I_BDUv2_dirty_DPM",
    "CUP_U_I_BDUv2_dirty_DPM"
];

KPLIB_r_uniforms_3 = [
    "U_BG_Guerilla1_1",
    "U_BG_Guerilla1_2_F",
    "U_BG_Guerrilla_6_1",
    "U_BG_leader",
    "U_I_C_Soldier_Para_1_F",
    "U_I_C_Soldier_Para_2_F",
    "U_I_C_Soldier_Para_3_F",
    "U_I_C_Soldier_Para_4_F",
    "U_I_C_Soldier_Camo_F",
    "CUP_U_I_BDUv2_dirty_DPM",
    "CUP_U_I_BDUv2_dirty_DPM",
    "CUP_U_I_BDUv2_dirty_DPM",
    "CUP_U_I_BDUv2_dirty_DPM",
    "CUP_U_I_BDUv2_dirty_DPM"
];

// Vests
KPLIB_r_vests_1 = [
    "V_LegStrapBag_coyote_F",
    "V_LegStrapBag_olive_F",
    "V_LegStrapBag_black_F",
    "V_Pocketed_coyote_F",
    "V_Pocketed_olive_F",
    "V_Pocketed_black_F",
    "V_BandollierB_cbr",
    "V_BandollierB_rgr",
    "V_BandollierB_khk",
    "V_BandollierB_oli",
    "V_BandollierB_blk",
    "V_BandollierB_ghex_F",
    "CUP_V_O_SLA_M23_1_OD",
    "CUP_V_OI_TKI_Jacket4_03",
    "CUP_V_OI_TKI_Jacket1_05",
    "CUP_V_OI_TKI_Jacket4_05" 
];

KPLIB_r_vests_2 = [
    "V_Chestrig_rgr",
    "V_Chestrig_khk",
    "V_Chestrig_oli",
    "V_Chestrig_blk",
    "V_HarnessO_brn",
    "V_HarnessO_gry",
    "V_HarnessO_ghex_F",
    "V_HarnessOGL_brn",
    "V_HarnessOGL_gry",
    "V_HarnessOGL_ghex_F",
    "V_TacVest_brn",
    "V_TacVest_khk",
    "V_TacVest_oli",
    "V_TacVest_blk",
    "CUP_V_O_SLA_M23_1_OD",
    "CUP_V_OI_TKI_Jacket4_03",
    "CUP_V_OI_TKI_Jacket1_05",
    "CUP_V_OI_TKI_Jacket4_05" 
];

KPLIB_r_vests_3 = [
    "CUP_V_IDF_Vest",
    "V_TacVest_brn",
    "V_TacVest_khk",
    "V_TacVest_oli",
    "V_TacVest_blk",
    "V_I_G_resistanceLeader_F"
];

// Headgear
KPLIB_r_headgear_1 = [
    "",
    "",
    "",
    "",
    "H_Hat_brown",
    "H_Hat_grey",
    "H_Hat_tan",
    "H_Hat_checker",
    "H_Hat_camo",
    "H_Bandanna_surfer",
    "H_Bandanna_surfer_grn",
    "H_Bandanna_surfer_blk",
    "H_Hat_Safari_olive_F",
    "H_Hat_Safari_sand_F",
    "H_Construction_basic_black_F",
    "H_Helmet_Skate",
    "H_Cap_blu",
    "H_Cap_grn",
    "H_Cap_tan",
    "H_Cap_oli",
    "H_Cap_red",
    "H_Cap_blk"
];

KPLIB_r_headgear_2 = [
    "H_Bandanna_blu",
    "H_Bandanna_sand",
    "H_Bandanna_gry",
    "H_Bandanna_camo",
    "H_Bandanna_cbr",
    "H_Bandanna_sgg",
    "H_Bandanna_khk",
    "H_Cap_blu",
    "H_Cap_grn",
    "H_Cap_tan",
    "H_Cap_oli",
    "H_Cap_red",
    "H_Cap_blk",
    "H_Cap_blk_Raven",
    "H_MilCap_dgtl",
    "CUP_H_Ger_M92"
];

KPLIB_r_headgear_3 = [
    "H_ShemagOpen_khk",
    "H_ShemagOpen_tan",
    "H_Shemag_olive",
    "H_Booniehat_khk",
    "H_Booniehat_oli",
    "H_Booniehat_tan",
    "H_Booniehat_dgtl",
    "H_Booniehat_tna_F",
    "H_PASGT_basic_olive_F",
    "H_PASGT_basic_white_F",
    "CUP_H_Ger_M92"
];

// Facegear. Applies for tier 2 and 3.
KPLIB_r_facegear = [
    "G_Armband_fia2_F"
];
