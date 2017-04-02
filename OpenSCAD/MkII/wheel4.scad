include <constants.scad>;
include <bitbeam-beam.scad>;

module leg() {
    union() {
        cube([3.5, 8*2, 8]);
        translate([3.5, 0, 0])
            beam(5);            
        translate([3.5, 8, 0])
            beam(5);
    }
}

module wheel4() {
	difference() {
        union() {
            cylinder(r=45, h=1, center=true);
            translate([0, 0, 4.5/2])
                cylinder(r=16/2, h=4.5, center=true);
            
            translate([-35, 0, 7])
                motorPeg();
            
            translate([14, 0, 7])
                motorPeg();
            
//            translate([8*4, -8*2, 0])
//                rotate([90, 270, 0])
//                    leg();
//            
//            translate([8*4, 8*3, 0])
//                rotate([90, 270, 0])
//                    leg();
        }
		for (i = [0 : 0]) {
			translate([0, 0, 0])
			rotate([0,0,i*36])
				translate([0, 33, -1])
					cylinder(h=3, r=pill_diam / 2);
		}
		translate([0, 0, -1])
			cylinder(r=13.5/2, h=10);  
	}
}

//wheel4();