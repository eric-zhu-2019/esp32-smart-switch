// Socket enclosure: UNPOWERED FIT PROTOTYPE. All dimensions in mm.
// Commercial connectors only; no electrical contacts are printed.
// References and unresolved construction details: README.md.
// Amazon replacement connector cutouts are PENDING verified drawings.
// Reinforcement is geometric only: no mechanical load rating established.
part = "assembly"; // [base,lid,guard,coupon,assembly]
show_components = true;
wall=4;
floor_thickness=4;
base_height=70;
outer_x=200;
outer_y=180;
corner_radius=5;
relay_length=72.64;
relay_width=49.27;
relay_height=19.17;
relay_hole_offset_x=2.85; // Provisional photo interpretation.
relay_hole_offset_y=2.85;
relay_x=66;
relay_y=65;
standoff_height=5;
standoff_diameter=6.5;
relay_z=floor_thickness+standoff_height;
pilot_diameter=2.5;
lid_thickness=3;
lid_screw_clearance=3.4;
lid_post_diameter=8;
lid_post_inset=6;
lid_pilot_depth=12;
lip_height=2;
lip_thickness=1.4;
lip_clearance=0.3;
rim_extension=3;
rim_height=4;
lid_seat_wall=wall+rim_extension;
divider_x=154;
divider_thickness=2.4;
controller_center_x=176;
controller_preview_length=18;
controller_preview_width=22.52;
controller_preview_height=12; // Illustrative, unmeasured height; mounts pending.
controller_pcb_bottom_z=8.4;
controller_x=controller_center_x-controller_preview_length/2;
controller_y=outer_y-wall-1.5-controller_preview_width;
usb_opening_width=14;
usb_opening_height=8;
usb_opening_radius=2;
usb_center_z=12;

// Interpower 88261100, current drawing rev 2, 2026-02-20:
// General application cutout 34 +/-0.5 square; NOT the alternate 46.3 cutout.
// Four through holes 3.5 +/-0.13 on a 46 +/-0.13 square pattern.
outlet_cutout=34;
outlet_hole_pitch=46;
outlet_hole_diameter=3.5;
outlet_flange=52.8;
outlet_centers=[40,105]; // Two on front, two on rear.
connector_center_z=35;
mount_pad_size=62;
mount_panel_thickness=6; // 4 mm wall plus 2 mm interior reinforcement.
rib_thickness=4;
rib_offset=30;
rib_foot_depth=24;
rib_top_z=60;
mount_tool_diameter=8; // Provisional clearance envelope; check actual tool/washer.
outlet_depth_reservation=50; // 34.28 body/terminal depth plus wiring allowance.

// SCHURTER 6100.3300, FRONT-mounted standard C14, no sealing kit.
// Drawing: 28 +0.2/0 x 20 +0.2/0, max R3, hole pitch 40 +0.2/0.
inlet_width=28.1;
inlet_height=20.1;
inlet_radius=2;
inlet_hole_pitch=40.1;
inlet_hole_diameter=3.5;
inlet_center_y=90;
inlet_depth_reservation=50; // Includes room beyond 23.5 mm terminal depth.
low_voltage_gland_diameter=12.1; // Existing M12 external low-voltage supply.
low_voltage_center_y=65;
low_voltage_center_z=23;

// Removable inner guard covers the mains compartment. Not rated insulation.
guard_x=6.4;
guard_y=6.4;
guard_width=144.6;
guard_length=167.2;
guard_z=63;
guard_thickness=2.4;
guard_post_diameter=8;
guard_screw_clearance=3.4;
guard_post_x=[12,146];
guard_post_y=[58,122];
$fn=64;
eps=0.02;

assert(outer_x<250 && outer_y<250 && base_height<250,"Exceeds P1S working envelope");
assert(outlet_centers[1]-outlet_centers[0]>mount_pad_size,"Mount pads overlap");
// Reinforcement intentionally joins the corner towers; openings remain clear.
assert(outlet_centers[0]-outlet_hole_pitch/2-mount_tool_diameter/2>
       lid_post_inset+lid_post_diameter/2,"Mount hardware intersects corner tower");
assert(rib_offset-rib_thickness/2>outlet_hole_pitch/2+mount_tool_diameter/2,
       "Gusset blocks reference outlet mounting hardware");
assert(outlet_centers[1]+mount_pad_size/2<divider_x,"Outlet enters controller bay");
assert(connector_center_z-mount_pad_size/2>=floor_thickness &&
       connector_center_z+mount_pad_size/2<base_height-lip_height,
       "Mount pad intersects floor or lid lip");
assert(relay_y>outlet_depth_reservation+10 &&
       relay_y+relay_width<outer_y-outlet_depth_reservation-10,
       "Relay intersects reserved outlet/wiring volume");
assert(relay_x>inlet_depth_reservation+10 && relay_x+relay_length<divider_x-10,
       "Relay intersects inlet/wiring volume or divider");
assert(inlet_center_y-mount_pad_size/2>outlet_depth_reservation &&
       inlet_center_y+mount_pad_size/2<outer_y-outlet_depth_reservation,
       "Inlet overlaps outlet wiring reservations");
assert(guard_z>connector_center_z+outlet_flange/2 &&
       guard_z+guard_thickness<base_height-lip_height,"Guard vertical clearance");
assert(guard_x+guard_width<divider_x,"Guard intersects divider");
assert(guard_x>mount_panel_thickness && guard_y>mount_panel_thickness,
       "Guard intersects mounting pads");
assert(guard_z>rib_top_z && guard_z+guard_thickness<base_height-rim_height,
       "Guard intersects gussets or top rim");
echo("Socket prototype outer size including lid",[outer_x,outer_y,base_height+lid_thickness]);
echo("Mains connector arrangement","1 C14 inlet + 4 NEMA 5-15R outlets");
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


// Local panel coordinates: X horizontal, Y upward, Z inward from outside face.
module outlet_locations() {
    for(x=outlet_centers) {
        translate([x,0,connector_center_z]) rotate([90,0,0])
            mirror([0,0,1]) children();
        translate([x,outer_y,connector_center_z]) rotate([90,0,0]) children();
    }
}
module inlet_location() {
    translate([0,inlet_center_y,connector_center_z])
        multmatrix([[0,0,1,0],[1,0,0,0],[0,1,0,0],[0,0,0,1]]) children();
}
module outlet_cut() {
    translate([-outlet_cutout/2,-outlet_cutout/2,-eps])
        cube([outlet_cutout,outlet_cutout,mount_panel_thickness+2*eps]);
    for(x=[-1,1], y=[-1,1])
        translate([x*outlet_hole_pitch/2,y*outlet_hole_pitch/2,-eps])
            cylinder(d=outlet_hole_diameter,h=mount_panel_thickness+2*eps);
}
module inlet_cut() {
    translate([-inlet_width/2,-inlet_height/2,-eps])
        rounded_plate(inlet_width,inlet_height,mount_panel_thickness+2*eps,inlet_radius);
    for(x=[-1,1]) translate([x*inlet_hole_pitch/2,0,-eps])
        cylinder(d=inlet_hole_diameter,h=mount_panel_thickness+2*eps);
}
module mount_pad() {
    translate([-mount_pad_size/2,-mount_pad_size/2,wall-eps])
        rounded_plate(mount_pad_size,mount_pad_size,mount_panel_thickness-wall+eps,3);
}
// Side gussets carry panel loads into the floor without occupying the opening.
// Local X horizontal, Y vertical, Z inward, as for mount_pad().
module mount_gussets() {
    for(x=[-rib_offset,rib_offset])
        translate([x-rib_thickness/2,0,0])
            multmatrix([[0,0,1,0],[1,0,0,0],[0,1,0,0],[0,0,0,1]])
                linear_extrude(height=rib_thickness)
                    polygon([[floor_thickness-connector_center_z-eps,wall-eps],
                             [floor_thickness-connector_center_z-eps,rib_foot_depth],
                             [rib_top_z-connector_center_z,mount_panel_thickness],
                             [rib_top_z-connector_center_z,wall-eps]]);
}
module reinforced_mount() { mount_pad(); mount_gussets(); }
module top_rim() {
    translate([0,0,base_height-rim_height]) difference() {
        rounded_plate(outer_x,outer_y,rim_height,corner_radius);
        translate([lid_seat_wall,lid_seat_wall,-eps])
            rounded_plate(outer_x-2*lid_seat_wall,outer_y-2*lid_seat_wall,
                          rim_height+2*eps,2);
    }
}
module guard_positions() {
    for(x=guard_post_x,y=guard_post_y) translate([x,y,0]) children();
}
module base() {
    difference() {
        union() {
            difference() {
                rounded_plate(outer_x,outer_y,base_height,corner_radius);
                translate([wall,wall,floor_thickness])
                    rounded_plate(outer_x-2*wall,outer_y-2*wall,base_height,corner_radius-wall);
            }
            lid_positions() cylinder(d=lid_post_diameter,h=base_height);
            relay_positions() cylinder(d=standoff_diameter,h=relay_z);
            guard_positions() cylinder(d=guard_post_diameter,h=guard_z);
            translate([divider_x,wall-eps,floor_thickness-eps])
                cube([divider_thickness,outer_y-2*wall+2*eps,
                      base_height-lip_height-floor_thickness+eps]);
            outlet_locations() reinforced_mount();
            inlet_location() reinforced_mount();
            top_rim();
        }
        lid_positions() translate([0,0,base_height-lid_pilot_depth])
            cylinder(d=pilot_diameter,h=lid_pilot_depth+eps);
        relay_positions() translate([0,0,floor_thickness])
            cylinder(d=pilot_diameter,h=standoff_height+eps);
        guard_positions() translate([0,0,guard_z-10]) cylinder(d=pilot_diameter,h=10+eps);
        outlet_locations() outlet_cut();
        inlet_location() inlet_cut();
        // Low-voltage supply entry in the right wall.
        translate([outer_x-wall-eps,low_voltage_center_y,low_voltage_center_z])
            rotate([0,90,0]) cylinder(d=low_voltage_gland_diameter,h=wall+2*eps);
        translate([controller_center_x-usb_opening_width/2,outer_y+eps,
                   usb_center_z-usb_opening_height/2]) rotate([90,0,0])
            rounded_plate(usb_opening_width,usb_opening_height,wall+2*eps,usb_opening_radius);
        // Small control-wire passage; final insulation/bushing remains unresolved.
        translate([divider_x-eps,90,14])
            multmatrix([[0,0,1,0],[1,0,0,0],[0,1,0,0],[0,0,0,1]])
                rounded_plate(12,8,divider_thickness+2*eps,2);
    }
}
// Lid is exported exterior-face-down, with its locating lip pointing upward.
module lid() {
    difference() {
        union() {
            rounded_plate(outer_x,outer_y,lid_thickness,corner_radius);
            difference() {
                translate([lid_seat_wall+lip_clearance,lid_seat_wall+lip_clearance,lid_thickness-eps])
                    rounded_plate(outer_x-2*(lid_seat_wall+lip_clearance),
                                  outer_y-2*(lid_seat_wall+lip_clearance),lip_height+eps,2);
                translate([lid_seat_wall+lip_clearance+lip_thickness,
                           lid_seat_wall+lip_clearance+lip_thickness,lid_thickness-2*eps])
                    rounded_plate(outer_x-2*(lid_seat_wall+lip_clearance+lip_thickness),
                                  outer_y-2*(lid_seat_wall+lip_clearance+lip_thickness),
                                  lip_height+4*eps,1);
                lid_positions() translate([0,0,lid_thickness-2*eps])
                    cylinder(d=lid_post_diameter+2*lip_clearance,h=lip_height+4*eps);
            }
        }
        lid_positions() translate([0,0,-eps])
            cylinder(d=lid_screw_clearance,h=lid_thickness+lip_height+2*eps);
    }
}


// Exported flat at origin; fits onto four posts at guard_z in the base.
module guard() {
    difference() {
        rounded_plate(guard_width,guard_length,guard_thickness,2);
        for(x=guard_post_x,y=guard_post_y)
            translate([x-guard_x,y-guard_y,-eps])
                cylinder(d=guard_screw_clearance,h=guard_thickness+2*eps);
        // Clearance around the two left corner towers.
        for(y=[lid_post_inset,outer_y-lid_post_inset])
            translate([lid_post_inset-guard_x,y-guard_y,-eps])
                cylinder(d=lid_post_diameter+2,h=guard_thickness+2*eps);
    }
}
module coupon() {
    difference() {
        union() {
            cube([136,30,floor_thickness]);
            cube([136,wall,base_height]);
            for(x=[36,102]) translate([x,0,connector_center_z])
                rotate([90,0,0]) mirror([0,0,1]) reinforced_mount();
        }
        translate([36,0,35]) rotate([90,0,0]) mirror([0,0,1]) outlet_cut();
        translate([102,0,35]) rotate([90,0,0]) mirror([0,0,1]) inlet_cut();
    }
}
// Illustrative connector faces/body envelopes ONLY. Do not print these as parts.
module connector_previews() {
    outlet_locations() {
        color([0.12,0.13,0.15]) difference() {
            translate([-outlet_flange/2,-outlet_flange/2,-8])
                rounded_plate(outlet_flange,outlet_flange,8,3);
            for(x=[-6.35,6.35]) translate([x-1.5,0,-8-eps]) cube([3,10,8+2*eps]);
            translate([0,-9,-8-eps]) cylinder(d=6,h=8+2*eps);
        }
        color([0.7,0.5,0.1,0.25]) translate([-17,-17,0]) cube([34,34,outlet_depth_reservation]);
    }
    inlet_location() {
        color([0.12,0.13,0.15]) difference() {
            translate([-25,-15,-3]) rounded_plate(50,30,3,3);
            translate([-14,-10,-3-eps]) rounded_plate(28,20,3+2*eps,2);
        }
        color([0.7,0.5,0.1,0.25]) translate([-20,-15,0]) cube([40,30,inlet_depth_reservation]);
    }
    color([0.75,0.12,0.12,0.6]) translate([relay_x,relay_y,relay_z])
        cube([relay_length,relay_width,relay_height]);
    color([0.1,0.65,0.4,0.6]) translate([controller_x,controller_y,controller_pcb_bottom_z])
        cube([controller_preview_length,controller_preview_width,controller_preview_height]);
}
if(part=="base") base();
else if(part=="lid") lid();
else if(part=="guard") guard();
else if(part=="coupon") coupon();
else if(part=="assembly") {
    color([0.6,0.7,0.8]) base();
    translate([guard_x,guard_y,base_height+15]) color([0.8,0.65,0.3,0.6]) guard();
    translate([0,outer_y,base_height+lid_thickness+45]) rotate([180,0,0])
        color([0.7,0.8,0.9,0.5]) lid();
    if(show_components) connector_previews();
} else assert(false,"Unknown part");
