/*
    File: fn_createSavedMines.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 02/06/2026
    Last Update: 16/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
       Create saved mines of a sector

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
private _APMinesPos = (KPLIB_savedMinesPosHash getOrDefault [_sector, []]) # 0;
if (count _APMinesPos > 0) then {
	// Signs class
	private _mineSignClass = "Land_Sign_MinesDanger_English_F"; // Vanilla
	if (isClass(configFile >> "CfgPatches" >> "CUP_CAMisc_ACR_Sign_Mines")) then {
		_mineSignClass = "Sign_DangerMines_ACR"; // CUP
	};

	// AP Mine
	{
		private _center = _x;
		_center set [2,0]; // Reset Z pos
		private _mine = createMine [KPLIB_o_APMine, _center, [], 0];
		_APMinesObj pushBack _mine;
		
		KPLIB_side_enemy revealMine _mine;
		KPLIB_side_civilian revealMine _mine;
		if ((KPLIB_side_resistance getFriend KPLIB_side_enemy) > 0) then {KPLIB_side_resistance revealMine _mine};
	}forEach _APMinesPos;

	private _APMinesSignsPos = (KPLIB_savedMinesPosHash getOrDefault [_sector, []]) # 1;
	{
		private _pos = _x # 0;
		private _dir = _x # 1;

		private _sign = createVehicle [_mineSignClass, _pos, [], 0, "CAN_COLLIDE"];
		_sign setDir _dir;
		_sign enableSimulationGlobal false;

		_APMinesSigns pushBack _sign;
	}forEach _APMinesSignsPos;
};

// Spawn AT Mines
private _ATMinesPos = (KPLIB_savedMinesPosHash getOrDefault [_sector, []]) # 2;
if (count _ATMinesPos > 0) then {
	{
		_x set [2,0]; // Reset Z pos
		private _mine = createMine [KPLIB_o_ATMine, _x, [], 0];
		_ATMinesObj pushBack _mine;
		
		KPLIB_side_enemy revealMine _mine;
		KPLIB_side_civilian revealMine _mine;
		if ((KPLIB_side_resistance getFriend KPLIB_side_enemy) > 0) then {KPLIB_side_resistance revealMine _mine};
	}forEach _ATMinesPos;
};

KPLIB_sectorMinesHash set [_sector, [_APMinesObj, _APMinesSigns, _ATMinesObj]];
KPLIB_savedMinesPosHash set [_sector, [_APMinesObj apply {ASLToAGL (ATLtoASL getPosATL _x)}, _APMinesSigns apply {[ASLToAGL (ATLtoASL getPosATL _x), getDir _x]}, _ATMinesObj apply {ASLToAGL (ATLtoASL getPosATL _x)}]];

[_APMinesObj, _ATMinesObj]