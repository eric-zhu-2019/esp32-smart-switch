"""Validate the socket-version STL exports and render actual mesh previews."""
from mesh_tools import *

names = [f"socket-{part}-fit-check.stl" for part in ("base", "lid", "guard", "coupon")]
meshes = {name: read_and_check(name) for name in names}
for triangles,bounds in meshes.values():
    assert np.all(np.ptp(bounds,axis=0)<[250,250,250]), "Part exceeds conservative P1S envelope"

base = meshes[names[0]][0]
fig, axes = plt.subplots(1,2,figsize=(15,7),facecolor="#f3f5f7")
for ax,direction,title in zip(axes,[(-1,-1.6,1.45),(1,1.6,1.45)],
    ["FRONT / LEFT · outlets 1–2 + C14 inlet", "REAR / RIGHT · outlets 3–4 + USB / low-voltage entry"]):
    ax.imshow(render_mesh(base,direction)); ax.set_axis_off(); ax.set_title(title,fontsize=11,color="#223746")
fig.suptitle("SMART SWITCH · REINFORCED REFERENCE CONNECTOR MOUNTS",fontsize=19,color="#223746",y=.96)
fig.text(.5,.075,"200 × 180 × 73 mm · 6 mm mount panels · 4 mm gussets and floor · continuous top rim",ha="center",fontsize=12,color="#223746")
fig.text(.5,.03,"Unpowered prototype · Amazon connector cutouts pending · mechanical load capacity untested",ha="center",fontsize=10,color="#8b3d27")
fig.subplots_adjust(left=.01,right=.99,bottom=.13,top=.85,wspace=.02)
fig.savefig(ROOT / "socket-connectors-preview.png",dpi=160,facecolor=fig.get_facecolor())

fig, axes=plt.subplots(1,3,figsize=(15,6),facecolor="#f3f5f7")
for ax,name,title in zip(axes,names[1:],["LID · exterior face down", "INNER GUARD · removable", "PRINT FIRST · outlet + inlet coupon"]):
    ax.imshow(render_mesh(meshes[name][0],(1,-1.6,1.8))); ax.set_axis_off(); ax.set_title(title,fontsize=10,color="#223746")
fig.suptitle("SOCKET ENCLOSURE · PRINTED PARTS",fontsize=20,color="#223746",y=.95)
fig.text(.5,.045,"Print separately at 100% scale · coupon reproduces reinforced 6 mm mounting areas",ha="center",fontsize=11,color="#223746")
fig.subplots_adjust(left=.01,right=.99,bottom=.12,top=.85,wspace=.02)
fig.savefig(ROOT / "socket-parts-preview.png",dpi=160,facecolor=fig.get_facecolor())
