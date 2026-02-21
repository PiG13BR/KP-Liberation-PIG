/*
    File: fn_deploy_PFH.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 04/11/2025
    Last Update: 21/11/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handles the deploy PFH

    Parameter(s):
        _objectPos - object respawn position [POSITIOn]
        _buttonControl - deploy button [CONTROL]

    Returns:
        -
*/

params["_objectPos", "_buttonControl"];

KPLIB_REDEPLOY_pfhandle = [
	{
		params["_args"];
		_args params ["_objectPos", "_buttonControl"];
        [] call KPLIB_fnc_TeamSpeakCheck;
        // Meanwhile, updates deploy list box
        [] call KPLIB_fnc_deploy_getPositions;

        // Disable if sector is under attack
        if (!KPLIB_param_attackedFobRespawn && {_objectPos in KPLIB_sectorsUnderAttack}) exitWith {
            _buttonControl ctrlSetText (localize "STR_DEPLOY_DISABLED");
            _buttonControl ctrlEnable false;
            _buttonControl ctrlSetTooltip (localize "STR_DEPLOY_UNDERATTACK");
        };
        
        // Disable if there are enemies nearby
        if ([_objectPos] call KPLIB_fnc_deploy_isEnemyNear) exitWith {
            _buttonControl ctrlSetText (localize "STR_DEPLOY_DISABLED");
            _buttonControl ctrlEnable false;
            _buttonControl ctrlSetTooltip (localize "STR_DEPLOY_ENEMIESNEARBY");
        };

        if (KPLIB_param_respawnCost > 0) then {
            ([_objectPos] call KPLIB_fnc_deploy_playerCanRedeploy) params ["_canRespawn", "_fobName"];

            private _barracks = ([_objectPos] call KPLIB_fnc_deploy_barracksNearby);
            // Respawn cost (FOB)
            if (!_canRespawn && !_barracks) then {
                _buttonControl ctrlSetText (localize "STR_DEPLOY_DISABLED");
                _buttonControl ctrlEnable false;
                _buttonControl ctrlSetTooltip format [localize "STR_DEPLOY_NORESOURCES", _fobName];
            } else {
                if (_fobName isNotEqualTo "") then {
                    // Check for barracks
                    if (_barracks) then {
                        _buttonControl ctrlSetText (localize "STR_DEPLOY_BUTTON");
                        _buttonControl ctrlEnable true;
                        _buttonControl ctrlSetTooltip (localize "STR_DEPLOY_NOCOST_WARNING");
                    } else {
                        // Fob nearby and no barracks, warn costs
                        _buttonControl ctrlSetText (localize "STR_DEPLOY_BUTTON");
                        _buttonControl ctrlEnable true;
                        _buttonControl ctrlSetTooltip  format [localize "STR_DEPLOY_COST_WARNING", KPLIB_param_respawnCost, _fobName];
                    };
                } else {
                    // No fob nearby
                    _buttonControl ctrlSetText (localize "STR_DEPLOY_BUTTON");
                    _buttonControl ctrlEnable true;
                    _buttonControl ctrlSetTooltip (localize "STR_DEPLOY_NOCOST_WARNING");
                };
            }
        } else {
            // No respawn cost
            _buttonControl ctrlSetText (localize "STR_DEPLOY_BUTTON");
            _buttonControl ctrlEnable true;
            _buttonControl ctrlSetTooltip "";
        };
	}, 0.5, 
	[_objectPos, _buttonControl]
] call CBA_fnc_addPerFrameHandler;
