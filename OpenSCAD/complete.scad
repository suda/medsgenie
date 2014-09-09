include <constants.scad>;
include <wheel1.scad>;
include <wheel2.scad>;
include <wheel3.scad>;
include <wheel4.scad>;
include <tube.scad>;

module complete() {
	wheel1();
	translate([0, 0, 10])
		wheel2();
	translate([0, 0, 20])
		wheel3();
	translate([0, 0, 30])
		wheel4();
	
	pills = 5;
	for (i = [1 : 4]) {
		translate([0, 0, -(pill_height * pills) - 10])
			rotate([0,0,i*36])
				translate([0, 33, -1])
					tube(pills);
	}
}

rotate([0, 180, 90])
	complete();