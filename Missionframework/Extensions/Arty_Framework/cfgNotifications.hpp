class lib_artillery: lib_default_notification {
    title = $STR_TITLE_ENEMYARTILLERY;
    description = $STR_NOTIFICATION_ENEMYARTILLERY;
    iconPicture = "a3\ui_f\data\gui\cfg\communicationmenu\artillery_ca.paa";
    color[] = { 1, 0, 0, 1 };
    sound = "taskFailed";
};
class lib_artillery_firing: lib_default_notification {
    title = $STR_TITLE_ENEMYARTILLERY;
    description = $STR_NOTIFICATION_ENEMYARTILLERY_FIRING;
    iconPicture = "a3\ui_f\data\gui\cfg\communicationmenu\artillery_ca.paa";
    color[] = { 1, 0, 0, 1 };
    sound = "taskFailed";
};
class lib_artillery_destroyed: lib_default_notification {
    title = $STR_TITLE_ENEMYARTILLERY;
    description = $STR_NOTIFICATION_ENEMYARTILLERY_DESTROYED;
    iconPicture = "a3\ui_f\data\gui\cfg\communicationmenu\artillery_ca.paa";
    color[] = { 0, 1, 0, 1 };
    sound = "taskSucceeded";
};
