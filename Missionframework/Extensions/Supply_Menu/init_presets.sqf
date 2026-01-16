
// Supply dump preset
[] call compile preprocessFileLineNumbers 'Extensions\Supply_Menu\presets\custom.sqf';

if (KPLIB_param_lockArsenal > 0) then {
    // Check for locked sector items
    // Case sensitive failsafe
    private _sectorsPlayer = KPLIB_sectors_player apply {toLowerANSI _x};

    KPLIB_supply_VirtualItems_classes = KPLIB_supply_VirtualItems apply {_x#0};

    {
        private _sector = _x;
        private _items = _y;

        if !(toLowerANSI(_sector) in _sectorsPlayer) then {
            {
                KPLIB_supply_VirtualItems deleteAt KPLIB_supply_VirtualItems_classes find _x;
            }forEach _items;
        };
    }forEach KPLIB_sector_arsenalLink;
};
