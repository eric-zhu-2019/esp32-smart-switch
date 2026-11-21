"""Check exported binary STL topology and render an unpowered fit-check preview.

Run: MPLCONFIGDIR=/tmp/smart-switch-mpl python check_and_preview.py
Requires numpy and matplotlib. This does not validate physical/electrical safety.
"""

from collections import Counter
from pathlib import Path
import struct

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

ROOT = Path(__file__).resolve().parent


def read_and_check(name):
    data = (ROOT / name).read_bytes()
    count = struct.unpack_from("<I", data, 80)[0]
    assert len(data) == 84 + count * 50, "Expected binary STL"
    records = np.frombuffer(
        data, offset=84, count=count,
        dtype=[("normal", "<f4", (3,)), ("vertices", "<f4", (3, 3)), ("attr", "<u2")],
    )
    triangles = records["vertices"].astype(float)
    vertices, inverse = np.unique(triangles.reshape(-1, 3), axis=0, return_inverse=True)
    faces = inverse.reshape(-1, 3)
    edges = Counter()
    winding = Counter()
    parent = list(range(len(vertices)))

    def root(i):
        while parent[i] != i:
            parent[i] = parent[parent[i]]
            i = parent[i]
        return i

    for a, b, c in faces:
        for u, v in ((a, b), (b, c), (c, a)):
            edge = (min(u, v), max(u, v))
            edges[edge] += 1
            winding[edge] += 1 if u < v else -1
            parent[root(u)] = root(v)
    assert all(n == 2 for n in edges.values()), "Non-manifold or open edge"
    assert all(n == 0 for n in winding.values()), "Inconsistent face winding"
    assert len({root(i) for i in range(len(vertices))}) == 1, "Disconnected mesh"
    areas = np.linalg.norm(np.cross(triangles[:, 1]-triangles[:, 0],
                                    triangles[:, 2]-triangles[:, 0]), axis=1)
    assert np.all(areas > 1e-8), "Degenerate triangle"
    volume = np.einsum("ij,ij->i", triangles[:, 0],
                       np.cross(triangles[:, 1], triangles[:, 2])).sum()/6
    assert volume > 0, "Nonpositive volume"
    bounds = np.array([vertices.min(axis=0), vertices.max(axis=0)])
    print(f"{name}: closed, consistently wound, connected mesh; "
          f"{count} triangles; bounds {(bounds[1]-bounds[0]).round(2)} mm; "
          f"volume {volume/1000:.2f} cm3")
    return triangles, bounds


def render_mesh(triangles, direction=(1.0, -1.6, 2.4)):
    """Orthographic, depth-buffered rendering of the actual triangles."""
    width, height = 1000, 700
    view = np.array(direction, dtype=float)
    view /= np.linalg.norm(view)
    right = np.cross([0, 0, 1], view)
    right /= np.linalg.norm(right)
    up = np.cross(view, right)
    projected = triangles @ np.column_stack([right, up, view])
    low = projected.min(axis=(0, 1))
    high = projected.max(axis=(0, 1))
    scale = min((width-60)/(high[0]-low[0]), (height-60)/(high[1]-low[1]))
    projected[:, :, 0] = (projected[:, :, 0]-(low[0]+high[0])/2)*scale+width/2
    projected[:, :, 1] = -(projected[:, :, 1]-(low[1]+high[1])/2)*scale+height/2
    depth = np.full((height, width), -np.inf)
    canvas = np.ones((height, width, 3))*np.array([243, 245, 247])/255
    light = np.array([-0.4, -0.5, 1.0])
    light /= np.linalg.norm(light)
    for original, face in zip(triangles, projected):
        normal = np.cross(original[1]-original[0], original[2]-original[0])
        normal /= np.linalg.norm(normal)
        shade = 0.5+0.5*max(0, normal @ light)
        color = np.array([137, 169, 188])/255*shade
        x0, y0 = np.maximum(np.floor(face[:, :2].min(axis=0)).astype(int), 0)
        x1, y1 = np.minimum(np.ceil(face[:, :2].max(axis=0)).astype(int), [width-1, height-1])
        a, b, c = face
        denominator = (b[1]-c[1])*(a[0]-c[0])+(c[0]-b[0])*(a[1]-c[1])
        if abs(denominator) < 1e-9:
            continue
        yy, xx = np.mgrid[y0:y1+1, x0:x1+1]
        w0 = ((b[1]-c[1])*(xx-c[0])+(c[0]-b[0])*(yy-c[1]))/denominator
        w1 = ((c[1]-a[1])*(xx-c[0])+(a[0]-c[0])*(yy-c[1]))/denominator
        w2 = 1-w0-w1
        z = w0*a[2]+w1*b[2]+w2*c[2]
        region = depth[y0:y1+1, x0:x1+1]
        mask = (w0 >= -1e-8) & (w1 >= -1e-8) & (w2 >= -1e-8) & (z > region)
        region[mask] = z[mask]
        canvas[y0:y1+1, x0:x1+1][mask] = color
    return canvas


