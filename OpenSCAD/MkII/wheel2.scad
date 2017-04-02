include <constants.scad>;

module wheel2() {
	difference() {
		cylinder(r=45, h=1, center=true);
		for (i = [0 : 0]) {
			translate([0, 0, 0])
			rotate([0,0,i*36])
				translate([0, 33, -1])
					cylinder(h=3, r=pill_diam / 2);
		}

		//-- Inner drill
		translate([0, 0, -pill_height / 2])
			cylinder(h=pill_height, r=rh_diam1/2+0.2,$fn=100);

		//-- Carved circle for the Futaba rounded horn
		translate([0, 0, pill_height / 2 - 2])
			cylinder(r=rh_diam2/2+0.25, h=2.1, $fn=30);
	}
}
