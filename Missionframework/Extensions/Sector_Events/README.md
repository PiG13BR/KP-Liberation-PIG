# SECTOR EVENTS

## DESCRIPTION
- Create unique sector events when captured by players.
- As default, sector events are disabled on mission parameters.
- Once the players capture a sector, a CBA event is raised (`KPLIB_sectorLiberated`) that calls the `file` related to the events. You can check the example available in the `events` folder.
    - Runs on unscheduled environment.
    - Runs on server side.
    - Passed argument to the event handler is: 
        - 0: Sector marker [STRING]
- As default, the event for a sector won't fire again if players loses it and recaptured afterwards. Read below for configuration details.

## HOW TO ADD A SECTOR EVENT
- Following the `example.sqf` on `events` folder, you can create a file for your own scenario, or use the `custom.sqf` (recommended).
- The events are collected on the `init_events.sqf` file.
    - If you want to create a new events file, you need to edit the `init_events.sqf` file and files related to mission parameters as well.
    - To be able to repeat events for a sector, add this code: `KPLIB_sectorLiberated deleteAt (KPLIB_sectorLiberated find _sector)`.
    - There are some defaults functions in the `functions` folder. You can create your own functions to be called in the sector events. The path for cfgFunctions for this extension is already defined.