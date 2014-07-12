include <constants.scad>;
use <tapped.scad>;

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

		//-- small drills for the rounded horn
		horn_drills(d=rounded_horn_drill_distance, n=4, h=pill_height);
	}
}

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

		//-- small drills for the rounded horn
		horn_drills(d=rounded_horn_drill_distance, n=4, h=pill_height);
	}
}

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

wheel1();
//wheel2();
//wheel3();
//wheel4();