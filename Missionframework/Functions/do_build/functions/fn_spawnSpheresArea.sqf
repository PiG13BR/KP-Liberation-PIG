/*
    File: fn_spawnShepresArea.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 28/08/2025
    Last update: 10/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Creates spheres around the building area, locally

    Parameter(s)
        _fobPos - fob position [POSITION, defaults to [0,0,0]] 
        _player - player that is using the build menu [OBJECT, defaults to player]

    Returns:
        -
*/
params[["_fobPos", [0,0,0], [[]]], ["_player", player, [ObjNull]]];

if (_fobPos isEqualTo [0,0,0]) exitWith {["Position is [0,0,0]"] call BIS_fnc_error};

private _range = KPLIB_range_fob;

private _fob_spheres = [];
for "_i" from 1 to 36 do {
    _fob_spheres pushBack ("Sign_Sphere100cm_F" createVehicleLocal [0, 0, 0]);
};

{
    _x setObjectTexture [0, "#(rgb,8,8,3)color(0.9,0.6,0,1)"]; 
    _x setPosATL (_fobPos getPos [_range, 10 * _forEachIndex]);
} foreach _fob_spheres;

localNamespace setVariable ["KPLIB_BUILD_areaSpheres", _fob_spheres];