class lib_enemy_fighter_inbound: lib_default_notification {
    title = $STR_TITLE_ENEMYFIGHTER;
    description = $STR_NOTIFICATION_ENEMYFIGHTER;
    iconPicture = "a3\air_f_jets\plane_fighter_02\data\ui\fighter02_icon_ca.paa";
    color[] = { 1, 0, 0, 1 };
    sound = "taskFailed";
};
class lib_enemy_fighter_destroyed: lib_default_notification {
    title = $STR_TITLE_ENEMYFIGHTER;
    description = $STR_NOTIFICATION_ENEMYFIGHTER_DESTROYED;
    iconPicture = "a3\ui_f\data\igui\cfg\revive\overlayicons\f75_ca.paa";
    color[] = { 0, 1, 0, 1 };
    sound = "taskSucceeded";
};