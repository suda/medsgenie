include <constants.scad>;

module middle_gato() {
	difference() {
        translate([57, 57, 53])
            difference() {
                gato();
                translate([0, -50, -83.5])
                    cube([100, 100, 60], center=true);
                translate([0, -50, -14])
                    cube([100, 100, 60], center=true);
            }
        cylinder(r=46, h=100, center=true);
	}
}

//middle_gato();