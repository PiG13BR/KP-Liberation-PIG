if (hasInterface && {["TS_Verification"] call cba_settings_fnc_get}) then {
    [] spawn {
        waitUntil { !isNull (findDisplay 46) };

        private _expectedTS = ["TS_ServerName"] call cba_settings_fnc_get;
        private _discordLink = ["TS_DiscordInvite"] call cba_settings_fnc_get;
        private _msgTemplate = localize "STR_TS3_MESSAGE";
        private _lastCheckFailed = false;
        copyToClipboard _discordLink;
        while {
            isNil "KPLIB_initServerDone" || 
            isNil "KPLIB_init" || 
            { ([] call acre_api_fnc_getVOIPServerName) != _expectedTS }
        } do {
            private _currentTS = [] call acre_api_fnc_getVOIPServerName;
            private _isWrongTS = (_currentTS != _expectedTS);
            private _displayCurrent = if (_currentTS == "") then {"NOT CONNECTED"} else {_currentTS};

            "KPLIB_start" cutText [
                format [_msgTemplate, _displayCurrent, _expectedTS, _discordLink],
                "BLACK FADED",
                10e10,
                false,
                true
            ];

            if (_isWrongTS && !_lastCheckFailed) then {
                _lastCheckFailed = true;
            };

            if (!_isWrongTS) then { _lastCheckFailed = false; };

            sleep 1;
        };

        "KPLIB_start" cutText ["", "PLAIN"];
    };
};