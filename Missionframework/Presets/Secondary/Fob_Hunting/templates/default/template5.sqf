private _objects_to_build = [
    [ "Land_HelipadCircle_F", [-1.31, 11.44, 0], 0 ],
    [ KPLIB_o_transportHeli, [-1.31, 11.45, 0], 134.19 ],
    [ "Land_Cargo_House_V3_F", [15.93, -7.13, 0], 90.12 ],
    [ KPLIB_o_transportTruck, [-17.59, 5.76, -0.03], 310.87 ],
    [ KPLIB_o_flag, [-20.4, -2.8, 0], 90 ],
    [ "Land_PaperBox_open_full_F", [12.36, -16.46, 0], 228.14 ],
    [ KPLIB_o_flag, [20.06, 6.22, 0], 90 ],
    [ "Land_PaperBox_open_empty_F", [14.86, -16.08, 0], 2.94 ],
    [ "Land_PaperBox_closed_F", [13.68, -18.27, 0], 287.62 ],
    [ "Land_HBarrierBig_F", [-22.99, -3.72, 0], 89.34 ],
    [ "CamoNet_OPFOR_open_F", [14.88, -18.51, 0], 0 ],
    [ "Land_HBarrierBig_F", [22.88, 3.58, 0], 89.34 ],
    [ KPLIB_o_mrap, [17.18, 16.24, 0.01], 326.13 ],
    [ "Land_HBarrierBig_F", [23.08, -5.21, 0], 89.34 ],
    [ "Land_HBarrierBig_F", [0.66, -24.24, 0], 0.36 ],
    [ "Land_HBarrierBig_F", [-8.2, -24.3, 0], 0.36 ],
    [ "Land_HBarrierBig_F", [-22.79, -12.51, 0], 89.34 ],
    [ "Land_HBarrierBig_F", [9.52, -24.42, 0], 1.39 ],
    [ "Land_HBarrierBig_F", [23.35, -14.06, 0], 89.34 ],
    [ KPLIB_o_flag, [19.21, -21.72, 0], 90 ],
    [ "Land_HBarrierBig_F", [-16.97, -24.38, 0], 0.36 ],
    [ "Land_HBarrierBig_F", [18.28, -24.49, 0], 1.39 ],
    [ "Land_HBarrierBig_F", [-22.52, -21.36, 0], 89.34 ],
    [ "Land_HBarrierBig_F", [22.45, -21.48, 0], 103.04 ]
];

private _objectives_to_build = [
    [ KPLIB_o_fuelContainer, [-16.82, 17.67, -0.01], 47.97 ],
    [ KPLIB_o_ammoContainer, [-0.42, -3.26, 0.02], 104.66 ],
    [ KPLIB_o_fuelContainer, [-9.52, -0.47, -0.04], 295.86 ],
    [ KPLIB_o_ammoContainer, [2.85, -14.48, 0], 0.69 ]
];

private _building_static_weapons = [
    [ "Land_Cargo_Patrol_V3_F", [17.36, 1.08, 0], 269.81 ],
    [ "Land_Cargo_HQ_V3_F", [-11.82, -13.91, 0], 89.97 ]
];

private _building_to_garrison = [
    [ "Land_Cargo_HQ_V3_F", [-11.82, -13.91, 0], 89.97 ]
];

private _base_corners = [
    [35,35,0],
    [35,-35,0],
    [-35,-35,0],
    [-35,35,0]
];

[_objects_to_build, _objectives_to_build, _building_static_weapons, _building_to_garrison, _base_corners]
