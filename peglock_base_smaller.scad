
use <peglock_modules.scad>

base_width = 25; // [22:.1:30]
base_height = 50; // [42:.1:60]

peglockInit(
    base_width = base_width,
    base_height = base_height) {
    peglockBase();
}
