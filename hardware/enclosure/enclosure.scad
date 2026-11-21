// Smart switch enclosure: unpowered FIT-CHECK prototype, all dimensions in mm.
// Confirm the hole offsets, controller dimensions and cable fittings before use.
// The divider is a routing aid, NOT a verified electrical insulation barrier.

/* [Output] */
part = "assembly"; // [base, lid, coupon, layout, assembly]
show_components = true;

/* [Relay measurements transcribed from IMG_8118] */
relay_length = 72.64;
relay_width = 49.27;
relay_height = 19.17; // Assumed total height from PCB underside; verify.
relay_hole_diameter = 3.0;
// PROVISIONAL: interpret 1.35 mm as edge-to-hole-edge, on both axes.
// Replace with measured edge-to-CENTER offsets; they may differ by axis.
relay_hole_offset_x = 1.35 + relay_hole_diameter / 2;
relay_hole_offset_y = 1.35 + relay_hole_diameter / 2;

/* [Shell] */
wall = 3;
floor_thickness = 2.4;
base_height = 46;
corner_radius = 5;
front_wiring_margin = 28;
rear_wiring_margin = 18;
controller_bay_width = 40;
divider_thickness = 2;
divider_rear_gap = 14;

/* [Fasteners and fit] */
standoff_height = 5;
standoff_diameter = 6.5;
pilot_diameter = 2.5; // Pilot to tap M3, not a clearance hole.
lid_thickness = 3;
lid_screw_clearance = 3.4;
lid_post_diameter = 8;
lid_post_inset = 6;
lid_pilot_depth = 12;
lip_height = 2;
lip_thickness = 1.4;
lip_clearance = 0.3; // Per side; adjust to printer fit.

/* [Commercial gland mounting holes] */
// LAPP 53017030/53017230: M20x1.5, 13 mm thread, round cable OD 6-12 mm.
// Smooth through-holes; use commercial locknuts, never printed threads.
// Finished holes: M20 20.0-20.2 / M12 12.0-12.2 mm. Calibrate with coupon.
load_gland_diameter = 20.1;
load_gland_count = 4;
load_gland_pitch = 38;
load_gland_first_x = 29;
load_gland_center_z = 23;
load_nut_across_flats = 27; // LAPP 53119020.
load_tool_envelope_diameter = 38; // Reserved space, verify actual tool.
load_thread_length = 13;
// LAPP 53010000: M12x1.5, 15 mm thread, round LV cable OD 3.5-7 mm.
low_voltage_gland_diameter = 12.1;
low_voltage_gland_center_z = 23;
low_voltage_nut_across_flats = 17;
usb_opening_width = 14;
usb_opening_height = 8;
usb_opening_radius = 2;
usb_center_z = 12;
usb_opening_enabled = true;

/* [ESP32-C3 Super Mini preview ONLY - no mounts generated] */
// Nominal reference: Nologo SuperMini, 22.52 x 18 mm; Amazon variant unverified.
// PCB long axis follows enclosure Y; USB faces the rear (+Y) wall.
controller_preview_length = 18; // Enclosure X dimension.
controller_preview_width = 22.52; // Enclosure Y dimension.
controller_preview_height = 12; // Reserved envelope, NOT a measured board height.
controller_pcb_bottom_z = 8.4; // Intended mount elevation, not yet implemented.
controller_rear_clearance = 1.5; // PCB end to rear wall's inside face.

/* [Hidden] */
$fn = 48;
eps = 0.02;
// Size the relay compartment from the gland/tool spacing, then center the PCB.
divider_x = max(relay_length+24,
                load_gland_first_x+(load_gland_count-1)*load_gland_pitch+26);
relay_x = (wall+divider_x-relay_length)/2;
relay_y = front_wiring_margin;
outer_x = divider_x + divider_thickness + controller_bay_width + wall;
outer_y = relay_width + front_wiring_margin + rear_wiring_margin;
relay_z = floor_thickness + standoff_height;
controller_center_x = divider_x + divider_thickness + controller_bay_width / 2;
controller_x = controller_center_x - controller_preview_length / 2;
controller_y = outer_y - wall - controller_rear_clearance - controller_preview_width;

assert(relay_z + relay_height + 3 <= base_height - lip_height,
       "Increase enclosure height for relay and lid clearance");
assert(relay_hole_offset_x > relay_hole_diameter / 2 &&
       relay_hole_offset_y > relay_hole_diameter / 2,
       "Hole centers must lie inside the PCB");
assert(pilot_diameter < relay_hole_diameter, "Pilot must be smaller than PCB hole");
assert(load_gland_count >= 1 && load_gland_count <= 4);
load_nut_sweep = load_nut_across_flats/cos(30);
low_voltage_nut_sweep = low_voltage_nut_across_flats/cos(30);
assert(load_gland_diameter >= 20 && load_gland_diameter <= 20.2,
       "Reference M20 gland needs a finished 20.0-20.2 mm hole");
assert(low_voltage_gland_diameter >= 12 && low_voltage_gland_diameter <= 12.2,
       "Reference M12 gland needs a finished 12.0-12.2 mm hole");
assert(load_gland_pitch >= load_tool_envelope_diameter &&
       load_tool_envelope_diameter > load_nut_sweep+4,
       "Increase pitch or tool clearance around locknuts");
assert(load_gland_center_z-load_tool_envelope_diameter/2 > floor_thickness &&
       load_gland_center_z+load_tool_envelope_diameter/2 < base_height-lip_height,
       "Gland/tool envelope intersects floor or lid lip");
assert(load_gland_first_x-load_tool_envelope_diameter/2 >=
       lid_post_inset+lid_post_diameter/2 &&
       load_gland_first_x+(load_gland_count-1)*load_gland_pitch+
       load_tool_envelope_diameter/2 < divider_x,
       "Gland/tool envelope intersects lid post or divider");
assert(relay_y > load_thread_length+10,
       "Leave lead-in space between gland threads and relay board");
assert(low_voltage_gland_center_z-low_voltage_nut_sweep/2 > floor_thickness &&
       low_voltage_gland_center_z+low_voltage_nut_sweep/2 < base_height-lip_height &&
       outer_y/2+low_voltage_nut_sweep/2 < controller_y,
       "Side locknut intersects floor, lid lip or controller envelope");
assert(!usb_opening_enabled ||
       (usb_opening_width > 2*usb_opening_radius &&
        usb_opening_height > 2*usb_opening_radius &&
        usb_opening_radius > 0 &&
        usb_center_z-usb_opening_height/2 > floor_thickness &&
        usb_center_z+usb_opening_height/2 < base_height-lip_height &&
        controller_center_x+usb_opening_width/2 < outer_x-lid_post_inset-lid_post_diameter/2 &&
        controller_center_x-usb_opening_width/2 > divider_x+divider_thickness),
       "USB opening must clear the floor, lip, divider and lid post");

echo("FIT-CHECK ONLY: hole offsets and controller fit unconfirmed");
echo("Outer dimensions including lid", [outer_x, outer_y, base_height + lid_thickness]);
echo("Provisional relay hole pitch", [relay_length-2*relay_hole_offset_x,
                                     relay_width-2*relay_hole_offset_y]);

module rounded_plate(x, y, z, radius) {
    linear_extrude(height=z)
        translate([radius, radius])
            offset(r=radius) square([x-2*radius, y-2*radius]);
}

module lid_positions() {
    for (x=[lid_post_inset, outer_x-lid_post_inset])
        for (y=[lid_post_inset, outer_y-lid_post_inset])
            translate([x,y,0]) children();
}

module relay_positions() {
    for (x=[relay_hole_offset_x, relay_length-relay_hole_offset_x])
        for (y=[relay_hole_offset_y, relay_width-relay_hole_offset_y])
            translate([relay_x+x,relay_y+y,0]) children();
}

module cable_cutouts() {
    // Load terminals must face the front wall (y=0). Confirm physical orientation.
    if (load_gland_diameter > 0)
        for (i=[1:load_gland_count])
            translate([load_gland_first_x + load_gland_pitch*(i-1),
                       wall+eps, load_gland_center_z])
                rotate([90,0,0]) cylinder(d=load_gland_diameter,h=wall+2*eps);
    // Low-voltage cable enters the right side, away from the USB connector.
    if (low_voltage_gland_diameter > 0)
        translate([outer_x-wall-eps, outer_y/2, low_voltage_gland_center_z])
            rotate([0,90,0]) cylinder(d=low_voltage_gland_diameter,h=wall+2*eps);
    // Rounded USB plug opening through the rear wall, aligned to board center.
    if (usb_opening_enabled)
        translate([controller_center_x-usb_opening_width/2, outer_y+eps,
                   usb_center_z-usb_opening_height/2])
            rotate([90,0,0])
                rounded_plate(usb_opening_width,usb_opening_height,
                              wall+2*eps,usb_opening_radius);
}

module base() {
    difference() {
        union() {
            difference() {
                rounded_plate(outer_x,outer_y,base_height,corner_radius);
                translate([wall,wall,floor_thickness])
                    rounded_plate(outer_x-2*wall,outer_y-2*wall,base_height,
                                  corner_radius-wall);
            }
            lid_positions() cylinder(d=lid_post_diameter,h=base_height);
            relay_positions() cylinder(d=standoff_diameter,h=relay_z);
            translate([divider_x,wall-eps,floor_thickness-eps])
                cube([divider_thickness,outer_y-wall-divider_rear_gap,
                      base_height-floor_thickness-lip_height-1]);
        }
        lid_positions() translate([0,0,base_height-lid_pilot_depth])
            cylinder(d=pilot_diameter,h=lid_pilot_depth+eps);
        relay_positions() translate([0,0,floor_thickness])
            cylinder(d=pilot_diameter,h=standoff_height+eps);
        cable_cutouts();
    }
}

// Lid is exported exterior-face-down, with its locating lip pointing upward.
module lid() {
    difference() {
        union() {
            rounded_plate(outer_x,outer_y,lid_thickness,corner_radius);
            difference() {
                translate([wall+lip_clearance,wall+lip_clearance,lid_thickness-eps])
                    rounded_plate(outer_x-2*(wall+lip_clearance),
                                  outer_y-2*(wall+lip_clearance),lip_height+eps,2);
                translate([wall+lip_clearance+lip_thickness,
                           wall+lip_clearance+lip_thickness,lid_thickness-2*eps])
                    rounded_plate(outer_x-2*(wall+lip_clearance+lip_thickness),
                                  outer_y-2*(wall+lip_clearance+lip_thickness),
                                  lip_height+4*eps,1);
                lid_positions() translate([0,0,lid_thickness-2*eps])
                    cylinder(d=lid_post_diameter+2*lip_clearance,h=lip_height+4*eps);
            }
        }
        lid_positions() translate([0,0,-eps])
            cylinder(d=lid_screw_clearance,h=lid_thickness+lip_height+2*eps);
    }
}

// Preview envelopes: geometry is illustrative, not a component CAD model.
module components() {
    color([0.75,0.12,0.12,0.6]) translate([relay_x,relay_y,relay_z])
        cube([relay_length,relay_width,1.6]);
    color([0.15,0.4,0.85,0.6]) translate([relay_x+5,relay_y+7,relay_z+1.6])
        cube([relay_length-10,relay_width-14,relay_height-1.6]);
    color([0.1,0.65,0.4,0.6]) translate([controller_x,controller_y,controller_pcb_bottom_z])
        cube([controller_preview_length,controller_preview_width,controller_preview_height]);
    // Illustrative USB socket envelope; dimensions must be measured on the board.
    color([0.7,0.7,0.75])
        translate([controller_center_x-4.5,outer_y-wall-7,usb_center_z-1.5])
            cube([9,7,3]);
}

// Upright coupon duplicates vertical-hole print orientation and 3 mm panel.
// Left M20; right M12. Fit real fittings before printing the complete base.
module coupon() {
    difference() {
        union() {
            cube([76,18,floor_thickness]);
            cube([76,wall,base_height]);
        }
        for (p=[[20,load_gland_diameter],[56,low_voltage_gland_diameter]])
            translate([p[0],wall+eps,load_gland_center_z])
                rotate([90,0,0]) cylinder(d=p[1],h=wall+2*eps);
    }
}

// Nut sweep preview reserves 7 mm axial space; actual nut thickness and
// tightening tool must be checked with the selected fitting and coupon.
module gland_envelopes() {
    for (i=[0:load_gland_count-1]) {
        translate([load_gland_first_x+i*load_gland_pitch,wall,load_gland_center_z])
            rotate([-90,0,0]) {
                color([1,0.65,0.1,0.4]) cylinder(d=load_nut_sweep,h=7);
                color([0.3,0.3,0.3,0.5]) cylinder(d=20,h=load_thread_length-wall);
            }
        translate([load_gland_first_x+i*load_gland_pitch,0,load_gland_center_z])
            rotate([90,0,0]) color([0.2,0.25,0.3,0.5])
                cylinder(d=28,h=31); // Illustrative external gland envelope.
    }
}

if (part == "base") base();
else if (part == "lid") lid();
else if (part == "coupon") coupon();
else if (part == "layout") {
    base();
    translate([outer_x+10,0,0]) lid();
} else if (part == "assembly") {
    color([0.75,0.78,0.82]) base();
    translate([0,outer_y,base_height+lid_thickness+25]) rotate([180,0,0])
        color([0.8,0.82,0.85,0.7]) lid();
    if (show_components) { components(); gland_envelopes(); }
} else assert(false, "Unknown part");
