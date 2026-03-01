#include "..\defines.hpp"
/*
    File: fn_production_handleListBox.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 15/11/2025
    Last Update: 07/02/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handles the production menu listbox. Add PFH to keep updating controls.

    Parameter(s):
        _lbControl - listbox control [CONTROL, defaults to (findDisplay IDD_PRODUCTION_MENU) displayCtrl IDC_PRODUCTION_LISTBOX]
        _lbCurSel - Listbox selection [NUMBER, defaults to -1]

    Returns:
        -
*/
params [["_lbControl", (findDisplay IDD_PRODUCTION_MENU) displayCtrl IDC_PRODUCTION_LISTBOX, [controlNull]], ["_lbCurSel", -1, [0]]];

if (_lbCurSel == -1) then {
    _lbCurSel = lbCurSel _lbControl;
};

private _sector = _lbControl lbData _lbCurSel;

// Map control
//"spawn_marker" setMarkerPosLocal (markerPos _sector); // ???
private _display = ctrlParent _lbControl;
private _mapCtrl = _display displayCtrl IDC_MAP;
_mapCtrl ctrlMapAnimAdd [0.5, 0.2, (markerPos _sector)];
ctrlMapAnimCommit _mapCtrl;

// Remove PFH
if (!isNil "KPLIB_production_MenuPFH") then {[KPLIB_production_MenuPFH] call CBA_fnc_removePerFrameHandler};

// Update menu
KPLIB_production_MenuPFH = [{
    params["_args", "_handle"];
    _args params ["_display", "_lbCurSel", "_sector"];

    private _storagespace = "";
    private _producing = "";
    private _productionTime = "";
    private _color_actual = COLOR_NEUTRAL;

    // Controls
    private _sectorNameCtrl = _display displayCtrl IDC_SECTOR_NAME_TEXT;
    private _sectorTypeCtrl = _display displayCtrl IDC_SECTOR_TYPE_LABEL;
    private _sectorProducingCtrl = _display displayCtrl IDC_SECTOR_PRODUCTION_LABEL;
    private _storageSpaceCtrl = _display displayCtrl IDC_SECTOR_STORAGE_LABEL;
    private _productionTimerCtrl = _display displayCtrl IDC_PRODUCTION_TIMER_LABEL;
    private _producesSupplyCtrl = _display displayCtrl IDC_SUPPLY_FACILITY_TEXT;
    private _producesAmmoCtrl = _display displayCtrl IDC_AMMO_FACILITY_TEXT;
    private _producesFuelCtrl = _display displayCtrl IDC_FUEL_FACILITY_TEXT;
    private _supplyAmountCtrl = _display displayCtrl IDC_STORAGE_SUPPLY_LABEL;
    private _ammoAmountCtrl = _display displayCtrl IDC_STORAGE_AMMO_LABEL;
    private _fuelAmountCtrl = _display displayCtrl IDC_STORAGE_FUEL_LABEL;
    private _productionBoostCtrl = _display displayCtrl IDC_PRODUCTION_BOOST_TEXT;
    

    // Get production elements for the selected sector
    //private _selectedProduction = +(KPLIB_production # _lbCurSel);
    private _selectedProduction = KPLIB_production get _sector;

    localNamespace setVariable ["KPLIB_production_SectorSelected", _sector];

    _selectedProduction params [
        "_sectorName",
        "_sectorType",
        "_storageArray",
        "_canProduceS",
        "_canProduceA",
        "_canProduceF",
        "_producingType",
        "_time",
        "_suppliesAmount",
        "_suppliesAmount",
        "_suppliesAmount"
    ];

    // Change sector name
    _sectorNameCtrl ctrlSetText _sectorName;

    // Change sector type
    private _sectorTypeName = "";
    if (_sectorType == SECTOR_TYPE_FACTORY) then {
        _sectorTypeName = localize "STR_PRODUCTION_FACTORY";
    } else {
        _sectorTypeName = localize "STR_PRODUCTION_CITY";
    };

    _sectorTypeCtrl ctrlSetText _sectorTypeName;

    private _storage = KPLIB_sector_storage getOrDefault [_sector, objNull];

    // Check for existing storage
    if !(isNull _storage) then {
        // Get storage object
        (_storage getVariable ["KPLIB_storageResources", [0,0,0]]) params ["_suppliesAmount", "_ammoAmount", "_fuelAmount"];
        private _reSum = _suppliesAmount + _ammoAmount + _fuelAmount;

        private _storageLimit = [_storage] call KPLIB_fnc_getStorageLimit;

        if (_reSum >= _storageLimit) then {
            _color_actual = COLOR_NEGATIVE;
        };
        
        private _storagespace = format ["%1 / %2", _reSum, _storageLimit];
        private _productionTime = format [localize "STR_PRODUCTION_MINUTES", _time];

        // Type of resource that is the selected sector is producing
        switch _producingType do {
            case PRODUCING_AMMO: {_producing = localize "STR_AMMO";};
            case PRODUCING_FUEL: {_producing = localize "STR_FUEL";};
            case PRODUCING_NOTHING: {
                _producing = localize "STR_PRODUCTION_NOTHING"; 
                _productionTime = localize "STR_PRODUCTION_NOTIMER";
            };
            default {_producing = localize "STR_MANPOWER";};
        };

        _sectorProducingCtrl ctrlSetText _producing;
        if (_producingType == PRODUCING_NOTHING) then {
            _sectorProducingCtrl ctrlSetTextColor COLOR_NEGATIVE;
            _sectorProducingCtrl ctrlSetTextColor COLOR_NEGATIVE;
        } else {
            _sectorProducingCtrl ctrlSetTextColor COLOR_NEUTRAL;
            _sectorProducingCtrl ctrlSetTextColor COLOR_NEUTRAL;
        };

        _storageSpaceCtrl ctrlSetText _storagespace;
        _storageSpaceCtrl ctrlSetTextColor _color_actual;

        _productionTimerCtrl ctrlSetText _productionTime;

        _color_actual = COLOR_NEUTRAL;
    } else {
        // No storage on this selected sector
        _producing = localize "STR_PRODUCTION_NOTHING";
        _storagespace = localize "STR_PRODUCTION_NOSTORAGE";
        _productionTime = localize "STR_PRODUCTION_NOTIMER";

        _sectorProducingCtrl ctrlSetText _producing;
        _sectorProducingCtrl ctrlSetTextColor COLOR_NEGATIVE;
        _storageSpaceCtrl ctrlSetText _storagespace;
        _storageSpaceCtrl ctrlSetTextColor COLOR_NEGATIVE;
        _productionTimerCtrl ctrlSetText _productionTime;
        _productionTimerCtrl ctrlSetTextColor COLOR_NEGATIVE;
    };

    // Check for facilities
    // Can produce supplies?
    if (_canProduceS) then {
        _producesSupplyCtrl ctrlSetTextColor COLOR_POSITIVE;
    } else {
        _producesSupplyCtrl ctrlSetTextColor COLOR_NEGATIVE;
    };

    // Can produce ammo?
    if (_canProduceA) then {
        _producesAmmoCtrl ctrlSetTextColor COLOR_POSITIVE;
    } else {
        _producesAmmoCtrl ctrlSetTextColor COLOR_NEGATIVE;
    };

    // Can produce fuel?
    if (_canProduceF) then {
        _producesFuelCtrl ctrlSetTextColor COLOR_POSITIVE;
    } else {
        _producesFuelCtrl ctrlSetTextColor COLOR_NEGATIVE;
    };

    // Get the <<actual>> amount of resources present in the storage. KPLIB_production is only updated each minute.
    (_storage getVariable ["KPLIB_storageResources", [0,0,0]]) params ["_suppliesAmount", "_ammoAmount", "_fuelAmount"];

    _supplyAmountCtrl ctrlSetText (str _suppliesAmount);
    _ammoAmountCtrl ctrlSetText (str _ammoAmount);
    _fuelAmountCtrl ctrlSetText (str _fuelAmount);

    _productionBoostCtrl ctrlSetText (format [localize "STR_PRODUCTION_BOOST", round (30 + (10 * KPLIB_param_difficulty))]);

    if (_sector in KPLIB_blockedFactories) then {
        // If factory was seized, replace production boost control text with the seized text
        _productionBoostCtrl ctrlSetText (localize "STR_FACTORY_SEIZED_TEXT");
        _productionBoostCtrl ctrlSetTextColor COLOR_NEGATIVE;
    } else {
        if (KPLIB_civ_rep >= round (30 + (10 * KPLIB_param_difficulty))) then {
            _productionBoostCtrl ctrlSetTooltip localize "STR_PRODUCTION_BOOST_ACTIVATED";
            _productionBoostCtrl ctrlSetTextColor COLOR_POSITIVE
        } else {
            _productionBoostCtrl ctrlSetTextColor COLOR_NEGATIVE;
        };
    };
}, 1, [_display, _lbCurSel, _sector]] call CBA_fnc_addPerFrameHandler;

