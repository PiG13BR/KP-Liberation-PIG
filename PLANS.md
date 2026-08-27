# PLANS AND IDEAS
- This is a list of future plans and ideas for the PiG's KP Liberation.

## ACTUAL PLANS
- Refactor enemy battlegroups/reinforcements/attacks (v0.97.2 main goal).
- Enable Dynamic Simulation for spawned enemy units (sectors and enemy positions only).
- Mission parameter for auto-registering of terrain objects in the sector's area to spawn static weapons.
- Use intel points to reveal artillery and SAM sites positions.
- Add enemy plane CAS support.
- Add Task framework to handle secondary objectives.
- Remove convoy secondary objective. Possible a replacer for it: kill commander on route to a military base to reduce enemy readiness. If he's not killed before reaching the military base, the enemy will send an attack to the nearest sector.
- Add guerrilla camp sites that can be destroyed or ignored by the players.
- Adapt AI spawn on airport sectors related to its area size.
- FOB Defense UI for static weapons / handle ammo / handle crew.
- Towers are GPS jammers and can cause radio interference (random towers, not all of them).

## IDEAS 
- Players have to stabilize town/cities after capturing them.
- Factories need workers. Workers can come from captured and stabilized nearby town/cities to work on the factories.
- Rearming friendly vehicles will cost ammo supplies (by using Jeroen's logistic system: https://github.com/Jeroen-Notenbomer/Limited-Arsenal).
- Bomb jammer for important sectors.

## HALLUCINATIONS
- Limit arsenal by using Jeroen's framework https://github.com/Jeroen-Notenbomer/Limited-Arsenal
- Make guerrilla fight every side as a mission parameter (maybe they will own sectors?).
- Convert some variables in `KPLIB_config.sqf` into CBA setting or mission parameter.