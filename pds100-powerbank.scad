// Dimensions of the PDS100 pcb.
pcb_width = 43.3;       // Actually 42.8, but give a bit more space.
pcb_length = 51.4;
pcb_thickness = 1.8;    // Actually 1.60, but give a bit more space.
pcb_bottom_space = 5;   // The space below the pcb to keep clear.
pcb_top_space = 10.2;   // The space above the pcb to keep clear.

// Parameters for the PDS100 cage.
pcb_wire_space = 6;     // Some space for the wires on the far-end of the pcb cage.
wall_thickness = 2.4;   // Wall thickness of the pcb cage. 
usb_wall_thickness = 1.2;  // Wall thickness for the usb ports wall.
round_radius = 6;       // Round radius for the pcb case. Decrease for a more square design.
plate_sink = 1.8;       // The cage is sunken into the battery plate. This distance is currently used for the locking mechanism of the pack cover plate.
d_vents = 2.5;          // Diameter of the vent holes.

back_plate_thickness = 2.4;  // Thickness of the back cover plate.


// Screw holes in batteryPlate and batteryAdapterParkside and batteryAdapterAldi.
screw_holes = [[6.5,-29],[6.5,29],[52.5,-29],[52.5,29]];


$fn=24;  // Give a nice rounding to most parts. Is overriden by some modules.


pds100Cage();
*backPlate();

*ParksideAdapter();


module pds100Cage() {
    height = usb_wall_thickness + pcb_length + pcb_wire_space;
    width = pcb_width + 2*wall_thickness;
    depth = pcb_bottom_space + pcb_thickness + pcb_top_space + wall_thickness;
    
    inner_depth = depth-wall_thickness;
    inner_height = pcb_length + pcb_wire_space;
    
    module air_hole_front() {
        translate([depth,0,0]) rotate([0,-90,0]) cylinder(h=wall_thickness, d=d_vents, $fn=6);
    };
    module air_hole_side() {
        translate([0,width/2,0]) rotate([90,0,0]) rotate([0,0,30]) cylinder(h=width, d=d_vents, $fn=6);
    };
    
    difference() {
        union() {
            // Battery plate
            translate([plate_sink,0,0]) rotate([0,-90,0])
            batteryPlate();
            
            // PDS100 casing
            translate([0,-width/2,0]) cube([depth, width, height]);
        };
        
        // Add roundings
        $fn=64;
        translate([depth,width/2,0]) rotate([0,0,180]) rounder(height, radius=round_radius);
        translate([depth,-width/2,0]) rotate([0,0,90]) rounder(height, radius=round_radius);
        
        // PDS100 hole and rails
        difference() {
            // PDS100 hole
            translate([0,-pcb_width/2,usb_wall_thickness])
            rounded_cube([inner_depth,pcb_width,inner_height],
                         radius=round_radius-wall_thickness, $fn=48);
            
            // Ramp for easier printing
            translate([0,pcb_width/2,height]) rotate([90,0,0]) linear_extrude(pcb_width)
            polygon([[0,0],[plate_sink,0],[0,-plate_sink]]);
            
            // PCB slider rails
            translate([pcb_bottom_space-0.1,-pcb_width/2,usb_wall_thickness]) {
                linear_extrude(inner_height) polygon([[-1.5,0],[-1,1],[0,1],[0,0]]);
                translate([pcb_thickness+0.2,0,0])
                linear_extrude(inner_height) polygon([[1.5,0],[1,1],[0,1],[0,0]]);
            };
            translate([pcb_bottom_space-0.1,pcb_width/2,usb_wall_thickness]) {
                linear_extrude(inner_height) polygon([[-1.5,0],[-1,-1],[0,-1],[0,0]]);
                translate([pcb_thickness+0.2,0,0])
                linear_extrude(inner_height) polygon([[1.5,0],[1,-1],[0,-1],[0,0]]);
            };
            
            // M2 holes mounts
            translate([inner_depth-1.5,pcb_width/2-1.5,height-7]) cylinder(d=5, h=7);
            translate([inner_depth-1.5,-pcb_width/2+1.5,height-7]) cylinder(d=5, h=7);
        };
        
        // PCB rail end
        translate([pcb_bottom_space,-pcb_width/2,usb_wall_thickness-0.4])
        cube([pcb_thickness,pcb_width,0.4]);
        
        x_pcb = pcb_bottom_space + pcb_thickness/2;
        
        // Display hole
        translate([x_pcb+1.0,0.1,0])
        cube([7.95,15.25,usb_wall_thickness]);
        
        // USB port
        translate([x_pcb+1.25,-16.65,0])
        cube([6,13.5,usb_wall_thickness]);
        
        // USB-C port
        translate([x_pcb-2.3,-9.9,usb_wall_thickness/2])
        hull() {
            translate([0,-3,0]) cylinder(d=3.6, h=usb_wall_thickness, center=true);
            translate([0,+3,0]) cylinder(d=3.6, h=usb_wall_thickness, center=true);
        }
        
        // Wire hole
        translate([0,0,10]) scale([1,1.5,1]) rotate([0,90,0])
        cylinder(h=10, d=13, center=true, $fn=64);
        
        // M2 holes for back cover
        translate([inner_depth-2,pcb_width/2-2,height-10]) cylinder(d=1.5, h=10);
        translate([inner_depth-2,-pcb_width/2+2,height-10]) cylinder(d=1.5, h=10);
        
        // Back cover "locks"
        translate([0,-5+12,height-plate_sink])
        cube([plate_sink+0.1,10,plate_sink+back_plate_thickness+0.2]);
        translate([0,-5-12,height-plate_sink])
        cube([plate_sink+0.1,10,plate_sink+back_plate_thickness+0.2]);
        
        // Vents
        for (c = [-3:3]) {
            for (r = [0:4]) {
                translate([0,c*5,10+r*9]) air_hole_front();
            };
        }
        for (c = [-3:2]) {
            for (r = [0:4]) {
                translate([0,2.5+c*5,14.5+r*9]) air_hole_front();
            };
        }
        for (c = [0:1]) {
            for (r = [0:4]) {
                translate([10+c*4,0,10+r*9]) air_hole_side();
            };
        }
        for (r = [0:4]) {
            translate([12,0,14.5+r*9]) air_hole_side();
        };
    };
};

module backPlate() {
    depth = -plate_sink + pcb_bottom_space + pcb_thickness + pcb_top_space + wall_thickness;
    width = pcb_width + 2*wall_thickness;
    height = back_plate_thickness;
    
    module pcb_pusher() {
        x_pcb = pcb_bottom_space - plate_sink + pcb_thickness/2;
        translate([0,2,height]) rotate([90,0,0]) linear_extrude(4)
        polygon([[0,0], [x_pcb-2, pcb_wire_space+0.2], [x_pcb+2, pcb_wire_space+0.2], [x_pcb*2, 0]]);
    };
    
    union() {
        difference() {
            translate([0,-width/2,0]) cube([depth,width,height]);
            
            $fn=64;
            translate([depth, width/2, 0]) rotate([0,0,180]) rounder(height, radius=round_radius);
            translate([depth, -width/2, 0]) rotate([0,0,90]) rounder(height, radius=round_radius);
            
            // M2 holes
            translate([depth-wall_thickness-2,pcb_width/2-2,0]) {
                cylinder(d=1.8, h=height);
                cylinder(d=3.7, h=1.8);
            };
            translate([depth-wall_thickness-2,-pcb_width/2+2,0]) {
                cylinder(d=1.8, h=height);
                cylinder(d=3.7, h=1.8);
            };
        };
        
        // Locks
        translate([-plate_sink,-4.5-12,0]) cube([plate_sink,9,height]);
        translate([-plate_sink,-4.5+12,0]) cube([plate_sink,9,height]);
        
        // PCB push thingy
        translate([0,-16,0]) pcb_pusher();
        translate([0,16,0]) pcb_pusher();
        
        // Outer shell support
        translate([depth-2.4-wall_thickness-0.1,-15,height]) rounded_cube([2.4,30,1]);
    };
};

// This battery plate was originally modelled for Parkside (Lidl) batteries but also fits
// on Active Energy (Aldi) batteries perfectly by accident. If you want to port this power
// bank to other batteries, this is the module that you need to update. The screw_holes
// should probably also be updated.
module batteryPlate(thickness=4) {
    length = 68.5;  // Length up until the locking thingy
    width = 66.6;
    
    difference() {
        union() {
            // Base of the plate
            translate([0,-width/2,0]) rounded_cube([length,width,thickness], radius=3);
            
            // Locking thingy
            translate([length,0,0]) linear_extrude(thickness)
            polygon([[0,-22],[10.5,-16.5],[11.5,0],[10.5,16.5],[0,22]]);
        };
        
        // Locking thingy hole
        translate([length,-12,0]) cube([7,24,thickness]);
        
        // Screw holes for m3 holes
        for (pos = screw_holes) {
            x = pos[0]; y = pos[1];
            translate([x,y,0]) cylinder(h=thickness, d=3.1);
        };
        
        // Some nice rounded corners
        $fn=48;
        translate([0,width/2,0]) rotate([0,0,-90]) rounder(thickness, radius=5);
        translate([0,-width/2,0]) rounder(thickness, radius=5);
    };
};

// The pins are exacty at x=0
module ParksideAdapter() {
    length = pins_left_offset + pins_right_offset;
    width = slider_top_width + 2 * ps_wall_thickness;
    height = slider_height;
    
    module m3_hole(insert=true) {
        $fn=24;
        if (insert) {
            cylinder(h=4.2, d=4.6);
        }
        cylinder(h=height, d=3.2);
    };
    
    difference() {
        // The base shape
        // TODO: add curve at right edge
        translate([length/2-pins_left_offset,0,0]) rounded_cube(length, width, height);
        
        // Slider
        battery_slider();
        translate([0,-pins_width/2,0]) rounder(height);
        translate([0,pins_width/2,0]) rotate([0,0,-90]) rounder(height);
        
        // Pins
        translate([0,12.4,0]) pin();
        translate([0,-12.4,0]) mirror([0,1,0]) pin();
        
        // Wire cavity
        translate([10,-12,floor_height]) cube([10,24,height]);
        
        // Screw holes
        for (pos = screw_holes) {
            x = pos[0]; y = pos[1];
            translate([x,y,0]) m3_hole();
        };
        
        // Some nice rounded corners
        $fn=48;
        translate([pins_right_offset,width/2,0]) rotate([0,0,180]) rounder(height, radius=5);
        translate([pins_right_offset,-width/2,0]) rotate([0,0,90]) rounder(height, radius=5);
    };
};


module rounder(height, radius=1) {
    difference() {
        translate([0,0,height/2]) cube([2*radius,2*radius,height], center=true);
        translate([radius,radius,0]) cylinder(h=height, r=radius);
    };
};

// Cube that is rounded in the xy plane.
module rounded_cube(dimensions, radius=1, center=false) {
    x=dimensions[0];y=dimensions[1];z=dimensions[2];
    
    module _rounded_cube() {
        linear_extrude(z)
        minkowski() {
            square([x-2*radius, y-2*radius], center=true);
            circle(r=radius);
        };
    }
    
    if (center) {
        translate([0,0,-z/2]) _rounded_cube();
    } else {
        translate([x/2,y/2,0]) _rounded_cube();
    }
};