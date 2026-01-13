/*
    File: custom.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 04/12/2025
    Last Update: 16/12/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Desciption:
        Lock items per sector
        Put here all item's classname to be locked once the mission starts and which capturable sector will unlock them
        For a random sector, leave it as an empty string ""
    
    ARRAY inside KPLIB_b_lockedArsenal:
        0: sector name to unlock items <STRING>
        1: item's classnames to lock <ARRAY of STRINGS>

    Example:
        ["capture_1", ["weapon_to_unlock1", "item_to_unlock1", "uniform_to_unlock2"], // Sector marker "capture_1"
        ["", ["weapon_to_unlock1", "item_to_unlock1", "uniform_to_unlock2"]]] // Random
*/

KPLIB_b_lockedArsenal = [
    ["capture_2", 
        [
            // Weapon
            "CUP_srifle_M107_Base",
            "CUP_launch_HCPF3",
            "CUP_arifle_Galil_SAR_black",
            "CUP_arifle_Galil_black",
            "CUP_arifle_Galil_556_black"    
        ]
    ],
    ["bigtown", 
        [
            // Weapon
            "CUP_srifle_AWM_wdl",
            "CUP_arifle_L85A2",
            "CUP_arifle_L85A2_G",
            "CUP_arifle_L86A2",
            "CUP_arifle_L85A2_GL",


            // Attach
            "CUP_optic_SUSAT",
            "CUP_muzzle_snds_L85"
        ]
    ],
    ["capture_35", 
        [
            // Weapon
            "CUP_Famas_F1",
            "CUP_Famas_F1_rail",
            "CUP_Famas_F1_wood",
            "CUP_Famas_F1_Rail_Wood",
            "CUP_launch_M136",

            // Attach
            "CUP_muzzle_snds_FAMAS",
            "CUP_optic_SB_11_4x20_PM"
        ]
    ],
    ["bigtown_8", 
        [
            // Weapon
            "CUP_CZ_BREN2_762_14",
            "CUP_CZ_BREN2_762_14_Grn",
            "CUP_CZ_BREN2_762_14_GL",
            "CUP_CZ_BREN2_762_14_Tan",

            // Attach
            "CUP_optic_HensoldtZO_low",
            "CUP_optic_HensoldtZO",
            "CUP_optic_HensoldtZO_RDS"
            
        ]
    ],
    ["bigtown_9", 
        [
            // Weapon
            "CUP_launch_Javelin"
        ]
    ],
    ["bigtown_2", 
        [
            // Weapon
            "CUP_launch_MAAWS",
            "CUP_hgun_Glock17",
            "CUP_hgun_Glock17_blk",
            "CUP_srifle_L129A1"
            
        ]
    ],
    ["bigtown_10", 
        [
            // Weapon
            "CUP_hgun_Mk23",
            "CUP_arifle_M4_MOE_BW",
            "CUP_arifle_HK_M27",
            "CUP_arifle_HK_M27_VFG",
            "ACE_launch_NLAW_ready_F",
            "CUP_arifle_HK_M27_AG36",
            "CUP_glaunch_M32",

            // Attach
            "CUP_optic_ACOG_TA01B_Black",
            "CUP_optic_ACOG2",
            "CUP_muzzle_snds_socom762rc",
            "muzzle_snds_M",
            "CUP_muzzle_snds_mk23"
        ]
    ],
    ["bigtown_4", 
        [
            // Weapon
            "CUP_arifle_Mk17_CQC_Black",
            "CUP_arifle_Mk17_CQC_FG_Black",
            "CUP_arifle_Mk20",
            "CUP_arifle_Mk17_CQC_EGLM_black",
            "CUP_lmg_Mk48",

            // Attach
            "CUP_optic_Elcan_SpecterDR_black",
            "CUP_optic_Elcan_SpecterDR_RMR_black",
            "CUP_optic_Elcan_reflex",
            "CUP_optic_Elcan"
            
        ]
    ],
    ["bigtown_1", 
        [
            // Weapon
            "CUP_lmg_minimipara",
            "CUP_lmg_minimi_railed",
            "CUP_arifle_DSA_SA58_DMR",
            "CUP_arifle_DSA_SA58",
            "CUP_arifle_DSA_SA58_OSW_M203"       
        ]
    ],
    ["bigtown_6", 
        [
            // Weapon
            "CUP_lmg_MG3_rail",
            "CUP_launch_Mk153Mod0"
        ]
    ]
];
