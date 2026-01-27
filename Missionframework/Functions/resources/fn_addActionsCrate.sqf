/*
    File: fn_addActionsCrate.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 26/05/2017
    Last Update: 26/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Add actions to resource crate

    Parameter(s):
        _crate - Crate to check [OBJECT, defaults to objNull]

    Returns:
        -
*/

params["_crate"];

private _loadAction = _crate addAction [
    "<t color='#FFFF00'>" + localize "STR_ACTION_LOAD_BOX" + "</t>",
    {
        params["_crate"];

        private _loaded = [_crate] call KPLIB_fnc_doLoadCrate;
        if (_loaded) then {["KPLIB_removeAllActionsCrate", _crate] call CBA_fnc_globalEventJIP;};
    },
    "",
    -501,
    true,
    true,
    "",
    toString {
        ((_target nearEntities [KPLIB_transport_classes, 15]) select {(alive _x) && {_x getVariable ["KPLIB_CARGO_isTransportVeh", false]} && {speed _x < 2} && {((getPosATL _x) # 2) < 5}} isNotEqualTo []) &&
        {!(_this getVariable ['KPLIB_BUILD_isBuilding', false])} &&
        {isNull objectParent _this} &&
        {[5] call KPLIB_fnc_hasPermission} &&
        {isNull (_this getVariable ["KPLIB_carriedObject", objNull])} &&
        {!(_target getVariable ["KPLIB_beignCarried", false])} &&
        {!(_target getVariable ["KPLIB_crateInStorage", false])}
    },
    5
];

private _storeAction = _crate addAction [
    "<t color='#FFFF00'>" + localize "STR_ACTION_STORE_CRATE" + "</t>",
    {
        params["_crate"];

        [_crate, (nearestObjects [player, KPLIB_storageBuildings, 20]) # 0,true] call KPLIB_fnc_crateToStorage;
    },
    "",
    -502,
    true,
    true,
    "",
    toString {
        !(_this getVariable ['KPLIB_BUILD_isBuilding', false]) && 
        {isNull objectParent _this} && 
        {nearestObjects [_target, KPLIB_storageBuildings, 20] isNotEqualTo []} &&
        {[5] call KPLIB_fnc_hasPermission} &&
        {isNull (_this getVariable ["KPLIB_carriedObject", objNull])} &&
        {!(_target getVariable ["KPLIB_beignCarried", false])} &&
        {!(_target getVariable ["KPLIB_crateInStorage", false])}
    },
    5
    
];

private _valueAction = _crate addAction [
    "<t color='#FFFF00'>" + localize "STR_ACTION_CRATE_VALUE" + "</t>",
    {
        [_this # 0] call KPLIB_fnc_checkCrateValue;
    },
    "",
    -503,
    true,
    true,
    "",
    toString {
        !(_this getVariable ['KPLIB_BUILD_isBuilding', false]) &&
        {isNull objectParent _this} &&
        {[5] call KPLIB_fnc_hasPermission} &&
        {isNull (_this getVariable ["KPLIB_carriedObject", objNull])} &&
        {!(_target getVariable ["KPLIB_beignCarried", false])} &&
        {!(_target getVariable ["KPLIB_crateInStorage", false])}
    },
    5
];

private _carryAction = _crate addAction [
    "<t color='#FFFF00'>" + localize "STR_ACTION_CRATE_CARRY" + "</t>",
    {
        params ["_crate", "_player"];
    
        _crate attachTo [_player, [0, 2, 1]];
        ["KPLIB_crateCollisionChange", [_crate, false]] call CBA_fnc_globalEventJIP;
        _crate setVariable ["KPLIB_beignCarried", true, true];
        _player setVariable ["KPLIB_carriedObject", _crate];
        _crate enableRopeAttach true;

        // Drop crate action
        _player addAction [
            ["<t color='#FFFF00'>", localize "STR_ACTION_CRATE_DROP", "</t>"] joinString "",
            {
                params ["_player", "_caller", "_actionId", "_arguments"];
                private _crate = _player getVariable ["KPLIB_carriedObject", objNull];

                // prevent players from putting crates inside vehicles
                private _crateSize = sizeOf typeOf _crate * 1.5;
                private _nearObjects = (_crate nearEntities [["CAManBase", "Air", "Car", "Tank"], _crateSize]) - [_crate, _player];
                if (_nearObjects isNotEqualTo []) exitWith {
                    [format [localize "STR_PLACEMENT_IMPOSSIBLE", count _nearObjects, _crateSize toFixed 0], true, 3] call KPLIB_fnc_hint
                };

                _player setVariable ["KPLIB_carriedObject", nil];
                _crate setVariable ["KPLIB_beignCarried", false, true];
                ["KPLIB_crateCollisionChange", [_crate, true]] call CBA_fnc_globalEventJIP;
                detach _crate;
                _crate awake true;
                _crate enableRopeAttach true;
                _player removeAction _actionId; // Remove action from player
            },
            nil,
            -504,
            true,
            false,
            "",
            toString {
                alive _originalTarget &&
                {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])} && {isNull (objectParent _originalTarget)} && {!isNull (_originalTarget getVariable ["KPLIB_carriedObject", objNull])}
            }
        ];
    },
    "",
    -504,
    true,
    false,
    "",
    toString {
        !(_this getVariable ['KPLIB_BUILD_isBuilding', false]) && 
        {isNull objectParent _this} &&
        {[5] call KPLIB_fnc_hasPermission} &&
        {isNull (_this getVariable ["KPLIB_carriedObject", objNull])} &&
        {!(_target getVariable ["KPLIB_beignCarried", false])} &&
        {!(_target getVariable ["KPLIB_crateInStorage", false])}
    },
    5
];

_crate setVariable ["KPLIB_crateActions", [_loadAction, _storeAction, _valueAction, _carryAction], true]