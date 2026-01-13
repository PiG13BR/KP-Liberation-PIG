#include "..\defines.hpp"

class LiberationBuildRsc {
    idd = IDD_BUILD_MENU;
    movingEnable = false;
    controlsBackground[] = {};
    onLoad = "[_this # 0] call KPLIB_fnc_build_loadMenu";
    onUnload = "[_this # 0] call KPLIB_fnc_build_unloadMenu";

    controls[] = {"OuterBG", "RecycleBG", "OuterBG_F", "InnerBG", "InnerBG_F", "Header",
    "ButtonClose","BuildInfantryButton","BuildTransportVehicleButton",
    "BuildCombatVehicleButton","BuildAerialButton","BuildDefenceButton",
    "BuildSupportButton","BuildSquadButton","BuildBuildingButton","BuildInfantryImage",
    "BuildTransportVehicleImage","BuildCombatVehicleImage","BuildAerialImage","ManpowerImageShadow","AmmoImageShadow","FuelImageShadow",
    "BuildDefenceImage","BuildSupportImage","BuildSquadImage","BuildBuildingImage","ListBG","ManpowerImage","AmmoImage","FuelImage",
    "BuildList","BuildButton","LabelManpower","LabelAmmo","LabelFuel","LabelCap","BuildMannedButton","PageLabel", "LinkedSector"
    };

    objects[] = {};

    class RecycleBG: BgPicture {
        x = (0.35 * safezoneW + safezoneX) - ( 2 * BORDERSIZE);
        y = (0.2 * safezoneH + safezoneY) - (3 * BORDERSIZE);
        w = (0.3 * safezoneW) + (4 * BORDERSIZE);
        h = (0.6 * safezoneH) + (6 * BORDERSIZE);
    };
    class OuterBG: StdBG {
        colorBackground[] = COLOR_BROWN;
        x = (0.35 * safezoneW + safezoneX) - ( 2 * BORDERSIZE);
        y = (0.2 * safezoneH + safezoneY) - (3 * BORDERSIZE);
        w = (0.3 * safezoneW) + (4 * BORDERSIZE);
        h = (0.6 * safezoneH) + (6 * BORDERSIZE);
    };
    class OuterBG_F: OuterBG {
        style = ST_FRAME;
    };
    class InnerBG: OuterBG {
        colorBackground[] = COLOR_GREEN;
        x = (0.35 * safezoneW + safezoneX)  - ( BORDERSIZE);
        y = 0.25 * safezoneH + safezoneY - (1.5 * BORDERSIZE);
        w = (0.3 * safezoneW) +  (2 * BORDERSIZE);
        h = 0.55 * safezoneH  + (3 * BORDERSIZE);
    };
    class InnerBG_F: InnerBG {
        style = ST_FRAME;
    };
    class Header: StdHeader {
        x = 0.35 * safezoneW + safezoneX - (BORDERSIZE);
        y = 0.19 * safezoneH + safezoneY;
        w = 0.3 * safezoneW + ( 2 * BORDERSIZE);
        h = 0.05 * safezoneH - (BORDERSIZE);
        text = $STR_BUILD_TITLE;
    };
    class ButtonClose: StdButton {
        idc = -1;
        x = 0.635 * safezoneW + safezoneX;
        w = 0.015 * safezoneW;
        h = 0.02 * safezoneH;
        y = 0.195 * safezoneH + safezoneY;
        text = "X";
        action = "closeDialog 0";
    };
    class BuildTypeImage {
        idc = -1;
        type = CT_STATIC;
        style = ST_PICTURE;
        colorText[] = {0, 0, 0, 1};
        colorBackground[] = {0, 0, 0, 1};
        font = FontM;
        sizeEx = 0.023;
        y = (0.2525 * safezoneH + safezoneY);
        w = (0.02 * safezoneW);
        h = (0.035 * safezoneH);
        moving = false;
    };
    class BuildTypeButton: StdButton {
        colorBackgroundActive[] = { 0,1,0,0.5 };
        colorFocused[] = { 0, 1, 0, 0.5 };
        y = (0.25 * safezoneH + safezoneY);
        w = (0.023 * safezoneW);
        h = (0.04 * safezoneH);
        text = "";
    };
    class BuildInfantryImage: BuildTypeImage {
        idc = -1;
        x = (0.402 * safezoneW + safezoneX);
        text = "\a3\Ui_F_Curator\Data\Displays\RscDisplayCurator\modeUnits_ca.paa";
    };
    class BuildInfantryButton: BuildTypeButton {
        idc = IDC_INFANTRY_BUTTON;
        text = "";
        //action = "buildtype=1";
        onButtonClick = "[1] call KPLIB_fnc_build_fillLnb";
        x = (0.4 * safezoneW + safezoneX);
    };
    class BuildTransportVehicleImage: BuildTypeImage {
        idc = -1;
        x = (0.427 * safezoneW + safezoneX);
        text = "\A3\ui_f\data\map\vehicleicons\iconCar_ca.paa";
    };
    class BuildTransportVehicleButton: BuildTypeButton{
        idc = IDC_TRANSPORT_BUTTON;
        text = "";
        //action = "buildtype=2";
        onButtonClick = "[2] call KPLIB_fnc_build_fillLnb";
        x = (0.425 * safezoneW + safezoneX);
    };
    class BuildCombatVehicleImage: BuildTypeImage {
        idc = -1;
        x = (0.452 * safezoneW + safezoneX);
        text = "\A3\ui_f\data\map\vehicleicons\iconTank_ca.paa";
    };
    class BuildCombatVehicleButton: BuildTypeButton{
        idc = IDC_COMBATVEH_BUTTON;
        text = "";
        //action = "buildtype=3";
        onButtonClick = "[3, ctrlParent (_this # 0)] call KPLIB_fnc_build_fillLnb";
        x = (0.45 * safezoneW + safezoneX);
    };
    class BuildAerialImage: BuildTypeImage {
        idc = -1;
        x = (0.477 * safezoneW + safezoneX);
        text = "\A3\ui_f\data\map\vehicleicons\iconHelicopter_ca.paa";
    };
    class BuildAerialButton: BuildTypeButton {
        idc = IDC_AERIAL_BUTTON;
        text = "";
        //action = "buildtype=4";
        onButtonClick = "[4] call KPLIB_fnc_build_fillLnb";
        x = (0.475 * safezoneW + safezoneX);
    };
    class BuildDefenceImage: BuildTypeImage {
        idc = -1;
        x = (0.502 * safezoneW + safezoneX);
        text = "\A3\ui_f\data\map\vehicleicons\iconStaticCannon_ca.paa";
    };
    class BuildDefenceButton: BuildTypeButton{
        idc = IDC_DEFENCE_BUTTON;
        text = "";
        //action = "buildtype=5";
        onButtonClick = "[5] call KPLIB_fnc_build_fillLnb";
        x = (0.5 * safezoneW + safezoneX);
    };
    class BuildBuildingImage: BuildTypeImage {
        idc = -1;
        x = (0.527 * safezoneW + safezoneX);
        text = "\A3\ui_f\data\map\mapcontrol\Bunker_CA.paa";
    };
    class BuildBuildingButton: BuildTypeButton {
        idc = IDC_BUILDING_BUTTON;
        text = "";
        //action = "buildtype=6";
        onButtonClick = "[6] call KPLIB_fnc_build_fillLnb";
        x = (0.525 * safezoneW + safezoneX);
    };
    class BuildSupportImage: BuildTypeImage {
        idc = -1;
        x = (0.552 * safezoneW + safezoneX);
        text = "\A3\ui_f\data\map\vehicleicons\iconCrateAmmo_ca.paa";
    };
    class BuildSupportButton: BuildTypeButton {
        idc = IDC_SUPPORT_BUTTON;
        text = "";
        //action = "buildtype=7";
        onButtonClick = "[7] call KPLIB_fnc_build_fillLnb";
        x = (0.55 * safezoneW + safezoneX);
    };
    class BuildSquadImage: BuildTypeImage {
        idc = IDC_SQUAD_IMAGE;
        x = (0.577 * safezoneW + safezoneX);
        text = "\a3\Ui_F_Curator\Data\Displays\RscDisplayCurator\modeGroups_ca.paa";
    };
    class BuildSquadButton: BuildTypeButton {
        idc = IDC_SQUAD_BUTTON;
        text = "";
        //action = "buildtype=8";
        onButtonClick = "[8] call KPLIB_fnc_build_fillLnb";
        x = (0.575 * safezoneW + safezoneX);
    };

    class IconImage {
        idc = -1;
        type = CT_STATIC;
        style = ST_PICTURE;
        colorText[] = {1, 1, 1, 1};
        colorBackground[] = {0, 0, 0, 1};
        font = FontM;
        sizeEx = 0.023;
        y = (0.32 * safezoneH + safezoneY);
        w = (0.015 * safezoneW);
        h = (0.025 * safezoneH);
        moving = false;
    };
    class ManpowerImage: IconImage {
        x = (0.5475 * safezoneW + safezoneX);
        text = "Images\ui_manpo.paa";
    };
    class AmmoImage: IconImage {
        x = (0.5775 * safezoneW + safezoneX);
        text = "Images\ui_ammo.paa";
    };
    class FuelImage: IconImage {
        x = (0.6075 * safezoneW + safezoneX);
        text = "Images\ui_fuel.paa";
    };
    class ManpowerImageShadow: IconImage {
        x = (0.5475 * safezoneW + safezoneX)  + 0.003;
        text = "Images\ui_manpo.paa";
        colorText[] = {0, 0, 0, 1};
        y = (0.32 * safezoneH + safezoneY) + 0.005;
    };
    class AmmoImageShadow: IconImage {
        x = (0.5775 * safezoneW + safezoneX) + 0.003;
        text = "Images\ui_ammo.paa";
        colorText[] = {0, 0, 0, 1};
        y = (0.32 * safezoneH + safezoneY) + 0.005;
    };
    class FuelImageShadow: IconImage {
        x = (0.6075 * safezoneW + safezoneX)  + 0.003;
        text = "Images\ui_fuel.paa";
        colorText[] = {0, 0, 0, 1};
        y = (0.32 * safezoneH + safezoneY) + 0.005;
    };

    class BuildList: StdListNBox {
        idc = IDC_BUILD_LISTBOX;
        x = 0.35 * safezoneW + safezoneX;
        w = 0.3 * safezoneW;
        y = 0.35 * safezoneH + safezoneY;
        h = (0.35 * safezoneH) - (2 * BORDERSIZE);
        columns[] = {
            0,
            0.65,
            0.75,
            0.85
        };
        onLBSelChanged="";
        shadow = 2;
        rowHeight = 1.25 * 0.018 * safezoneH;
        colorPicture[] = {1,1,1,1};
        colorPictureSelected[] = {0,1,0,1};
        colorPictureDisabled[] = {0.4,0.4,0.4,1};
    };
    class ListBG: OuterBG {
        colorBackground[] = COLOR_GREEN;
        x = 0.35 * safezoneW + safezoneX;
        w = 0.3 * safezoneW;
        y = 0.35 * safezoneH + safezoneY;
        h = (0.35 * safezoneH) - (2 * BORDERSIZE);
    };
    class LabelResource: StdText {
        x = (0.35 * safezoneW + safezoneX);
        w = (0.15 * safezoneW);
        h = (0.03 * safezoneH);
    };
    class LabelManpower: LabelResource {
        idc = IDC_SUPPLIES_TEXT;
        y = (0.7 * safezoneH + safezoneY);
        colorText[] = {0, 0.75, 0, 1};
    };
    class LabelAmmo: LabelResource {
        idc = IDC_AMMO_TEXT;
        y = (0.72 * safezoneH + safezoneY);
        colorText[] = {0.75, 0, 0, 1};
    };
    class LabelFuel: LabelResource {
        idc = IDC_FUEL_TEXT;
        y = (0.74 * safezoneH + safezoneY);
        colorText[] = {0.75, 0.75, 0, 1};
    };
    class LabelCap: LabelResource {
        idc = IDC_LABELCAP_TEXT;
        type = CT_STRUCTURED_TEXT;
        y = (0.78 * safezoneH + safezoneY);
        size = 0.02 * safezoneH;
        colorText[] = {0.8, 0.8, 0.8, 1};
    };
    class PageLabel: StdText {
        idc = IDC_PAGELABEL_TEXT;
        x = (0.35 * safezoneW + safezoneX);
        y = (0.3 * safezoneH + safezoneY);
        w = (0.2 * safezoneW);
        h = (0.05 * safezoneH);
        sizeEx = 0.03 * safezoneH;
    };

    class BuildButton: StdButton {
        idc = IDC_BUILD_BUTTON;
        x = (0.55 * safezoneW + safezoneX);
        y = (0.75 * safezoneH + safezoneY);
        w = (0.1 * safezoneW);
        h = (0.045 * safezoneH);
        sizeEx = 0.03 * safezoneH;
        text = $STR_BUILD_BUTTON;
        //action = "dobuild = 1;";
        onButtonClick = "[_this # 0, false] call KPLIB_fnc_build_handleBuildButton";

    };
    class BuildMannedButton: StdButton {
        idc = IDC_CREW_BUTTON;
        x = (0.55 * safezoneW + safezoneX);
        y = (0.7 * safezoneH + safezoneY);
        w = (0.1 * safezoneW);
        h = (0.045 * safezoneH);
        sizeEx = 0.02 * safezoneH;
        text = $STR_BUILD_CREW;
        //action = "dobuild = 1; manned = true;";
        onButtonClick = "[_this # 0, true] call KPLIB_fnc_build_handleBuildButton"; // True for manned
    };
    class LinkedSector {
        idc = IDC_LINKEDSECTOR_TEXT;
        type = CT_STRUCTURED_TEXT;
        colorBackground[] = COLOR_NOALPHA;
        style = ST_LEFT;
        x = 0.45 * safezoneW + safezoneX;
        w = 0.1 * safezoneW;
        y = 0.725 * safezoneH + safezoneY;
        h = 0.05 * safezoneH;
        text= "";
        size = 0.02 * safezoneH;
        sizeEx = 0.02 * safezoneH;
        shadow = 2;
        font = FontM;
        color = "#e0e000";
        align = "right";
        valign = "top";
    };
};
