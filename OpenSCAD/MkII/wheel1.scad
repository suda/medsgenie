include <constants.scad>;
include <bitbeam-beam.scad>;
include <tube.scad>;

module handle() {
    union() {
        cube([2.5, 8*2, 8]);
        translate([2.5, 0, 0])
            beam(2);            
        translate([2.5, 8, 0])
            beam(2);
    }
}

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
            
            rotate([0, 0, 270])
                translate([-35, 0, -8.5])
                    motorPeg(12+4);
            
            rotate([0, 0, 270])
                translate([14, 0, -8.5])
                    motorPeg(12+4);
		}

		translate([0, 0, -3])
			cylinder(r=13.5, h=4);

		translate([0, 0, -8])
				cylinder(r=7, h=6);
	}
    
    
	pills = 1;
	for (i = [1 : 4]) {
		translate([0, 0, -(pill_height * pills) + 1.5])
			rotate([0,0,i*36])
				translate([0, 33, -1])
					tube(pills);
	}
    
//    translate([8*2, -8*2, 0])
//        rotate([90, 90, 0])
//            handle();
//    
//    translate([8*2, 8*3, 0])
//        rotate([90, 90, 0])
//            handle();
}

//wheel1();
