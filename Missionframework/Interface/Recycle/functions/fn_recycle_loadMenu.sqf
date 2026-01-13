#include "..\defines.hpp"
/*
    File: fn_recycle_loadMenu.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 22/11/2025
    Last Update: 23/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Load the recycle menu and calculate resource gains

    Parameter(s):
        _display - recycle menu display [DISPLAY, defaults to findDisplay IDD_RECYCLE_MENU]

    Returns:
        -
*/

params[["_display", findDisplay IDD_RECYCLE_MENU]];

// Controls
private _infoTextCtrl = _display displayCtrl IDC_INFO_TEXT;
private _supplyNumberCtrl = _display displayCtrl IDC_SUPPLY_NUMBER;
private _ammoNumberCtrl = _display displayCtrl IDC_AMMO_NUMBER;
private _fuelNumberCtrl = _display displayCtrl IDC_FUEL_NUMBER;

// Get vehicle to recycle
private _vehToRecycle = localNamespace getVariable ["KPLIB_vehToRecycle", objNull];
if (isNull _vehToRecycle) exitWith {_display closeDisplay 1};

private _type = typeOf _vehToRecycle;
private _cfg = configFile >> "cfgVehicles";
private _suppMulti = 0.75;
private _ammoMulti = 0.75;
private _fuelMulti = 0.75;

if !(
    ((toLowerANSI _type) in KPLIB_b_deco_classes) ||
    ((toLowerANSI _type) in KPLIB_storageBuildings) ||
    ((toLowerANSI _type) in KPLIB_upgradeBuildings) ||
    (_type in KPLIB_ace_crates) ||
    (_type == "B_Slingload_01_Repair_F") ||
    (_type == "B_Slingload_01_Fuel_F") ||
    (_type == "B_Slingload_01_Ammo_F")
) then {
    private _currentAmmo = 0;
    private _allAmmo = 0;
    if (count (magazinesAmmo _vehToRecycle) > 0) then {
        {
            _currentAmmo = _currentAmmo + (_x select 1);
            _allAmmo = _allAmmo + (getNumber(configFile >> "CfgMagazines" >> (_x select 0) >> "count"));
        } forEach (magazinesAmmo _vehToRecycle);
    } else {
        _allAmmo = 1;
    };

    _suppMulti = (((_vehToRecycle getHitPointDamage "HitEngine") - 1) * -1) * (((_vehToRecycle getHitPointDamage "HitHull") - 1) * -1);
    _ammoMulti = _currentAmmo/_allAmmo;
    _fuelMulti = fuel _vehToRecycle;

    if (_type in boats_names) then {
        _suppMulti = (((_vehToRecycle getHitPointDamage "HitEngine") - 1) * -1);
    };
};

private _price_s = 0;
private _price_a = 0;
private _price_f = 0;

if ((toLowerANSI _type) in KPLIB_o_allVeh_classes) then {
    if (_vehToRecycle isKindOf "Car") then {
        _price_s = round (60 * _suppMulti);
        _price_a = round (25 * _ammoMulti);
        _price_f = round (40 * _fuelMulti);
    };
    if (_vehToRecycle isKindOf "Tank") then {
        _price_s = round (150 * _suppMulti);
        _price_a = round (120 * _ammoMulti);
        _price_f = round (100 * _fuelMulti);
    };
    if (_vehToRecycle isKindOf "Air") then {
        _price_s = round (250 * _suppMulti);
        _price_a = round (200 * _ammoMulti);
        _price_f = round (150 * _fuelMulti);
    };
} else {
    private _objectinfo = ((KPLIB_b_vehLight + KPLIB_b_vehHeavy + KPLIB_b_vehAir + KPLIB_b_vehStatic + KPLIB_b_vehSupport + KPLIB_b_objectsDeco) select {_type == (_x select 0)}) select 0;
    _price_s = round ((_objectinfo select 1) * KPLIB_recycling_percentage * _suppMulti);
    _price_a = round ((_objectinfo select 2) * KPLIB_recycling_percentage * _ammoMulti);
    _price_f = round ((_objectinfo select 3) * KPLIB_recycling_percentage * _fuelMulti);
};

_infoTextCtrl ctrlSetText format [localize "STR_RECYCLING_YIELD", getText (_cfg >> _type >> "displayName")];
_supplyNumberCtrl ctrlSetText format ["%1", _price_s];
_ammoNumberCtrl ctrlSetText format ["%1", _price_a];
_fuelNumberCtrl ctrlSetText format ["%1", _price_f];

// Save values (handled on fn_doRecycle.sqf)
localNamespace setVariable ["KPLIB_recycleGain", [_vehToRecycle, _price_s, _price_a, _price_f]];