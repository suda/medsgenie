//-------------------------------------------------------------
//-- Futaba Horn from Servo wheel by Juan Gonzalez (obijuan) juan@iearobotics.com
//-------------------------------------------------------------

//-- Wheel parameters
wheel_or_idiam = 50;                   //-- O-ring inner diameter
wheel_or_diam = 1;                     //-- O-ring section diameter
wheel_height = 2*wheel_or_diam+0;     //-- Wheel height: change the 0 for 
                                      //-- other value (0 equals minimun height)
//-- Parameters common to all horns
horn_drill_diam = 2;
horn_height = 8;        //-- Total height: shaft + plate
horn_plate_height = 2;  //-- plate height

//-- Futaba 3003 servo rounded horn parameters
rh_diam1 = 8.5;  //-- Rounded horn small diameter
rh_diam2 = 24; //-- Rounded horn big diameter
rounded_horn_drill_distance = 7.3;

//-- Futaba 3003 4-arm horn parameters
a4h_end_diam = 5;
a4h_center_diam = 10;
a4h_arm_length = 15;
a4h_drill_distance = 13.3;

//-- Pill parameters
pill_diam = 16;
pill_height = 8;
pill_holder = pill_diam * 1.5;

length = 70;


module motorPeg(height=12.5) {
    difference() {
        cube([7, 18, height], center=true);
        translate([0, -5, 0])
            cylinder(r=1, h=20, center=true, $fn=100);
        translate([0, 5, 0])
            cylinder(r=1, h=20, center=true, $fn=100);
    }
}

module gato() {
    scale(3)
        rotate([180, 0, -90])
            difference() {
                import("calicat.stl", convexity=3);
                translate([0, 8, 0])
                    cube([50, 50, 50]);
            }
}