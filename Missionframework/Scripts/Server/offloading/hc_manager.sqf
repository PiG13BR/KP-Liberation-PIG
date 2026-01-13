add_civ_waypoints = compile preprocessFileLineNumbers "Scripts\Server\ai\add_civ_waypoints.sqf";
add_defense_waypoints = compile preprocessFileLineNumbers "Scripts\Server\ai\add_defense_waypoints.sqf";
building_defence_ai = compile preprocessFileLineNumbers "Scripts\Server\ai\building_defence_ai.sqf";
patrol_ai = compile preprocessFileLineNumbers "Scripts\Server\ai\patrol_ai.sqf";
prisonner_ai = compile preprocessFileLineNumbers "Scripts\Server\ai\prisonner_ai.sqf";

ied_manager = compile preprocessFileLineNumbers "Scripts\Server\sector\ied_manager.sqf";
manage_asymIED = compile preprocessFileLineNumbers "Scripts\Server\asymmetric\ied\manage_asymIED.sqf";
sector_guerilla = compile preprocessFileLineNumbers "Scripts\Server\asymmetric\random\sector_guerilla.sqf";
asym_sector_ambush = compile preprocessFileLineNumbers "Scripts\Server\asymmetric\random\asym_sector_ambush.sqf";
civinfo_task = compile preprocessFileLineNumbers "Scripts\Server\civinformant\tasks\civinfo_task.sqf";

execVM "Scripts\Client\misc\synchronise_vars.sqf";
execVM "Scripts\Client\misc\synchronise_eco.sqf";
execVM "Scripts\Server\offloading\show_fps.sqf";
