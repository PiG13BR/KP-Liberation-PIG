/*
	File: fn_getContainerCargo.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 12/09/2025
	Last update: 16/09/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Get all items inside a container (backpack, vest, uniform)

	Parameters:
		_container - container items [ARRAY, defaults to []]

	Return:
		-
*/

params[["_container", [], [[]]]];

private _containerItems = [];

if (_container isEqualTo []) exitWith {_containerItems};

{
    private _containerClass = _x # 0;
    private _containerObject = _x # 1;

    // Weapons in container (with attachs)
    private _weaponsCargo = [];
    private _weaponsWithAttachInContainer = (weaponsItemsCargo _containerObject);
    //_weaponsWithAttachInContainer = _weaponsWithAttachInContainer arrayIntersect _weaponsWithAttachInContainer; // Intersect the arrays.
    {
        private _data = _x;
        private _wpClass = (_x # 0);
        private _index = (_weaponsCargo findIf {(_x # 0) isEqualTo _data});
        if (_index < 0) then {
            //_weaponsCargo pushBack [_x, (_weaponCargo # 1) # _forEachIndex]
            _weaponsCargo pushBack [_x, 1]
        } else {
            private _amount =  (_weaponsCargo # _index) # 1;
            _amount = _amount + 1;
            (_weaponsCargo # _index) set [1, _amount];
        };
    }forEach _weaponsWithAttachInContainer;
    //{_weaponsCargo pushBack [_x, ((getWeaponCargo _containerObject) # 1) # _forEachIndex]}forEach _weaponsWithAttachInContainer;
    
    // Magazines in container
    private _magazineCargo = [];
    {_magazineCargo pushBack [_x, ((getMagazineCargo _containerObject) # 1) # _forEachIndex]}forEach ((getMagazineCargo _containerObject) # 0);
    
    // Items in container
    private _itemsCargo = [];
    {_itemsCargo pushBack [_x, ((getItemCargo _containerObject) # 1) # _forEachIndex]}forEach ((getItemCargo _containerObject) # 0);

    private _data = [_containerClass, [_weaponsCargo, _magazineCargo, _itemsCargo]];

    private _index = (_containerItems findIf {(_x # 0) isEqualTo _data});
    if (_index < 0) then {
        // Create container array with all its cargo and count
        _containerItems pushBack [_data, 1];
    } else {
        private _amount =  (_containerItems # _index) # 1;
        _amount = _amount + 1;
        (_containerItems # _index) set [1, _amount];
    }
    
}forEach _container; 

_containerItems