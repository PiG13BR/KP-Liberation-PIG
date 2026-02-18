if (hasInterface && {["TS_Verification"] call cba_settings_fnc_get}) then {
    [] spawn {
        waitUntil { !isNull (findDisplay 46) };

        private _expectedTS = ["TS_ServerName"] call cba_settings_fnc_get;
        private _discordLink = ["TS_DiscordInvite"] call cba_settings_fnc_get;
        private _msgTemplate = localize "STR_TS3_MESSAGE";
        copyToClipboard _discordLink;

        while {
            isNil "KPLIB_initServerDone" || 
            isNil "KPLIB_init" || 
            {
                private _currentTS = "";
                
                if (isClass (configFile >> "CfgPatches" >> "acre_main")) then {
                    _currentTS = [] call acre_api_fnc_getVOIPServerName;
                } else {
                    if (isClass (configFile >> "CfgPatches" >> "task_force_radio") || isClass (configFile >> "CfgPatches" >> "tfar_core")) then {
                        _currentTS = [] call TFAR_fnc_getTeamSpeakServerName;
                    };
                };

                (_currentTS != _expectedTS)
            }
        } do {
            private _currentTS = "";
            if (isClass (configFile >> "CfgPatches" >> "acre_main")) then {
                _currentTS = [] call acre_api_fnc_getVOIPServerName;
            } else {
                if (isClass (configFile >> "CfgPatches" >> "task_force_radio") || isClass (configFile >> "CfgPatches" >> "tfar_core")) then {
                    _currentTS = [] call TFAR_fnc_getTeamSpeakServerName;
                };
            };

            private _displayCurrent = if (isNil "_currentTS" || {_currentTS == ""}) then {"NOT CONNECTED"} else {_currentTS};

            "KPLIB_start" cutText [
                format [_msgTemplate, _displayCurrent, _expectedTS, _discordLink],
                "BLACK FADED",
                10e10,
                false,
                true
            ];

            uiSleep 2;
        };

        "KPLIB_start" cutText ["", "PLAIN"];
    };
};