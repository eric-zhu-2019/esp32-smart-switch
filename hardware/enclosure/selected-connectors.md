# User-selected connectors

Selected 2026-11-20. These replace the earlier SCHURTER / Interpower references.
Listing data below was read from the two Amazon.ca pages on 2026-11-20. It is
seller-stated, not a manufacturer drawing; measure the received parts before
cutting final geometry.

| Role | Quantity | Selected listing |
| --- | --- | --- |
| Power inlet | 1 module | [Amazon.ca B0FFS5SBZZ](https://www.amazon.ca/gp/product/B0FFS5SBZZ) |
| Controlled outlet | 4 outlet positions | [Amazon.ca B07WV7MTQH](https://www.amazon.ca/dp/B07WV7MTQH) |

Quantity above means installed outlet positions, not retail packs.

## Inlet B0FFS5SBZZ: Acouto IEC 320 C14 inlet with rocker switch

- Listing title: "Acouto 1PCS IEC 320 C14 AC Power Cord Inlet Socket Outlet with
  Rocker Switch 250V10A". Model number as listed: Acoutoh0noc4fsxk. One per pack.
- Rated 250 V 10 A. Built-in ON/OFF rocker switch (red, illuminated style).
  **No fuse holder.** Terminals appear to be 6.3 mm quick-connect tabs.
- Stated panel cutout **42 × 27 mm**. Stated mounting screw hole spacing
  **50 mm centre to centre**, two holes on the long axis. Stated depth **27.5 mm**.
- Materials: ABS insulator, nickel-plated brass conductors.
- Not stated: screw hole diameter, flange outline, permitted panel thickness,
  cutout corner radius, whether the switch is single- or double-pole. Photo shows a
  lozenge-shaped flange with one hole beyond each end of the 42 mm axis; the
  C14 and the switch are stacked along that axis.

Fit against the current `socket-enclosure.scad` inlet mount (left wall):

| Item | Current CAD | Listing | Result |
| --- | --- | --- | --- |
| Opening | 28.1 × 20.1 mm | 42 × 27 mm | Too small on both axes; must be re-cut |
| Hole pitch | 40.1 mm | 50 mm | Must be re-drilled |
| Screw/tool envelope vs gussets | gussets at ±30 mm, 4 mm thick | holes at ±25 mm plus 8 mm envelope reach ±29 mm | Overlaps the gussets by ~1 mm; move `rib_offset` to ≥ 33 mm or widen the pad |
| Mount pad | 62 mm square | flange outline unknown, extends past the 50 mm holes | Enlarge pad along the hole axis to ~70 mm until flange is measured |
| Depth reservation | 50 mm | 27.5 mm body | OK |
| Orientation | — | 42 mm axis horizontal (along Y) | Required; vertical would put the upper screw inside the inner guard at z = 63 |

Electrical note: the inlet and its switch are 10 A parts and a C13 cord is
10 A. The whole box is therefore limited to 10 A total regardless of the
15 A receptacles. The switch does not provide overcurrent protection.

## Outlet B07WV7MTQH: BESTTEN 15 A decorator wall receptacle (10 pack)

- Listing title: "[10 Pack] BESTTEN 15 Amp Decorator Wall Receptacle Outlet,
  Tamper-Resistant (TR) Electrical Socket, 15A/125V/1875W ... cUL Listed, White".
  Model LD-3012TR, manufacturer part USP-15T-BN-10PK, maker Wenzhou Huaya
  Electric. NEMA 5-15R duplex, two outlets per device, cUL listed, thermoplastic.
- Seller dimension drawing: body width **1.29 in (32.8 mm)**, strap length
  **4.06 in (103.1 mm)**, face length **2.71 in (68.9 mm)**, depth behind the
  strap **0.98 in (24.9 mm)**. Product dimensions 3.4 × 2.41 × 10.31 cm, 70 g.
- Wiring: side screw terminals 12–14 AWG, back push-in 14 AWG only, solid copper
  only. Ground screw on the strap. Break-off plaster ears.
- Seller recommends BESTTEN USWP4 decorator wall plates (1 to 6 gang).
- Not stated but standard for North American decorator devices, to be confirmed on
  the received part: yoke box-mounting holes 6-32 at **3.281 in (83.3 mm)**,
  wall-plate screw holes in the device at **3.812 in (96.8 mm)**, decorator plate
  opening **1.31 × 2.63 in (33.3 × 66.8 mm)**, multi-gang pitch
  **1.812 in (46.0 mm)**, single-gang standard plate 2.75 × 4.5 in (69.8 × 114.3 mm).

**This is a wall-box device, not a panel-mount receptacle.** It mounts by its
metal strap into a device box and is finished with a wall plate. It does not use
a 34 mm square opening or a 46 mm hole square, so none of the outlet geometry in
`socket-enclosure.scad` applies. Comparison with the current layout:

| Arrangement | Needs | Current box | Result |
| --- | --- | --- | --- |
| Vertical on front/rear wall | 103.1 mm strap + 114.3 mm plate height | 70 mm wall | Does not fit |
| Horizontal on front/rear wall, two per wall | 2 × 114.3 mm plates = 228.6 mm | 200 mm wall | Does not fit; one plate also spans the full 70 mm wall and the lid seam |
| Row of four on the lid, lid acts as plate | openings at 46 mm pitch span 171.3 mm, strap 103.1 mm | 186 mm inside the rim, but only 147 mm left of the divider | Fits only if the box widens to ~235 mm or the controller bay moves |
| Row of four on the lid with a commercial 4-gang plate | 207.9 × 114.3 mm plate | 200 × 180 mm lid | Needs outer_x ≥ ~225 mm |

Body depth below the lid is about 25 mm (z ≈ 45 to 70), plus wire bend room.
The inner guard at z = 63 and the four 62 mm wall pads would be removed in a
lid-mounted layout; the relay module top at z ≈ 28 stays clear.

## CAD revision

Started in Onshape on 2026-11-20: see [onshape/README.md](onshape/README.md) for the
document link and the FeatureScript source. The list below is what that revision
implements; the OpenSCAD files are not updated.

### Revision plan

1. Widen the base to about 235 × 180 mm. Keep the controller bay on the right.
2. Put four receptacles face-up in the lid in one row at 46.0 mm pitch, with
   33.3 × 66.8 mm openings, 6-32 clearance holes at 96.8 mm for the plate
   screws into the device, and underside bosses for the 83.3 mm yoke screws.
   Alternatively cut a pocket for a commercial 4-gang USWP4 plate.
3. Thicken the lid locally to ≥ 6 mm around the openings, since it now carries
   plug insertion and extraction loads.
4. Re-cut the left wall for the 42 × 27 mm inlet with 50 mm holes, long axis
   horizontal, gussets moved outward.
5. Reserve wall positions for fuse holders if per-outlet fusing is adopted.
6. Re-export, re-run the mesh checks, and print a new coupon containing one
   receptacle opening and the inlet cutout before printing the full box.

## Existing files

`socket-enclosure.scad`, `socket-*-fit-check.stl`, and the current ZIP still contain
the previous SCHURTER 6100.3300 / Interpower 88261100 mounting geometry. Their mesh
and clearance checks remain valid only for that earlier geometry. They have NOT
been resized for these Amazon parts.

## Reinforcement revision

The reference enclosure has 4 mm walls/floor, 6 mm mounting panels, 62 mm square
pads, two 4 mm side gussets per mount, and a continuous top rim. This strengthens
the proposed geometry without establishing compatibility with the selected
connectors or a verified force rating. Mounting method, actual hardware, terminal
clearances and printed load tests remain pending. See the enclosure README.
