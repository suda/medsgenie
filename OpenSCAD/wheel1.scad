include <constants.scad>;

module wheel1() {
	difference() {
		cylinder(r=45, h=1, center=true);
		for (i = [1 : 4]) {
			translate([0, 0, 0])
			rotate([0,0,i*36])
				translate([0, 33, -1])
					cylinder(h=3, r=(pill_diam + 1.5) / 2);
		}

		translate([0, 0, -1])
			cylinder(r=13, h=2);
	}

	difference() {
		union() {
			translate([0, 0, -4])
				cylinder(r=15, h=4);

			translate([0, 0, -7])
				cylinder(r=9, h=3);
		}

		translate([0, 0, -3])
			cylinder(r=13, h=4);

		translate([0, 0, -7])
				cylinder(r=7, h=4);
	}
}
