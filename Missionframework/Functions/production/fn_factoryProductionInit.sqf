/*
    File: fn_factoryProduceResource.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 14/11/2025
    Last Update: 17/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Start production of resources at the game start on factories that were already producing resource

    Parameter(s):
        -

    Returns:
        -
*/

{
    private _sector = _x;

    private _storageArray = _y # 2;
    private _producing = _y # 6;

    if ((count _storageArray > 0) && {_producing < 3}) then {
        [_sector] call KPLIB_fnc_factoryProductionPFH;
    };
}forEach KPLIB_production