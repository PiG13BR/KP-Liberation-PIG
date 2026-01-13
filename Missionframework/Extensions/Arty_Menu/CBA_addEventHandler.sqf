// Fire Arty
["KPLIB_ArtyMenu_FireArty", {
    params["_arty", "_targetPos", "_ammo", "_rounds"];
    [_arty, _targetPos, _ammo, _rounds] call KPLIB_fnc_fireArty;
}] call CBA_fnc_addEventHandler;