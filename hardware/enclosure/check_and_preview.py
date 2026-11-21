"""Regenerate the legacy gland enclosure previews."""
from mesh_tools import *

mesh_data = {name: read_and_check(name) for name in
             ("base-fit-check.stl", "lid-fit-check.stl", "gland-fit-coupon.stl")}
base_size = np.ptp(mesh_data["base-fit-check.stl"][1], axis=0)
assert np.all(base_size < [250, 250, 250]), "Exceeds conservative P1S fit envelope"

fig = plt.figure(figsize=(15, 7), facecolor="#f3f5f7")
for index, (name, title) in enumerate([
    ("base-fit-check.stl", "BASE · relay cable entries + controller bay"),
    ("lid-fit-check.stl", "LID · inside face / locating lip"),
], start=1):
    triangles, bounds = mesh_data[name]
    ax = fig.add_subplot(1, 2, index, facecolor="#f3f5f7")
    ax.imshow(render_mesh(triangles))
    ax.set_axis_off()
    ax.set_title(title, fontsize=12, color="#223746", pad=0)

fig.suptitle("SMART SWITCH · ENCLOSURE FIT-CHECK DRAFT", fontsize=20,
             color="#223746", y=0.95)
fig.text(0.5, 0.08, f"{base_size[0]:g} × {base_size[1]:g} × {base_size[2]+3:g} mm assembled · dimensions in millimeters",
         ha="center", fontsize=12, color="#223746")
fig.text(0.5, 0.035,
         "Mounting-hole offsets provisional · controller mounts and physical gland fit pending · unpowered fit check only",
         ha="center", fontsize=10, color="#8b3d27")
fig.subplots_adjust(left=0.01, right=0.99, bottom=0.12, top=0.85, wspace=0.02)
fig.savefig(ROOT / "preview.png", dpi=160, facecolor=fig.get_facecolor())

base_triangles, _ = mesh_data["base-fit-check.stl"]
fig2 = plt.figure(figsize=(15, 7), facecolor="#f3f5f7")
for index, (direction, title) in enumerate([
    ((1, -1.6, 1.25), "FRONT / RIGHT · 4 × M20 gland mounts + M12 supply mount"),
    ((-1, 1.6, 1.25), "REAR · 14 × 8 USB-C opening in controller bay"),
], start=1):
    ax = fig2.add_subplot(1, 2, index)
    ax.imshow(render_mesh(base_triangles, direction))
    ax.set_axis_off()
    ax.set_title(title, fontsize=11, color="#223746")
fig2.suptitle("SMART SWITCH · CONNECTOR OPENINGS", fontsize=20, color="#223746", y=0.95)
fig2.text(0.5, 0.065,
          "Ø20.1 / Ø12.1 through-holes · 38 mm front pitch · 3 mm mounting walls",
          ha="center", fontsize=12, color="#223746")
fig2.text(0.5, 0.025,
          "Controller retention unfinished · unpowered fit-check draft",
          ha="center", fontsize=10, color="#8b3d27")
fig2.subplots_adjust(left=0.01, right=0.99, bottom=0.12, top=0.85, wspace=0.02)
fig2.savefig(ROOT / "connectors-preview.png", dpi=160, facecolor=fig2.get_facecolor())

fig3 = plt.figure(figsize=(10, 6), facecolor="#f3f5f7")
ax = fig3.add_subplot(111)
ax.imshow(render_mesh(mesh_data["gland-fit-coupon.stl"][0], (1,-1.6,1.25)))
ax.set_axis_off()
ax.set_title("PRINT FIRST · M20 (left) / M12 (right) gland fit coupon", color="#223746")
fig3.text(.5,.04,"76 × 18 × 46 mm · print upright as supplied · check real gland and locknut",ha="center")
fig3.savefig(ROOT / "gland-fit-coupon.png", dpi=160, facecolor=fig3.get_facecolor())
