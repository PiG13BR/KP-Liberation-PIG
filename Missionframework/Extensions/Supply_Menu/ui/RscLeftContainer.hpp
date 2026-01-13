
class Supply_Frame_leftControlLnb: SupplyMenu_Frame_Base
{
	idc = 89180;
	style = ST_BACKGROUND;

	x = 0.184473 * safezoneW + safezoneX;
	y = 0.303956 * safezoneH + safezoneY;
	w = 0.282726 * safezoneW;
	h = 0.434097 * safezoneH;
	colorBackground[] = {0.1,0.1,0.1,0.9};
};
class Supply_Frame_leftControl: SupplyMenu_Frame_Base
{
	idc = 89181;
    style = ST_FRAME;
	x = 0.197593 * safezoneW + safezoneX;
	y = 0.359969 * safezoneH + safezoneY;
	w = 0.256486 * safezoneW;
	h = 0.340062 * safezoneH;
};
class Supply_ListBox_leftControl: SupplyMenu_ListNBox_Base
{
	idc = IDC_L_CONTAINER_LISTNBOX;
	idcLeft = -1;
    idcRight = -1;
	x = 0.197593 * safezoneW + safezoneX;
	y = 0.359969 * safezoneH + safezoneY;
	w = 0.256486 * safezoneW;
	h = 0.330062 * safezoneH;

};
class Supply_Text_ItemsleftControl: SupplyMenu_Text_Base
{
	idc = 89101;
	text = $STR_SUPPLY_MENU_ITEM;

	x = 0.197593 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.136523 * safezoneW;
	h = 0.0280062 * safezoneH;
	colorBackground[] = {0.2,0.23,0.18,1};
};
class Supply_Text_AmountleftControl: SupplyMenu_Text_Base
{
	idc = 89102;
	style = ST_RIGHT;

	text = $STR_SUPPLY_MENU_AMOUNT;
	x = 0.332556 * safezoneW + safezoneX;
	y = 0.317959 * safezoneH + safezoneY;
	w = 0.121523 * safezoneW;
	h = 0.0280062 * safezoneH;
	colorBackground[] = {0.2,0.23,0.18,1};
};
class Supply_Text_leftControl: SupplyMenu_Text_Base
{
	idc = 89103;
	style = ST_CENTER;

	text = "";
	x = 0.184473 * safezoneW + safezoneX;
	y = 0.261947 * safezoneH + safezoneY;
	w = 0.282726 * safezoneW;
	h = 0.0280062 * safezoneH;
	colorBackground[] = {0.2,0.23,0.18,0.8};
};
class Supply_Slider_leftControl: SupplyMenu_Slider_Base
{
	idc = IDC_L_CONTAINER_SLIDER;
	x = 0.197593 * safezoneW + safezoneX;
	y = 0.710047 * safezoneH + safezoneY;
	w = 0.256486 * safezoneW;
	h = 0.0140031 * safezoneH;
};