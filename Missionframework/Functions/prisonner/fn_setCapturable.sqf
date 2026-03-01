/*
    File: fn_setCapturable.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 24/11/2025
    Last Update: 01/03/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Set a unit capturable/surrendered

    Parameter(s):
        _unit - cuffed unit to add deliver pow action [OBJECT]
        _force_surrender - true to force surrender [BOOL, defaults to false]

    Returns:
        -
*/

params ["_unit", ["_force_surrender", false]];

if (KPLIB_sectors_fob isEqualTo []) exitWith {};

// define who do not surrender
if ((!_force_surrender) && ((random 100) > KPLIB_surrender_chance)) exitWith {};

if ((side group _unit == KPLIB_side_enemy) && (_unit isKindOf "CAManBase") && (alive _unit)) then {

    if (!isNull objectParent _unit) then {objectParent _unit deleteVehicleCrew _unit};

    if (alive _unit) then {

        removeAllWeapons _unit;
        if (typeof _unit != KPLIB_b_heliPilotUnit) then {
            removeHeadgear _unit;
        };
        removeBackpack _unit;
        removeVest _unit;
        _unit unlinkItem hmd _unit;
        _unit setUnitPos "UP";

        private _grp = createGroup [KPLIB_side_enemy, true];
        [_unit] joinSilent _grp;

        if (KPLIB_ace) then {
            ["ace_captives_setSurrendered", [_unit, true], _unit] call CBA_fnc_targetEvent;
        } else {
            _unit disableAI "ANIM";
            _unit disableAI "MOVE";
            _unit playmove "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon";
            _unit setCaptive true;
        };

        // Add capture action (NO ACE). ACE is handled by its listen events.
        if (!KPLIB_ace) then {
            ["KPLIB_addActionCapture", _unit] call CBA_fnc_globalEventJIP;
        };

        // From now on this unit is a POW, even if it escapes from the player, there will be punishment for killing an unarmed soldier
        [{
            _this setVariable ["KPLIB_prisonner_surrendered", true, true];

            _this addEventHandler ["Killed", {
                params["_unit", "_killer"];

                if (side (group _killer) == KPLIB_side_player) then {
                    
                    [format[localize "STR_POW_KILLED", name _killer]] remoteExec ["systemChat"];

                    // Increase combat readiness
                    private _readiness_increase = 25 + (floor (random 10)) * KPLIB_param_difficulty;
                    KPLIB_enemyReadiness = KPLIB_enemyReadiness + _readiness_increase;
                    stats_readiness_earned = stats_readiness_earned + _readiness_increase;
                    if (KPLIB_enemyReadiness > 100.0 && KPLIB_param_difficulty < 2) then {KPLIB_enemyReadiness = 100.0};
                };
            }];
        
        [_this] call KPLIB_fnc_prisonnerCheckPFH;

        }, _unit, 5] call CBA_fnc_waitAndExecute;
    };
};