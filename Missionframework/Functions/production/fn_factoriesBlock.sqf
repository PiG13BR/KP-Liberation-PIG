/*
    File: fn_factoriesBlock.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 07/02/2026
    Last Update: 07/02/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Runs a PFH to block factory if the civilian reputation is low
        The factory gets seized by the resistance
        The players must eliminate all guerilla in the area to be able to use the factory again

    Parameter(s):
        -

    Returns:
        -
*/

if (isNil "KPLIB_blockedFactories") then {
    KPLIB_blockedFactories = [];
    publicVariable "KPLIB_blockedFactories";
};

[
    {
        private _factories = [];
        {
            if (_x in KPLIB_sectors_player) then {
                _factories pushBack _x
            };
        }forEach KPLIB_sectors_factory;

        // Amout of factories to block
        private _amount = -(KPLIB_civ_rep/25);

        if ((_amount < 1) || (_factories isEqualTo [])) then {continue};

        // Select a random factory to block its production
        if (KPLIB_civ_rep <= -25 && (count KPLIB_blockedFactories < _amount)) then {

            private _factoryToBlock = [_factories] call KPLIB_fnc_selectFactoryToBlock;
            if (_factoryToBlock == "") exitWith {};

            KPLIB_blockedFactories pushBackUnique _factoryToBlock;
            publicVariable "KPLIB_blockedFactories";

            // Spawns guerilla in factory
            private _guerUnits = [_factoryToBlock] call KPLIB_fnc_spawnGuerInFactory;

            // Create a marker on the top of the sector
            private _mk = createMarker [format["%1_blocked", _factoryToBlock], markerPos _factoryToBlock];
            _mk setMarkerType "mil_destroy";
            _mk setMarkerSize [1.2, 1.2];
            _mk setMarkerDir 45;
            _mk setMarkerColor "ColorRED";

            // Manage blocked factory
            [_factoryToBlock, _guerUnits] call KPLIB_fnc_factoryBlockedPFH;

            // Notification
            ["lib_factory_seized", [markerText _factoryToBlock]] remoteExec ["BIS_fnc_showNotification"];

            // Remove storage
            deleteVehicle (KPLIB_sector_storage get _factoryToBlock);

        };
    }, 3600, []
] call CBA_fnc_addPerFrameHandler;