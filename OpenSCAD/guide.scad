include <constants.scad>;

difference() {
	cube([pill_holder, pill_holder * 2, 2]);
	translate([pill_diam / 2 + 4, pill_diam - 4, -1])
		cylinder(h=4, r=(pill_diam + 2) / 2 + 0.25);
}

translate([0, pill_holder * 2, 0])
	cube([pill_holder, 2, pill_height + 2]);

translate([0, 0, pill_height + 2])
	cube([pill_holder, pill_holder * 2 + 2, 2]);