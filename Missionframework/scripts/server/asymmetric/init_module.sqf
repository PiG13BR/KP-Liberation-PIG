// Globals
// List sectors which are just liberated. Preventing direct ambush spawn.
asymm_blocked_sectors = [];
publicVariable "asymm_blocked_sectors";

// Start module loop
execVM "Scripts\Server\asymmetric\asymmetric_loop.sqf";
