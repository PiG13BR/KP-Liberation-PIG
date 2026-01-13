#include "..\defines.hpp"
#include "RscBaseClasses.hpp"

class PIG_RscArtyMenu
{
	idd = IDD_ARTY_MENU;
	movingEnable = false;
	onLoad = "[_this # 0] call KPLIB_fnc_manageArtyMenu;";
	onUnload = "";
	class controlsBackground {
		class Arty_MainBackground: ArtyMenu_Frame_Base
		{
			idc = -1;
			style = ST_BACKGROUND;

			x = 0.217913 * safezoneW + safezoneX;
			y = 0.135919 * safezoneH + safezoneY;
			w = 0.564174 * safezoneW;
			h = 0.756169 * safezoneH;
			colorBackground[] = {0.3,0.25,0.2,0.75};
		};
		class Arty_MenuBackground: ArtyMenu_Frame_Base
		{
			idc = -1;
			style = ST_BACKGROUND;
			x = 0.224473 * safezoneW + safezoneX;
			y = 0.205934 * safezoneH + safezoneY;
			w = 0.551054 * safezoneW;
			h = 0.67215 * safezoneH;
			colorBackground[] = {0.22,0.18,0.15,0.75};
		};
		class Arty_ArtyComboFrame: ArtyMenu_Frame_Base
		{
			idc = -1;
			x = 0.237593 * safezoneW + safezoneX;
			y = 0.219938 * safezoneH + safezoneY;
			w = 0.164004 * safezoneW;
			h = 0.0980219 * safezoneH;
			colorBackground[] = {0.19,0.16,0.13,0.8};
		};
		class Arty_AmmoComboFrame: ArtyMenu_Frame_Base
		{
			idc = -1;
			x = 0.408158 * safezoneW + safezoneX;
			y = 0.219938 * safezoneH + safezoneY;
			w = 0.177125 * safezoneW;
			h = 0.0980219 * safezoneH;
			colorBackground[] = {0.19,0.16,0.13,0.8};
		};
		class Arty_RoundsComboFrame: ArtyMenu_Frame_Base
		{
			idc = -1;
			x = 0.591842 * safezoneW + safezoneX;
			y = 0.219938 * safezoneH + safezoneY;
			w = 0.170564 * safezoneW;
			h = 0.0980219 * safezoneH;
			colorBackground[] = {0.19,0.16,0.13,0.8};
		};
		class Arty_MapFrame: ArtyMenu_Frame_Base
		{
			idc = -1;
			x = 0.237593 * safezoneW + safezoneX;
			y = 0.331963 * safezoneH + safezoneY;
			w = 0.524813 * safezoneW;
			h = 0.462103 * safezoneH;
		};
		class Arty_titleFrame: ArtyMenu_Frame_Base
		{
			idc = -1;
			x = 0.401597 * safezoneW + safezoneX;
			y = 0.146922 * safezoneH + safezoneY;
			w = 0.190245 * safezoneW;
			h = 0.0500125 * safezoneH;
			colorBackground[] = {0.22,0.18,0.15,0.75};
		};
	};
	class controls
	{
		class Arty_MenuMap : ArtyMenu_Map_Base
		{
			idc = IDC_MAP_CONTROL;
			text = "#(argb,8,8,3)color(1,1,1,1)";
			x = 0.244153 * safezoneW + safezoneX;
			y = 0.345966 * safezoneH + safezoneY;
			w = 0.511693 * safezoneW;
			h = 0.434097 * safezoneH;
			colorText[] = {0,0,0,1};
			colorBackground[] = {0.96,0.95,0.94,1};
		};
		class Arty_ButtonFire: ArtyMenu_Button_Base
		{
			idc = IDC_BUTTON_FIRE;
			action = "";

			text = $STR_MENU_FIRE;
			x = 0.467199 * safezoneW + safezoneX;
			y = 0.808069 * safezoneH + safezoneY;
			w = 0.0590415 * safezoneW;
			h = 0.0560125 * safezoneH;
			colorBackground[] = {0.37,0,0,1};
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.3)";
		};
		class Arty_TextTitle: ArtyMenu_Text_Base
		{
			idc = -1;
			style = ST_CENTER;

			text = $STR_ARTY_MENU_TITLE; 
			x = 0.404718 * safezoneW + safezoneX;
			y = 0.153925 * safezoneH + safezoneY;
			w = 0.184004 * safezoneW;
			h = 0.0350062 * safezoneH;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.5)";
			colorBackground[] = {0.22,0.18,0.15,0.75};
		};
		class Arty_TextArtillery: ArtyMenu_Text_Base
		{
			idc = -1;
			style = ST_CENTER;

			text = $STR_MENU_ARTILLERY; 
			x = 0.250714 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.136203 * safezoneW;
			h = 0.0280062 * safezoneH;
			colorBackground[] = {0.1,0.1,0.1,0.65};
		};
		class Arty_TextAmmunition: ArtyMenu_Text_Base
		{
			idc = -1;
			style = ST_CENTER;

			text = $STR_MENU_AMMUNITION; 
			x = 0.424838 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.142764 * safezoneW;
			h = 0.0280062 * safezoneH;
			colorBackground[] = {0.1,0.1,0.1,0.65};
		};
		class Arty_TextRounds: ArtyMenu_Text_Base
		{
			idc = -1;
			style = ST_CENTER;

			text = $STR_MENU_ROUNDS; 
			x = 0.604963 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.144324 * safezoneW;
			h = 0.0280062 * safezoneH;
			colorBackground[] = {0.1,0.1,0.1,0.65};
		};
		class Arty_ListBoxArty: ArtyMenu_Combo_Base
		{
			idc = IDC_ARTY_COMBOBOX;

			x = 0.250714 * safezoneW + safezoneX;
			y = 0.27595 * safezoneH + safezoneY;
			w = 0.137764 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class Arty_ListBoxAmmo: ArtyMenu_Combo_Base
		{
			idc = IDC_AMMO_COMBOBOX;

			x = 0.424838 * safezoneW + safezoneX;
			y = 0.27595 * safezoneH + safezoneY;
			w = 0.144324 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class Arty_ListBoxRounds: ArtyMenu_Combo_Base
		{
			idc = IDC_ROUNDS_COMBOBOX;

			x = 0.604963 * safezoneW + safezoneX;
			y = 0.27595 * safezoneH + safezoneY;
			w = 0.144324 * safezoneW;
			h = 0.0280062 * safezoneH;
		};
		class Arty_ButtonClose: ArtyMenu_Button_Base
		{
			idc = -1;
			action = "closeDialog 0";

			text = $STR_MENU_CLOSE;
			x = 0.237593 * safezoneW + safezoneX;
			y = 0.808069 * safezoneH + safezoneY;
			w = 0.0524813 * safezoneW;
			h = 0.0420094 * safezoneH;
			
		};
	}
};