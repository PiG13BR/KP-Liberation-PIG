// Functions
// Get buildings count for sector
F_cr_getBuildings = compile preprocessFileLineNumbers "Scripts\Server\civrep\fnc\f_kp_cr_getBuildings.sqf";
// Change CR value
F_cr_changeCR = compile preprocessFileLineNumbers "Scripts\Server\civrep\fnc\f_kp_cr_changeCR.sqf";
// Reputation gain for liberating a sector
F_cr_liberatedSector = compile preprocessFileLineNumbers "Scripts\Server\civrep\fnc\f_kp_cr_liberatedSector.sqf";
// Play random wounded animation on unit
F_cr_woundedAnim = compile preprocessFileLineNumbers "Scripts\Server\civrep\fnc\f_kp_cr_woundedAnim.sqf";

// Scripts
// Spawn wounded civilians in a sector
civrep_wounded_civs = compile preprocessFileLineNumbers "Scripts\Server\civrep\wounded\civrep_wounded_civs.sqf";
// Count initial buildings on each city and bigtown
execVM "Scripts\Server\civrep\init_buildings.sqf";
