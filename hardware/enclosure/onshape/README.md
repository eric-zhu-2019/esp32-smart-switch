# Onshape revision (2026-11-20)

Onshape document **Smart switch enclosure** (public, Free plan):
<https://cad.onshape.com/documents/940b394ae4e8ff53d033b902/w/f1eb790a62af46d396a671a9/e/5a41156f0f002ef10b1c862c>

- `smart-switch-enclosure.fs` is the source of the custom feature in the document's
  Feature Studio 1. Edit here, then paste into Onshape (or the reverse) and keep
  the two in step. Std version 3132.
- Part Studio 1 contains one instance of the feature producing parts **Base** and
  **Lid** with the defaults: 235 × 180 × 70 mm base, 4 mm walls/floor, 6 mm lid,
  outlet pitch 46.04 mm, 40 mm controller bay, 12.7 mm fuse holes, lid exploded
  25 mm above the base.
- `onshape-preview.jpg` is a screenshot of the generated parts.
- `smart-switch-base.stl` and `smart-switch-lid.stl` were exported from Onshape on
  2026-11-20 (binary STL, millimetres, fine resolution) and copied here.
- `check_onshape_exports.py` checks both STLs and renders `onshape-mesh-preview.png`.

## Export check, 2026-11-20

```sh
MPLCONFIGDIR=/tmp/smart-switch-mpl python onshape/check_onshape_exports.py   # from hardware/enclosure
```

| File | Result | Triangles | Bounds, mm | Volume |
| --- | --- | --- | --- | --- |
| `smart-switch-base.stl` | closed, consistently wound, connected | 14178 | 235 × 180 × 70 | 423.24 cm³ |
| `smart-switch-lid.stl` | closed, consistently wound, connected | 13950 | 235 × 180 × 8 | 201.67 cm³ |

Both fit a conservative 250 mm print envelope. 63 point probes confirmed the four
33.3 × 66.8 mm lid openings at 46.04 mm pitch with their plate-screw holes and
blind yoke pilots, the six lid screw holes and lip, the 42 × 27 mm inlet opening
with 50 mm holes on a 6 mm pad, the four fuse holes, corner posts and pilots,
relay standoffs and pilots, divider passage, USB opening and low-voltage entry.
Geometry only: no print, connector fit, load or electrical validation.

Layout produced by the feature (see `../selected-connectors.md` for the sources):

- Four BESTTEN LD-3012TR decorator receptacles face-up in the lid, one row at
  46.04 mm pitch, 33.3 × 66.8 mm openings, Ø3.7 through holes at 96.8 mm for the
  6-32 plate screws, Ø2.8 blind pilots from the underside at 83.3 mm for the yoke
  screws. The lid acts as the wall plate.
- Acouto C14 inlet with switch in the left wall: 42 × 27 mm opening, Ø3.5 holes
  at 50 mm, on a 6 mm thick pad.
- Optional Ø12.7 mm fuse-holder hole in the front wall under each outlet. Replace
  with the chosen holder's own cutout (usually a round hole with a flat).
- Six lid posts (Ø8, 2.5 mm pilots), lid lip, relay standoffs on the provisional
  72.64 × 49.27 mm pattern, divider with wire passage, USB opening and Ø12.1 mm
  low-voltage entry carried over from the OpenSCAD version.

Not yet done: corner radii, local lid thickening around openings, printing
orientation checks, STL export, physical coupon. Seller dimensions only; measure
the received parts. Unpowered fit prototype; no mains suitability is asserted.
