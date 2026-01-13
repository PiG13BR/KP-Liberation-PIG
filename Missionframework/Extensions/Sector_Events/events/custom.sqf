params["_sector"];

switch _sector do {
    case "military_1" :  {
        // Execute some script
    };
    case "military_2" :  {
        // Execute some script
    };
    case "tower_6" :  {
        // Execute some script
    };
    case "capture_10" :  {
        // Execute some script
    };
    case "bigtown_3" :  {
        // Delete this sector from the captured list. Repeat the event for this sector
        KPLIB_sectorLiberated deleteAt (KPLIB_sectorLiberated find _sector); 
        // Execute some script
    };
}