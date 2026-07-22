# KP LIBERATION PIG
- Check this [updated branch](https://github.com/PiG13BR/KP-Liberation-PIG/tree/v0.97.1-AIRPORT-SECTOR). It has a lot of additions and fixes.
  
## DESCRIPTION
Welcome to PiG's Liberation. This fork of APR is aimed to add several features but maintaining the original feeling of Liberation. This is **not** an overhaul of the gamemode.

The majority of the gameplay is the same, but there are more to it. Check the [CHANGELOG](https://github.com/PiG13BR/KP-Liberation-PIG/blob/v0.97.0-PIG-UNSTABLE/CHANGELOG.md) for further details.

There are new system in `Extensions` folder, some of them you can find details in README.md files.

Please, read the addition notes below for further explanation on important system of this fork.

Feel free to report issues and make pull requests, I eventually will take a look at them.

## HOW TO INSTALL
1. [Download](https://github.com/PiG13BR/KP-Liberation-PIG/releases/download/v0.97.0-UNSTABLE/v0.97.0-PIG-UNSTABLE.zip) the whole content. 
2. Take a map folder from `Missionbasefiles` and place in your missions folder (in your arma profile documents).
    - You could also port the liberation for others maps, read devkit guide below.
3. Copy everything from `Missionframework` and paste inside the folder.
4. Test it out before editing anything! Launch it with only CBA and ACE.

## DEVKIT
The devkit had some small additions, but still uses the same logic that you can follow in [official tutorial page](https://github.com/KillahPotatoes/KP-Liberation/wiki/EN_Devkit).

Below are listed the additions so far, all optional:
- New sector: Outpost (marker name: `outpost`). This is an invisible sector aimed to be a filler. It spawns some patrol units and garrisons. Doesn't spawn vehicles.
- Factory sector: You can choose what the factory can produce at start by adding `supply`, `ammo` or `fuel` in the marker name (i.e: `factory_supply_1`).
- Enemy road spawn points (marker name: `spawn_opfor_road_point`). Enemy vehicles will use them. This marker will also be used for the convoy secondary objective.

## DISCLAIMERS
- [LICENSE](https://github.com/KillahPotatoes/KP-Liberation/blob/master/LICENSE.md).
- This mission is only a continued project based on the original, but most likely abandoned, mission from [GreuhZbug](https://github.com/GreuhZbug).

## ADDITIONAL NOTES
- It should be compatible with saves from 0.96.8, but it's not guaranteed.
- The AI logistics in the current version is **turned off** because of the resources management changes for storages. There are a bunch of codes related to that in the logistic script and I don't want to touch it right now.
- It takes about 60 seconds from the server start to add actions to the objects.
- The loading screen only happens on mission start! It's just a placebo black screen to have players waiting for the server to add the actions mentioned above.
- There are a KP Liberation label on CBA settings.

- **Arsenal and Supply Dump:**
    - The arsenal was divided into two options: shared and whitelist by role/classnames. The first one is the default option (the same arsenal items for everyone), and the second one the arsenal items are shared by roles. Access `Presets\Arsenal\roles_presets\...` to configure the whitelist option. Don't forget to change mission parameters to enable it.
    - To have **access to the arsenal in a FOB**, the players need to build the Supply Dump, available in the support label.
    - The supply dump is a system that you can fill crates (that can be bought it in the build menu) with items from the supply dump preset `Extensions\Supply_Menu\presets`.
    - The items can be also transfered crate to crate.
    - If using ACE, all actions are avaiable in the interaction menu.
- **Discord Extension:**
    - You can send information about factory and FOB resources to a discord channel. Information [here](https://github.com/PiG13BR/KP-Liberation-PIG/tree/v0.97.0-PIG-UNSTABLE/Missionframework/Extensions/Discord_Log).
- **Presets:**
    - Presets are now mission parameters.
    - Player and enemy presets now have a `default.sqf` file, that it reads before the actual selected preset. It was created to make new additions for the presets without requiring to edit every file.
    - Not only vehicles are unlockable per sector, but also arsenal items. Check the files in `Extensions\Lock_Arsenal`.
    - You can choose what sector unlocks each elite vehicle in the presets (read the commentary before `KPLIB_b_vehToUnlock` in the `default.sqf` file).
- **Redeploy:**
    - You can redeploy near your squadmates by using the new rally point system (`Extensions\Rally_Point`).
    - There is a mission parameters that enables FOB redeploy cost, subtracting resources. For a particular FOB, you can build two barracks (in the build support label) to stop from taking resources for each redeploy. Also, the barracks are required to be able to buy AI units.
- **Sector events:**
    - Now it's possible to create unique sectors events (`Extensions\Sector_Events`).
- **Zeus Module:**
    - The zeus has no more restrictions, and as default it has to be accessed via admin logged. There is a whitelist for players for it in the `KPLIB_whitelist.sqf` file (KPLIB_whitelist_zeus), that creates a game master module for each logged player.
    - It's highly recommended that you use the whitelist, because as tested, using it fixed some issues related to not having access to zeus in respawns.
- **Resources Management:**
    - In previous versions of the KP LIBERATION, the players would store the crates in plataforms, and those crates would be visible for them. Now the resources in storages (fob and factories) are just numbers in a variable, the crates are deleted when stored and its resource value saved virtually. The crate with its value is created again when you want to unload the choosen resource.
    - This was changed because creates are objects and can take performance. The crates are just a way to transport the resources from a storage to another.
    - You can set the resources value for a particular container by just messing with its variable, where the array corresponds to `[supply, ammo, fuel]`:
        - `storageOject setVariable ["KPLIB_storageResources", [0,0,0], true];`
- **SAM and Artillery Sites:**
    - The enemy will eventually spawn SAM and artillery positions.
    - The player can destroy those positions. The main building of the SAM site is the RADAR, generally in the middle of the site. As for the artillery, the players need to destroy all artillery pieces.
    - In both cases, the enemy is punished with more delay to spawn the next site.
    - The main goal of the artillery site is to target FOBS with players on it. There are some cases that it can fire on player attacking a sector. I personally recommend using [LAMBS_Danger.fsm (DEV)](https://steamcommunity.com/sharedfiles/filedetails/?id=2434257231) for a better experience.
    - For SAM Sites, there is a mission parameters that enables to customize the radar target range and it's altitude detection. The numbers related to this can be changed via CBA settings, you can find them in the KP Liberation label.
- **Teamspeak Verification:**
    - In CBA Settings, under KP Liberation label, there is an option for blocking players from playing the mission without a teamspeak verification (for using radio). It works for both ACRE2 and TFAR mods. This was fully tested in a 24/7 server and worked nicely.

## ISSUES
If you having gameplay issues with this version of liberation, please, report them.

- Zeus whitelist (reported: 10/04/2026): some players can't do some ZEN actions and it's related to the whitelist module creation. If you're having this issue, don't use the whitelist for now. The gamemaster module placed on editor for the #loggedAdmin is working fine.

## CREDITS
- [GREUH](https://github.com/GreuhZbug) and [KillahPotatoes](https://github.com/KillahPotatoes/);
- [Apricot](https://github.com/Apricot-ale/) for making a stable fork to work with;
- [FernandimModelador](https://github.com/FernandimModelador) for helping me debug scripts and solve issues.

## REQUIRED ADD-ONS
- [CBA_A3](https://steamcommunity.com/sharedfiles/filedetails/?id=450814997)

## RECOMMENDED ADD-ONS
- [ACE](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057)
- [Zeus Enhanced](https://steamcommunity.com/workshop/filedetails/?id=1779063631)
- [LAMBS_Danger.fsm (DEV)](https://steamcommunity.com/sharedfiles/filedetails/?id=2434257231)
- [Sling Load Rigging](https://steamcommunity.com/sharedfiles/filedetails/?id=2128676112)
- [cTab 1erGTD](https://steamcommunity.com/sharedfiles/filedetails/?id=2262006564)
- [Better CAS Environment (BCE)](https://steamcommunity.com/sharedfiles/filedetails/?id=2853828143)
- [IADS Coordinater (Beta)](https://steamcommunity.com/sharedfiles/filedetails/?id=3670705586)
