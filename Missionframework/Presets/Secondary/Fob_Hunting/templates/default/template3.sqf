
private _objects_to_build = [
    [ "Land_HBarrierWall_corridor_F", [-0.11, 4.98, 0], 270.45 ],
    [ "Land_HBarrierBig_F", [-3.24, 5.12, 0], 90.35 ],
    [ "CamoNet_OPFOR_open_F", [-1.91, 5.06, 0], 0 ],
    [ "Land_HBarrierBig_F", [3.27, 5.52, 0], 90.35 ],
    [ "Land_HBarrierBig_F", [8.17, 5.21, 0], 181.2 ],
    [ "Land_HBarrierBig_F", [-8.76, 5.21, 0], 0.69 ],
    [ "Land_HelipadSquare_F", [-0.84, -11.68, 0], 270.25 ],
    [ "CamoNet_OPFOR_open_F", [13.71, -11.54, 0], 270.25 ],
    [ "Land_HBarrierBig_F", [16.94, 5.18, 0], 181.2 ],
    [ "Land_Cargo_House_V3_F", [-16.03, -9.69, 0], 269.88 ],
    [ KPLIB_o_transportTruck, [-10.4, 14.9, -0.02], 181.03 ],
    [ "Land_HBarrierBig_F", [-17.6, 5.28, 0], 359.67 ],
    [ "Land_HBarrierBig_F", [20.42, 1.73, 0], 89.37 ],
    [ "Land_HBarrierBig_F", [-1.65, -21.15, 0], 0.36 ],
    [ KPLIB_o_flag, [-20.59, 7.5, 0], 90 ],
    [ "Land_HBarrierBig_F", [21.02, -7.36, 0], 90.4 ],
    [ "Land_HBarrierBig_F", [7.21, -21.33, 0], 1.39 ],
    [ "Land_HBarrierBig_F", [-22.71, 1.71, 0], 91.24 ],
    [ KPLIB_o_mrapArmed, [-17.33, 14.88, 0.01], 359.22 ],
    [ "Land_HBarrierBig_F", [20.76, 10.25, 0], 89.37 ],
    [ "Land_HBarrierBig_F", [-10.52, -21.21, 0], 0.36 ],
    [ "Land_HBarrierBig_F", [-22.91, -6.7, 0], 270.29 ],
    [ "Land_HBarrierBig_F", [-23.19, 10.11, 0], 89.68 ],
    [ "Land_HBarrierBig_F", [21.1, -16.14, 0], 90.4 ],
    [ "Land_HBarrierBig_F", [15.97, -21.41, 0], 1.39 ],
    [ KPLIB_o_flag, [18.67, -19.05, 0], 90 ],
    [ KPLIB_o_mrap, [11.09, 25.14, 0.01], 268.69 ],
    [ KPLIB_o_flag, [-20.66, -18.6, 0], 90 ],
    [ "Land_HBarrierBig_F", [-23.05, -15.49, 0], 271.36 ],
    [ "Land_HBarrierBig_F", [20.55, 19.13, 0], 89.37 ],
    [ "Land_HBarrierBig_F", [-19.29, -21.29, 0], 0.36 ],
    [ "Land_HBarrierBig_F", [-23.27, 18.53, 0], 89.68 ]
];

private _objectives_to_build = [
    [ KPLIB_o_fuelContainer, [2.64, -13.76, -0.04], 0.35 ],
    [ KPLIB_o_ammoContainer, [-3.69, -14.92, 0], 180.33 ],
    [ KPLIB_o_fuelContainer, [2.7, -5.53, -0.04], 358.03 ],
    [ KPLIB_o_ammoContainer, [-3.96, -5.86, 0], 180.38 ]
];

private _building_static_weapons = [
    [ "Land_Cargo_Patrol_V3_F", [15.5, -0.02, 0], 178.97 ],
    [ "Land_Cargo_Patrol_V3_F", [-17.12, -0.35, 0], 179.97 ],
    [ "Land_Cargo_HQ_V3_F", [11.25, 14.59, 0], 89.97 ]
];

private _building_to_garrison = [
    [ "Land_Cargo_HQ_V3_F", [11.25, 14.59, 0], 89.97 ]
];

private _base_corners = [
    [35,35,0],
    [35,-35,0],
    [-35,-35,0],
    [-35,35,0]
];

[_objects_to_build, _objectives_to_build, _building_static_weapons, _building_to_garrison, _base_corners]
