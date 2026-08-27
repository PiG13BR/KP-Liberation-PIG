/*
    File: custom.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 04/12/2025
    Last Update: 26/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Desciption:
        Lock items per sector
        Put here all item's classname to be locked once the mission starts and which capturable sector will unlock them
        For a random sector, leave it as an empty string ""
    
    ARRAY inside KPLIB_b_lockedArsenal:
        0: sector name to unlock items <STRING>
        1: item's classnames to lock <ARRAY of STRINGS>

    Example:
    // Sector marker "capture_1"
    ["capture_1", 
        [   
            "weapon_to_unlock1", 
            "item_to_unlock1", 
            "uniform_to_unlock2"
        ],
    ], 
    // Random
    ["", 
        [
            "weapon_to_unlock1", 
            "item_to_unlock1", 
            "uniform_to_unlock2"
        ]
    ]
*/

KPLIB_b_lockedArsenal = [
    
];