include <constants.scad>;

module wheel3() {
	difference() {
		cylinder(r=45, h=pill_height, center=true);
		for (i = [0 : 0]) {
			translate([0, 0, 0])
			rotate([0,0,i*36])
				translate([0, 33, -pill_height / 2])
					cylinder(h=pill_height + 2, r=pill_diam / 2);
		}

		translate([60, 0, -1])
			cube([90, 90, pill_height + 2], center=true);

		//-- Inner drill
		translate([0, 0, -pill_height / 2])
			cylinder(h=pill_height, r=rh_diam1/2+0.2,$fn=100);

		//-- Carved circle for the Futaba rounded horn
		translate([0, 0, pill_height / 2 - 2])
			cylinder(r=rh_diam2/2+0.25, h=2.1, $fn=30);
	}
}
