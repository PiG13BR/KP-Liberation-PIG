/*
    - Place here the structures that you want the enemy static weapons to spawn. For that, you need:
        The classname of the building [STRING], followed by an bigger array;
        The type of the static weapon ("RAISED-HMG", "LOWERED-HMG", "RAISED-GMG", "LOWERED-GMG", "AT", "AA") [ARRAY], related to ones in the presets. Can be more than one. Recommended: one type per position;
        The PositionRelative coordinates [ARRAY] where the static weapon will spawn, relative to the structure;
        The direction of the weapon [NUMBER] (it will be relative to the object).
    - Example:
        - [STRING, [[[STRING], ARRAY, NUMBER]]]
        - ["building_classname", [[["type"], [relative position], relative direction], [["RAISED-HMG", "AT", "AA"], [x,y,z], (+/- dir)], [["RAISED-HMG"], [-1.14307,-1.2998,-0.55952], (180)]]]
    - To get positionRelative, stand your character where you want to static weapon to spawn and run the code below in debug, it will return a [x,y,z] array. 
        (varNameOfTheObject or cursorObject) worldToModel ASLToAGL getPosASL player
    - Using modded static weapons may require small adjustments in relative positions.
    - To open the possibility of spawning static weapons, it requires more editing by placing those buildings classnames referenced below in the map. Some building classes may be already in the map.
    - The static weapons will only spawn near sectors, so place the garrisons buildings near them.
    - Don't duplicate classnames.
    - Be careful when making a new array. Copy an example and change the values, and then check for missing or additional commas.
*/

KPLIB_staticsConfigs = [
// Vanilla
    ["Land_Cargo_Patrol_V1_F", [[["RAISED-HMG"], [-1,-1.3,-0.5], (180)]]],
    ["Land_Cargo_Patrol_V2_F", [[["RAISED-HMG"], [-1,-1.3,-0.5], (180)]]],
    ["Land_Cargo_Patrol_V3_F", [[["RAISED-HMG"], [-1,-1.3,-0.5], (180)]]],
    ["Land_Cargo_Patrol_V4_F", [[["RAISED-HMG"], [-1,-1.3,-0.5], (180)]]], 
    ["Land_Cargo_HQ_V1_F", [[["AA"], [1.54492,0.740723,-0.747444], (0)]]],
    ["Land_Cargo_HQ_V2_F", [[["AA"], [1.54492,0.740723,-0.747444], (0)]]],
    ["Land_Cargo_HQ_V3_F", [[["AA"], [1.54492,0.740723,-0.747444], (0)]]],
    ["Land_Cargo_HQ_V4_F", [[["AA"], [1.54492,0.740723,-0.747444], (0)]]],
    ["Land_Cargo_Tower_V1_F", [[["RAISED-HMG"], [4.61279,3.98389,5.00471], (45)], [["RAISED-HMG"], [4.8584,-2.90234,5.00471], (140)], [["RAISED-HMG"], [-4.18359,-3.16211,5.00471], (- 90)], [["RAISED-HMG"], [-3.07178,4.40283,5.00471], (0)]]],
    ["Land_Cargo_Tower_V2_F", [[["RAISED-HMG"], [4.61279,3.98389,5.00471], (45)], [["RAISED-HMG"], [4.8584,-2.90234,5.00471], (140)], [["RAISED-HMG"], [-4.18359,-3.16211,5.00471], (- 90)], [["RAISED-HMG"], [-3.07178,4.40283,5.00471], (0)]]],
    ["Land_Cargo_Tower_V3_F", [[["RAISED-HMG"], [4.61279,3.98389,5.00471], (45)], [["RAISED-HMG"], [4.8584,-2.90234,5.00471], (140)], [["RAISED-HMG"], [-4.18359,-3.16211,5.00471], (- 90)], [["RAISED-HMG"], [-3.07178,4.40283,5.00471], (0)]]],
    ["Land_Cargo_Tower_V4_F", [[["RAISED-HMG"], [4.61279,3.98389,5.00471], (45)], [["RAISED-HMG"], [4.8584,-2.90234,5.00471], (140)], [["RAISED-HMG"], [-4.18359,-3.16211,5.00471], (- 90)], [["RAISED-HMG"], [-3.07178,4.40283,5.00471], (0)]]],
    ["Land_Cargo_Tower_V1_No1_F", [[["RAISED-HMG"], [4.61279,3.98389,5.00471], (45)], [["RAISED-HMG"], [4.8584,-2.90234,5.00471], (140)], [["RAISED-HMG"], [-4.18359,-3.16211,5.00471], (- 90)], [["RAISED-HMG"], [-3.07178,4.40283,5.00471], (0)]]],
    ["Land_Cargo_Tower_V1_No2_F", [[["RAISED-HMG"], [4.61279,3.98389,5.00471], (45)], [["RAISED-HMG"], [4.8584,-2.90234,5.00471], (140)], [["RAISED-HMG"], [-4.18359,-3.16211,5.00471], (- 90)], [["RAISED-HMG"], [-3.07178,4.40283,5.00471], (0)]]],
    ["Land_Cargo_Tower_V1_No3_F", [[["RAISED-HMG"], [4.61279,3.98389,5.00471], (45)], [["RAISED-HMG"], [4.8584,-2.90234,5.00471], (140)], [["RAISED-HMG"], [-4.18359,-3.16211,5.00471], (- 90)], [["RAISED-HMG"], [-3.07178,4.40283,5.00471], (0)]]],
    ["Land_Cargo_Tower_V1_No4_F", [[["RAISED-HMG"], [4.61279,3.98389,5.00471], (45)], [["RAISED-HMG"], [4.8584,-2.90234,5.00471], (140)], [["RAISED-HMG"], [-4.18359,-3.16211,5.00471], (- 90)], [["RAISED-HMG"], [-3.07178,4.40283,5.00471], (0)]]],
    ["Land_Cargo_Tower_V1_No5_F", [[["RAISED-HMG"], [4.61279,3.98389,5.00471], (45)], [["RAISED-HMG"], [4.8584,-2.90234,5.00471], (140)], [["RAISED-HMG"], [-4.18359,-3.16211,5.00471], (- 90)], [["RAISED-HMG"], [-3.07178,4.40283,5.00471], (0)]]],
    ["Land_Cargo_Tower_V1_No6_F", [[["RAISED-HMG"], [4.61279,3.98389,5.00471], (45)], [["RAISED-HMG"], [4.8584,-2.90234,5.00471], (140)], [["RAISED-HMG"], [-4.18359,-3.16211,5.00471], (- 90)], [["RAISED-HMG"], [-3.07178,4.40283,5.00471], (0)]]],
    ["Land_Cargo_Tower_V1_No7_F", [[["RAISED-HMG"], [4.61279,3.98389,5.00471], (45)], [["RAISED-HMG"], [4.8584,-2.90234,5.00471], (140)], [["RAISED-HMG"], [-4.18359,-3.16211,5.00471], (- 90)], [["RAISED-HMG"], [-3.07178,4.40283,5.00471], (0)]]],
    ["Land_BagFence_Round_F", [[["AT"], [0,1.5,0], (180)]]],
    ["Land_BagFence_Long_F", [[["AA"], [0,1.5,0], (180)]]],
    ["Land_HBarrierTower_F", [[["RAISED-HMG"], [0,-1.2793,0.0967188], (180)]]],
    ["Land_BagBunker_Small_F", [[["RAISED-HMG"], [0,0,-0.9], (180)]]],
    ["Land_BagBunker_Large_F", [[["RAISED-HMG"], [0.0717773,-3.24316,-0.709913], (180)], [["RAISED-HMG"], [2.7627,-1.0293,-0.709913], (90)]]],
    ["Land_BagBunker_Tower_F", [[["AA", "AT"], [0.163086,1.16992,0.571415], (0)], [["RAISED-HMG", "RAISED-GMG"], [-0.599121,-1.44092,0.571415], (180)]]],
    ["Land_HBarrier_01_tower_green_F", [[["AA", "AT"], [0.163086,1.16992,0.571415], (0)], [["RAISED-HMG", "RAISED-GMG"], [-0.599121,-1.44092,0.571415], (180)]]],
    ["Land_ClutterCutter_medium_F", [[["LOWERED-HMG", "LOWERED-GMG"], [0,0,0], (0)]]],
    ["Sign_Arrow_Yellow_F", [[["RAISED-HMG", "RAISED-GMG"], [0,0,0], (0)]]],
    ["Land_ClutterCutter_large_F", [[["FLAK36"], [0,0,0], (0)]]], // WW2 ONLY
    // CUP
    ["Land_fort_artillery_nest", [[["AA"], [0,-2,0], (0)]]],
    // IFA3
    ["Land_WW2_Bunker_H679", [[["RAISED-HMG", "RAISED-GMG"], [-1,0,0.5], (- 90)]]],
    ["Land_I44_Buildings_Bunker_AA", [[["AA"], [2.31982,-2.47934,0.339201], (0)]]],
    ["Land_WW2_Bunker_Gun_L", [[["AT"], [0,0,0], (180)]]],
    ["Land_WW2_Bunker_Gun_R", [[["AT"], [0,2,0], (180)]]],
    ["Land_WW2_BET_Pillbox", [[["RAISED-HMG", "RAISED-GMG"], [0,3.3,0], (0)]]],
    ["Land_WW2_BET_Pillbox_Splinter", [[["RAISED-HMG", "RAISED-GMG"], [0,3.3,0], (0)]]],
    ["Land_WW2_BET_RGB_667_Plant_R",  [[["RAISED-HMG", "RAISED-GMG"], [0,1,-1.2], (0)]]],
    ["Land_WW2_BET_RGB_667_Plant_B", [[["RAISED-HMG", "RAISED-GMG"], [0,1,-1.1], (0)]]],
    ["Land_WW2_BET_RGB_667_R", [[["RAISED-HMG", "RAISED-GMG"], [-1.4,1,-0.5], (0)]]] ,
    ["Land_WW2_BET_RGB_667_B", [[["RAISED-HMG", "RAISED-GMG"], [0,1,-0.5], (0)]]],
    ["Land_WW2_BET_RGB_667_B_A", [[["RAISED-HMG", "RAISED-GMG"], [0,1,-0.5], (0)]]], //
    ["Land_WW2_BET_RGB669_Pak_L_Splinter", [[["AT"], [0,2,-0.2], (0)]]],
    ["Land_WW2_BET_RGB669_Pak_R_Splinter", [[["AT"], [0,2,-0.2], (0)]]],
    ["Land_WW2_BET_RGB669_Pak_L", [[["AT"], [0,2,-0.3], (0)]]], 
    ["Land_WW2_BET_RGB669_Pak_R", [[["AT"], [0,2,-0.3], (0)]]], 
    ["Land_Fort_Bagfence_Bunker", [[["RAISED-HMG", "RAISED-GMG"], [0,0,-0.7], (0)]]],
    ["Land_WW2_Trench_Mortar_w", [[["RAISED-HMG", "RAISED-GMG"], [0,-0.2,0.0837255], (0)]]],
    ["Land_WW2_Trench76_w", [[["AT"], [-1.10352,0.114258,0.946551], (0)]]],
    ["Land_WW2_Trench_MG_Low_w", [[["RAISED-HMG", "RAISED-GMG"], [-0.5,0.5,0.05], (0)]]],
    ["Land_WW2_BET_RGB_671", [[["AT"], [1.43896,-1.45752,-2.29714], (0)]]],
    ["Land_WW2_BET_Unterstand_Art_B", [[["LOWERED-HMG"], [5.32346,-0.337402,-0.481478], (90)]]],
    ["Land_I44_Bunker_01", [[["RAISED-HMG"], [5.32346,-0.337402,-0.481478], (0)]]],
    ["Land_WW2_BET_RGB_667_Com_B", [[["RAISED-HMG", "RAISED-GMG"], [0,0.2,-1.8] , (0)]]],
    ["Land_WW2_Posed", [[["RAISED-HMG", "RAISED-GMG"], [0,0.8,0.9], (0)]]],

    // GRAD Trenches
    ["ACE_envelope_small", [[["RAISED-HMG", "RAISED-GMG"], [0,0,3], (0)]]]
];

/*
    Static/trenched vehicle configuration to spawn enemy tanks
*/
KPLIB_staticVehConfigs = [
    ["CamoNet_OPFOR_big_F", [[[0.3,-4.15,-2], 180]]],
    ["CamoNet_BLUFOR_big_F", [[[0.3,-4.15,-2], 180]]],
    ["CamoNet_INDP_big_F", [[[0.3,-4.15,-2], 180]]],
    ["CamoNet_ghex_big_F", [[[0.3,-4.15,-2], 180]]],
    ["CamoNet_wdl_big_F", [[[0.3,-4.15,-2], 180]]],

    // WW2
    ["Land_WW2_TrenchTank", [[[0,-1.5,0], 0]]],

    // GRAD Trenches
    ["GRAD_envelope_vehicle", [[[0,-1.5,0], 0]]]
];

KPLIB_staticConfigs_classes = KPLIB_staticsConfigs apply { _x select 0 };
KPLIB_staticVehConfigs_classes = KPLIB_staticVehConfigs apply { _x select 0 };