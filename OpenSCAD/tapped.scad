include <constants.scad>;

//--------------------------------------------------------------
//-- Generic module for the horn's drills
//-- Parameters:
//--  d = drill's radial distance (from the horn's center)
//--  n = number of drills
//--  h = wheel height
//--------------------------------------------------------------
module horn_drills(d,n,h)
{
  union() {
    for ( i = [0 : n-1] ) {
        rotate([0,0,i*360/n])
        translate([0,d,0])
        cylinder(r=horn_drill_diam/2, h=h+10,center=true, $fn=6);  
      }
  }
}

//-----------------------------------------
//-- Futaba 3003 horn4 arm
//-- This module is just one arm
//-----------------------------------------
module horn4_arm(h=5)
{
  translate([0,a4h_arm_length-a4h_end_diam/2,0])
  //-- The arm consist of the perimeter of a cylinder and a cube
  hull() {
    cylinder(r=a4h_end_diam/2, h=h, center=true, $fn=20);
    translate([0,1-a4h_arm_length+a4h_end_diam/2,0])
      cube([a4h_center_diam,2,h],center=true);
  }
}

//-------------------------------------------
//-- Futaba 3003 4-arm horn
//-------------------------------------------
module horn4(h=5)
{
  union() {
    //-- Center part (is a square)
    cube([a4h_center_diam+0.2,a4h_center_diam+0.2,h],center=true);

    //-- Place the 4 arms in every side of the cube
    for ( i = [0 : 1] ) {
      rotate( [0,0,i*180])
      translate([0, a4h_center_diam/2, 0])
      horn4_arm(h);
    }
  }

}

//-------------------------------------------------------
//--  A Wheel for the futaba 3003 4-arm horns
//--------------------------------------------------------
module Servo_wheel_4_arm_horn()
{
  difference() {
      raw_wheel(or_idiam=wheel_or_idiam, or_diam=wheel_or_diam, h=wheel_height);

      //-- Inner drill
      cylinder(center=true, h=2*wheel_height + 10, r=a4h_center_diam/2,$fn=20);

      //-- substract the 4-arm servo horn
      translate([0,0,horn_height-horn_plate_height])
        horn4(h=wheel_height);

      //-- Horn drills
      horn_drills(d=a4h_drill_distance, n=4, h=wheel_height);

  }
}

difference() {
//	minkowski() {
		union() {
			// Bottom plate
			translate([-a4h_center_diam, -a4h_center_diam - a4h_arm_length, -wheel_height])
				cube([pill_holder, length, wheel_height]);

			// Hole plate
			translate([-a4h_center_diam, length - a4h_center_diam - a4h_arm_length - pill_holder + 5, -wheel_height])
				cube([pill_holder, pill_holder, pill_height]);

			// Filler plate
			translate([-a4h_center_diam + pill_holder - 4, length - a4h_center_diam - a4h_arm_length - pill_holder + 3, -wheel_height])				
				rotate([0, 0, -10])
					cube([pill_holder, pill_holder, pill_height]);				
		}
//		sphere(r=2, $fn=40);
//	}			

	// Horn hole
	horn4(h=wheel_height);
	horn_drills(d=a4h_drill_distance, n=2, h=wheel_height);
	translate([0, 0, -wheel_height * 2])
		cylinder(h=wheel_height * 2, r=3);

	// Pill hole
	translate([2, 38, -pill_height])
		cylinder(h=pill_height * 2, r=pill_diam / 2);
}
	