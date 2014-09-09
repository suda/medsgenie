include <constants.scad>;

module wheel4() {
	difference() {
		cylinder(r=45, h=1, center=true);
		for (i = [0 : 0]) {
			translate([0, 0, 0])
			rotate([0,0,i*36])
				translate([0, 33, -1])
					cylinder(h=3, r=pill_diam / 2);
		}
		translate([0, 0, -1])
			cylinder(r=7, h=3);
		translate([60, 0, -1])
			cube([90, 90, 3], center=true);
	}
}
