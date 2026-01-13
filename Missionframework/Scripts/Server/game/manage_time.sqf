scriptName "manage_time";

while {true} do {
    if (KPLIB_param_shorterNights && (sunOrMoon == 0)) then {
        setTimeMultiplier (KPLIB_param_timeMulti * 60);
    } else {
        setTimeMultiplier KPLIB_param_timeMulti;
    };
    sleep 10;
};
