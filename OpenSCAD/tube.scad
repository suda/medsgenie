include <constants.scad>;

module tube(pills=1) {
	difference() {
		cylinder(h=(pill_height * pills), r=(pill_diam + 2) / 2);
		translate([0, 0, -1])
			cylinder(h=(pill_height * pills) + 2, r=pill_diam / 2);
	}
}

translate([-30, 0, -wheel_height])
	tube(5);