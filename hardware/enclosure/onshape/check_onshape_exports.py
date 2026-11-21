"""Check the Onshape STL exports of the Smart Switch Enclosure feature.

Run from hardware/enclosure:
    MPLCONFIGDIR=/tmp/smart-switch-mpl python onshape/check_onshape_exports.py
Topology checks come from mesh_tools.py. Probe points verify that the expected
openings exist at the expected places in the exported meshes. Geometry only.
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from mesh_tools import *  # noqa: E402,F401

HERE = Path(__file__).resolve().parent
names = ["onshape/smart-switch-base.stl", "onshape/smart-switch-lid.stl"]
meshes = {n: read_and_check(n) for n in names}
for tri, bounds in meshes.values():
    assert np.all(np.ptp(bounds, axis=0) < [250, 250, 250]), "Exceeds conservative P1S envelope"


def inside(triangles, p, direction=(0.37, 0.61, 0.70)):
    """Parity ray cast from p along direction (Moller-Trumbore, vectorised)."""
    d = np.array(direction, float)
    v0, v1, v2 = triangles[:, 0], triangles[:, 1], triangles[:, 2]
    e1, e2 = v1 - v0, v2 - v0
    h = np.cross(d, e2)
    a = np.einsum("ij,ij->i", e1, h)
    ok = np.abs(a) > 1e-12
    f = np.zeros_like(a); f[ok] = 1 / a[ok]
    s = np.array(p, float) - v0
    u = f * np.einsum("ij,ij->i", s, h)
    q = np.cross(s, e1)
    v = f * np.einsum("j,ij->i", d, q)
    t = f * np.einsum("ij,ij->i", e2, q)
    hit = ok & (u >= 0) & (v >= 0) & (u + v <= 1) & (t > 1e-9)
    return hit.sum() % 2 == 1


# Expected layout for the default parameters (see smart-switch-enclosure.fs).
X, Y, H, w, lidT, explode = 235, 180, 70, 4, 6, 25
pitch, bayW = 46.04, 40
divX = X - w - bayW - 2.4
rowCx = (w + divX) / 2
centers = [rowCx + (i - 1.5) * pitch for i in range(4)]
lidZ = H + explode
base, lid = meshes[names[0]][0], meshes[names[1]][0]

probes = []
# Lid: openings 33.3 x 66.8, plate screw holes at +/-48.4, pilots at +/-41.65 (blind, 5 deep).
for cx in centers:
    probes += [(lid, (cx, 90, lidZ + 3), False, "lid opening centre"),
               (lid, (cx + 16.4, 90, lidZ + 3), False, "lid opening inside long edge"),
               (lid, (cx + 16.9, 90, lidZ + 3), True, "lid solid beyond long edge"),
               (lid, (cx, 90 + 33.1, lidZ + 3), False, "lid opening inside short edge"),
               (lid, (cx, 90 + 33.7, lidZ + 3), True, "lid solid beyond short edge"),
               (lid, (cx, 90 + 48.4, lidZ + 3), False, "plate screw hole"),
               (lid, (cx, 90 + 41.65, lidZ + 2), False, "yoke pilot (blind)"),
               (lid, (cx, 90 + 41.65, lidZ + 5.5), True, "yoke pilot skin intact")]
probes += [(lid, (6, 6, lidZ + 3), False, "lid corner screw hole"),
           (lid, (X / 2, 6, lidZ + 3), False, "lid mid screw hole"),
           (lid, (60, 5, lidZ - 1), True, "lid lip present"),
           (lid, (X / 2, 20, lidZ - 1), False, "no lip inboard")]
# Base: inlet 42 x 27 at (y 90, z 35) through a 6 mm panel; holes at y 65 / 115.
probes += [(base, (3, 90, 35), False, "inlet opening centre"),
           (base, (3, 90 + 20.8, 35), False, "inlet inside long edge"),
           (base, (3, 90 + 21.3, 35), True, "inlet solid beyond long edge"),
           (base, (3, 90, 35 + 13.3), False, "inlet inside short edge"),
           (base, (3, 90, 35 + 13.8), True, "inlet solid beyond short edge"),
           (base, (5, 90, 35 + 20), True, "inlet pad is 6 mm thick"),
           (base, (7, 90, 35 + 20), False, "cavity beyond the pad"),
           (base, (3, 65, 35), False, "inlet screw hole"),
           (base, (3, 115, 35), False, "inlet screw hole"),
           (base, (6, 6, 50), True, "corner post"),
           (base, (6, 6, 65), False, "corner post pilot"),
           (base, (X - w - bayW / 2, Y - 2, 12), False, "USB opening"),
           (base, (X - 2, 65, 23), False, "low-voltage entry"),
           (base, (divX + 1.2, 90, 18), False, "divider wire passage"),
           (base, (divX + 1.2, 90, 40), True, "divider solid"),
           (base, (60 + 2.85 + 2.4, 65 + 2.85, 7), True, "relay standoff"),
           (base, (60 + 2.85, 65 + 2.85, 8.5), False, "relay pilot"),
           (base, (X / 2, 90, 2), True, "floor"),
           (base, (X / 2, 90, 40), False, "cavity")]
for cx in centers:
    probes += [(base, (cx, 2, 35), False, "fuse hole"),
               (base, (cx, 2, 35 + 6.6), True, "wall beyond fuse hole")]

failures = 0
for mesh, p, expect_solid, label in probes:
    got = inside(mesh, p)
    mark = "ok " if got == expect_solid else "BAD"
    if got != expect_solid:
        failures += 1
    print(f"{mark} {label:32s} at {tuple(round(c, 2) for c in p)} -> {'solid' if got else 'empty'}")
print(f"{len(probes)} probes, {failures} unexpected")

fig, axes = plt.subplots(1, 2, figsize=(15, 6.5), facecolor="#f3f5f7")
for ax, name, direction, title in zip(axes, names, [(-1, -1.6, 1.45), (1, -1.6, 2.2)],
                                      ["BASE · inlet wall and fuse holes", "LID · four decorator openings"]):
    ax.imshow(render_mesh(meshes[name][0], direction)); ax.set_axis_off()
    ax.set_title(title, fontsize=11, color="#223746")
fig.suptitle("SMART SWITCH · ONSHAPE EXPORT CHECK", fontsize=19, color="#223746", y=.96)
fig.text(.5, .04, "Unpowered fit prototype · seller-stated connector dimensions · no load rating",
         ha="center", fontsize=10, color="#8b3d27")
fig.subplots_adjust(left=.01, right=.99, bottom=.1, top=.86, wspace=.02)
fig.savefig(HERE / "onshape-mesh-preview.png", dpi=160, facecolor=fig.get_facecolor())
sys.exit(1 if failures else 0)
