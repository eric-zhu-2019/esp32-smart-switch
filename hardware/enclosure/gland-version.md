# Smart switch enclosure — fit-check draft

This is a parametric mechanical starting point for the photographed four-relay
module and a separate ESP32-C3 Super Mini controller bay. It is **not ready for powered mains
use**. Controller dimensions, hole-center offsets, wiring, actual cord diameter, and physical gland fit
still need confirmation. There is no space allocated for an internal AC/DC supply.

## Photo observations and dimensions

`IMG_8120.HEIC` shows four Songle **SRD-12VDC-SL-C** relays. Their markings indicate
12 V DC coils. The Chinese PCB text describes a four-channel optocoupled relay
module supporting high/low-level triggering. The module model, jumper settings,
input thresholds, and isolation topology are not established by this photograph.
Do not infer 3.3 V GPIO compatibility or full-board current ratings from the relay
markings. Keep firmware relay outputs unconfigured pending interface verification.

`IMG_8118.HEIC` is the user's dimension sketch:

| Item | Sketch reading | CAD interpretation |
| --- | --- | --- |
| PCB outline | 72.64 × 49.27 mm | Used directly |
| Module height | 19.17 mm | Assumed measured from PCB underside; verify |
| Mounting holes | M3 / 3 mm | 3 mm PCB holes |
| Edge annotation | 1.35 mm | Provisionally edge-to-hole-edge on both axes |

The provisional hole-center offsets are **2.85 mm**, giving a **66.94 × 43.57 mm**
center-to-center pattern. Measure both axes before printing the whole enclosure.
If 1.35 mm meant something else, replace `relay_hole_offset_x/y` in the source.

## Selected controller

The user confirmed the **ESP32-C3 Super Mini** from
[Amazon listing B0GQM4SRS3](https://www.amazon.ca/dp/B0GQM4SRS3).
The listing could not be read directly during research.
[Nologo's SuperMini documentation](https://www.nologo.tech/product/esp32/esp32c3/esp32c3supermini/esp32C3SuperMini.html)
specifies a nominal **22.52 × 18 mm** board with USB-C. This is a reference
footprint, not verification of the Amazon variant or its connector overhang.

The OpenSCAD assembly preview uses that footprint with its long axis along
enclosure Y and its USB connector facing the rear (+Y) wall. Its PCB end is placed
1.5 mm from the rear inside wall, centered across the controller bay. The intended
PCB underside elevation is 8.4 mm above the box's outside bottom; controller
retention is still unfinished. The 12 mm preview height remains a reserved
envelope, not a measured height. Header pins, solder joints, connector overhang,
and the actual USB plug need a fit check. The 40 mm bay leaves room for wiring.

## Files

- `enclosure.scad`: editable OpenSCAD source, with Customizer parameters.
- `base-fit-check.stl`: base with relay posts, lid posts, and a routing divider.
- `lid-fit-check.stl`: screw-on lid, exported exterior face down for printing.
- `gland-fit-coupon.stl`: upright M20/M12 test panel; print this first.
- `gland-fit-coupon.png`: coupon preview, larger M20 hole on the left.
- `preview.png`: view generated from the actual exported meshes.
- `connectors-preview.png`: front/right and rear views showing connector openings.
- `check_and_preview.py`: checks mesh topology and regenerates the preview.

## Draft dimensions and features

- Assembled outer dimensions: **214 × 95.27 × 49 mm**.
- Walls: 3 mm; floor: 2.4 mm; lid: 3 mm; locating lip: 2 mm.
- Relay standoffs: 5 mm above the floor, with 2.5 mm pilots intended to be tapped
  M3. Check solder protrusions and component clearance against the real board.
- Four lid screw holes: 3.4 mm clearance into 2.5 mm pilots, 12 mm deep.
  M3 × 10 mm pan-head lid screws are a starting point after tapping; verify fit.
- Controller bay: 40 mm wide before wall clearance, with **no controller mounts**.
  The assembly preview's 18 × 22.52 × 12 mm green block uses the SuperMini's
  nominal footprint and a placeholder height. It is not a full component model.
- Relay load terminals should face the front wall; control wiring routes behind
  the divider. The divider is a routing aid with a rear gap, not a verified
  electrical insulation barrier. It does not divide the relay PCB's voltage domains.
- Commercial-gland mounting holes and USB access are included in the exported
  base. Supply is assumed external; the side entry is low voltage only.

## Commercial cord-grip mounting

The user plans a desktop-computer-style power cord. Its jacket diameter and shape
are not yet measured. The four front ports are therefore designed around **M20 ×
1.5** commercial glands, using **LAPP SKINTOP ST-M ISO 53017030** (gray) as the
mechanical reference. Its current specification accepts **round cable OD 6–12 mm**;
confirm the actual cord and purchased gland specification before assembly.
The 13 mm long mounting thread leaves more engagement through the 3 mm wall than
the standard short-thread version. Do not substitute PG or NPT fittings.

| Position | Panel hole | Reference fitting / locknut | Cable jacket range |
| --- | --- | --- | --- |
| Four front ports | Ø20.1 mm, smooth through-hole | LAPP 53017030 / 53119020, M20 × 1.5 | Round 6–12 mm |
| Right side, low voltage only | Ø12.1 mm, smooth through-hole | LAPP 53010000 / 53119000, M12 × 1.5 | Round 3.5–7 mm |
| Rear USB access | 14 × 8 mm, R2 corners | Proposed Super Mini USB position | Verify plug envelope |

Front centers: **x = 29, 67, 105, 143 mm; z = 23 mm**, measured from the
outside left edge and bottom. Front pitch is **38 mm**. The side center is
**x = 214; y = 47.635; z = 23 mm**. USB center is
**x = 191; y = 95.27; z = 12 mm**.

The M20 locknut is 27 mm across flats, requiring a **31.18 mm rotation envelope**.
The layout reserves a 38 mm circular tool envelope at each front port, clear of
the floor, divider, lid lip, and corner posts. Actual spanner access needs a
physical check; the reservation is not a guarantee for every tool. The inside
wall is flat for the nut, and the outside is flat for the gland shoulder/seal.
There are no printed threads or printed cable clamps. Fit the commercial gland
from outside and its locknut from inside with the lid removed, before the PCB.

The assembly preview includes approximate gland and nut envelopes, which are
**not included in printable STLs**. The axial nut reservation is 7 mm, not a
verified nut thickness. Check the actual nut, seal arrangement, full thread
engagement and the manufacturer's tightening instructions using the coupon.
The relay PCB begins 28 mm behind the exterior front face, leaving 15 mm beyond
the nominal 13 mm gland thread reach; this is lead-in space, not a verified bend
radius. Cable routing and terminal access need checking with the actual cords.

Each gland clamps one intact outer jacket. These openings do **not** pass a
molded computer IEC connector; using an intact detachable PC cord would instead
require a separately specified panel IEC inlet and a different cutout. Do not
force a plug through or enlarge the gland hole to fit it. Use compatible
commercial blanking plugs in unused entries. Four ports are retained from the
previous draft; final incoming/outgoing cord count and circuit layout remain open.

Manufacturer references (checked 2026-11-18):

- [M20 gland 53017030 and current 6–12 mm range](https://www.lapp.com/en_CA/ca/skintop-st-m-iso/skintop-str-m-iso/p/53017030).
- [ST-M catalogue, long-thread lengths and M12 53010000](https://products.lappgroup.com/online-catalogue/cable-glands/skintop-cable-glands-plastic-metric/standard/skintop-st-m.html).
- [GMP-GL-M locknuts and wrench sizes](https://products.lappgroup.com/online-catalogue/cable-glands/skintop-cable-gland-accessories-metric/counter-nuts/skintop-gmp-gl-m.html).
- [LAPP mounting-hole table](https://www.lapp.com/en_CA/ca/products/cable-glands/single-entries/c/113981): finished M20 hole 20.0–20.2 mm, M12 hole 12.0–12.2 mm.

## Bambu Lab P1S / H2C printing

Both parts fit either printer individually. The base is **214 × 95.27 × 46 mm**,
the lid **214 × 95.27 × 5 mm**, and the upright coupon **76 × 18 × 46 mm**.
Use Bambu Studio with the actual P1S or H2C printer/nozzle/plate/filament preset.
The [P1S specification](https://cdn1.bambulab.com/documentation/quick-start-2024-01-17/Quick-Start-P1S_en.pdf)
lists 256 × 256 × 256 mm; the
[H2C specification](https://blog.bambulab.com/bambu-lab-h2c-where-multi-material-vortek-system-meets-engineering-precision/)
lists 305 × 320 × 325 mm for single-nozzle printing. Center each part on its own
plate, away from excluded areas. No printer-specific sliced file is supplied.

For an **unpowered fit prototype**, use a 0.4 mm nozzle, 0.20 mm layers,
six wall loops, six top/bottom layers and 20% infill as starting settings.
PLA is suitable for checking shape only; this is not a mains-service material
recommendation. Import STLs in millimeters at **100% scale**. Print the base
floor-down, lid exterior-down (lip up), and coupon upright as exported.
Use a brim if necessary, especially for the coupon.

Print the coupon first using the same filament, orientation and settings as the
base. Horizontal circular bores can sag at the top; inspect the sliced overhangs
and use localized removable support if necessary. Remove support and measure
both axes of each hole. Carefully finish undersized bores to the manufacturer's
hole range; reject oversized or cracked parts. Verify the gland shoulder and
locknut seat flat, the thread engages fully, and the correct cable is retained.
A fitting's IP rating does not give the printed housing an IP rating.

## Export and inspect

From this directory, with OpenSCAD installed:

```sh
openscad --hardwarnings --export-format binstl -D 'part="base"' -o base-fit-check.stl enclosure.scad
openscad --hardwarnings --export-format binstl -D 'part="lid"' -o lid-fit-check.stl enclosure.scad
openscad --hardwarnings --export-format binstl -D 'part="coupon"' -o gland-fit-coupon.stl enclosure.scad
MPLCONFIGDIR=/tmp/smart-switch-mpl python check_and_preview.py
```

The optional Python mesh check/preview requires `numpy` and `matplotlib`.
Open the source in OpenSCAD and choose `assembly` for an exploded component
preview, or `layout` for a visual arrangement of both parts (not a printer plate).
`base`, `lid`, and `coupon` exports contain only the actual printed part.

## Fit-check printing and remaining work

Tune `lip_clearance` to the printer before assuming a final lid fit.

Before finishing the design, confirm:

1. Relay mounting-hole centers in both axes and the height measurement reference.
2. Super Mini board thickness/height and header installation, mounting method,
   antenna keepout, USB connector position, and access to BOOT/RESET.
3. Cable count/diameters, connector or gland dimensions, wiring clearance, and
   external power arrangement. A 12 V relay supply must not feed a 3.3 V GPIO.
4. Load/current and electrical construction: strain relief, terminal access,
   insulation distances, thermal behavior, protection, and enclosure material.

For the 120 V installation, use a suitably rated electrical enclosure or have the
complete construction evaluated; these prototype STLs do not establish compliance.
Material ratings from molded plastic do not automatically transfer to printed
parts, as explained by [UL Solutions](https://www.ul.com/news/ul-finds-safety-variability-3d-printed-plastic-parts).
Use these parts for unpowered fit checking while the electrical housing is resolved.
