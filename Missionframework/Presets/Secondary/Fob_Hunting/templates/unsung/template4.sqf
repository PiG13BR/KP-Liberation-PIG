private _objects_to_build = [
    ["Land_Campfire_burning", [-2.54, 0.11, -0.03], 0.00],
    ["LAND_uns_vcshelter1", [-3.90, 0.16, 0.00], 0.00],
    ["LAND_uns_vcshelter2", [5.75, 9.72, 0.00], 90.00],
    ["LAND_uns_vcshelter2", [9.24, 6.72, 0.00], 175.56],
    ["LAND_uns_vctower1", [-13.31, 13.96, 0.00], 144.79],
    ["LAND_uns_vctower1", [-14.13, -13.21, 0.00], 42.90],
    ["LAND_uns_vctower1", [12.95, -12.88, 0.00], 318.28],
    ["LAND_uns_vctower1", [13.68, 14.05, 0.00], 224.50],
    [KPLIB_o_mrap, [9.04, -7.43, -0.00], 270.00],
    [KPLIB_o_flag, [-6.05, -13.43, 0.00], 0.00],
    [KPLIB_o_flag, [0.55, 14.33, 0.00], 0.00],
    ["Vil_Fence", [-14.66, 12.34, 0.00], 270.00],
    ["Vil_Fence", [-14.71, 6.41, 0.00], 270.00],
    ["Vil_Fence", [-14.77, 0.42, 0.00], 270.00],
    ["Vil_Fence", [-14.86, -5.61, 0.00], 270.00],
    ["Vil_Fence", [-6.15, 14.69, 0.00], 0.00],
    ["Vil_Fence", [-6.50, -14.03, 0.00], 0.00],
    ["Vil_Fence", [11.80, -13.94, 0.00], 0.00],
    ["Vil_Fence", [12.15, 14.78, 0.00], 0.00],
    ["Vil_Fence", [14.65, -5.31, 0.00], 270.00],
    ["Vil_Fence", [14.74, 0.72, 0.00], 270.00],
    ["Vil_Fence", [14.79, 6.71, 0.00], 270.00],
    ["Vil_Fence", [14.85, 12.65, 0.00], 270.00],
    ["Vil_Fence", [5.86, -13.88, 0.00], 0.00],
    ["Vil_Fence", [6.21, 14.84, 0.00], 0.00],
    ["wx_chair", [-3.49, 1.43, 0.00], 322.25],
    ["wx_chair", [-4.20, -0.30, 0.00], 283.18]
];

private _objectives_to_build = [
    [KPLIB_o_ammoTruck, [9.96, -2.73, 0.00], 270.00],
    [KPLIB_o_fuelTruck, [10.24, 2.73, 0.00], 270.00],
    [KPLIB_o_ammoContainer, [-10.12, -7.24, 0.00], 270.00],
    [KPLIB_o_ammoContainer, [-9.74, -2.72, 0.00], 270.00],
    [KPLIB_o_fuelContainer, [-9.75, 2.07, 0.00], 270.00],
    [KPLIB_o_fuelContainer, [-9.82, 6.30, 0.00], 270.00]
];

private _building_static_weapons = [];

private _building_to_garrison = [];

private _base_corners = [
    [40, 40, 0],
    [40, -40, 0],
    [-40, -40, 0],
    [-40, 40, 0]
];

[_objects_to_build, _objectives_to_build, _building_static_weapons, _building_to_garrison, _base_corners]
