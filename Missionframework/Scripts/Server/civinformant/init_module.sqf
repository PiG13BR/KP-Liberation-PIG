// Scripts
// Task selection and spawning
civinfo_task = compile preprocessFileLineNumbers "Scripts\Server\civinformant\tasks\civinfo_task.sqf";

// Start spawn loop
execVM "Scripts\Server\civinformant\civinfo_loop.sqf";
