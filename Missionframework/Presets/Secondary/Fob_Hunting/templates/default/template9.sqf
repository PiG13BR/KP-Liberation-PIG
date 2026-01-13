private _objects_to_build = [
    [KPLIB_o_flag, [-19.05, -5.29, 0.00], 0.00],
    [KPLIB_o_flag, [2.55, 4.91, 0.00], 0.00],
    ["Land_BarGate_F", [-18.53, 3.79, 0.00], 270.00],
    ["Land_HBarrier_Big_F", [-11.04, -17.98, 0.00], 0.00],
    ["Land_HBarrier_Big_F", [-11.45, 19.44, 0.00], 0.00],
    ["Land_HBarrier_Big_F", [-16.53, -7.99, 0.00], 270.00],
    ["Land_HBarrier_Big_F", [-16.80, 9.31, 0.00], 270.00],
    ["Land_HBarrier_Big_F", [-2.23, -17.62, 0.00], 0.00],
    ["Land_HBarrier_Big_F", [-3.20, 28.38, 0.00], 0.00],
    ["Land_HBarrier_Big_F", [-8.29, 25.01, 0.00], 270.00],
    ["Land_HBarrier_Big_F", [14.65, 20.26, 0.00], 0.00],
    ["Land_HBarrier_Big_F", [15.06, -17.16, 0.00], 0.00],
    ["Land_HBarrier_Big_F", [2.51, 25.17, 0.00], 270.00],
    ["Land_HBarrier_Big_F", [20.34, 10.15, 0.00], 270.00],
    ["Land_HBarrier_Big_F", [20.43, 1.59, 0.00], 270.00],
    ["Land_HBarrier_Big_F", [20.60, -7.15, 0.00], 270.00],
    ["Land_HBarrier_Big_F", [5.93, 20.00, 0.00], 0.00],
    ["Land_HBarrier_Big_F", [6.34, -17.42, 0.00], 0.00],
    [KPLIB_o_mrap, [-12.85, -10.52, -0.00], 180.00],
    [KPLIB_o_transportTruck, [-8.65, -8.70, 0.00], 180.00]
];

private _objectives_to_build = [
    [KPLIB_o_ammoContainer, [12.70, -11.73, 0.00], 0.00],
    [KPLIB_o_ammoContainer, [8.19, -11.71, 0.00], 0.00],
    [KPLIB_o_fuelContainer, [12.28, 15.45, 0.00], 0.00],
    [KPLIB_o_fuelContainer, [7.56, 15.24, 0.00], 0.00],
    [KPLIB_o_ammoTruck, [-12.86, 10.58, 0.00], 0.00],
    [KPLIB_o_fuelTruck, [-8.32, 10.38, 0.00], 0.00]
];

private _building_static_weapons = [
    ["Land_Cargo_HQ_V3_F", [8.99, 1.74, 0.00], 0.00],
    ["Land_Cargo_Patrol_V3_F", [-3.15, 24.19, 0.00], 180.00],
    ["Land_HBarrierTower_F", [-17.31, -15.72, 0.00], 90.00],
    ["Land_HBarrierTower_F", [-17.88, 17.11, 0.00], 90.00],
    ["Land_HBarrierTower_F", [21.12, 18.04, 0.00], 270.00],
    ["Land_HBarrierTower_F", [21.43, -14.52, 0.00], 270.00]
];

private _building_to_garrison = [
    ["Land_Cargo_HQ_V3_F", [8.99, 1.74, 0.00], 0.00]
];

private _base_corners = [
    [40, 40, 0],
    [40, -40, 0],
    [-40, -40, 0],
    [-40, 40, 0]
];

[_objects_to_build, _objectives_to_build, _building_static_weapons, _building_to_garrison, _base_corners]
