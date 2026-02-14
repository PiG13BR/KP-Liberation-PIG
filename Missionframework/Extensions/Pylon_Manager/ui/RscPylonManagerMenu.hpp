#include "..\defines.hpp"
#include "RscBaseClasses.hpp"

class PIG_PylonManager_RscMainMenu
{
	idd = IDD_PYLONMANAGER_MENU;
	movingEnable = true;
	onLoad = "[_this # 0] call KPLIB_fnc_loadPylonManagerMenu";
	onUnload = "[_this # 0] call KPLIB_fnc_unloadPylonManagerMenu";
	onMouseButtonDown = "['onMouseButtonDown', _this, PIG_PylonManager_RscMainMenu] call KPLIB_fnc_mouseButtonDown";
    onMouseButtonUp = "['onMouseButtonUp', _this, PIG_PylonManager_RscMainMenu] call KPLIB_fnc_mouseButtonUp";
	class ControlsBackground
	{
		class mouseArea: PIG_PylonManager_controlsGroup {
            idc = IDC_MOUSEAREA;
            style = 16;
            type = CT_CONTROLS_GROUP;
            onMouseMoving = "['onMouseMoving', _this, PIG_PylonManager_RscMainMenu] call KPLIB_fnc_handleMouse";
            onMouseZChanged = "['onMouseZChanged', _this, PIG_PylonManager_RscMainMenu] call KPLIB_fnc_handleScrollWheel";
            onMouseHolding = "['onMouseHolding', _this, PIG_PylonManager_RscMainMenu] call KPLIB_fnc_handleMouse";
            x = -0.00513284 * safezoneW + safezoneX;
            y = -0.00411243 * safezoneH + safezoneY;
            w = 1.01683 * safezoneW;
            h = 1.00822 * safezoneH;
        };
		class PylonManager_Background_1: PylonManager_Frame_Base
		{
			idc = -1;
			type = CT_STATIC;
			style = ST_BACKGROUND;
			x = 0.0342282 * safezoneW + safezoneX;
			y = 0.149922 * safezoneH + safezoneY;
			w = 0.170564 * safezoneW;
			h = 0.350078 * safezoneH;
			colorBackground[] = {0.1,0.1,0.1,0.8};
		};
		class PylonManager_Background_2: PylonManager_Frame_Base
		{
			idc = -1;
			type = CT_STATIC;
			style = ST_BACKGROUND;

			x = 0.762407 * safezoneW + safezoneX;
			y = 0.149922 * safezoneH + safezoneY;
			w = 0.209925 * safezoneW;
			h = 0.392087 * safezoneH;
			colorBackground[] = {0.1,0.1,0.1,0.8};
		};
		class PylonManager_Background_3: PylonManager_Frame_Base
		{
			idc = -1;
			type = CT_STATIC;
			style = ST_BACKGROUND;
			
			x = 0.0342279 * safezoneW + safezoneX;
			y = 0.570016 * safezoneH + safezoneY;
			w = 0.170564 * safezoneW;
			h = 0.350078 * safezoneH;
			colorBackground[] = {0.1,0.1,0.1,0.8};
		};
	};
	class controls
	{
		class PylonManager_Pylons_Lb : PylonManager_Listbox_Base
		{
			idc = IDC_PYLONS_LISTBOX;

			onLBSelChanged = "[_this # 0, _this # 1] call KPLIB_fnc_handlePylonsLb";
			x = 0.0407883 * safezoneW + safezoneX;
			y = 0.163925 * safezoneH + safezoneY;
			w = 0.157444 * safezoneW;
			h = 0.322072 * safezoneH;
		};
		class PylonManager_Magazines_Lb: PylonManager_Listbox_Base
		{
			idc = IDC_MAGAZINES_LISTBOX;

			onLBSelChanged = "[_this # 0, _this # 1] call KPLIB_fnc_handleAirMagazinesLb";
			x = 0.0407883 * safezoneW + safezoneX;
			y = 0.584019 * safezoneH + safezoneY;
			w = 0.157444 * safezoneW;
			h = 0.322072 * safezoneH;
		};
		class PylonManager_Presets_Lb: PylonManager_Listbox_Base
		{
			idc = IDC_PRESETS_LISTBOX;

			onLBSelChanged = "[_this # 0, _this # 1] call KPLIB_fnc_handleAirPresetsLb";
			onLBDblClick = "[_this # 0, _this # 1] call KPLIB_fnc_handlePresetDoubleClick";
			x = 0.775527 * safezoneW + safezoneX;
			y = 0.163925 * safezoneH + safezoneY;
			w = 0.104963 * safezoneW;
			h = 0.266059 * safezoneH;
		};
		/*
		class PylonManager_Spawn_Button: PylonManager_Button_Base
		{
			idc = IDC_SPAWN_BUTTON;

			onButtonClick = "[_this # 0] call KPLIB_fnc_handleSpawnButton";
			text = "Spawn";
			x = 0.821448 * safezoneW + safezoneX;
			y = 0.556012 * safezoneH + safezoneY;
			w = 0.0918423 * safezoneW;
			h = 0.0560125 * safezoneH;
		};
		*/
		class PylonManager_Save_Button: PylonManager_Button_Base
		{
			idc = IDC_SAVE_BUTTON;

			onButtonClick = "[] call KPLIB_fnc_saveAirPreset";
			text = "Save";
			toolTip = "Overwrite preset";
			x = 0.88705 * safezoneW + safezoneX;
			y = 0.163925 * safezoneH + safezoneY;
			w = 0.078722 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class PylonManager_Load_Button: PylonManager_Button_Base
		{
			idc = IDC_LOAD_BUTTON;

			onButtonClick = "[] call KPLIB_fnc_handleLoadPresetButton";
			text = "Load";
			toolTip = "Load preset on selected aircraft";
			x = 0.88705 * safezoneW + safezoneX;
			y = 0.205934 * safezoneH + safezoneY;
			w = 0.078722 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class PylonManager_Delete_Button: PylonManager_Button_Base
		{
			idc = IDC_DELETE_BUTTON;

			onButtonClick = "[] call KPLIB_fnc_deleteAirPreset";
			text = "Delete";
			toolTip = "Delete preset (this can't be undone)";
			x = 0.88705 * safezoneW + safezoneX;
			y = 0.247944 * safezoneH + safezoneY;
			w = 0.078722 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class PylonManager_Rename_Button: PylonManager_Button_Base
		{
			idc = IDC_RENAME_BUTTON;

			onButtonClick = "[] call KPLIB_fnc_renameAirPreset";
			text = "Rename";
			toolTip = "Rename the selected preset";
			x = 0.88705 * safezoneW + safezoneX;
			y = 0.443988 * safezoneH + safezoneY;
			w = 0.0656017 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class PylonManager_SaveNew_Button: PylonManager_Button_Base
		{
			idc = IDC_SAVENEW_BUTTON;

			onButtonClick = "[] call KPLIB_fnc_saveNewAirPreset";
			text = "Save new preset";
			toolTip = "Save this as a new preset";
			x = 0.782087 * safezoneW + safezoneX;
			y = 0.485997 * safezoneH + safezoneY;
			w = 0.0918423 * safezoneW;
			h = 0.0420094 * safezoneH;
		};
		class SpawAir_Rename_Edit: PylonManager_Edit_Base
		{
			idc = IDC_RENAME_EDIT;

			onEditChanged = "[_this # 0, _this # 1] call KPLIB_fnc_handlePresetEdit";
			x = 0.775527 * safezoneW + safezoneX;
			y = 0.443988 * safezoneH + safezoneY;
			w = 0.104963 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class PylonManager_Text_1000: PylonManager_Text_Base
		{
			idc = -1;
			style = ST_CENTER;

			text = "Air Spawner Menu";
			x = 0.349116 * safezoneW + safezoneX;
			y = 0.0238938 * safezoneH + safezoneY;
			w = 0.288647 * safezoneW;
			h = 0.0420094 * safezoneH;
			sizeEx = 0.08;
		};
		/*
		class PylonManager_Text_1001: PylonManager_Text_Base
		{
			idc = -1;
			style = ST_RIGHT;

			text = "Aircrafts:";
			x = 0.257274 * safezoneW + safezoneX;
			y = 0.107913 * safezoneH + safezoneY;
			w = 0.131203 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		*/
		class PylonManager_Text_1002: PylonManager_Text_Base
		{
			idc = -1;
			style = ST_CENTER;

			text = "Pylons";
			x = 0.0342282 * safezoneW + safezoneX;
			y = 0.107913 * safezoneH + safezoneY;
			w = 0.170564 * safezoneW;
			h = 0.0280062 * safezoneH;
			colorBackground[] = {0.23,0.34,0.82,0.6};
		};
		class PylonManager_Text_1003: PylonManager_Text_Base
		{
			idc = -1;
			style = ST_CENTER;

			text = "Ammunition";
			x = 0.0342282 * safezoneW + safezoneX;
			y = 0.528006 * safezoneH + safezoneY;
			w = 0.170564 * safezoneW;
			h = 0.0280062 * safezoneH;
			colorBackground[] = {0.23,0.34,0.82,0.6};
		};
		class PylonManager_Text_1004: PylonManager_Text_Base
		{
			idc = -1;
			style = ST_CENTER;
			text = "Presets / Loadout";
			x = 0.762407 * safezoneW + safezoneX;
			y = 0.107913 * safezoneH + safezoneY;
			w = 0.209925 * safezoneW;
			h = 0.0280062 * safezoneH;
			colorBackground[] = {0.23,0.34,0.82,0.6};
		};

	}
};
