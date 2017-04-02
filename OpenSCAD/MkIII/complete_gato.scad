include <constants.scad>;
include <wheel1_gato.scad>;
include <wheel2.scad>;
include <wheel3.scad>;
include <wheel4_gato.scad>;
include <middle_gato.scad>;
include <tube.scad>;

module complete() {
	wheel1();
	translate([0, 0, 1])
		wheel2();
	translate([0, 0, 5.5])
		wheel3();
	translate([0, 0, 10])
		wheel4();
    translate([0, 0, 1])
        middle_gato();
}

rotate([0, 180, 90])
	complete();