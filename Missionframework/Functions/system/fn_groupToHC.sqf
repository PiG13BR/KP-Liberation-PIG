/*
	File: fn_groupToHC.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 22/09/2024 
	Last Update: 22/09/2024 
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Change ownership of an AI group to the less loaded HC

	Parameter(s):
		_group - group to transfer ownership [GROUP]

	Returns:
		Transfer successful [BOOL]
*/
params["_group"];

private _transfered = false;

if (!isServer) exitWith {_transfered};

if (local _group) then {
    private _hc = [] call KPLIB_fnc_getLessLoadedHC;
    if (!isNull _hc) then {
        _transfered = _group setGroupOwner (owner _hc);
    };
};

_transfered