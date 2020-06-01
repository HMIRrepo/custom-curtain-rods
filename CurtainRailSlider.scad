// Curtain Rail Slider by DrLex, 2020/05
// Released under Creative Commons - Attribution license

// Diameter of the cylinder (all dimensions in millimetres)
outer_dia = 10.6; //[5:.2:20]

// Diameter of the connecting part, must be slightly smaller than the gap in the rail
inner_dia = 4.6; //[3:.2:15]

// Thickness of the flanges
flange = 2.2; //[1:.2:5]

// Width of the gap between flanges
gap = 2.3; //[1:.1:5]

// Inner diameter of the hook ring
ring_dia = 7; //[4:.5:15]

// Thickness of the hook ring
ring_thick = 2.2; //[1.4:.2:4]

// How far the center of the ring should be from the flange edge
ring_offset = 2; //[0:.2:10]

// Wall thickness of the support, set to 0 to disable support
support_thick = 0.76; //[0:.01:2]

// Gap between support and ring
support_gap = 0.2; //[0:.01:1]

// Chop off part of the side for easier print
chop = "yes"; //[yes,no]

// Number of segments in outer cylinders
detail = 48; //[16:1:128]

/* [Hidden] */
doChop = chop == "yes" ? true : false;
outer_r = outer_dia/2;
inner_r = inner_dia/2;
detail_inner = round(detail * inner_dia / outer_dia);
ring_r = (ring_dia + ring_thick)/2;
detail_ring = round(detail * 2*ring_thick / outer_dia);
ring_z = 2*flange + gap + ring_offset;

shift_it = doChop ? outer_r*5/6 : outer_r;

difference() {
    translate([0, 0, shift_it]) rotate([90, 0, 0]) {
        cylinder(r=outer_r, h=flange, $fn=detail);
        translate([0, 0, flange - .1]) cylinder(r=inner_r, h=gap+.2, $fn=detail_inner);
        translate([0, 0, flange + gap]) cylinder(r=outer_r, h=flange, $fn=detail);

        difference() {
            translate([0, 0, ring_z]) {
                rotate([90, 0, 0])
                rotate_extrude(convexity = 5, $fn=detail)
                translate([ring_r, 0, 0])
                circle(r = ring_thick/2, $fn=detail_ring);
            }
            cylinder(r=outer_dia, h=flange+gap+.1);
        }
    }

    if(doChop) {
        translate([0, 0.1-outer_dia, -outer_dia]) cube(2*outer_dia, center=true);
    }
}

if(support_thick > 0) {
    support_h = outer_r - ring_thick/2 - support_gap - (doChop ? outer_r/6 : 0);
    difference() {
        translate([0, -ring_z, 0]) {
            difference() {
                cylinder(r=ring_r + support_thick/2, h=support_h, $fn=detail);
                translate([0, 0, -.1]) cylinder(r=ring_r - support_thick/2, h=.2 + support_h, $fn=detail);
            }
        }
        translate([0, outer_dia - (2*flange + gap + .5), 0]) cube(2*outer_dia, center=true);
    }
}
