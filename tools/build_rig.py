#!/usr/bin/env python3
"""Meccha Chameleon - Pillar 5 rig generator.

Emits the spawn .mcfunction files for the custom player rig. The heavy,
per-pixel *static* affine transforms are computed here (matching the Pillar-2
"precompute in Python" philosophy) and baked into each text_display's
`transformation` (decomposed translation/left_rotation/scale).

Key rules from the spec:
  * Pixels are text_display entities, each exactly 1/16 block, scaled by the
    rig scale (hider = 1/3 of the Hunter -> fewer pixels, ~181 total).
  * Every pixel of one cuboid shares ONE origin entity (a marker) and the same
    world rotation; only the baked per-pixel transform differs. Posing the rig
    is therefore just /tp-ing that shared origin (see rig/apply_pose).
  * Each pixel gets unique tags: cb_<cuboid>, face_<dir>, u_<i>, v_<j>.

Also emits, per cuboid:
  * the origin marker carrying `data.wfaces` (block-space face planes relative
    to the origin) consumed by the Paintbrush (Pillar 4.2), Shading (Pillar 6)
    and the Hunter OBB test (Pillar 7).
  * 6 stretched overlay displays (one per face) for directional shading.

Usage:  python tools/build_rig.py --datapack . [--scale 0.333]
"""
from __future__ import annotations
import argparse
import math
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "lib"))
from mcfunction_writer import FunctionWriter, snbt, F        # noqa: E402

# Humanoid rig: name -> (offset-from-root [bx,by,bz] in blocks at full scale,
# size in pixels [w,h,d]). Resolutions = sizes (1 pixel == 1/16 block full).
RIG = {
    "head":   ([0.0, 1.5, 0.0], [8, 8, 8]),
    "torso":  ([0.0, 0.75, 0.0], [8, 12, 4]),
    "arm_l":  ([0.375, 0.75, 0.0], [4, 12, 4]),
    "arm_r":  ([-0.375, 0.75, 0.0], [4, 12, 4]),
    "leg_l":  ([0.125, 0.0, 0.0], [4, 12, 4]),
    "leg_r":  ([-0.125, 0.0, 0.0], [4, 12, 4]),
}

# Face dir -> (p0 corner, u edge, v edge, normal) in PIXEL units (0..size).
def _faces(w, h, d):
    return {
        "north": ([w, h, 0], [-w, 0, 0], [0, -h, 0], [0, 0, -1], (w, h)),
        "south": ([0, h, d], [w, 0, 0], [0, -h, 0], [0, 0, 1], (w, h)),
        "west":  ([0, h, 0], [0, 0, d], [0, -h, 0], [-1, 0, 0], (d, h)),
        "east":  ([w, h, d], [0, 0, -d], [0, -h, 0], [1, 0, 0], (d, h)),
        "top":   ([0, h, 0], [w, 0, 0], [0, 0, d], [0, 1, 0], (w, d)),
        "bottom":([0, 0, d], [w, 0, 0], [0, 0, -d], [0, -1, 0], (w, d)),
    }


def _quat_from_normal(n):
    """Quaternion rotating the display's default +Z facing onto normal n,
    keeping world-up as the secondary axis where possible."""
    nz = _norm(n)
    up = [0, 1, 0] if abs(nz[1]) < 0.99 else [0, 0, 1]
    rx = _norm(_cross(up, nz))
    ry = _cross(nz, rx)
    # Basis matrix columns (rx, ry, nz) -> quaternion.
    m = [rx, ry, nz]
    return _mat_to_quat(m)


def _norm(v):
    m = math.sqrt(sum(c * c for c in v)) or 1.0
    return [c / m for c in v]


def _cross(a, b):
    return [a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2], a[0]*b[1]-a[1]*b[0]]


def _mat_to_quat(m):
    # m is [col0, col1, col2]; build row-major r[i][j] = m[j][i].
    r = [[m[0][0], m[1][0], m[2][0]],
         [m[0][1], m[1][1], m[2][1]],
         [m[0][2], m[1][2], m[2][2]]]
    tr = r[0][0] + r[1][1] + r[2][2]
    if tr > 0:
        s = math.sqrt(tr + 1.0) * 2
        w = 0.25 * s
        x = (r[2][1] - r[1][2]) / s
        y = (r[0][2] - r[2][0]) / s
        z = (r[1][0] - r[0][1]) / s
    elif r[0][0] > r[1][1] and r[0][0] > r[2][2]:
        s = math.sqrt(1.0 + r[0][0] - r[1][1] - r[2][2]) * 2
        w = (r[2][1] - r[1][2]) / s
        x = 0.25 * s
        y = (r[0][1] + r[1][0]) / s
        z = (r[0][2] + r[2][0]) / s
    elif r[1][1] > r[2][2]:
        s = math.sqrt(1.0 + r[1][1] - r[0][0] - r[2][2]) * 2
        w = (r[0][2] - r[2][0]) / s
        x = (r[0][1] + r[1][0]) / s
        y = 0.25 * s
        z = (r[1][2] + r[2][1]) / s
    else:
        s = math.sqrt(1.0 + r[2][2] - r[0][0] - r[1][1]) * 2
        w = (r[1][0] - r[0][1]) / s
        x = (r[0][2] + r[2][0]) / s
        y = (r[1][2] + r[2][1]) / s
        z = 0.25 * s
    return [round(x, 5), round(y, 5), round(z, 5), round(w, 5)]


def build(datapack, scale):
    # Each pixel is ALWAYS exactly 1/16 block (spec). The rig scale shrinks the
    # model by tiling FEWER pixels per cuboid (res = round(size * scale)), so a
    # 1/3-scale hider drops from ~1632 to ~181 pixels while every pixel stays
    # 1/16 block. The Hunter rig is the same generator with scale = 1.0.
    px = 1.0 / 16.0
    spawn = FunctionWriter("meccha:rig/spawn",
                           "AUTO-GENERATED rig spawner. Run positioned at the rig root.")
    spawn.comment(f"rig scale = {scale} (hider = 1/3 of Hunter); pixel = 1/16 block")
    total = 0
    for name, (off, (w, h, d)) in RIG.items():
        rw = max(1, round(w * scale))
        rh = max(1, round(h * scale))
        rd = max(1, round(d * scale))
        fn, n = _build_cuboid(datapack, name, off, rw, rh, rd, scale, px)
        total += n
        spawn.raw(f"function {fn}")
    spawn.write(datapack)
    print(f"[meccha-rig] cuboids={len(RIG)} pixels={total} scale={scale}")


def _build_cuboid(datapack, name, off, w, h, d, scale, px):
    fid = f"meccha:rig/spawn_{name}"
    fn = FunctionWriter(fid, f"AUTO-GENERATED cuboid '{name}' ({w}x{h}x{d} px)")
    ox, oy, oz = [c for c in off]

    # ---- origin marker with world-space (origin-relative) face planes ----
    wfaces = []
    for dirn, (p0, eu, ev, nrm, (ru, rv)) in _faces(w, h, d).items():
        wfaces.append({
            "face": dirn,
            "p0": [round(p0[0] * px, 5), round(p0[1] * px, 5), round(p0[2] * px, 5)],
            "eu": [round(eu[0] * px, 5), round(eu[1] * px, 5), round(eu[2] * px, 5)],
            "ev": [round(ev[0] * px, 5), round(ev[1] * px, 5), round(ev[2] * px, 5)],
            "n": [float(c) for c in nrm],
            "res": [ru, rv],
        })
    marker = {
        "Tags": ["meccha_cuboid", "meccha_rig_part", "rig_unassigned", f"cb_{name}"],
        "data": {"cuboid": name, "size": [w, h, d], "scale": int(scale * 1000),
                 # OBB half-extents (blocks) and local centre for Pillar 7.
                 "half": [round(w*px/2, 5), round(h*px/2, 5), round(d*px/2, 5)],
                 "cl": [round(w*px/2, 5), round(h*px/2, 5), round(d*px/2, 5)],
                 "hp": 3,
                 "wfaces": wfaces},
    }
    fn.raw(f"summon minecraft:marker ~{ox:.4f} ~{oy:.4f} ~{oz:.4f} {snbt(marker)}")

    # ---- pixels: one text_display per (face,i,j), transform baked ----
    count = 0
    
    # Text display scale adjustments and pivot parameters
    pixel_scale_xy = 5.7
    text_pivot_x = 0.0135
    text_pivot_y = 0.15
    
    for dirn, (p0, eu, ev, nrm, (ru, rv)) in _faces(w, h, d).items():
        # Compute rotation basis vectors to accurately translate the pivot offset
        nz = _norm(nrm)
        up = [0, 1, 0] if abs(nz[1]) < 0.99 else [0, 0, 1]
        rx = _norm(_cross(up, nz))
        ry = _cross(nz, rx) # Local Y-axis in world space
        
        quat = _mat_to_quat([rx, ry, nz])
        
        # Calculate the translation shift needed to counter the scale's pull towards the pivot
        # Delta = Old Visual Offset - New Visual Offset
        local_delta_x = (px * text_pivot_x) - (px * pixel_scale_xy * text_pivot_x)
        local_delta_y = (px * text_pivot_y) - (px * pixel_scale_xy * text_pivot_y)
        shift_x = rx[0] * local_delta_x + ry[0] * local_delta_y
        shift_y = rx[1] * local_delta_x + ry[1] * local_delta_y
        shift_z = rx[2] * local_delta_x + ry[2] * local_delta_y

        for j in range(rv):
            for i in range(ru):
                # pixel centre in block space relative to the cuboid origin
                cx = (p0[0] + (eu[0]*(i+0.5)/ru) + (ev[0]*(j+0.5)/rv)) * px
                cy = (p0[1] + (eu[1]*(i+0.5)/ru) + (ev[1]*(j+0.5)/rv)) * px
                cz = (p0[2] + (eu[2]*(i+0.5)/ru) + (ev[2]*(j+0.5)/rv)) * px
                
                # Apply the compensational shift to our translation
                tx = cx + shift_x
                ty = cy + shift_y
                tz = cz + shift_z
                
                transform = {
                    "translation": [F(round(tx, 5)), F(round(ty, 5)), F(round(tz, 5))],
                    "left_rotation": [F(q) for q in quat],
                    "scale": [F(round(px * pixel_scale_xy, 5)), F(round(px * pixel_scale_xy, 5)), F(round(px, 5))],
                    "right_rotation": [F(0.0), F(0.0), F(0.0), F(1.0)],
                }
                disp = {
                    "Tags": ["meccha_pixel", "meccha_rig_part", "rig_unassigned",
                             f"cb_{name}", f"face_{dirn}", f"u_{i}", f"v_{j}"],
                    "text": {"text":"⬛","color":"#FFC5C5"},
                    "background": 0,
                    "billboard": "fixed",
                    "transformation": transform,
                    "Glowing": False,
                    "brightness": {"sky": 15, "block": 15},
                }
                fn.raw(f"summon minecraft:text_display ~{ox:.4f} ~{oy:.4f} ~{oz:.4f} {snbt(disp)}")
                count += 1

        # ---- one stretched shading overlay per face (Pillar 6) ----
        oquat = _quat_from_normal(nrm)
        ctr_x = (p0[0] + eu[0]*0.5 + ev[0]*0.5) * px
        ctr_y = (p0[1] + eu[1]*0.5 + ev[1]*0.5) * px
        ctr_z = (p0[2] + eu[2]*0.5 + ev[2]*0.5) * px
        overlay = {
            "Tags": ["meccha_overlay", "meccha_rig_part", "rig_unassigned",
                     f"cb_{name}", f"face_{dirn}"],
            "text": {"text":"⬛","color":"#B9FFB3"},
            "background": 0,
            "billboard": "fixed",
            "transformation": {
                "translation": [F(round(ctr_x, 5)), F(round(ctr_y, 5)), F(round(ctr_z + 0.001, 5))],
                "left_rotation": [F(q) for q in oquat],
                "scale": [F(round(abs(_len(eu)) * px, 5)), F(round(abs(_len(ev)) * px, 5)), F(1.0)],
                "right_rotation": [F(0.0), F(0.0), F(0.0), F(1.0)],
            },
        }
        fn.raw(f"summon minecraft:text_display ~{ox:.4f} ~{oy:.4f} ~{oz:.4f} {snbt(overlay)}")

    fn.comment(f"pixels in this cuboid: {count}")
    fn.write(datapack)
    return fid, count


def _len(v):
    return math.sqrt(sum(c*c for c in v))


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--datapack", required=True)
    ap.add_argument("--scale", type=float, default=1.0/3.0,
                    help="rig scale; hider = 1/3 of Hunter")
    args = ap.parse_args()
    build(args.datapack, args.scale)