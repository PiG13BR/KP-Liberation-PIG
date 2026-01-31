#include "..\defines.hpp"

// ToDo: refresh button

class LiberationProductionsRsc {
    idd = IDD_PRODUCTION_MENU;
    movingEnable = false;
    controlsBackground[] = {};
    onLoad = "[_this # 0] call KPLIB_fnc_production_loadMenu";
    onUnload = "[_this # 0] call KPLIB_fnc_production_unloadMenu";

    controls[] = {
        "OuterBG1", "OuterBG_F1", "InnerBG1", "InnerBG_F1", "InnerBG2", "InnerBG_F2", "InnerBG3", "InnerBG_F3",
        "Header", "ButtonClose", "ProductionList",
        "SectorName", "SectorTypeLabel", "SectorType", "SectorProdLabel", "SectorProd", "SectorStorageLabel", "SectorStorage", "SectorTimerLabel", "SectorTimer",
        "FacilitiesTitle", "FacilitiesSupply", "FacilitiesAmmo", "FacilitiesFuel",
        "StorageTitle", "StorageSupplyLabel", "StorageSupply", "StorageAmmoLabel", "StorageAmmo", "StorageFuelLabel", "StorageFuel",
        "ProduceTitle", "ProduceToolBox", "ButtonSaveSector",
        "SectorMap", "ButtonClose2", "ProductionBoost"
    };

    objects[] = {};

    class OuterBG1: StdBG {
        colorBackground[] = COLOR_BROWN;
        x = (0.2 * safezoneW + safezoneX) - (2 * BORDERSIZE);
        y = (0.15 * safezoneH + safezoneY) - (3 * BORDERSIZE);
        w = (0.6 * safezoneW) + (4 * BORDERSIZE);
        h = (0.65 * safezoneH) + (6 * BORDERSIZE);
    };
    class OuterBG_F1: OuterBG1 {
        style = ST_FRAME;
    };
    class InnerBG1: OuterBG1 {
        colorBackground[] = COLOR_GREEN;
        x = (0.2 * safezoneW + safezoneX) - (BORDERSIZE);
        y = (0.2 * safezoneH + safezoneY) - (1.5 * BORDERSIZE);
        w = (0.12 * safezoneW) + (2 * BORDERSIZE);
        h = (0.55 * safezoneH) + (3 * BORDERSIZE);
    };
    class InnerBG_F1: InnerBG1 {
        style = ST_FRAME;
    };
    class InnerBG2: OuterBG1 {
        colorBackground[] = COLOR_GREEN;
        x = (0.338 * safezoneW + safezoneX) - (BORDERSIZE);
        y = (0.2 * safezoneH + safezoneY) - (1.5 * BORDERSIZE);
        w = (0.153 * safezoneW) + (2 * BORDERSIZE);
        h = (0.55 * safezoneH) + (3 * BORDERSIZE);
    };
    class InnerBG_F2: InnerBG2 {
        style = ST_FRAME;
    };
    class InnerBG3: OuterBG1 {
        colorBackground[] = COLOR_GREEN;
        x = (0.51 * safezoneW + safezoneX) - (BORDERSIZE);
        y = (0.2 * safezoneH + safezoneY) - (1.5 * BORDERSIZE);
        w = (0.29 * safezoneW) + (2 * BORDERSIZE);
        h = (0.55 * safezoneH) + (3 * BORDERSIZE);
    };
    class InnerBG_F3: InnerBG3 {
        style = ST_FRAME;
    };
    class Header: StdHeader {
        x = 0.2 * safezoneW + safezoneX - (BORDERSIZE);
        y = 0.14 * safezoneH + safezoneY;
        w = 0.6 * safezoneW + ( 2 * BORDERSIZE);
        h = 0.05 * safezoneH - (BORDERSIZE);
        text = $STR_PRODUCTION_HEADER;
    };
    class ButtonClose: StdButton {
        idc = IDC_CLOSE_BUTTON;
        x = 0.785 * safezoneW + safezoneX;
        y = 0.145 * safezoneH + safezoneY;
        w = 0.015 * safezoneW;
        h = 0.02 * safezoneH;
        text = "X";
        onButtonClick = "(ctrlParent (_this # 0)) closeDisplay 1";
    };
    class ProductionList: StdListBox {
        idc = IDC_PRODUCTION_LISTBOX;
        colorSelect[] = COLOR_BLUE;
        colorSelect2[] = COLOR_BLUE;
        x = (0.2 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.2 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.12 * safezoneW) + BORDERSIZE;
        h = (0.55 * safezoneH) + (1.5 * BORDERSIZE);
        shadow = 2;
        onLBSelChanged = "_this call KPLIB_fnc_production_handleListbox";
    };
    class SectorName: StdText {
        idc = IDC_SECTOR_NAME_TEXT;
        style = ST_CENTER;
        colorBackground[] = COLOR_BLACK_ALPHA;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.2 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.02 * safezoneH);
        text = "";
    };
    class SectorTypeLabel: StdText {
        idc = -1;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.23 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.07 * safezoneW);
        h = (0.02 * safezoneH);
        text = $STR_PRODUCTION_TYPE;
    };
    class SectorType: SectorTypeLabel {
        idc = IDC_SECTOR_TYPE_LABEL;
        style = ST_RIGHT;
        x = (0.4145 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        w = (0.08 * safezoneW);
        text = "";
    };
    class SectorProdLabel: StdText {
        idc = -1;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.26 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.07 * safezoneW);
        h = (0.02 * safezoneH);
        text = $STR_PRODUCTION_PRODUCING;
    };
    class SectorProd: SectorProdLabel {
        idc = IDC_SECTOR_PRODUCTION_LABEL;
        style = ST_RIGHT;
        x = (0.4145 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        w = (0.08 * safezoneW);
        text = "";
    };
    class SectorStorageLabel: StdText {
        idc = -1;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.29 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.07 * safezoneW);
        h = (0.02 * safezoneH);
        text = $STR_PRODUCTION_STORAGE;
    };
    class SectorStorage: SectorStorageLabel {
        idc = IDC_SECTOR_STORAGE_LABEL;
        style = ST_RIGHT;
        x = (0.4145 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        w = (0.08 * safezoneW);
        text = "";
    };
    class SectorTimerLabel: StdText {
        idc = -1;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.32 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.07 * safezoneW);
        h = (0.02 * safezoneH);
        text = $STR_PRODUCTION_TIMER;
    };
    class SectorTimer: SectorTimerLabel {
        idc = IDC_PRODUCTION_TIMER_LABEL;
        style = ST_RIGHT;
        x = (0.4145 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        w = (0.08 * safezoneW);
        text = "";
    };
    class FacilitiesTitle: StdText {
        idc = -1;
        style = ST_CENTER;
        colorBackground[] = COLOR_BLACK_ALPHA;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.37 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.02 * safezoneH);
        text = $STR_PRODUCTION_FACILITIES;
    };
    class FacilitiesSupply: StdText {
        idc = IDC_SUPPLY_FACILITY_TEXT;
        style = ST_CENTER;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.4 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.02 * safezoneH);
        text = $STR_MANPOWER;
    };
    class FacilitiesAmmo: StdText {
        idc = IDC_AMMO_FACILITY_TEXT;
        style = ST_CENTER;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.43 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.02 * safezoneH);
        text = $STR_AMMO;
    };
    class FacilitiesFuel: StdText {
        idc = IDC_FUEL_FACILITY_TEXT;
        style = ST_CENTER;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.46 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.02 * safezoneH);
        text = $STR_FUEL;
    };
    class StorageTitle: StdText {
        idc = -1;
        style = ST_CENTER;
        colorBackground[] = COLOR_BLACK_ALPHA;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.51 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.02 * safezoneH);
        text = $STR_PRODUCTION_STORAGEDETAIL;
    };
    class StorageSupplyLabel: StdText {
        idc = -1;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.54 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.07 * safezoneW);
        h = (0.02 * safezoneH);
        text = $STR_MANPOWER;
    };
    class StorageSupply: StorageSupplyLabel {
        idc = IDC_STORAGE_SUPPLY_LABEL;
        style = ST_RIGHT;
        x = (0.4145 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        w = (0.08 * safezoneW);
        text = "";
    };
    class StorageAmmoLabel: StdText {
        idc = -1;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.57 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.07 * safezoneW);
        h = (0.02 * safezoneH);
        text = $STR_AMMO;
    };
    class StorageAmmo: StorageAmmoLabel {
        idc = IDC_STORAGE_AMMO_LABEL;
        style = ST_RIGHT;
        x = (0.4145 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        w = (0.08 * safezoneW);
        text = "";
    };
    class StorageFuelLabel: StdText {
        idc = -1;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.6 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.07 * safezoneW);
        h = (0.02 * safezoneH);
        text = $STR_FUEL;
    };
    class StorageFuel: StorageFuelLabel {
        idc = IDC_STORAGE_FUEL_LABEL;
        style = ST_RIGHT;
        x = (0.4145 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        w = (0.08 * safezoneW);
        text = "";
    };
    class ProduceTitle: StdText {
        idc = -1;
        style = ST_CENTER;
        colorBackground[] = COLOR_BLACK_ALPHA;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.65 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.02 * safezoneH);
        text = $STR_PRODUCTION_PRODUCE;
    };
    class ProduceToolBox {
        idc = IDC_PRODUCE_TOOLBOX;
        type = CT_TOOLBOX;
        style = ST_CENTER;
        font = FontM;
        sizeEx = 0.02 * safezoneH;
        color[] = {0, 0, 0, 1};
        colorText[] = COLOR_WHITE;
        colorTextSelect[] = {0, 0.9, 0, 1};
        colorSelect[] = {0, 0, 1, 1};
        colorTextDisable[] = {0, 1, 0, 1};
        colorDisable[] = {1, 0, 0, 1};
        colorSelectedBg[] = COLOR_LIGHTGRAY_ALPHA;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.68 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.03 * safezoneH);
        rows = 1;
        columns = 3;
        strings[] = {$STR_MANPOWER,$STR_AMMO,$STR_FUEL};
        values[] = {0,1,2};
        onToolBoxSelChanged = "localNameSpace setVariable ['KPLIB_production_new', (_this select 1)]";
    };
    class ButtonSaveSector: StdButton {
        idc = IDC_PRODUCE_BUTTON;
        sizeEx = 0.026 * safezoneH;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.7128 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.045 * safezoneH);
        text = $STR_CONFIRM;
        onButtonClick = "_this call KPLIB_fnc_production_confirmButton";
    };
    class SectorMap: kndr_MapControl {
        idc = IDC_MAP;
        x = (0.51 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.2 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.29 * safezoneW) + BORDERSIZE;
        h = (0.55 * safezoneH) + (1.5 * BORDERSIZE);
    };
     class ButtonClose2: StdButton {
        idc = IDC_CLOSE_BUTTON2;
        x = 0.709925 * safezoneW + safezoneX;
        y = 0.780062 * safezoneH + safezoneY;
        w = 0.0918423 * safezoneW;
        h = 0.0280062 * safezoneH;
        text = $STR_CLOSE;
        onButtonClick = "(ctrlParent (_this # 0)) closeDisplay 1";
    };
    class ProductionBoost: StdText
    {
        idc = IDC_PRODUCTION_BOOST_TEXT;
        text = "";
        x = 0.198232 * safezoneW + safezoneX;
        y = 0.780062 * safezoneH + safezoneY;
        w = 0.472332 * safezoneW;
        h = 0.0280062 * safezoneH;
        sizeEx = 0.026 * safezoneH;
    };
};