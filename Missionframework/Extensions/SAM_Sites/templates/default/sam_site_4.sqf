private _samSiteRadar = [KPLIB_o_SAM_radars, [-0.02, 1.88, -0.00], 360.00];

private _samSiteLaunchers = [
    [KPLIB_o_SAM_launchers, [13.40, -7.76, 0.00], 312.07],
    [KPLIB_o_SAM_launchers, [-13.26, -8.12, 0.00], 42.42]
];

private _samSiteSHORAD = [
    [KPLIB_o_SAM_SHORAD, [-0.68, 26.15, 0.01], 0.00]
];

private _samSiteStatics = [
    [KPLIB_o_statics_H_GMG, [-0.60, -18.68, -0.01], 184.71]
];

private _samSiteObjects = [
    ["Land_DirtPatch_05_F", [0.16, 1.35, 3.90], 2.49],
    ["Land_DirtPatch_05_F", [-10.08, 3.82, 0.18], 349.56],
    ["Land_DirtPatch_05_F", [11.03, 3.29, 0.00], 349.56],
    ["Land_HBarrier_Big_F", [-7.69, -12.65, 0.00], 316.26],
    ["Land_HBarrier_Big_F", [8.19, -12.77, 0.00], 45.44],
    ["Land_DirtPatch_05_F", [13.59, -7.34, 0.00], 349.56],
    ["Land_DirtPatch_05_F", [-13.83, -7.26, 0.00], 2.49],
    ["CamoNet_OPFOR_open_F", [-15.79, 6.47, 0.18], 312.69],
    ["Land_DirtPatch_05_F", [-0.94, -17.30, 0.00], 180.27],
    ["CamoNet_OPFOR_open_F", [15.32, 8.39, 0.18], 46.05],
    ["CamoNet_OPFOR_open_F", [0.06, -17.76, 0.00], 183.57],
    ["Land_HBarrier_Big_F", [17.79, -2.25, 0.00], 225.91],
    ["Land_HBarrier_Big_F", [-17.63, -3.34, 0.00], 135.78],
    ["Land_BagBunker_Small_F", [-0.54, -18.66, 0.00], 2.55],
    ["Land_HBarrier_Big_F", [-15.38, -16.10, 0.00], 359.79],
    ["Land_HBarrier_Big_F", [16.36, -15.34, 0.00], 178.64],
    ["Land_HBarrier_Big_F", [21.28, -9.92, 0.00], 269.44],
    ["Land_HBarrier_Big_F", [-20.84, -11.28, 0.00], 268.99],
    ["Land_DirtPatch_05_F", [-0.24, 23.78, 0.00], 180.62],
    ["Land_HBarrier_Big_F", [-3.99, 24.80, 0.00], 89.76],
    ["Land_HBarrier_Big_F", [2.85, 25.19, 0.00], 89.76],
    ["Land_HBarrier_Big_F", [-0.71, 30.30, 0.00], 178.04]
];

private _samSiteGarrisons = [
    // Put here all buildings classnames from the _samSiteObjects that you want infantry to garrison
    ["Land_BagBunker_Large_F", [13.85, 6.44, 0.00], 226.76],
    ["Land_BagBunker_Large_F", [-13.76, 5.12, 0.00], 133.41]
];

[_samSiteRadar, _samSiteLaunchers, _samSiteSHORAD, _samSiteStatics, _samSiteGarrisons, _samSiteObjects]