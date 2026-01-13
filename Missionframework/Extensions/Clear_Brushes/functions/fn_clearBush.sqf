/*
* Author: Ampersand, johnb43
* Destroy a bush or place a grass cutter.
*
* Arguments:
* 0: Unit trying to clear brush <OBJECT>
* If unit is a player, unit must be local.
*
* Return Value:
* Object that was cut down, grass cutter or objNull if nothing was found <OBJECT>
*
* Example:
* [player] call abc_main_fnc_clearBrush
*/

params ["_unit"];

// Check if unit is a player
private _startPos = if (isPlayer _unit) then {
    AGLToASL positionCameraToWorld [0, 0, 0]
} else {
    eyePos _unit
};

// Check 2m in front of unit if there is an object
private _intersections = lineIntersectsSurfaces [_startPos, _startPos vectorAdd ((getCameraViewDirection _unit) vectorMultiply 2), _unit];

if (_intersections isEqualTo []) exitWith {objNull};

(_intersections # 0) params ["_intersectPosASL", "", "_intersectObj", "_parentObject"];

// Play gesture
["ace_common_playActionNow", [_unit, "ace_gestures_cover"], _unit] call CBA_fnc_targetEvent;

// If terrain, spawn grass cutter
if (isNull _intersectObj && {isNull _parentObject}) then {
    private _existing = _intersectPosASL nearestObject "Land_ClutterCutter_small_F";
    private _distance = 1;
    private _cutter = "Land_ClutterCutter_small_F";

    _intersectPosASL = ASLtoAGL _intersectPosASL;

    if (!isNull _existing) then {
        _distance = _existing distance _intersectPosASL;
    };

    if (_distance < 0.5) then {
        _cutter = "Land_ClutterCutter_medium_F";
    };

    // Progress bar
    [
        1, 
        [_intersectPosASL, _unit, _cutter], 
        {
            (_this # 0) params ["_intersectPosASL", "", "_cutter"];
            // Create grass cutter
            createVehicle [_cutter, _intersectPosASL, [], 0, "CAN_COLLIDE"];
            localNamespace setVariable ["KPLIB_grassSoundCut", nil];
        }, 
        {},
        "Cortando...",
        {
            (_this # 0) params ["", "_unit"]; 
            private _sound = localNamespace getVariable ["KPLIB_grassSoundCut", -1];
            if (soundParams _sound isEqualTo []) then {
                _id = playSound3D [getMissionPath "Extensions\Clear_Brushes\sounds\clippers_cut.ogg", _unit, false, getPosASL _unit, 2, 1, 20];
                localNamespace setVariable ["KPLIB_grassSoundCut", _id];
            };
            
            !isNull _unit && {alive _unit} && {[_unit] call ace_common_fnc_isAwake}
        }, 
        ["isNotDragging", "isNotCarrying", "isNotSwimming"]
    ] call ace_common_fnc_progressBar;
    
} else {
    // If not terrain, check for bushes
    if ((nearestTerrainObjects [_intersectObj, ["Bush", "Tree"], 0]) isNotEqualTo []) then {

        private _maxZ = ((boundingBoxReal _intersectObj) # 1) # 2;
        private _timeToCut = _maxZ;

        // Progress bar
        [
            _timeToCut * ClearBrush_clearTimeCoef, 
            [_intersectObj, _unit], 
            {
                (_this # 0) params ["_intersectObj", "_unit"];
                // Destroy bush
                _intersectObj setDamage [1, true, _unit];
                localNamespace setVariable ["KPLIB_bushSoundCut", nil];
            }, 
            {},
            "Derrubando...",
            {
                (_this # 0) params ["_intersectObj", "_unit"]; 
                private _sound = localNamespace getVariable ["KPLIB_bushSoundCut", -1];
                if (soundParams _sound isEqualTo []) then {
                    _id = playSound3D [getMissionPath "Extensions\Clear_Brushes\sounds\chop_wood_axe.ogg", _intersectObj, false, getPosASL _intersectObj, 2, 1, 25];
                    localNamespace setVariable ["KPLIB_bushSoundCut", _id];
                };
                
                !isNull _unit && {alive _unit} && {[_unit] call ace_common_fnc_isAwake}
            }, 
            ["isNotDragging", "isNotCarrying", "isNotSwimming"]
        ] call ace_common_fnc_progressBar;
        
        _intersectObj
    } else {
        objNull
    };
};
