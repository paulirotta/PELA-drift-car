/*
PELA Slot Mount - 3D Printed LEGO-compatible PCB mount, vertical slide-in

Published at https://PELAblocks.org

By Paul Houghton
Twitter: @mobile_rat
Email: paulirotta@gmail.com
Blog: https://medium.com/@paulhoughton

Creative Commons Attribution ShareAlike NonCommercial License
    https://creativecommons.org/licenses/by-sa/4.0/legalcode

Design work kindly sponsored by
    https://www.futurice.com

All modules are setup for stateless functional-style reuse in other OpenSCAD files.
To this end, you can always pass in and override all parameters to create
a new effect. Doing this is not natural to OpenSCAD, so apologies for all
the boilerplate arguments which are passed in to each module or any errors
that may be hidden by the sensible default values. This is an evolving art.
*/

include <PELA-blocks/material.scad>
include <PELA-blocks/style.scad>
use <PELA-blocks/technic-beam/PELA-technic-beam.scad>
use <PELA-blocks/technic-mount/PELA-technic-box.scad>
use <PELA-blocks/PELA-technic-block.scad>



/* [Render] */

// Show the inside structure [mm]
_cut_line = 0; // [0:1:16]

// Printing material (set to select calibrated knob, socket and axle hole fit)
_material = 1; // [0:PLA, 1:ABS, 2:PET, 3:Biofila Silk, 4:Pro1, 5:NGEN, 6:NGEN FLEX, 7:Bridge Nylon, 8:TPU95, 9:TPU85/NinjaFlex, 10:Polycarbonite]

// Is the printer nozzle >= 0.5mm? If so, some features are enlarged to make printing easier
_large_nozzle = true;

// Render front or back half of the beam
_front_half=true;


/* [Technic Beam] */

// Beam length [blocks]
_l = 15; // [1:1:30]

// Beam width [blocks]
_w = 1; // [1:1:30]

// Beam height [blocks]
_h = 1; // [1:1:30]

// Add full width through holes spaced along the length for techic connectors
_side_holes = 2; // [0:disabled, 1:short air vents, 2:full width connectors, 3:short connectors]



/* [Technic Beam] */

// Vertical clearance space between two parts to be placed next to one another on a 8mm grid [mm]
_vertical_skin = 0.1; // [0:0.02:0.5]

// Horizontal clearance space removed from the outer horizontal surface to allow two parts to be placed next to one another on a 8mm grid [mm]
_horizontal_skin = 0.1; // [0:0.02:0.5]



///////////////////////////////
// DISPLAY
///////////////////////////////
extra=36-18;

carson_l=_l+extra;
front_l=carson_l/2-0.5;

if (_front_half) {
    difference() {
        carson_beam();
        back_space(front_l=front_l);
    }
} else {
    intersection() {
        carson_beam();
        back_space(front_l=front_l);
    }
    
    translate([block_width(-1.5), block_width(-0.5), block_width(3)])
        rotate([0, 180, -90])
            end_connector();
}



///////////////////////////////////
// MODULES
///////////////////////////////////


module end_connector() {
    import("PELA-carson-drift-car-end-connector.stl", convexity=8);
}

module back_space(front_l) {
    translate([block_width(-0.5), block_width(-0.5), -block_width(1)])
        cube([block_width(front_l), block_width(11), block_width(10)]);
}


module carson_beam() {
    difference() {
        technic_box(material=_material, large_nozzle=_large_nozzle, cut_line=_cut_line, l=carson_l, w=11, h=1, twist_l=10, twist_w=2, knob_vent_radius=0, top_vents=0, center=3, text="Jee!      Jee!", text_depth=0.5, horizontal_skin=_horizontal_skin, vertical_skin=_vertical_skin, cover_corner_tabs=false, knob_height=0);

        union() {
            translate([block_width(10.5), block_width(4.5), -_defeather])
                cube([block_width(5), block_width(1), block_width(2)]);
        }
    }
}
