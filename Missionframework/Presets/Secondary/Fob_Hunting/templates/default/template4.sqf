private _objects_to_build = [
    [ KPLIB_o_mrap, [13.31, 0, 0.01], 268.69 ],
    [ "Land_CncBarrierMedium4_F", [-15.55, -1.69, 0], 90.88 ],
    [ "Land_HBarrierBig_F", [-13.27, -8.61, 0], 91.24 ],
    [ KPLIB_o_transportTruck, [1.21, 15.8, -0.03], 274.41 ],
    [ "Land_BarGate_F", [-16.65, 2.15, 0], 90.88 ],
    [ KPLIB_o_mrapArmed, [-20.26, -3.22, 0.01], 359.22 ],
    [ "Land_HBarrierBig_F", [1.23, 20.94, 0], 0.69 ],
    [ KPLIB_o_flag, [-12.14, 18.09, 0], 90 ],
    [ "Land_HBarrierBig_F", [22.07, -0.21, 0], 89.37 ],
    [ "Land_HBarrierBig_F", [-18.87, 11.86, 0], 182.13 ],
    [ "Land_HBarrierBig_F", [-19.02, -11.48, 0], 180.79 ],
    [ "Land_HBarrierBig_F", [-7.55, 20.91, 0], 0.69 ],
    [ "Land_HBarrierBig_F", [-0.63, -22.83, 0], 0.36 ],
    [ KPLIB_o_flag, [-11.33, -19.92, 0], 90 ],
    [ "Land_HBarrierBig_F", [9.38, 20.92, 0], 181.2 ],
    [ "Land_HBarrierBig_F", [21.86, 8.66, 0], 89.37 ],
    [ "Land_HBarrierBig_F", [22.03, -9.04, 0], 90.4 ],
    [ "Land_HBarrierBig_F", [8.22, -23.01, 0], 1.39 ],
    [ "Land_HBarrierBig_F", [-9.5, -22.89, 0], 0.36 ],
    [ "Land_HBarrierBig_F", [-16.39, 20.98, 0], 359.67 ],
    [ "Land_HBarrierBig_F", [-21.5, 17.42, 0], 91.24 ],
    [ "Land_HBarrierBig_F", [18.15, 20.89, 0], 181.2 ],
    [ "Land_HBarrierBig_F", [21.63, 17.44, 0], 89.37 ],
    [ "Land_HBarrierBig_F", [-22.04, -17.17, 0], 271.36 ],
    [ KPLIB_o_flag, [19.21, -20.29, 0], 90 ],
    [ "Land_HBarrierBig_F", [22.12, -17.82, 0], 90.4 ],
    [ "Land_HBarrierBig_F", [16.99, -23.08, 0], 1.39 ],
    [ "Land_HBarrierBig_F", [-18.27, -22.97, 0], 0.36 ]
];

private _objectives_to_build = [
    [ KPLIB_o_fuelTruck, [1.41, 11.53, -0.03], 271.88 ],
    [ KPLIB_o_ammoTruck, [-1.45, -13.1, -0.04], 357.37 ],
    [ KPLIB_o_ammoContainer, [13.59, 4.13, 0.02], 96.77 ],
    [ KPLIB_o_ammoTruck, [-7.67, -13, -0.04], 0.71 ],
    [ KPLIB_o_ammoContainer, [13.76, 9.31, 0.02], 270.25 ]
];

private _building_static_weapons = [
    [ "Land_Cargo_Patrol_V3_F", [16.23, 15.36, 0], 269.81 ],
    [ "Land_Cargo_Patrol_V3_F", [-16.73, 16.16, 0], 89.4 ],
    [ "Land_Cargo_Patrol_V3_F", [-16.22, -17.77, 0], 0.54 ],
    [ "Land_Cargo_HQ_V3_F", [11.47, -12.17, 0], 89.97 ]
];

private _building_to_garrison = [
    [ "Land_Cargo_HQ_V3_F", [11.47, -12.17, 0], 89.97 ]
];

private _base_corners = [
    [35,35,0],
    [35,-35,0],
    [-35,-35,0],
    [-35,35,0]
];

[_objects_to_build, _objectives_to_build, _building_static_weapons, _building_to_garrison, _base_corners]
