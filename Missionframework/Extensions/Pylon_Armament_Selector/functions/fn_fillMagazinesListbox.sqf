#include "..\defines.hpp"
/*
	File: fn_fillMagazinesListBox.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 15/06/2026
	Last Update: 07/10/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Fills the magazine list box

	Parameter(s):
		_display - pylon manager display [DISPLAY]
        _index - index from magazines combo selection [NUMBER, defaults to 0]
	
	Returns:
		-
*/
params["_display", ["_index", 0]];

private _ctrlMagazinesListBox = _display displayCtrl IDC_MAGAZINES_LISTBOX;
lbClear _ctrlMagazinesListBox;

private _pylonIndex = localNameSpace getVariable ["PIG_PAS_pylonIndex", 0];
private _aircraft = localNameSpace getVariable ["PIG_PAS_aircraft", objNull];

private _compatibleMagazines = ((typeOf _aircraft) getCompatiblePylonMagazines _pylonIndex);

// Check for custom preset
if (!(isNil "PIG_PAS_customPreset") && {count PIG_PAS_customPreset > 0}) then {
    // Only add compatible magazines on custom preset
    _compatibleMagazines = _compatibleMagazines arrayIntersect PIG_PAS_customPreset;
};

// Fix compatible magazines return
private _compatMagazines = [];
{        
    if (_x isEqualType []) then {
        _compatMagazines append _x
    } else {
        _compatMagazines pushBackUnique _x
    }
}forEach _compatibleMagazines;

_compatMagazines = _compatMagazines arrayIntersect _compatMagazines; // Remove duplicated magazines

// Filter list
_compatMagazines = _compatMagazines select {
    private _magazine = _x;
    private _ammo = getText(configFile >> "cfgMagazines" >> _magazine >> "ammo");

    !(toLowerANSI(_magazine) in (["cwr3_PylonMissile_1Rnd_RN28","tu95_1Rnd_Kh55", "tu95_6Rnd_Kh55"] apply {toLowerANSI _x})) // Do not include nuclear weapons
    && !("sonobuoy" in _magazine) // Useless
    && !(_ammo isKindOf ["pook_Missile_CruiseBase", configFile >> "cfgAmmo"]) // Remove pook's cruise missiles (bad config)
};

// For magazine listbox
// Top option: "none"
_ctrlMagazinesListBox lbAdd (localize "STR_PAS_NONE");
_ctrlMagazinesListBox lbSetTooltip [0, localize "STR_PAS_EMPTY"];
_ctrlMagazinesListBox lbSetData [0, ""];
_ctrlMagazinesListBox lbSetPictureRight [0, "a3\ui_f\data\igui\cfg\actions\obsolete\ui_action_cancel_ca.paa"];

private _favorites = profileNamespace getVariable ["PIG_PAS_favorites", []];

// For Lb selector
private _magazinePylon = (getPylonMagazines _aircraft) # (_pylonIndex - 1);

private _magIndex = -1;
switch _index do {
    case 0 : {
        // All
        {
            private _magazine = _x;
            
            if (_magazine == _magazinePylon) then {
                _magIndex = _forEachIndex + 1;
            };

            private _name = getText(configFile >> "cfgMagazines" >> _magazine >> "displayName");
            _ctrlMagazinesListBox lbAdd _name;
            _ctrlMagazinesListBox lbSetTooltip [(_forEachIndex + 1), str(parseText(getText(configFile >> "CfgMagazines" >> _x >> "descriptionShort")))];
            _ctrlMagazinesListBox lbSetData [(_forEachIndex + 1), _magazine]; // Store default list box data
            _ctrlMagazinesListBox lbSetPicture [_forEachIndex + 1, "a3\3den\data\displays\display3den\panelright\modefavorites_ca.paa"]; // Add favorite pic
            _ctrlMagazinesListBox lbSetPictureColor [_forEachIndex + 1, [1,1,1,1]];

            // Mark favorites magazines
            if (_magazine in _favorites) then {
                _ctrlMagazinesListBox lbSetColor [_forEachIndex + 1, [0.87,0.76,0.22,1]];
                _ctrlMagazinesListBox lbSetPictureColor [_forEachIndex + 1, [0.87,0.76,0.22,1]];
                _ctrlMagazinesListBox lbSetPictureColorSelected [_forEachIndex + 1, [0.87,0.76,0.22,1]];
            };
            
            [_ctrlMagazinesListBox, _magazine, _forEachIndex + 1] call KPLIB_fnc_setLbPictureRight;
            
        }forEach _compatMagazines;   
    };
    case 1 : {
        // Favorites
        // Only show compatible favorite magazines for the selected pylon
        _favorites = _favorites select {
            _x in _compatMagazines;
        };

        {
            private _name = getText(configFile >> "cfgMagazines" >> _x >> "displayName");
            _ctrlMagazinesListBox lbAdd _name;
            _ctrlMagazinesListBox lbSetTooltip [(_forEachIndex + 1), getText(configFile >> "CfgMagazines" >> _x >> "descriptionShort")];
            _ctrlMagazinesListBox lbSetData [(_forEachIndex + 1), _x]; // Store default list box data
            _ctrlMagazinesListBox lbSetPicture [(_forEachIndex + 1), "a3\3den\data\displays\display3den\panelright\modefavorites_ca.paa"];
            _ctrlMagazinesListBox lbSetPictureColor [(_forEachIndex + 1), [0.87,0.76,0.22,1]];
            _ctrlMagazinesListBox lbSetPictureColorSelected [(_forEachIndex + 1), [0.87,0.76,0.22,1]];
            [_ctrlMagazinesListBox, _x, (_forEachIndex + 1)] call KPLIB_fnc_setLbPictureRight;
        }forEach _favorites;
    };
};

// Create turret buttons
[_display, _aircraft] call KPLIB_fnc_createTurretButtons;

if (_magIndex > 0) then {
    _ctrlMagazinesListBox lbSetCurSel _magIndex;
} else {
    _ctrlMagazinesListBox lbSetCurSel 0;
};
