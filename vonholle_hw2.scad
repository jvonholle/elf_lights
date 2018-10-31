// James R Von Holle JR
// CS 480 HW 2
// Ring for Pixie light

// Global variables
// all milimeters
// all need to be re-checked with calipers
out_diam = 180;
ring_size = 15;
ring_height = 10;
in_diam  = out_diam-(ring_size*2);
led_in_d = 7.2;
led_thick = 2.5;
led_out_d = led_in_d+led_thick;
ledX = 3;
ledY = 5;
// end global variables

module ring_cutout() {
    difference() {
        cylinder(d=out_diam-1, h=ring_height-2, $fn=100);
        cylinder(d=in_diam+1,  h=ring_height-2, $fn=100);
    }
}

// Taken from https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#Chapter_3_--_2D_Objects
module regular_polygon(order, r=1){
 	angles=[ for (i = [0:order-1]) i*(360/order) ];
 	coords=[ for (th=angles) [r*cos(th), r*sin(th)] ];
 	polygon(coords);
 }

// Taken from https://gist.githubusercontent.com/anoved/9622826/raw/f8318e624ab7811c5a44347a3ebe32c2938a49ea/star.scad 
// points = number of points (minimum 3)
// outer  = radius to outer points
// inner  = radius to inner points
module Star(points, outer, inner) {
	
	// polar to cartesian: radius/angle to x/y
	function x(r, a) = r * cos(a);
	function y(r, a) = r * sin(a);
	
	// angular width of each pie slice of the star
	increment = 360/points;
	
	union() {
		for (p = [0 : points-1]) {
			
			// outer is outer point p
			// inner is inner point following p
			// next is next outer point following p

			assign(	x_outer = x(outer, increment * p),
					y_outer = y(outer, increment * p),
					x_inner = x(inner, (increment * p) + (increment/2)),
					y_inner = y(inner, (increment * p) + (increment/2)),
					x_next  = x(outer, increment * (p+1)),
					y_next  = y(outer, increment * (p+1))) {
				polygon(points = [[x_outer, y_outer], [x_inner, y_inner], [x_next, y_next], [0, 0]], paths  = [[0, 1, 2, 3]]);
			}
		}
	}
}

module led_holder() {
    difference() {
        
    }
}

module led_ring(order, r=(in_diam+out_diam)/4, led_size){
 	angles=[ for (i = [0:order-1]) i*(360/order) ];
 	coords=[ for (th=angles) [r*cos(th), r*sin(th), ring_height] ];
    for (cd=coords) {
        translate(cd) {
            cylinder(d=led_size, h=5, $fn=100);
        }
        translate([0,0,0]);
    }
}

module hook() {
    cube(size=[5,10,8], center=true);
    translate([-2.5,10,0])
        rotate([0,90,0])
            difference() {
                cylinder(d=13,h=5);
                cylinder(d=11,h=10);                
            }
}

module feather_mounts() {
    translate( [45.72/2, 17.72/2, 0])
        difference() {
            cylinder(d=5, h=3, $fn=100);
            cylinder(d=2, h=3, $fn=100);
        }
    translate( [-45.72/2, -17.72/2, 0])
        difference() {
            cylinder(d=5, h=3, $fn=100);
            cylinder(d=2, h=3, $fn=100);
        }
    translate( [-45.72/2, 17.72/2, 0])
        difference() {
            cylinder(d=5, h=3, $fn=100);
            cylinder(d=2, h=3, $fn=100);
        }
    translate( [45.72/2, -17.72/2, 0])
        difference() {
            cylinder(d=5, h=3, $fn=100);
            cylinder(d=2, h=3, $fn=100);
        }
}

module main() {
    difference() {
        cylinder(d=out_diam, h=ring_height, $fn=100);
        
        
        translate([0,0,ring_height-1.5]){
            linear_extrude(2)
            Star(5,in_diam/1.9, in_diam/6);
        }
        
        cylinder(d=in_diam, h=ring_height, $fn=100);

        ring_cutout();
            translate([0,0,-5])
                led_ring(30,led_size=led_in_d);
    }
        difference() {
            led_ring(30,led_size=led_out_d);
            led_ring(30,led_size=led_in_d);
            translate([0,0,-5])
                led_ring(30,led_size=led_in_d);
        }
}
    
main();