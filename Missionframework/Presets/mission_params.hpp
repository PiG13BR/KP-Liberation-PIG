class Spacer11 {
    title = "";
    values[] = {""};
    texts[] = {""};
    default = "";
};
class PresetCustomization {
    title = $STR_PARAMS_PRESET_CUSTOMIZATION;
    values[] = {""};
    texts[] = {""};
    default = "";
};
class BLUFORPreset {
    title = $STR_PARAMS_BLUFORPRESET;
    values[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31};
    texts[] = {"Default (Vanilla NATO)", "Apex Tanoa", "3cb BAF (MTP)", "3cb BAF (Desert)", "BWMod Bundeswehr (Flecktarn)", "BWMod Bundeswehr (Tropentarn)", "RHS USAF (Woodland)", "RHS USAF (Desert)", "RHS AFRF (VDV/MSV)", "Germany West (Global Mobilization)", "Germany West Winter (Global Mobilization)", "Germany East (Global Mobilization)", "Germany East Winter (Global Mobilization)", "CSAT Brown", "CSAT Green", "Unsung US", "CUP British Armed Forces (Desert)", "CUP British Armed Forces (Woodland)", "CUP US Marine Corps (Desert)", "CUP US Marine Corps (Woodland)", "CUP US Army (Desert)", "CUP US Army (Woodland)", "CUP Chernarus Defense Force", "CUP Army of the Czech Republic (Desert)", "CUP Army of the Czech Republic (Woodland)", "CUP Chernarussian Movement of the Red Star", "CUP Sahrani Liberation Army", "CUP Takistani Army", "SFP (Woodland)", "SFP (Desert)", "LDF (Contact DLC)", "CUP AAF Deserters mix (AAF, Aegis Task Force and CTRG)"};
    default = 0;
};
class OPFORPreset {
    title = $STR_PARAMS_OPFORPRESET;
    values[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21};
    texts[] = {"Default (Vanilla CSAT)", "Apex Tanoa", "RHS AFRF (EMR/MSV)", "Project OPFOR (Takistan)", "Project OPFOR (Islamic State)", "Project OPFOR (Sahrani)", "AAF", "NATO", "Germany West (Global Mobilization)", "Germany West Winter (Global Mobilization)", "Germany East (Global Mobilization)", "Germany East Winter (Global Mobilization)", "Unsung NVA", "CUP Sahrani Liberation Army", "CUP Takistani Army", "CUP Chernarussian Movement of the Red Star", "CUP Armed Forces of the Russian Federation (MSV - EMR)", "CUP Armed Forces of the Russian Federation (Modern MSV)", "CUP Chernarus Defense Force", "CUP British Armed Forces (Desert)", "CUP British Armed Forces (Woodland)", "CUP AAF"};
    default = 0;
};
class guerPreset {
    title = $STR_PARAMS_GUERPRESET;
    values[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    texts[] = {"Default Vanilla FIA", "Apex Tanoa (apex vanilla Syndikat)", "RHS GREF", "Project OPFOR (Middle Eastern)", "Project OPFOR (Sahrani)", "Germany (Global Mobilization)", "Unsung", "CUP Takistani Locals", "CUP National Party of Chernarus", "CUP FIA"};
    default = 0;
};
class civPreset {
    title = $STR_PARAMS_CIVPRESET;
    values[] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
    texts[] = {"Default Vanilla", "Apex Tanoa (apex vanilla)", "Project OPFOR (Middle Eastern)", "RDS Civilians", "Germany (Global Mobilization)", "Unsung", "CUP Takistani Civilians", "CUP Chernarussian Civilians", "CUP ACW"};
    default = 0;
};
class ArsenalUsePreset {
    title = $STR_PARAMS_ARSENALUSEPRESET;
    values[] = {0, 1, 2};
    texts[] = {$STR_PARAMS_NORESTRICTIONS, $STR_PARAMS_USEPRESET, $STR_PARAMS_ARSENAL_WHITELIST};
    default = 1;
};
class arsenalPreset {
    title = $STR_PARAMS_ARSENALPRESET;
    values[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16};
    texts[] = {"Blacklist method (Presets\Arsenal\blacklist.sqf)", "Custom arsenal preset (Presets\Arsenal\custom.sqf)", "RHS USAF arsenal preset", "3cbBAF and RHS USAF arsenal preset", "GM West arsenal preset", "GM East arsenal preset", "CSAT arsenal preset", "Unsung US arsenal preset", "SFP arsenal preset", "BWMod arsenal preset", "NATO MTP arsenal preset", "NATO Tropic arsenal preset", "NATO Woodland arsenal preset", "CSAT Hex arsenal preset", "CSAT Green Hex arsenal preset", "AAF arsenal preset", "LDF arsenal preset"};
    default = 0;
};
class arsenalWhiteListPreset {
    title = $STR_PARAMS_ARSENALWHITELIST_PRESET;
    values[] = {0};
    texts[] = {"Custom Preset (Presets\Arsenal\roles_presets\custom.sqf)"};
    default = 0;
};