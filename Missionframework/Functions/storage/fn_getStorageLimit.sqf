/*
    File: fn_getStorageLimit.sqf
    Author: PiG13BR - https://github.com/KillahPotatoes
    Date: 28/01/2026
    Last Update: 28/01/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Get the storage's total resource limit to be stored.

    Parameter(s):
        _storage - storage to check its storage limit [OBJECT, defaults to objNull]

    Returns:
        The storage limit [NUMBER]
*/
params["_storage"];

private _limit = -1;
switch (typeOf _storage) do {
    case KPLIB_b_smallStorage : {
        _limit = 1500
    };
    case KPLIB_b_largeStorage : {
        _limit = 5000
    };
    case KPLIB_b_transStorage : {
        _limit = 500
    };
    default {};
};

_limit