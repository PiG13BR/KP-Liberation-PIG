#include "..\defines.hpp"

class LiberationLogisticRsc {
    idd = IDD_LOGISTIC_MENU;
    movingEnable = false;
    controlsBackground[] = {};
    onLoad = "[_this # 0] call KPLIB_fnc_logistic_loadMenu";
    onUnload = "[_this # 0] call KPLIB_fnc_logistic_unloadMenu";

    controls[] = {
        "OuterBG1", "OuterBG_F1", "InnerBG1", "InnerBG_F1", "InnerBG2", "InnerBG_F2", "InnerBG3", "InnerBG_F3",
        "Header", "ButtonClose", "LogisticList", "ButtonCreateLogisticGroup", "ButtonDeleteLogisticGroup",
        "LogisticName", "StatusLabel", "Status", "TimeLabel", "Time", "DestinationLabel", "Destination",
        "LoadedTitle", "TruckCountLabel", "TruckCount", "LoadedSupplyLabel", "LoadedSupply", "LoadedAmmoLabel", "LoadedAmmo", "LoadedFuelLabel", "LoadedFuel", "ButtonBuyTruck", "ButtonSellTruck",
        "ATitle", "ACombo", "ASupp", "AAmmo", "AFuel",
        "BTitle", "BCombo", "BSupp", "BAmmo", "BFuel",
        "ALabel", "BLabel",
        "ButtonSaveLogistic", "ButtonAbortLogistic",
        "LogisticMap", "ButtonClose2"
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
        text = $STR_LOGISTIC_HEADER;
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
    class LogisticList: StdListBox {
        idc = IDC_LOGISTIC_LISTBOX;
        sizeEx = 0.025 * safezoneH;
        x = (0.2 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.2 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.12 * safezoneW) + BORDERSIZE;
        h = (0.50 * safezoneH) + (1.5 * BORDERSIZE);
        shadow = 2;
        onLBSelChanged="_this call KPLIB_fnc_logistic_handleListBox";
    };
    class ButtonCreateLogisticGroup: StdButton {
        idc = IDC_CREATE_GROUP_BUTTON;
        sizeEx = 0.026 * safezoneH;
        x = (0.2 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.7128 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.055 * safezoneW) + BORDERSIZE;
        h = (0.045 * safezoneH);
        text = $STR_ADD;
        onButtonClick = "_this call KPLIB_fnc_logistic_addGroup";
        //action = "addLogiGroup = 1";
    };
    class ButtonDeleteLogisticGroup: StdButton {
        idc = IDC_DELETE_GROUP_BUTTON;
        sizeEx = 0.026 * safezoneH;
        x = (0.265 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.7128 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.055 * safezoneW) + BORDERSIZE;
        h = (0.045 * safezoneH);
        text = $STR_DEL;
        onButtonClick = "_this call KPLIB_fnc_logistic_deleteGroup";
        //action = "deleteLogiGroup = 1";
    };
    class LogisticName: StdText {
        idc = IDC_LOGISTIC_NAME_TEXT;
        style = ST_CENTER;
        colorBackground[] = COLOR_BLACK_ALPHA;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.2 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.023 * safezoneH);
        text = "";
        sizeEx = 0.025 * safezoneH;
    };
    class StatusLabel: StdText {
        idc = IDC_LOGISTIC_STATUS_TEXT;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.23 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.07 * safezoneW);
        h = (0.02 * safezoneH);
        text = $STR_LOGISTIC_STATUS;
        sizeEx = 0.021 * safezoneH;
    };
    class Status: StatusLabel {
        idc = IDC_LOGISTIC_STATUS;
        style = ST_RIGHT;
        x = (0.4145 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        w = (0.08 * safezoneW);
        text = "";
    };
    class TimeLabel: StdText {
        idc = IDC_TIME_LABEL_TEXT;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.26 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.07 * safezoneW);
        h = (0.02 * safezoneH);
        text = $STR_PRODUCTION_TIMER;
        sizeEx = 0.021 * safezoneH;
    };
    class Time: TimeLabel {
        idc = IDC_TIME_LABEL;
        style = ST_RIGHT;
        x = (0.4145 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        w = (0.08 * safezoneW);
        text = "";
    };
    class DestinationLabel: StdText {
        idc = IDC_DESTINATION_TEXT;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.29 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.07 * safezoneW);
        h = (0.02 * safezoneH);
        text = $STR_LOGISTIC_DESTINATION;
        sizeEx = 0.021 * safezoneH;
    };
    class Destination: DestinationLabel {
        idc = IDC_DESTINATION;
        style = ST_RIGHT;
        x = (0.4145 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        w = (0.08 * safezoneW);
        sizeEx = 0.020 * safezoneH;
        text = "";
    };
    class LoadedTitle: StdText {
        idc = IDC_LOADED_TITLE;
        style = ST_CENTER;
        colorBackground[] = COLOR_BLACK_ALPHA;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.34 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.023 * safezoneH);
        text = $STR_LOGISTIC_LOADEDDETAIL;
        sizeEx = 0.025 * safezoneH;
    };
    class TruckCountLabel: StdText {
        idc = IDC_TRUCK_COUNT_TEXT;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.37 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.07 * safezoneW);
        h = (0.02 * safezoneH);
        text = $STR_LOGISTIC_TRUCKCOUNT;
        sizeEx = 0.021 * safezoneH;
    };
    class TruckCount: TruckCountLabel {
        idc = IDC_TRUCK_COUNT;
        style = ST_RIGHT;
        x = (0.4145 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        w = (0.08 * safezoneW);
        text = "";
    };
    class LoadedSupplyLabel: StdText {
        idc = IDC_LOADED_SUPPLY_TEXT;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.4 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.07 * safezoneW);
        h = (0.02 * safezoneH);
        text = $STR_MANPOWER;
        sizeEx = 0.021 * safezoneH;
    };
    class LoadedSupply: LoadedSupplyLabel {
        idc = IDC_LOADED_SUPPLY;
        style = ST_RIGHT;
        x = (0.4145 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        w = (0.08 * safezoneW);
        text = "";
    };
    class LoadedAmmoLabel: StdText {
        idc = IDC_LOADED_AMMO_TEXT;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.43 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.07 * safezoneW);
        h = (0.02 * safezoneH);
        text = $STR_AMMO;
        sizeEx = 0.021 * safezoneH;
    };
    class LoadedAmmo: LoadedAmmoLabel {
        idc = IDC_LOADED_AMMO;
        style = ST_RIGHT;
        x = (0.4145 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        w = (0.08 * safezoneW);
        text = "";
    };
    class LoadedFuelLabel: StdText {
        idc = IDC_LOADED_FUEL_TEXT;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.46 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.07 * safezoneW);
        h = (0.02 * safezoneH);
        text = $STR_FUEL;
        sizeEx = 0.021 * safezoneH;
    };
    class LoadedFuel: LoadedFuelLabel {
        idc = IDC_LOADED_FUEL;
        style = ST_RIGHT;
        x = (0.4145 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        w = (0.08 * safezoneW);
        text = "";
    };
    class ButtonBuyTruck: StdButton {
        idc = IDC_BUY_TRUCK_BUTTON;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.50 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.0725 * safezoneW) + BORDERSIZE;
        h = (0.025 * safezoneH);
        text = $STR_LOGSTIC_BUYTRUCK;
        tooltip = $STR_LOGISTIC_TT_BUYTRUCK;
        sizeEx = 0.022 * safezoneH;
        onButtonClick = "_this call KPLIB_fnc_logistic_addTruck";
    };
    class ButtonSellTRuck: StdButton {
        idc = IDC_SELL_TRUCK_BUTTON;
        x = (0.4185 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.50 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.0725 * safezoneW) + BORDERSIZE;
        h = (0.025 * safezoneH);
        text = $STR_LOGSTIC_SELLTRUCK;
        tooltip = $STR_LOGISTIC_TT_SELLTRUCK;
        sizeEx = 0.022 * safezoneH;
        onButtonClick = "_this call KPLIB_fnc_logistic_deleteTruck";
    };
    class ATitle: StdText {
        idc = IDC_A_TITLE;
        style = ST_CENTER;
        colorBackground[] = COLOR_BLACK_ALPHA;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.54 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.023 * safezoneH);
        text = $STR_LOGISTIC_LABELA;
        sizeEx = 0.025 * safezoneH;
    };
    class ACombo: StdCombo {
        idc = IDC_A_COMBO;
        sizeEx = 0.022 * safezoneH;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.57 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.02 * safezoneH);
        onLBSelChanged = "_this call KPLIB_fnc_logistic_handleComboBox";
    };
    class ASupp: StdEdit {
        idc = IDC_A_SUPPLY_EDIT;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.595 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = 0.05 * safezoneW;
        h = (0.025 * safezoneH);
        sizeEx = 0.022 * safezoneH;
        text = "";
        tooltip = $STR_LOGISTIC_TT_SUPPLY;
        action = "";
        autocomplete = "";
    };
    class AAmmo: StdEdit {
        idc = IDC_A_AMMO_EDIT;
        x = (0.392 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.595 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = 0.05 * safezoneW;
        h = (0.025 * safezoneH);
        sizeEx = 0.022 * safezoneH;
        text = "";
        tooltip = $STR_LOGISTIC_TT_AMMO;
        action = "";
        autocomplete = "";
    };
    class AFuel: StdEdit {
        idc = IDC_A_FUEL_EDIT;
        x = (0.446 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.595 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = 0.05 * safezoneW;
        h = (0.025 * safezoneH);
        sizeEx = 0.022 * safezoneH;
        text = "";
        tooltip = $STR_LOGISTIC_TT_FUEL;
        action = "";
        autocomplete = "";
    };
    class BTitle: StdText {
        idc = IDC_B_TITLE;
        style = ST_CENTER;
        colorBackground[] = COLOR_BLACK_ALPHA;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.63 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.023 * safezoneH);
        text = $STR_LOGISTIC_LABELB;
        sizeEx = 0.025 * safezoneH;
    };
    class BCombo: StdCombo {
        idc = IDC_B_COMBO;
        sizeEx = 0.022 * safezoneH;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.66 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.02 * safezoneH);
        onLBSelChanged = "_this call KPLIB_fnc_logistic_handleComboBox";
    };
    class BSupp: StdEdit {
        idc = IDC_B_SUPPLY_EDIT;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.685 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = 0.05 * safezoneW;
        h = (0.025 * safezoneH);
        sizeEx = 0.022 * safezoneH;
        text = "";
        tooltip = $STR_LOGISTIC_TT_SUPPLY;
        action = "";
        autocomplete = "";
    };
    class BAmmo: StdEdit {
        idc = IDC_B_AMMO_EDIT;
        x = (0.392 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.685 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = 0.05 * safezoneW;
        h = (0.025 * safezoneH);
        sizeEx = 0.022 * safezoneH;
        text = "";
        tooltip = $STR_LOGISTIC_TT_AMMO;
        action = "";
        autocomplete = "";
    };
    class BFuel: StdEdit {
        idc = IDC_B_FUEL_EDIT;
        x = (0.446 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.685 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = 0.05 * safezoneW;
        h = (0.025 * safezoneH);
        sizeEx = 0.022 * safezoneH;
        text = "";
        tooltip = $STR_LOGISTIC_TT_FUEL;
        action = "";
        autocomplete = "";
    };
    class ALabel: StdText {
        idc = IDC_A_LABEL_TEXT;
        style = ST_CENTER;
        sizeEx = 0.018 * safezoneH;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.57 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.02 * safezoneH);
        text = "";
    };
    class BLabel: StdText {
        idc = IDC_B_LABEL_TEXT;
        style = ST_CENTER;
        sizeEx = 0.018 * safezoneH;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.66 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.02 * safezoneH);
        text = "";
    };
    class ButtonSaveLogistic: StdButton {
        idc = IDC_SAVE_BUTTON;
        sizeEx = 0.021 * safezoneH;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.7128 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.021 * safezoneH);
        text = $STR_LOGISTIC_CONFIRM;
        onButtonClick = "_this call KPLIB_fnc_logistic_confirmConvoy";
    };
    class ButtonAbortLogistic: StdButton {
        idc = IDC_ABORT_BUTTON;
        sizeEx = 0.021 * safezoneH;
        x = (0.338 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.7368 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.153 * safezoneW) + BORDERSIZE;
        h = (0.021 * safezoneH);
        text = $STR_LOGISTIC_CANCEL;
        onButtonClick = "_this call KPLIB_fnc_logistic_abortConvoy";
    };
    class LogisticMap: kndr_MapControl {
        idc = IDC_MAP;
        x = (0.51 * safezoneW + safezoneX) - (0.5 * BORDERSIZE);
        y = (0.2 * safezoneH + safezoneY) - (0.75 * BORDERSIZE);
        w = (0.29 * safezoneW) + BORDERSIZE;
        h = (0.55 * safezoneH) + (1.5 * BORDERSIZE);
    };
     class ButtonClose2: StdButton {
        idc = IDC_CLOSE2_BUTTON;
        x = 0.455 * safezoneW + safezoneX;
        y = 0.77 * safezoneH + safezoneY;
        w = 0.09 * safezoneW;
        h = 0.035 * safezoneH;
        text = $STR_CLOSE;
        onButtonClick = "(ctrlParent (_this # 0)) closeDisplay 1";
        sizeEx = 0.025 * safezoneH;
    };
};
