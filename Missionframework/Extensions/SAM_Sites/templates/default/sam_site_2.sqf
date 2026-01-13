private _samSiteRadar = [KPLIB_o_SAM_radars, [0.02, 1.91, -0.00], 360.00];

private _samSiteLaunchers = [
    [KPLIB_o_SAM_launchers, [0.03, -18.93, 0.00], 0.68],
    [KPLIB_o_SAM_launchers, [20.10, -8.54, 0.00], 314.56],
    [KPLIB_o_SAM_launchers, [-21.14, -10.24, 0.00], 40.91]
];

private _samSiteSHORAD = [
    [KPLIB_o_SAM_SHORAD, [20.86, 12.38, 0.02], 46.13],
    [KPLIB_o_SAM_SHORAD, [-21.67, 12.18, 0.02], 309.53]
];

private _samSiteStatics = [];

private _samSiteObjects = [
    ["Land_DirtPatch_05_F", [0.34, 2.00, 0.00], 0.00],
    ["Land_HBarrier_Big_F", [7.82, -15.47, 0.00], 286.16],
    ["Land_HBarrier_Big_F", [-8.17, -15.42, 0.00], 258.64],
    ["Land_HBarrier_Big_F", [12.76, -13.25, 0.00], 215.04],
    ["Land_HBarrier_Big_F", [-13.50, -13.44, 0.00], 330.69],
    ["Land_DirtPatch_05_F", [-0.37, -19.53, 0.00], 201.26],
    ["Land_HBarrier_Big_F", [-12.94, 15.15, 0.00], 33.64],
    ["Land_DirtPatch_05_F", [0.56, 20.49, 0.00], 349.56],
    ["Land_HBarrier_Big_F", [13.31, 15.99, 0.00], 149.29],
    ["Land_DirtPatch_05_F", [20.31, -9.23, 0.00], 150.61],
    ["Land_DirtPatch_05_F", [-19.70, 10.78, 0.00], 272.85],
    ["Land_DirtPatch_05_F", [20.48, 11.76, 0.00], 9.44],
    ["Land_DirtPatch_05_F", [-21.22, -10.52, 0.00], 270.36],
    ["Land_HBarrier_Big_F", [5.77, -23.77, 0.00], 286.16],
    ["Land_HBarrier_Big_F", [-6.26, -23.65, 0.00], 258.64],
    ["Land_HBarrier_Big_F", [24.58, -2.38, 0.00], 242.57],
    ["Land_HBarrier_Big_F", [-24.49, 3.99, 0.00], 61.16],
    ["Land_HBarrier_Big_F", [-24.76, -1.99, 0.00], 303.17],
    ["Land_HBarrier_Big_F", [24.83, 4.81, 0.00], 121.76],
    ["Land_HBarrier_Big_F", [19.81, -17.89, 0.00], 215.04],
    ["Land_HBarrier_Big_F", [-0.34, -26.76, 0.00], 0.55],
    ["CamoNet_OPFOR_open_F", [-0.24, 26.78, 0.18], 181.14],
    ["Land_HBarrier_Big_F", [-20.67, -17.71, 0.00], 330.69],
    ["Land_HBarrier_Big_F", [-20.11, 19.62, 0.00], 33.64],
    ["Land_HBarrier_Big_F", [20.37, 20.43, 0.00], 149.29],
    ["Land_HBarrier_Big_F", [28.61, -9.68, 0.00], 242.57],
    ["Land_HBarrier_Big_F", [-29.17, -9.19, 0.00], 303.17],
    ["Land_HBarrier_Big_F", [26.25, -16.06, 0.00], 316.96],
    ["Land_HBarrier_Big_F", [-28.70, 11.20, 0.00], 61.16],
    ["Land_HBarrier_Big_F", [-27.13, -15.56, 0.00], 45.08],
    ["Land_HBarrier_Big_F", [29.07, 12.12, 0.00], 121.76],
    ["Land_HBarrier_Big_F", [-26.50, 17.63, 0.00], 135.55],
    ["Land_HBarrier_Big_F", [26.87, 18.44, 0.00], 223.68]
];

private _samSiteGarrisons = [
    // Move to here all buildings arrays from the _samSiteObjects that you want infantry to garrison. 
    ["Land_BagBunker_Large_F", [-0.08, 24.81, 0.00], 180.00]
];

[_samSiteRadar, _samSiteLaunchers, _samSiteSHORAD, _samSiteStatics, _samSiteGarrisons, _samSiteObjects]