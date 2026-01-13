#include "..\defines.hpp"

class LiberationRecycleRsc {
    idd = IDD_RECYCLE_MENU;
    movingEnable = false;
    onLoad = "[_this # 0] call KPLIB_fnc_recycle_loadMenu";
    onUnload = "[_this # 0] call KPLIB_fnc_recycle_unLoadMenu";
    controlsBackground[] = { "OuterBG", "RecycleBG", "OuterBG_F", "InnerBG", "InnerBG_F" };
    controls[] = { "Header", "ButtonClose",
        "ManpowerImageShadow","AmmoImageShadow","FuelImageShadow",
        "ManpowerImage","AmmoImage","FuelImage",
        "Infotext","LabelManpower","LabelAmmo","LabelFuel",
        "RecycleButton","CancelButton"
    };
    objects[] = {};

    class RecycleBG: BgPicture {
        x = (0.35 * safezoneW + safezoneX) - ( 2 * BORDERSIZE);
        y = (0.4 * safezoneH + safezoneY) - (3 * BORDERSIZE);
        w = (0.3 * safezoneW) + (4 * BORDERSIZE);
        h = (0.2 * safezoneH) + (6 * BORDERSIZE);
    };
    class OuterBG: StdBG {
        colorBackground[] = COLOR_BROWN;
        x = (0.35 * safezoneW + safezoneX) - ( 2 * BORDERSIZE);
        y = (0.4 * safezoneH + safezoneY) - (3 * BORDERSIZE);
        w = (0.3 * safezoneW) + (4 * BORDERSIZE);
        h = (0.2 * safezoneH) + (6 * BORDERSIZE);
    };
    class OuterBG_F: OuterBG {
        style = ST_FRAME;
    };
    class InnerBG: OuterBG {
        colorBackground[] = COLOR_GREEN;
        x = (0.35 * safezoneW + safezoneX)  - ( BORDERSIZE);
        y = 0.45 * safezoneH + safezoneY - (1.5 * BORDERSIZE);
        w = (0.3 * safezoneW) +  (2 * BORDERSIZE);
        h = 0.15 * safezoneH  + (3 * BORDERSIZE);
    };
    class InnerBG_F: InnerBG {
        style = ST_FRAME;
    };
    class Header: StdHeader {
        x = 0.35 * safezoneW + safezoneX - (BORDERSIZE);
        y = 0.39 * safezoneH + safezoneY;
        w = 0.3 * safezoneW + ( 2 * BORDERSIZE);
        h = 0.05 * safezoneH - (BORDERSIZE);
        text = $STR_RECYCLING;
    };
    class ButtonClose: StdButton {
        idc = -1;
        x = 0.632 * safezoneW + safezoneX;
        w = 0.015 * safezoneW;
        h = 0.02 * safezoneH;
        y = 0.402 * safezoneH + safezoneY;
        text = "X";
        onButtonClick = "(ctrlParent (_this # 0)) closeDisplay 1";
    };
    class IconImage {
        idc = -1;
        type = CT_STATIC;
        style = ST_PICTURE;
        colorText[] = {1, 1, 1, 1};
        colorBackground[] = {0, 0, 0, 1};
        font = FontM;
        sizeEx = 0.023;
        y = (0.5 * safezoneH + safezoneY);
        w = (0.015 * safezoneW);
        h = (0.025 * safezoneH);
        moving = false;
    };
    class ManpowerImage: IconImage {
        idc = -1;
        x = (0.42 * safezoneW + safezoneX);
        text = "Images\ui_manpo.paa";
    };
    class AmmoImage: IconImage {
        idc = -1;
        x = (0.48 * safezoneW + safezoneX);
        text = "Images\ui_ammo.paa";
    };
    class FuelImage: IconImage {
        idc = -1;
        x = (0.54 * safezoneW + safezoneX);
        text = "Images\ui_fuel.paa";
    };
    class ManpowerImageShadow: IconImage {
        idc = -1;
        x = (0.42 * safezoneW + safezoneX)  + 0.003;
        text = "Images\ui_manpo.paa";
        colorText[] = {0, 0, 0, 1};
        y = (0.5 * safezoneH + safezoneY) + 0.005;
    };
    class AmmoImageShadow: IconImage {
        idc = -1;
        x = (0.48 * safezoneW + safezoneX) + 0.003;
        text = "Images\ui_ammo.paa";
        colorText[] = {0, 0, 0, 1};
        y = (0.5 * safezoneH + safezoneY) + 0.005;
    };
    class FuelImageShadow: IconImage {
        idc = -1;
        x = (0.54 * safezoneW + safezoneX)  + 0.003;
        text = "Images\ui_fuel.paa";
        colorText[] = {0, 0, 0, 1};
        y = (0.5 * safezoneH + safezoneY) + 0.005;
    };
    class Infotext: StdText {
        idc = IDC_INFO_TEXT;
        style = ST_CENTER;
        x = (0.35 * safezoneW + safezoneX);
        w = (0.3 * safezoneW);
        h = (0.03 * safezoneH);
        y = (0.45 * safezoneH + safezoneY);
        colorText[] = {0.9, 0.9, 0.9, 1};
    };
    class LabelNumber: StdText {
        y = (0.5 * safezoneH + safezoneY) - (0.5 * BORDERSIZE);
        w = (0.1 * safezoneW);
        h = (0.03 * safezoneH);
        sizeEx = 0.03 * safezoneH;
    };
    class LabelManpower: LabelNumber {
        idc = IDC_SUPPLY_NUMBER;
        x = (0.44 * safezoneW + safezoneX) - BORDERSIZE;
        colorText[] = {0, 0.75, 0, 1};
    };
    class LabelAmmo: LabelNumber {
        idc = IDC_AMMO_NUMBER;
        x = (0.5 * safezoneW + safezoneX) - BORDERSIZE;
        colorText[] = {0.75, 0, 0, 1};
    };
    class LabelFuel: LabelNumber {
        idc = IDC_FUEL_NUMBER;
        x = (0.56 * safezoneW + safezoneX) - BORDERSIZE;
        colorText[] = {0.75, 0.75, 0, 1};
    };
    class RecycleButton: StdButton {
        idc = -1;
        x = (0.4 * safezoneW + safezoneX) - (BORDERSIZE);
        y = (0.55 * safezoneH + safezoneY);
        w = (0.1 * safezoneW) - (BORDERSIZE);
        h = (0.045 * safezoneH);
        sizeEx = 0.025 * safezoneH;
        text = $STR_RECYCLING_PROCEED;
        //action = "dorecycle = 1;";
        onButtonClick = "[] call KPLIB_fnc_doRecycle; (ctrlParent (_this # 0)) closeDisplay 1";
    };
    class CancelButton: StdButton {
        idc = 121;
        x = (0.5 * safezoneW + safezoneX) + (BORDERSIZE);
        y = (0.55 * safezoneH + safezoneY);
        w = (0.1 * safezoneW);
        h = (0.045 * safezoneH);
        sizeEx = 0.025 * safezoneH;
        text = $STR_RECYCLING_CANCEL;
        onButtonClick = "(ctrlParent (_this # 0)) closeDisplay 1";
    };

};
