/*
    missionconfigfile >> "PIG_RscSupplyMenu"
*/

#include "..\defines.hpp"
#include "RscBaseClasses.hpp"

class PIG_RscSupplyMenu
{
    idd = IDD_SUPPLY_MENU;
    onLoad = "";
    onUnload = "";
    controlsBackground[] = {};
    class controls
    {
		class Supply_Text_Title: SupplyMenu_Text_Base
		{
			idc = 89100;
			style = ST_CENTER;
			text = $STR_SUPPLY_MENU_TITLE;
			x = 0.237593 * safezoneW + safezoneX;
			y = 0.0238937 * safezoneH + safezoneY;
			w = 0.537934 * safezoneW;
			h = 0.0560125 * safezoneH;
			//colorBackground[] = {0.2,0.23,0.18,0.9};
			sizeEx = 0.08;
		};
		class Supply_Edit_Amount: SupplyMenu_Edit_Base
		{
			idc = IDC_SUPPLY_MENU_EDIT;

			x = 0.480319 * safezoneW + safezoneX;
			y = 0.528006 * safezoneH + safezoneY;
			w = 0.0328008 * safezoneW;
			h = 0.0280062 * safezoneH;
			colorBackground[] = {0.1,0.1,0.1,0.9};
			tooltip = $STR_SUPPLY_MENU_AMOUNT_ITEMS;
		};
		class Supply_Button_Add: SupplyMenu_Button_Base
		{
			idc = IDC_SUPPLY_MENU_ADD_BUTTON;
			text = ">";
			x = 0.475319 * safezoneW + safezoneX;
			y = 0.401978 * safezoneH + safezoneY;
			w = 0.0459212 * safezoneW;
			h = 0.0420094 * safezoneH;
			colorBackground[] = {0.1,0.1,0.1,0.95};
			sizeEx = 0.05;
			tooltip = $STR_SUPPLY_TRANSFER_RIGHT;
		};
		class Supply_Button_Remove: SupplyMenu_Button_Base
		{
			idc = IDC_SUPPLY_MENU_REMOVE_BUTTON;
			text = "<";
			x = 0.475319 * safezoneW + safezoneX;
			y = 0.471994 * safezoneH + safezoneY;
			w = 0.0459212 * safezoneW;
			h = 0.0420094 * safezoneH;
			colorBackground[] = {0.1,0.1,0.1,0.95};
			tooltip = $STR_SUPPLY_TRANSFER_LEFT;
			sizeEx = 0.05;
		};
		class Supply_Button_Close: SupplyMenu_Button_Base
		{
			idc = IDC_SUPPLY_MENU_CLOSE_BUTTON;

			text = $STR_SUPPLY_MENU_CLOSE;
			x = 0.768606 * safezoneW + safezoneX;
			y = 0.752056 * safezoneH + safezoneY;
			w = 0.0459212 * safezoneW;
			h = 0.0280062 * safezoneH;
			colorBackground[] = {0.2,0.23,0.18,1};
		};
		#include "RscFilterButtons.hpp"
		#include "RscLeftContainer.hpp"
		#include "RscRightContainer.hpp"
    }
}