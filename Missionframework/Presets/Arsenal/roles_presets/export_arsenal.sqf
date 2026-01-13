/*
	
	Use this script to export all itens from playable units.
	Once executed, the export result will be printed in your rpt files (https://community.bistudio.com/wiki/Crash_Files)

	IF EXECUTED ON EDITOR, IT REQUIRES ADVANCED DEVELOPER TOOLS TO WORK!
*/

private _allRoles = [];
private _allWeapons = [];
private _allWeaponsAcc = [];
private _allBinos = [];
private _allMagazines = [];
private _allThrowables = [];
private _allBackpacks = [];
private _allItems = [];
private _allUniforms = [];
private _allVests = [];
private _allHeadGear = [];
private _allNvgs = [];

{
	private _role = _x;
	_allRoles pushBackUnique (typeOf _role);

	{
		if (_x isEqualTo "") then {continue};
        if (_x isKindOf ["Binocular", configFile >> "cfgWeapons"]) then {continue}; // Ignore binoculars only
		_allWeapons pushBackUnique _x
	}forEach (weapons _role);

	{
		if (_x isEqualTo "") then {continue};
		_allWeaponsAcc pushBackUnique _x;
	}forEach (primaryWeaponItems _role) + (handgunItems _role) + (secondaryWeaponItems _role);

	{
		if (_x isEqualTo "") then {continue};
        if (_x isKindOf ["Binocular", configFile >> "cfgWeapons"]) then {
            _allBinos pushBackUnique _x
        }
	}forEach (weapons _role);

	{
		if (_x isEqualTo "") then {continue};

		private _ammo = getText(configFile >> "cfgMagazines" >> _x >> "ammo");
		if (_x isKindOf ["HandGrenade", configFile >> "cfgMagazines"] || {_ammo isEqualTo "GrenadeHand"} || {_ammo isKindOf "IRStrobeBase"}) then {
			_allThrowables pushBackunique _x;
			continue
		};
		if (_ammo isKindOf "BulletCore" || {_ammo isKindOf "MissileCore"} || {_ammo isKindOf "RocketCore"} || {_ammo isKindOf "GrenadeCore"} || {_ammo isKindOf "SmokeShell"} || {(toLowerANSI _x) isEqualTo "laserbatteries"}) then {
			if (_x in _allThrowables) then {continue}; // Config conflicts in some cases. Don't add item to the magazine list
			_allMagazines pushBackUnique _x;
			continue
		};

	}forEach (magazines _role), (primaryWeaponMagazine _role), (handgunMagazine _role), (secondaryWeaponMagazine _role);

	{
		if (_x isEqualTo "") then {continue};
		_allBackpacks pushBackUnique _x;
	}forEach (backpacks _role) + [backpack _role]; 

	{
		if (_x isEqualTo "") then {continue};
		if ((hmd _role) isEqualTo _x) then {continue}; // Ignore nvgs
		if (_x in _allMagazines || {_x in _allThrowables} || {_x in _allBinos} || {_x in _allWeaponsAcc}) then {continue};
		_allItems pushBackUnique _x;
	}forEach (assignedItems _role) + (backpackitems _role) + (uniformItems _role) + (vestItems _role);

	{
		if (_x isEqualTo "") then {continue};
		_allUniforms pushBackUnique _x;
	}forEach [(uniform _role)];

	{
		if (_x isEqualTo "") then {continue};
		_allVests pushBackUnique _x;
	}forEach [(vest _role)];

	{
		if (_x isEqualTo "") then {continue};
		_allHeadGear pushBackUnique _x;
	}forEach [(headgear _role)] + [(goggles _role)];

    {
		if (_x isEqualTo "") then {continue};
		_allNvgs pushBackUnique _x;
	}forEach [(hmd _role)];

}forEach playableUnits;

// Log
diag_log "////////// ARSENAL EXPORTER START \\\\\\\\\\";
diag_log "--- ROLES ----";
{
	diag_log format ["%1", _x]
}forEach _allRoles;

diag_log "--- WEAPON (Primary, Pistols, Secondary) ----";
{
	diag_log format ["%1", _x]
}forEach _allWeapons;

diag_log "--- WEAPONS ACCESSORIES ----";
{
	diag_log format ["%1", _x]
}forEach _allWeaponsAcc;

diag_log "--- BINOCULARS ----";
{
	diag_log format ["%1", _x]
}forEach _allBinos;

diag_log "--- MAGAZINES ----";
{
	diag_log format ["%1", _x]
}forEach _allMagazines;

diag_log "--- THROWABLES ----";
{
	diag_log format ["%1", _x]
}forEach _allThrowables;

diag_log "--- BACKPACKS ----";
{
	diag_log format ["%1", _x]
}forEach _allBackpacks;

diag_log "--- ITEMS ----";
{
	diag_log format ["%1", _x]
}forEach _allItems;

diag_log "--- UNIFORMS ----";
{
	diag_log format ["%1", _x]
}forEach _allUniforms;

diag_log "--- VESTS ----";
{
	diag_log format ["%1", _x]
}forEach _allVests; 

diag_log "--- HEADGEAR (glasses, hats, helmets) ----";
{
	diag_log format ["%1", _x]
}forEach _allHeadGear;

diag_log "--- NVGS ----";
{
	diag_log format ["%1", _x]
}forEach _allNvgs;
diag_log "////////// ARSENAL EXPORTER END \\\\\\\\\\";