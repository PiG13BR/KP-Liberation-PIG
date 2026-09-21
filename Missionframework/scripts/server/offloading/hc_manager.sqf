add_civ_waypoints = compile preprocessFileLineNumbers "Scripts\Server\ai\add_civ_waypoints.sqf";
building_defence_ai = compile preprocessFileLineNumbers "Scripts\Server\ai\building_defence_ai.sqf";
patrol_ai = compile preprocessFileLineNumbers "Scripts\Server\ai\patrol_ai.sqf";
prisonner_ai = compile preprocessFileLineNumbers "Scripts\Server\ai\prisonner_ai.sqf";

// Patrol
manage_one_civilian_patrol = compile preprocessFileLineNumbers "Scripts\Server\patrols\manage_one_civilian_patrol.sqf";
reinforcements_manager = compile preprocessFileLineNumbers "Scripts\Server\patrols\reinforcements_manager.sqf";

execVM "Scripts\Client\misc\synchronise_vars.sqf";
execVM "Scripts\Client\misc\synchronise_eco.sqf";
execVM "Scripts\Server\offloading\show_fps.sqf";