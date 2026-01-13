
class Supply_Backgorund_rightControlLnb: SupplyMenu_Frame_Base
{
	idc = 89183;
	style = ST_BACKGROUND;

	x = 0.532801 * safezoneW + safezoneX;
	y = 0.303956 * safezoneH + safezoneY;
	w = 0.282726 * safezoneW;
	h = 0.434097 * safezoneH;
	colorBackground[] = {0.1,0.1,0.1,0.9};
};
class Supply_Frame_rightControl: SupplyMenu_Frame_Base
{
	idc = 89184;
    style = ST_FRAME;
	x = 0.545921 * safezoneW + safezoneX;
	y = 0.357969 * safezoneH + safezoneY;
	w = 0.256486 * safezoneW;
	h = 0.340062 * safezoneH;
};
class Supply_ListBox_rightControl: SupplyMenu_ListNBox_Base
{
	idc = IDC_R_CONTAINER_LISTNBOX;
	idcLeft = -1;
    idcRight = -1;
	x = 0.545921 * safezoneW + safezoneX;
	y = 0.359969 * safezoneH + safezoneY;
	w = 0.256486 * safezoneW;
	h = 0.330062 * safezoneH;
};
class Supply_Text_ItemsrightControl: SupplyMenu_Text_Base
{
	idc = 89104;

	text = $STR_SUPPLY_MENU_ITEM;
	x = 0.545921 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.136523* safezoneW;
	h = 0.0280062 * safezoneH;
	colorBackground[] = {0.2,0.23,0.18,1};
};
class Supply_Text_AmountrightControl: SupplyMenu_Text_Base
{
	idc = 89105;
	style = ST_RIGHT;

	text = $STR_SUPPLY_MENU_AMOUNT;
	x = 0.679324 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.121523 * safezoneW;
	h = 0.0280062 * safezoneH;
	colorBackground[] = {0.2,0.23,0.18,1};
};
class Supply_Text_rightControl: SupplyMenu_Text_Base
{	
	idc = 89106;
	style = ST_CENTER;
	
	text = "";
	x = 0.532801 * safezoneW + safezoneX;
	y = 0.261947 * safezoneH + safezoneY;
	w = 0.282726 * safezoneW;
	h = 0.0280062 * safezoneH;
	colorBackground[] = {0.2,0.23,0.18,0.8};
};
class Supply_Slider_rightControl: SupplyMenu_Slider_Base
{
	idc = IDC_R_CONTAINER_SLIDER;
	x = 0.545921 * safezoneW + safezoneX;
	y = 0.710047 * safezoneH + safezoneY;
	w = 0.256486 * safezoneW;
	h = 0.0140031 * safezoneH;
};
