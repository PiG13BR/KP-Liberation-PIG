// Create sector mines
["KPLIB_createSectorMines", {

	if (isNil "KPLIB_sectorMinesHash") then {
		KPLIB_sectorMinesHash = createHashMap;
	};

	if (isNil "KPLIB_savedMinesPosHash") then {
		KPLIB_savedMinesPosHash = createHashMap;
	};

	// Avoid spawning mines again
	private _mines = KPLIB_sectorMinesHash getOrDefault [_this, []];
	if (_mines isNotEqualTo []) exitWith {};

	// Check for spawned mines positions in this sector
	if !(_this in KPLIB_savedMinesPosHash) then {
		// Create new minefield
		_this call KPLIB_fnc_createMines;
	} else {
		// Respawn the minefields
		_this call KPLIB_fnc_createSavedMines;
	};
}] call CBA_fnc_addEventHandler;

// Delete sector mines
["KPLIB_deleteSectorMines", {
	params["_sector", ["_forced", false, [false]]];
    private _sectorMines = KPLIB_sectorMinesHash getOrDefault [_sector, []];
	if (_sectorMines isEqualTo []) exitWith {};

	// Save active mines only
	private _sectorAPMines = (_sectorMines # 0) select {mineActive _x};
	private _APMinesSigns = (_sectorMines # 1);
	private _sectorATMines = (_sectorMines # 2) select {mineActive _x};
	KPLIB_savedMinesPosHash set [_sector, [_sectorAPMines apply {ASLToAGL (ATLtoASL getPosATL _x)}, _APMinesSigns apply {[ASLToAGL (ATLtoASL getPosATL _x), getDir _x]}, _sectorATMines apply {ASLToAGL (ATLtoASL getPosATL _x)}]]; 
	{
		[_x, _forced] call KPLIB_fnc_despawnObject;
    }forEach (_sectorAPMines + _sectorATMines + _APMinesSigns);

    KPLIB_sectorMinesHash deleteAt _sector // Clear sector key
}] call CBA_fnc_addEventHandler;