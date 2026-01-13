/*
    File: fn_addArtyMenuAction.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 30/09/2025
    Last update: 22/11/2025

    Description:
        Register artillery to be called in the artillery menu
        [this] call KPLIB_fnc_addArtyMenuAction

    Parameter(s):
        _player - player who is going to receive the action [OBJECT, defaults to player]
    
    Returns:
        BOOL - true on success
*/
params[["_player", player, [objNull]]];

if !(isClass (configfile >> "CfgPatches" >> "ace_common")) exitWith {["[ARTY MENU] Ace mod required"] call BIS_fnc_error; false};
if (isNull _player) exitWith {["[ARTY MENU] object is null"] call BIS_fnc_error; false};
if !(KPLIB_ace) exitWith {};

private _supportAction = [
    "PIG_SUPPORTS_ACE",
    "Support",
    "a3\modules_f_curator\data\portraitradio_ca.paa",   
    {nil},{true},
    // Create children
	{
        params ["_target", "_player", "_params"];
        private _artyAction = [
            "KPLIB_ARTY_callArty_ACE",
            "Artillery Support", 
            "a3\ui_f\data\gui\cfg\communicationmenu\artillery_ca.paa",
            {
                [] call KPLIB_fnc_createArtyMenuRsc;
            },
            {
                private _requiredItems = ((parseSimpleArray PIG_ARTYMenu_Setting_RequiredItems) apply {toLowerANSI _x});
                private _items = ((assignedItems _player) + (backpackitems _player) + (uniformItems _player) + (vestItems _player)) + [backpack _player];

                alive _player &&
                {(_player isEqualTo ([] call KPLIB_fnc_getCommander)) || {(getPlayerUID _player) in KPLIB_whitelist_supportModule}} &&
                {(_requiredItems isNotEqualTo [] &&
                {
                    _items findIf {(toLowerANSI _x) in _requiredItems} >= 0
                }) || 
                {_requiredItems isEqualTo []}}
            },
            nil,
            ["ACE_SelfActions"] 
        ] call ace_interact_menu_fnc_createAction;

        [[_artyAction, [], _target]] // Required return
    },
	["ACE_SelfActions"]
] call ace_interact_menu_fnc_createAction;

[player, 1, ["ACE_SelfActions"], _supportAction] call ace_interact_menu_fnc_addActionToObject;

true