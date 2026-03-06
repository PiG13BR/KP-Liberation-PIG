if (KPLIB_param_ArtyMenu && KPLIB_ace) then {
    [
        "PIG_ARTYMenu_Setting_RequiredItems", 
        "EDITBOX",  
        [localize "STR_ARTYMENU_SETTING_ITEMS_DESCRIPTION", localize "STR_ARTYMENU_SETTING_ITEMS_TOOLTIP"], 
        ["KP Liberation", localize "STR_ARTY_MENU_TITLE"], 
        "[]"
    ] call CBA_fnc_addSetting;
};

if (KPLIB_param_clearBrush && KPLIB_ace) then {
    [
        "ClearBrush_requireEntrenchingTool",
        "CHECKBOX",
        localize "STR_CLEAR_BRUSHES_SETTING_REQUIRE_ITEM",
        ["KP Liberation", localize "STR_CLEAR_BRUSHES_TITLE"],
        true,
        true
    ] call CBA_fnc_addSetting;

    [
        "ClearBrush_clearTimeCoef", 
        "SLIDER",   
        [localize "STR_CLEAR_BRUSHES_SETTING_COEF_DESCRIPTION", localize "STR_CLEAR_BRUSHES_SETTING_COEF_TOOLTIP"], 
        ["KP Liberation", localize "STR_CLEAR_BRUSHES_TITLE"],
        [1, 2, 1.2, 1],
        true
    ] call CBA_fnc_addSetting;
};

if (KPLIB_param_pylonManager && KPLIB_ace) then {
    // Invert camera movement
    [
        "PIG_PylonManager_camInverted",
        "CHECKBOX",
        localize "STR_TITLE_SETTING_INVERT_CAMERA",
        localize "STR_TITLE_PYLONMANAGER",
        false
    ] call CBA_fnc_addSetting;

    // Required objects nearby
    [
        "PIG_PylonManager_RequireNearby", 
        "EDITBOX",  
        [localize "STR_PYLONMANAGER_SETTING_NEARBYOBJECTS_DESCRIPTION", localize "STR_PYLONMANAGER_SETTING_NEARBYOBJECTS_TOOLTIP"], 
        ["KP Liberation", localize "STR_TITLE_PYLONMANAGER"], 
        "['Land_Missle_Trolley_02_F', 'Land_Bomb_Trolley_01_F']",
        true // Global
    ] call CBA_fnc_addSetting;
};

if (KPLIB_param_rallyPoint && KPLIB_ace) then {
    // Members required
    [
        "PIG_RallyPoint_Setting_Members", 
        "LIST",     
        [localize "STR_RALLYPOINT_SETTING_MEMBERS_DESCRIPTION", localize "STR_RALLYPOINT_SETTING_MEMBERS_TOOLTIP"], 
        ["KP Liberation", localize "STR_TITLE_RALLYPOINT"], 
        [
            [0, 1, 2, 3, 4], 
            [localize "STR_RALLYPOINT_SETTING_DISABLE", format[localize "STR_RALLYPOINT_SETTING_MEMBERS_REQUIRED", 1], format[localize "STR_RALLYPOINT_SETTING_MEMBERS_REQUIRED", 2], format[localize "STR_RALLYPOINT_SETTING_MEMBERS_REQUIRED", 3], format[localize "STR_RALLYPOINT_SETTING_MEMBERS_REQUIRED", 4]], 
            1
        ],
        true // Global
    ] call CBA_fnc_addSetting;

    // Items required
    [
        "PIG_RallyPoint_Setting_RequiredItems", 
        "EDITBOX",  
        [localize "STR_RALLYPOINT_SETTING_ITEMS_DESCRIPTION", localize "STR_RALLYPOINT_SETTING_ITEMS_TOOLTIP"], 
        ["KP Liberation", localize "STR_TITLE_RALLYPOINT"], 
        "[]",
        true // Global
    ] call CBA_fnc_addSetting;

    // Deploy cooldown
    [
        "PIG_RallyPoint_Setting_Cooldown", 
        "LIST",     
        [localize "STR_RALLYPOINT_SETTING_COOLDOWN_DESCRIPTION", localize "STR_RALLYPOINT_SETTING_COOLDOWN_TOOLTIP"], 
        ["KP Liberation", localize "STR_TITLE_RALLYPOINT"], 
        [
            [0, 2, 5, 10, 15], 
            [localize "STR_RALLYPOINT_SETTING_DISABLE", format[localize "STR_RALLYPOINT_SETTING_TIMER_OPTIONS", 2], format[localize "STR_RALLYPOINT_SETTING_TIMER_OPTIONS", 5], format[localize "STR_RALLYPOINT_SETTING_TIMER_OPTIONS", 10], format[localize "STR_RALLYPOINT_SETTING_TIMER_OPTIONS", 15]], 
            2
        ],
        true, // Global
        {},
        true
    ] call CBA_fnc_addSetting;
};

if (KPLIB_ace) then {
    // Ace setting
    [
        "PIG_SupplyMenu_Setting_ignoreWeight", 
        "CHECKBOX", 
        [localize "STR_SUPPLY_SETTING_IGNOREWEIGHT_TITLE", localize "STR_SUPPLY_SETTING_IGNOREWEIGHT"], 
        ["KP Liberation", localize "STR_SUPPLY_MENU_TITLE"], 
        true
    ] call CBA_fnc_addSetting;
} else {
    [
        "PIG_SupplyMenu_Setting_weightCoef", 
        "LIST",     
        [localize "STR_RALLYPOINT_SETTING_MEMBERS_DESCRIPTION", localize "STR_SUPPLY_SETTING_WEIGHTCOEF_TOOLTIP"], 
        ["KP Liberation", localize "STR_SUPPLY_MENU_TITLE"], 
        [
            [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1], 
            ["0.1 (10%)", "0.2 (20%)", "0.3 (30%)", "0.4 (40%)", "0.5 (50%)", "0.6 (60%)", "0.7 (70%)", "0.8 (80%)", "0.9 (90%)", "1 (100%)"], 
            0.3
        ],
        true // Global
    ] call CBA_fnc_addSetting;
};

if (KPLIB_param_SAMSite > 0) then {
    // Maximum SAM Sites
    [
        "PIG_SAMSite_Setting_MaxSites", 
        "LIST",     
        [localize "STR_SAMSITE_SETTING_MAXSITES_DESCRIPTION", localize "STR_SAMSITE_SETTING_MAXSITES_TOOLTIP"], 
        ["KP Liberation", localize "STR_SAM_TITLE"], 
        [
            [2, 3, 4, 5, 6, 7, 8, 9, 10], 
            [2, 3, 4, 5, 6, 7, 8, 9, 10], 
            5
        ],
        true, // Global
        {},
        true
    ] call CBA_fnc_addSetting;

    if (KPLIB_param_SAMSite == 2) then {
        // Custom radar configuration
        [
            "PIG_SAMSite_Setting_maxRange", 
            "EDITBOX",  
            ["STR_SAMSITE_SETTING_MAXRANGE_DESCRIPTION", "STR_SAMSITE_SETTING_MAXRANGE_TOOLTIP"], 
            ["KP Liberation", localize "STR_SAM_TITLE"], 
            "10000",
            true,
            {},
            true
        ] call CBA_fnc_addSetting;

        [
            "PIG_SAMSite_Setting_minAlt", 
            "EDITBOX",  
            ["STR_SAMSITE_SETTING_MINALT_DESCRIPTION", "STR_SAMSITE_SETTING_MINALT_TOOLTIP"], 
            ["KP Liberation", localize "STR_SAM_TITLE"], 
            "200",
            true,
            {},
            true
        ] call CBA_fnc_addSetting;
    };
};

[
    "TS_Verification",
    "CHECKBOX",
    localize "STR_TS_TITLE",
    ["KP Liberation", "Team Speak"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "TS_ServerName",
    "EDITBOX",
    localize "STR_TS_SERVER",
    ["KP Liberation", "Team Speak"],
    "Liberation OAB - TS3 Server",
    1
] call CBA_fnc_addSetting;

[
    "TS_ServerIP",
    "EDITBOX",
    localize "STR_TS_SERVER_IP",
    ["KP Liberation", "Team Speak"],
    "ts3.example.com",
    1
] call CBA_fnc_addSetting;

[
    "TS_DiscordInvite",
    "EDITBOX",
    localize "STR_TS_DISCORD",
    ["KP Liberation", "Team Speak"],
    "discord.gg/link",
    1
] call CBA_fnc_addSetting;

[
    "KPLIB_factory_logging_enabled",
    "CHECKBOX",
    [localize "STR_FDC_TITLE", localize "STR_FDC_DESC"],
    ["KP Liberation", "Factory Logging"],
    false,
    1
] call CBA_fnc_addSetting;

[
    "KPLIB_fob_logging_enabled",
    "CHECKBOX",
    [localize "STR_FOBDC_TITLE", localize "STR_FOBDC_DESC"],
    ["KP Liberation", "FOB Logging"],
    false,
    1
] call CBA_fnc_addSetting;