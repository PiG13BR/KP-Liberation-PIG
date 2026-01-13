private _samSiteRadar = [KPLIB_o_SAM_radars, [-0.61, -12.68, -0.00], 177.13];

private _samSiteLaunchers = [
    [KPLIB_o_SAM_launchers, [-1.80, 10.71, 0.00], 359.03]
];

private _samSiteSHORAD = [];

private _samSiteStatics = [
    [KPLIB_o_statics_H_GMG, [11.30, -1.27, 4.33], 88.36]
];

private _samSiteObjects = [
    ["Land_HBarrier_Big_F", [-4.32, -1.51, 0.00], 90.00],
    ["Land_HBarrier_Big_F", [5.10, 6.53, 0.00], 130.00],
    ["Land_HBarrier_Big_F", [-7.46, 6.37, 0.00], 230.00],
    ["Land_HBarrier_Big_F", [5.68, -8.64, 0.00], 230.00],
    ["Land_DirtPatch_05_F", [-1.29, 10.18, 1.80], 2.49],
    ["Land_DirtPatch_05_F", [10.64, -0.70, 2.35], 311.19],
    ["Land_Cargo_Patrol_V3_F", [10.39, -0.28, 0.00], 266.19],
    ["Land_HBarrier_Big_F", [-7.08, -9.61, 0.00], 130.00],
    ["CamoNet_OPFOR_big_F", [-12.76, -2.37, 0.00], 91.33],
    ["Land_DirtPatch_05_F", [0.22, -12.99, 3.90], 2.49],
    [KPLIB_o_ammoTruck, [-13.61, -1.98, -0.01], 268.23],
    ["Land_HBarrier_Big_F", [11.96, 7.41, 0.00], 45.36],
    ["Land_HBarrier_Big_F", [5.30, 13.05, 0.00], 39.14],
    ["Land_DirtPatch_05_F", [-14.44, -2.08, 0.00], 2.49],
    ["Land_HBarrier_Big_F", [12.70, -8.50, 0.00], 131.84],
    ["Land_HBarrier_Big_F", [15.47, -0.45, 0.00], 269.01],
    ["Land_HBarrier_Big_F", [-14.32, 6.19, 0.00], 307.47],
    ["Land_HBarrier_Big_F", [-9.16, 12.94, 0.00], 307.47],
    ["Land_HBarrier_Big_F", [7.16, -15.15, 0.00], 131.84],
    ["Land_HBarrier_Big_F", [-8.00, -15.73, 0.00], 40.83],
    ["Land_HBarrier_Big_F", [-14.66, -10.31, 0.00], 40.83],
    ["Land_DirtPatch_05_F", [-2.04, 23.23, 0.18], 349.56],
    ["Land_DirtPatch_05_F", [-0.40, -23.78, 0.00], 349.56],
    ["CamoNet_OPFOR_open_F", [-2.55, 28.94, 0.18], 175.41],
    ["CamoNet_OPFOR_open_F", [0.42, -30.51, 0.18], 179.28]
];

private _samSiteGarrisons = [
    // Put here all buildings classnames from the _samSiteObjects that you want infantry to garrison
    ["Land_BagBunker_Large_F", [-2.30, 26.85, 0.00], 180.00],
    ["Land_BagBunker_Large_F", [0.00, -28.11, 0.00], 0.00]
];

[_samSiteRadar, _samSiteLaunchers, _samSiteSHORAD, _samSiteStatics, _samSiteGarrisons, _samSiteObjects]