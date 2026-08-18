/*
    File: fn_createMines.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 02/06/2026
    Last Update: 16/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
       Create mines on sector for the first time in the session

    Parameter(s):
        _sector - sector to spawn mines [STRING]

    Returns:
        Spawned mines [ARRAY]
*/
params["_sector"];

private _APMinesObj = [];
private _APMinesSigns = [];
private _ATMinesObj = [];

// Spawn AP Mines
private _APMinesPos = (KPLIB_sectorMinesPositionsHash getOrDefault [_sector, []]) # 0;
if (count _APMinesPos > 0) then {
	// Signs class
	private _mineSignClass = "Land_Sign_MinesDanger_English_F"; // Vanilla
	if (isClass(configFile >> "CfgPatches" >> "CUP_CAMisc_ACR_Sign_Mines")) then {
		_mineSignClass = "Sign_DangerMines_ACR"; // CUP
	};

	// AP Mine
	{
		private _center = _x;
		for "_i" from 0 to (6 + (random 3)) do {
			private _mine = createMine [KPLIB_o_APMine, _center, [], 30];
			_APMinesObj pushBack _mine;

			//private _mk = createMarker [format["mine_%1", getPosATL _mine], getPosATL _mine];
			//_mk setMarkerType "hd_dot";
			//_mk setMarkerColor "colorRed";
			
			KPLIB_side_enemy revealMine _mine;
			KPLIB_side_civilian revealMine _mine;
			if ((KPLIB_side_resistance getFriend KPLIB_side_enemy) > 0) then {KPLIB_side_resistance revealMine _mine};
		};

		{
			private _pos = _center getPos [32, _x];
			if (isOnRoad _pos || surfaceIsWater _pos || !(_pos inArea KPLIB_centerArea)) then {continue};
			private _sign = createVehicle [_mineSignClass, _pos, [], 0, "CAN_COLLIDE"];
			_sign setDir (_pos getDir _center);
			_sign enableSimulationGlobal false;
			
			_APMinesSigns pushBack _sign;
		}forEach [0, 45, 90, 135, 180, 225, 270, 315];

	}forEach _APMinesPos;
};

// Spawn AT Mines
private _ATMinesPos = (KPLIB_sectorMinesPositionsHash getOrDefault [_sector, []]) # 1;
if (count _ATMinesPos > 0) then {
	{
		for "_i" from 0 to (2 + (random 2)) do {
			private _mine = createMine [KPLIB_o_ATMine, _x, [], 7];
			_ATMinesObj pushBack _mine;

			//private _mk = createMarker [format["mine_%1", getPosATL _mine], getPosATL _mine];
			//_mk setMarkerType "hd_dot";
			//_mk setMarkerColor "colorRed";
			
			KPLIB_side_enemy revealMine _mine;
			KPLIB_side_civilian revealMine _mine;
			if ((KPLIB_side_resistance getFriend KPLIB_side_enemy) > 0) then {KPLIB_side_resistance revealMine _mine};
		}
	}forEach _ATMinesPos;
};

KPLIB_sectorMinesHash set [_sector, [_APMinesObj, _APMinesSigns, _ATMinesObj]];
KPLIB_savedMinesPosHash set [_sector, [_APMinesObj apply {ASLToAGL (ATLtoASL getPosATL _x)}, _APMinesSigns apply {[ASLToAGL (ATLtoASL getPosATL _x), getDir _x]}, _ATMinesObj apply {ASLToAGL (ATLtoASL getPosATL _x)}]];

[_APMinesObj, _ATMinesObj]