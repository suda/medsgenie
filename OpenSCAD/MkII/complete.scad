include <constants.scad>;
include <wheel1.scad>;
include <wheel2.scad>;
include <wheel3.scad>;
include <wheel4.scad>;
include <tube.scad>;

spacing = 5 + (20 * $t);

module complete() {
    color([211/255, 84/255, 0])
        wheel1();
	translate([0, 0, spacing])
        color([142/255, 68/255, 173/255])
            wheel2();
	translate([0, 0, spacing*2])
        color([41/255, 128/255, 185/255])
            wheel3();
	translate([0, 0, spacing*3])
        color([39/255, 174/255, 96/255])
            wheel4();
}

rotate([0, 180, 90])
	complete();