#include "..\defines.hpp"
/*
	File: fn_setFavoriteMagazine.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 15/06/2026
	Last Update: 07/10/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Sets/removes and saves favorite magazine

	Parameter(s):
		magazines control passed arguments
	
	Returns:
		-
*/
params ["_control", "_selectedIndex"];

private _display = ctrlParent _control;
private _ctrlMagazinesListBox = _display displayCtrl IDC_MAGAZINES_LISTBOX;
private _ctrlMagazinesCombo = _display displayCtrl IDC_MAGAZINES_COMBO;
private _magazine = _control lbData _selectedIndex;

private _aircraft = localNameSpace getVariable ["PIG_PAS_aircraft", objNull];

private _favorites = profileNamespace getVariable ["PIG_PAS_favorites", []];
if !(_magazine in _favorites) then {
    // Add to favorites
    //_control lbSetPicture [_selectedIndex, "a3\3den\data\displays\display3den\panelright\modefavorites_ca.paa"];
    _control lbSetColor [_selectedIndex, [0.87,0.76,0.22,1]];
    _control lbSetPictureColor [_selectedIndex, [0.87,0.76,0.22,1]];
    _control lbSetPictureColorSelected [_selectedIndex, [0.87,0.76,0.22,1]];
    _favorites pushBack _magazine;
    profileNamespace setVariable ["PIG_PAS_favorites", _favorites]
} else {
    // Remove it
    _control lbSetColor [_selectedIndex, [1,1,1,1]];
    _control lbSetPictureColor [_selectedIndex, [1,1,1,1]];
    _control lbSetPictureColorSelected [_selectedIndex, [1,1,1,1]];
    _favorites deleteAt (_favorites find _magazine);
    profileNamespace setVariable ["PIG_PAS_favorites", _favorites];

    // Refresh favorites
    if (lbCurSel _ctrlMagazinesCombo == 1) then {
        [_display, 1] call KPLIB_fnc_fillMagazinesListbox;
    };
};
