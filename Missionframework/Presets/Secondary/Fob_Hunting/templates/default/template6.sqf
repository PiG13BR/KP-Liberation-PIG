private _objects_to_build = [
    ["Land_HBarrier_Big_F", [1.26, 3.05, 0.00], 270.00],
    ["Land_HBarrierWall_corridor_F", [3.15, -3.47, 0.00], 0.00],
    ["Land_HBarrier_3_F", [6.63, -1.77, 0.00], 0.00],
    ["Land_HBarrier_Big_F", [1.30, -10.24, 0.00], 270.00],
    ["Land_HBarrier_3_F", [-11.31, -3.66, 0.00], 0.00],
    ["Land_HBarrier_3_F", [10.17, -1.77, 0.00], 0.00],
    ["Land_HBarrier_Big_F", [1.30, 11.84, 0.00], 270.00],
    ["Land_HBarrier_3_F", [10.39, -5.08, 0.00], 0.00],
    ["Land_HBarrier_5_F", [-17.00, -3.61, 0.00], 0.00],
    ["Land_HBarrier_3_F", [13.91, -4.95, 0.00], 0.00],
    ["Land_HBarrier_Big_F", [4.46, -15.53, 0.00], 0.00],
    ["Land_BarGate_F", [-2.24, -15.93, 0.00], 0.00],
    ["Land_HBarrier_Big_F", [2.95, 17.31, 0.00], 0.00],
    ["Land_HBarrier_Big_F", [17.88, -2.95, 0.00], 270.00],
    ["Land_HBarrier_Big_F", [-5.57, 17.11, 0.00], 0.00],
    ["Land_HBarrier_Big_F", [17.64, 5.67, 0.00], 270.00],
    ["Land_HBarrier_Big_F", [-18.70, -3.80, 0.00], 270.00],
    ["Land_HBarrier_Big_F", [12.73, -15.14, 0.00], 0.00],
    ["Land_HBarrier_Big_F", [-19.06, 4.79, 0.00], 270.00],
    ["Land_HBarrier_Big_F", [11.68, 17.41, 0.00], 0.00],
    ["Land_HBarrier_Big_F", [18.24, -11.71, 0.00], 270.00],
    ["Land_HBarrier_Big_F", [-14.18, 16.76, 0.00], 0.00],
    ["Land_HBarrier_Big_F", [-18.39, -12.33, 0.00], 270.00],
    ["Land_HBarrier_Big_F", [17.25, 14.49, 0.00], 270.00],
    ["Land_HBarrier_Big_F", [-19.27, 13.26, 0.00], 270.00]
];

private _objectives_to_build = [
    [KPLIB_o_fuelTruck, [-13.32, -0.24, 0.00], 270.00],
    [KPLIB_o_ammoTruck, [-13.24, 3.86, 0.00], 270.00],
    [KPLIB_o_fuelContainer, [6.71, 13.81, 0.00], 270.00],
    [KPLIB_o_ammoContainer, [7.09, 1.62, 0.00], 270.00],
    [KPLIB_o_fuelContainer, [6.87, 7.71, 0.00], 270.00]
];

private _building_static_weapons = [
    ["Land_Cargo_Patrol_V3_F", [14.31, -9.82, 0.00], 270.00],
    ["Land_Cargo_Patrol_V3_F", [-13.93, 12.36, 0.00], 180.00],
    ["Land_HBarrierTower_F", [-14.27, -16.29, 0.00], 0.00]
];

private _building_to_garrison = [];

private _base_corners = [
    [40, 40, 0],
    [40, -40, 0],
    [-40, -40, 0],
    [-40, 40, 0]
];

[_objects_to_build, _objectives_to_build, _building_static_weapons, _building_to_garrison, _base_corners]
