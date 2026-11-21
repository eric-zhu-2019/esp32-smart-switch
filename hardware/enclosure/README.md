# Smart switch enclosure: C14 inlet and four NEMA outlets

> **Connector selection changed on 2026-11-20:** the user selected
> [inlet B0FFS5SBZZ](https://www.amazon.ca/gp/product/B0FFS5SBZZ) and
> [outlet B07WV7MTQH](https://www.amazon.ca/dp/B07WV7MTQH).
> Their listing dimensions and a fit comparison are in
> [selected-connectors.md](selected-connectors.md). The outlet is a wall-box
> decorator receptacle that the current front/rear wall layout cannot hold.
> A revised layout for these parts is in Onshape: see [onshape/README.md](onshape/README.md).
> The OpenSCAD CAD, STLs and previews below still describe the earlier reference
> connectors and have **not been adapted** to these Amazon parts.

Current design, 2026-11-20: one removable-computer-cord **IEC C14 inlet** and
**four individually mountable NEMA 5-15R outlets**, as requested. Two outlets
are on the front, two on the rear, and the inlet is on the left side. The
right compartment is reserved for the ESP32-C3 Super Mini and external
low-voltage supply connection. The connectors are purchased parts, not printed.

**Unpowered mechanical fit prototype.** This revision establishes mounting
geometry; it is not an electrically validated power strip. Controller retention,
actual wiring, overcurrent protection and relay-board isolation remain unresolved.

## Print files

| File | Purpose | Dimensions, mm |
| --- | --- | --- |
| `socket-enclosure.scad` | Current editable source and exploded preview | Assembled 200 × 180 × 73 |
| `socket-base-fit-check.stl` | Base, reinforced connector mounts, divider and posts | 200 × 180 × 70 |
| `socket-lid-fit-check.stl` | Outer lid, exterior face down | 200 × 180 × 5 |
| `socket-guard-fit-check.stl` | Removable inner cover over the mains compartment | 144.6 × 167.2 × 2.4 |
| `socket-coupon-fit-check.stl` | Print first: one outlet mount and one inlet mount | 136 × 30 × 70 |
| `socket-connectors-preview.png` | Opposite views of the actual exported base | |
| `socket-parts-preview.png` | Lid, guard and test-panel views | |
| `check_socket_enclosure.py` | Mesh checks and previews, using `mesh_tools.py` | |

The previous circular-gland version is retained in `enclosure.scad`, the
unprefixed STL/preview files and [gland-version.md](gland-version.md). **Use the
`socket-` files for the current version.** The two revisions' lids are not
interchangeable.

## Reference parts and mounting dimensions

These specific parts define the cutouts. A generic C14 or NEMA connector does
not necessarily share the mounting geometry. Confirm purchased part numbers and
fit the coupon before printing the full enclosure.

| Qty | Reference part | Panel mounting |
| --- | --- | --- |
| 1 | SCHURTER **6100.3300**, standard C14 inlet, 6.3 mm quick-connect terminals | Front-mounted 28.1 × 20.1 mm opening, R2 corners; two Ø3.5 holes on 40.1 mm centers |
| 4 | Interpower **88261100**, NEMA 5-15R screw-mount receptacle | 34 × 34 mm square opening; four Ø3.5 holes on a 46 × 46 mm pattern |
| 1, optional low-voltage supply | LAPP **53010000**, M12 gland with matching locknut | Ø12.1 mm right-side hole; round cable jacket 3.5–7 mm |

The inlet dimensions use SCHURTER's **front mounting** drawing, not its different
rear mounting cutout. Published opening limits are 28.0–28.2 × 20.0–20.2 mm,
maximum corner radius 3 mm, mounting pitch 40.0–40.2 mm. The standard inlet permits
up to 8 mm panel thickness; this design uses 6 mm at the mount and does not use
the optional sealing kit.

The Interpower drawing (revision 2, dated 2026-02-20) specifies **34 ±0.5 mm
square** for general applications, four **Ø3.5 ±0.13 mm** through holes on
**46 ±0.13 mm** centers. Its alternate 46.3 mm rounded cutout is intended for
combination with another socket family and is not used here. The flange is
52.8 mm square. This is a panel receptacle, not a standard wall-box duplex outlet.

Sources:

- [SCHURTER 6100-3 dimensions and variants](https://www.schurter.com/en/datasheet/6100-3), front mounting drawing and standard 6100.3300 variant.
- [SCHURTER datasheet](https://www.schurter.com/en/datasheet/typ_6100-3.pdf).
- [Interpower 88261100 product page](https://www.interpower.com/cgi-bin/ic.cgi/findpart.p?w_part=88261100).
- [Interpower current mounting drawing](https://www.interpower.com/drawings/88261100.pdf), lower-right general-application cutout, inspected visually.
- [LAPP long-thread gland catalogue](https://products.lappgroup.com/online-catalogue/cable-glands/skintop-cable-glands-plastic-metric/standard/skintop-st-m.html).

## Layout and assembly fit

Coordinates are measured from the exterior front-left-bottom corner:

- Outlet centers: x = 40 and 105, z = 35, on y = 0 and y = 180 walls.
- Inlet center: x = 0, y = 90, z = 35.
- USB opening: rear controller bay, x = 176, z = 12; 14 × 8 mm, R2.
- Low-voltage gland: right wall, y = 65, z = 23. No internal mains power supply
  has been allocated or selected.
- Walls and floor are **4 mm**. Each mains connector has a **62 × 62 mm** internal
  pad making the mounting panel **6 mm thick**, with two **4 mm side gussets**
  extending 24 mm inward at the floor and tapering to the pad at z = 60.
  A continuous top rim is 7 mm wide and 4 mm high; the lid lip fits inside it.
  The pads/ribs intentionally join adjacent corner or guard posts where they meet.
  Mount connectors from outside with through bolts, washers and nuts. Select
  lengths after checking the actual flange and hardware stack; do not rely on
  threads cut into the printed wall. The reference outlet bolt locations reserve
  an 8 mm diameter washer/tool envelope; check actual hardware and access.
- A 50 mm inward depth is reserved at each mains connector. Interpower's
  body/terminal dimension is 34.28 mm behind its flange reference; SCHURTER gives
  23.5 mm for quick-connect terminals. Remaining space is a preliminary wiring
  allowance, not verification of cable bend radius or insulated terminal fit.
- The relay board starts at x = 66, y = 65, underside z = 9. Its nominal
  footprint remains 72.64 × 49.27 mm. Hole offsets 2.85 mm and height 19.17 mm
  are still provisional interpretations of the user's sketch.
- The divider now spans the depth of the enclosure, with a small rounded control
  wire passage. It does not establish the relay PCB's electrical isolation.
- The inner guard rests on four posts at z = 63, covering the mains compartment
  below the outer lid, with 0.4 mm edge clearance from connector pads. Fit with four M3 screws into 2.5 mm pilots after tapping.
  The guard is an access barrier prototype, not certified insulation. The
  controller bay remains accessible when the outer lid is removed.
- The guard and lid have separate fasteners. Lid clearance holes are Ø3.4 with
  matching 2.5 mm pilots. Check screw engagement and installed connector hardware.
- The Super Mini preview uses a nominal 18 × 22.52 mm footprint, USB facing rear.
  Its 12 mm height is only a reservation; controller mounts remain unfinished.

The assembly view includes simplified connector faces and translucent depth
reservations to explain layout. They are not manufacturer CAD, contain no usable
contacts, and are excluded from all printable STL exports.

## Bambu Lab P1S or H2C

Each part fits either printer individually. Center one part per plate in Bambu
Studio, use the actual printer/nozzle/plate/filament profile, and import at
**100% scale in millimeters**. No sliced G-code or printer configuration is supplied.

For an unpowered fit check with a 0.4 mm nozzle, start with 0.20 mm layers,
eight wall loops, eight top/bottom layers and 20% infill. Inspect the sliced
mounting pads, gussets and their floor junctions; use local solid infill modifiers
where needed to avoid sparse infill in these load paths. Base prints floor-down;
lid exterior-down with lip up; guard flat; test panel upright on its foot.
The upright coupon matches the base's connector-hole orientation and 6 mm
reinforced mounting areas, including side gussets. Use a brim if required.

The rectangular openings have horizontal roofs: inspect Bambu Studio's preview
and add removable local support inside connector cutouts as needed. The square
outlet openings are particularly unlikely to retain dimensional accuracy without
support. Remove support, measure the actual openings and hole patterns, and fit
both commercial connectors with their hardware. Do not scale the whole model to
correct hole fit. Check flange seating, plug insertion/removal, fastener retention
and the available rear space without power. Verify the internal guard and lid fit.

PLA can be used for this unpowered shape check. Neither a printer model nor a
filament label establishes the complete enclosure's suitability for mains use.

## Push/pull reinforcement and validation

The 2026-11-20 reinforcement revision keeps the outside dimensions unchanged.
The enlarged mounting pads spread flange/washer loads into the walls; side
ribs join the pads to the thicker floor, and the top rim ties the walls together.
These are proposed geometric improvements, **not a verified force rating**.
The new guard and lid must be printed with the new base; the prior socket lid
lip interferes with the new rim.

The Amazon modules still need verified mounting method and permitted panel
thickness. A snap-in module may require a thinner local seat and a separate
retainer supported by this frame. Do not force a snap latch into a 6 mm panel or
assume the current through-hole pattern is compatible. Check rear terminal,
insulation and tool clearance after adapting the cutouts.

Before accepting the printed assembly mechanically:

1. Fit the actual connectors and hardware to a coupon. Check full flange seating,
   access to mounting nuts and switches/fuses, and plug insertion/removal.
   The coupon tests fit; its open sides do not represent complete-box strength.
2. Use the intended filament, print settings and orientation for the assembled
   box test. Record measured plug insertion/extraction forces and intended service
   temperature, then establish an appropriate proof load and cycle count with
   the person assessing the complete product. These targets remain unset.
3. With all power disconnected, test each connector for inward/outward loads,
   repeated mating cycles and off-axis cord loading, with the lid secured and
   the box supported as it will be used. Inspect for wall movement, cracks,
   layer separation, loose fasteners, permanent set and lost terminal clearance.
4. Record material, hardware, test loads, cycles, temperature and results. Do not
   mark this design load-validated until the actual assembly passes the agreed
   test plan. Avoid over-tightening fasteners; plastic creep and thermal exposure
   also need assessment.

Print perimeter count matters to strength ([Prusa guidance](https://help.prusa3d.com/article/layers-and-perimeters_1748));
layer direction and gussets matter as well ([Zortrax design guidance](https://support.zortrax.com/tips-for-modeling-3d-parts/)).
Neither source establishes a load capacity for this enclosure.

## Rebuild and checks

```sh
openscad --hardwarnings --export-format binstl -D 'part="base"' -o socket-base-fit-check.stl socket-enclosure.scad
openscad --hardwarnings --export-format binstl -D 'part="lid"' -o socket-lid-fit-check.stl socket-enclosure.scad
openscad --hardwarnings --export-format binstl -D 'part="guard"' -o socket-guard-fit-check.stl socket-enclosure.scad
openscad --hardwarnings --export-format binstl -D 'part="coupon"' -o socket-coupon-fit-check.stl socket-enclosure.scad
MPLCONFIGDIR=/tmp/smart-switch-mpl python check_socket_enclosure.py
```

Checks cover closed, connected, consistently wound meshes with positive volume
and no degenerate triangles, plus a conservative 250 mm print envelope. OpenSCAD
assertions check the layout against connector and board reservations. These are
geometric checks, not electrical, thermal or mechanical-load certification.

## Remaining electrical construction

Four outlets are four proposed controlled channels; firmware does not operate
relays yet. Connector nameplate ratings do not establish the whole device's
rating, and four 15 A receptacles do not imply a 60 A supply. Total and per-channel
limits, protective devices, conductor sizes, terminal insulation, earthing,
relay inrush ratings and temperature rise must be established for the actual loads.
Protective earth must remain continuous to every grounded outlet and must never
be switched by a relay. Insulate accessible rear terminals using suitable
commercial parts even with the inner guard present. The relay's apparent
optocouplers alone do not verify isolation from the ESP32 or its USB port.

Keep this assembly unpowered until the complete construction has been assessed
by a qualified person. The intended final mains housing must be suitably rated
or evaluated as a complete assembly; these prints have no asserted safety/IP rating.
