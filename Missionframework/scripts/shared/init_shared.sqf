kill_manager = compile preprocessFileLineNumbers "Scripts\Shared\kill_manager.sqf";

prisonner_remote_call = compile preprocessFileLineNumbers "Scripts\Server\remotecall\prisonner_remote_call.sqf";
reinforcements_remote_call = compile preprocessFileLineNumbers "Scripts\Server\remotecall\reinforcements_remote_call.sqf";
intel_remote_call = compile preprocessFileLineNumbers "Scripts\Server\remotecall\intel_remote_call.sqf";
start_secondary_remote_call = compile preprocessFileLineNumbers "Scripts\Server\remotecall\start_secondary_remote_call.sqf";

remote_call_sector = compile preprocessFileLineNumbers "Scripts\Client\remotecall\remote_call_sector.sqf";
remote_call_fob = compile preprocessFileLineNumbers "Scripts\Client\remotecall\remote_call_fob.sqf";
remote_call_endgame = compile preprocessFileLineNumbers "Scripts\Client\remotecall\remote_call_endgame.sqf";
remote_call_prisonner = compile preprocessFileLineNumbers "Scripts\Client\remotecall\remote_call_prisonner.sqf";
remote_call_intel = compile preprocessFileLineNumbers "Scripts\Client\remotecall\remote_call_intel.sqf";
remote_call_artillery = compileFinal preprocessFileLineNumbers "Scripts\Client\remotecall\remote_call_artillery.sqf";
remote_call_artillery_firing = compileFinal preprocessFileLineNumbers "Scripts\Client\remotecall\remote_call_artillery_firing.sqf";

civinfo_notifications = compile preprocessFileLineNumbers "Scripts\Client\civinformant\civinfo_notifications.sqf";
civinfo_escort = compile preprocessFileLineNumbers "Scripts\Client\civinformant\civinfo_escort.sqf";
civinfo_delivered = compile preprocessFileLineNumbers "Scripts\Server\civinformant\civinfo_delivered.sqf";

asymm_notifications = compile preprocessFileLineNumbers "Scripts\Client\asymmetric\asymm_notifications.sqf";

execVM "Scripts\Shared\diagnostics.sqf";