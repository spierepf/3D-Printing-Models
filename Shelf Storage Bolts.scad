include <BOSL2/std.scad>
include <BOSL2/threading.scad>

$fn = $preview ? 32 : 256;
$slop = 0.15;

INCH = 25.4;
TOLERANCE = 0.005;

shelf_height = 60;
post_diameter = 38;

// cyl(h=5, r=post_diameter/2-2.5, r2=post_diameter/2, anchor=BOTTOM) position(TOP)
// cyl(h=5, r=post_diameter/2, anchor=BOTTOM) position(TOP)

module head() {
    difference() {
        cyl(h=6, r=post_diameter/2, r2=post_diameter/2+10, anchor=BOTTOM) position(TOP) cyl(h=3, r=post_diameter/2+10, anchor=BOTTOM);
        for(theta = [0, 120, 240]) rotate([0,0,theta]) translate([0, post_diameter+15, -TOLERANCE]) cyl(h=9+2*TOLERANCE, r=post_diameter/2+10, anchor=BOTTOM);
    }
    hide_this() cyl(h=9, r=1, anchor=BOTTOM) children();
}

module collar(h=shelf_height, r=post_diameter/2, r2=post_diameter/2) {
    cyl(h=h, r=r, r2=r2, anchor=BOTTOM)
    children();
}

module thread(h=shelf_height/2, internal) {
    intersection() {
        collar(h=h, r=post_diameter/2+TOLERANCE, r2=post_diameter/2+TOLERANCE);
        threaded_rod(d=post_diameter-5, h=h-(internal ? 0 : 2), internal=internal, pitch=4, end_len2=shelf_height/6, bevel1=!internal, bevel2=internal?5:-5, anchor=BOTTOM);
    }
    hide_this() collar(h=h-(internal ? 0 : 2)) children();
}

module nut(h=shelf_height/2) {
    difference() {
        collar(h=h);
        down(TOLERANCE) thread(h=h+2*TOLERANCE, internal=true);
    }
    children();
}

xdistribute(1.2 * post_diameter) {
    rotate([0,0,30]) head() position(TOP) collar() position(TOP) nut();

    thread(internal=false) position(TOP) collar() position(TOP) collar() up(shelf_height-2) rotate([180,0,0]) thread(internal=false);

    rotate([0,0,-30]) head() position(TOP) collar() position(TOP) nut();
}

// difference() {
//     union() {
//         thread(internal=false);
//         rotate([0,0,180]) nut();
//     }
//     down(TOLERANCE) rotate([0,0,45]) cube(100);
// }
