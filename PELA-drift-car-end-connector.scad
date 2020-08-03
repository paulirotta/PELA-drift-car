/*
PELA Drift Car Tamiya TT-02 Center Beam End Connector - 3D Printed LEGO-compatible attachment to the vertical mount pegs on a donor car body

Put pegs through the car mount points and into this piece. Add one piece in the top front and top back of the car. Place a PELA-drift-car-center-beam or similar part between these two hard mounts.

This is a library module used by other models

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

include <PELA-blocks/style.scad>
include <PELA-blocks/material.scad>
use <PELA-blocks/PELA-block.scad>
use <PELA-blocks/PELA-technic-block.scad>


/* [Render] */

// Show the inside structure [mm]
cut_line = 0; // [0:1:100]

// Printing material (set to select calibrated knob, socket and axle hole fit)
material = 1; // [0:PLA, 1:ABS, 2:PET, 3:Biofila Silk, 4:Pro1, 5:NGEN, 6:NGEN FLEX, 7:Bridge Nylon, 8:TPU95, 9:TPU85/NinjaFlex, 10:Polycarbonite]

// Is the printer nozzle >= 0.5mm? If so, some features are enlarged to make printing easier
large_nozzle = true;



/* [End Connector] */

// How far apart are the two mounting holes on the car body [mm]
mount_hole_spacing = 67.2; // [0:0.1:300]

// Height of the mount hole in the side
mount_hole_z = 4; // [0:0.1:100]

// Height of the mount hole in the side
mount_hole_diameter = 5; // [0:0.1:30]

// Connector length [blocks]
l = 10; // [1:1:40]

// Connector width [blocks]
w = 2; // [1:1:40]

// Connector width [blocks]
h = 2; // [1:1:40]

// Fill technic holes at both beam both ends [blocks]
solid_end_length = 1.5; // [0:0.5:10]

// Cut clearance space from the back center
back_cut = true;



/* [Block Features] */

// Presence of bottom connector sockets
sockets = false;

// Presence of top connector knobs
knobs = false;

// How tall are top connectors [mm]
knob_height = 2.9; // [1.8:traditional blocks, 2.9:PELA 3D print tall]

// Basic unit vertical size of each block
block_height = 8; // [8:technic, 9.6:traditional blocks]

// Place holes in the corners for mountings screws (0=>no holes, 1=>holes)
corner_bolt_holes = false;

// Size of corner holes for M3 mountings bolts
bolt_hole_radius = 1.6; // [0.0:0.1:2.0]

// Add interior fill for upper layers
solid_upper_layers = true;

// Add interior fill for the base layer
solid_first_layer = true;



/* [Technic Features] */

// Add full width through holes spaced along the length for techic connectors
side_holes = 2; // [0:disabled, 1:short air vents, 2:full width connectors, 3:short connectors]

// Add a wrapper around side holes (disable for extra ventilation but loose lock notches)
side_sheaths = true;

// Add short end holes spaced along the width for techic connectors
end_holes = 0; // [0:disabled, 1:short air vents, 2:full width connectors, 3:short connectors]

// Add a wrapper around end holes (disable for extra ventilation but loose lock notches)
end_sheaths = true;

// Add holes in the top deck to improve airflow and reduce weight
top_vents = false;

// Size of a hole in the top of each knob. 0 to disable or use for air circulation/aesthetics/drain resin from the cutout, but larger holes change flexture such that knobs may not hold as well
knob_vent_radius = 0; // [0.0:0.1:3.9]

// Height of the back cut
cut_height = 2; // [0:1:10]


///////////////////////////////
// DISPLAY
///////////////////////////////
difference() {
    drift_car_tt02_end_connector();

    translate([block_width(3.5), block_width(1.5), 0])
        cube([block_width(4), block_width(2), block_width(1)]);
}

module drift_car_tt02_end_connector() {
    difference() {
        union() {
            PELA_technic_block(material=material, large_nozzle=large_nozzle, cut_line=cut_line, l=l, w=w, h=h, knob_height=knob_height, knob_flexture_height=_knob_flexture_height, sockets=sockets, knobs=knobs, knob_vent_radius=knob_vent_radius, ridge_width=_ridge_width, skin=_skin, top_shell=_top_shell, bottom_stiffener_width=_bottom_stiffener_width, bottom_stiffener_height=_bottom_stiffener_height, corner_bolt_holes=corner_bolt_holes, bolt_hole_radius=bolt_hole_radius, solid_upper_layers=solid_upper_layers, top_vents=top_vents, side_holes=side_holes, side_sheaths=side_sheaths, end_holes=end_holes, end_sheaths=end_sheaths, solid_first_layer=solid_first_layer, block_height=block_height);

            color("white") skinned_block(material=material, large_nozzle=large_nozzle, l=l, w=1, h=h, block_height=block_height, ridge_width=_ridge_width, ridge_depth=_ridge_depth, skin=_skin);

            skinned_block(material=material, large_nozzle=large_nozzle, l=solid_end_length, w=w, h=h, block_height=block_height, ridge_width=_ridge_width, ridge_depth=_ridge_depth, skin=_skin);

            translate([block_width(l-solid_end_length), 0, 0]) {
                skinned_block(material=material, large_nozzle=large_nozzle, l=solid_end_length, w=w, h=h, block_height=block_height, ridge_width=_ridge_width, ridge_depth=_ridge_depth, skin=_skin);
            }
        }

        union() {
            color("red") mount_holes();

            if (back_cut) {            
                color("yellow") back_cut(cut_height=cut_height);
            }

            end_connector_vertical_hole_set();
            
            translate([block_width(l-2), 0, 0]) {
                end_connector_vertical_hole_set();
            }
        }
    }
}


module end_connector_vertical_hole_set() {
    
    if (!knobs) {
        axle_hole_radius = material_axle_hole_radius(material=material, large_nozzle=large_nozzle);

        for (i=[0:w-1]) {
            for (j=[0:w-1]) {
                translate([block_width(i+0.5), block_width(j+0.5), block_width(h)]) {
                    rotate([180, 0, 0])
                    axle_hole(length=block_width()/2, material=material, large_nozzle=large_nozzle, hole_type=2, radius=axle_hole_radius);
                }
            }
        }
    }    
}


module mount_holes() {
    translate([block_width(l/2) - mount_hole_spacing/2, 0, mount_hole_z]) {
        mount_hole();
    }

    translate([block_width(l/2) + mount_hole_spacing/2, 0, mount_hole_z]) {
        mount_hole();
    }
}


module mount_hole() {
    rotate([990, 0, 0]) {
        cylinder(d=mount_hole_diameter, block_width(w));
    }
}


module back_cut(cut_height) {

    assert(cut_height!=undef);

    _defeather = 0.001;
    
    translate([block_width(solid_end_length), block_width(-2), -_defeather]) {
        hull() {
            skinned_block(material=material, large_nozzle=large_nozzle, l=l-2*solid_end_length, w=3, h=cut_height, block_height=block_height, skin=0, , ridge_width=_ridge_width, ridge_depth=_ridge_depth);

            translate([block_width(), block_width(), block_height(cut_height, block_height)]) {
                skinned_block(material=material, large_nozzle=large_nozzle, l=l-2-2*solid_end_length, w=1, h=1, block_height=block_height, ridge_width=_ridge_width, ridge_depth=_ridge_depth, skin=_skin);
            }
        }
    }
}