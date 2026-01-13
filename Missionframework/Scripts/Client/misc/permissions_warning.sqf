if ( KPLIB_param_permissions ) then {

    waitUntil { !(isNil "KPLIB_permissions") };

    sleep 5;

    while { count KPLIB_permissions == 0 } do {
        [localize "STR_PERMISSION_WARNING", true, 5] call KPLIB_fnc_hint;
        sleep 5;
    };

    hintSilent "";

};
