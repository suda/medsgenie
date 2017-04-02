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
//	difference() {
//        union() {
//            cylinder(r=45, h=1, center=true);
//            translate([0, 0, 4.5/2])
//                cylinder(r=16/2, h=4.5, center=true);
//            
//            translate([-35, 0, 7])
//                motorPeg();
//            
//            translate([14, 0, 7])
//                motorPeg();
//            
////            translate([8*4, -8*2, 0])
////                rotate([90, 270, 0])
////                    leg();
////            
////            translate([8*4, 8*3, 0])
////                rotate([90, 270, 0])
////                    leg();
//        }
//		for (i = [0 : 0]) {
//			translate([0, 0, 0])
//			rotate([0,0,i*36])
//				translate([0, 33, -1])
//					cylinder(h=3, r=pill_diam / 2);
//		}
//		translate([0, 0, -1])
//			cylinder(r=13.5/2, h=10);  
//	}
//    
//    translate([57, 57, 43])
//        difference() {
//            gato();
//            translate([0, -50, -83.5])
//                cube([50, 100, 80], center=true);
//            translate([0, -60, -2])
//                cube([6, 70, 10], center=true);
//            
//            translate([-5, -57, -22])
//                rotate([90, 0, 90])
//                    union() {
//                        cube([37, 21, 8], center=true);
//                        translate([-26, 0, 1])
//                            cube([15, 12, 11], center=true);
//                        translate([0, 9, -10])
//                            cube([29, 1, 20], center=true);
//                        translate([0, -9, -10])
//                            cube([29, 1, 20], center=true);
//                        translate([0, 0, -18])
//                            cube([37, 21, 23], center=true);
//                    }
//        }
    // TODO: Signature
    translate([50, 0, 5])
        rotate([90, 0, 90])
            difference() {
//                cube([30, 8, 3], center=true);
                rotate([0, 0, 180])
                linear_extrude(1.5)
                    text("Diana", font="SignPainter:style=HouseScript Semibold", size=8,  halign="center", valign="center");
            }
}

wheel4();