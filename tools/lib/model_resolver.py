"""Model Resolver.

Reads `assets/minecraft/models/block/*.json`, follows the `parent` chain,
merges `textures`, and resolves every `elements` cuboid into engine-ready
*face geometry*: for each visible face we precompute

    p0       one corner of the face   (the texture-UV origin, u=0 v=0)
    edge_u   in-plane vector to u=1    (length = face width in 1/16 units)
    edge_v   in-plane vector to v=1    (length = face height)
    n        outward unit normal
    uv       [u1,v1,u2,v2] pixel bounds into the face's texture
    tex      texture variable ("#side", later resolved to a texture key)
    rot      face uv rotation (0/90/180/270)

This is exactly the data the Eyedropper's *secondary* virtual raycast
(Pillar 4.1 Step 3) and the OBB/SAT hunter math (Pillar 7) consume, so all of
the trigonometry happens once, here, in Python.

Face UV convention (self-consistent, documented in NBT_SCHEMA.md):
  u increases left->right, v increases top->bottom, normals point outward.
"""
from __future__ import annotations
from typing import Optional
import json
import math
import os

# direction -> (p0_corner, u_dir, v_dir, normal) expressed via box dims.
# fx,fy,fz = from ; tx,ty,tz = to ; dx,dy,dz = sizes.
_FACES = ("north", "south", "west", "east", "up", "down")


def _face_geometry(d: str, f: list[float], t: list[float]):
    fx, fy, fz = f
    tx, ty, tz = t
    dx, dy, dz = tx - fx, ty - fy, tz - fz
    if d == "north":   # -Z
        return [fx, ty, fz], [dx, 0, 0], [0, -dy, 0], [0, 0, -1]
    if d == "south":   # +Z
        return [tx, ty, tz], [-dx, 0, 0], [0, -dy, 0], [0, 0, 1]
    if d == "west":    # -X
        return [fx, ty, tz], [0, 0, -dz], [0, -dy, 0], [-1, 0, 0]
    if d == "east":    # +X
        return [tx, ty, fz], [0, 0, dz], [0, -dy, 0], [1, 0, 0]
    if d == "up":      # +Y
        return [fx, ty, tz], [dx, 0, 0], [0, 0, -dz], [0, 1, 0]
    if d == "down":    # -Y
        return [fx, fy, fz], [dx, 0, 0], [0, 0, dz], [0, -1, 0]
    raise ValueError(d)


def _default_uv(d: str, f: list[float], t: list[float]) -> list[float]:
    fx, fy, fz = f
    tx, ty, tz = t
    # Mirrors vanilla auto-uv: project the box onto the face plane.
    if d in ("north", "south"):
        return [fx, 16 - ty, tx, 16 - fy]
    if d in ("east", "west"):
        return [fz, 16 - ty, tz, 16 - fy]
    if d in ("up", "down"):
        return [fx, fz, tx, tz]
    raise ValueError(d)


def _rotate_point(p, origin, axis, angle_deg):
    """Rotate point p about `origin` around a principal axis by angle (deg)."""
    a = math.radians(angle_deg)
    ca, sa = math.cos(a), math.sin(a)
    x, y, z = p[0] - origin[0], p[1] - origin[1], p[2] - origin[2]
    if axis == "x":
        y, z = y * ca - z * sa, y * sa + z * ca
    elif axis == "y":
        x, z = x * ca + z * sa, -x * sa + z * ca
    elif axis == "z":
        x, y = x * ca - y * sa, x * sa + y * ca
    return [x + origin[0], y + origin[1], z + origin[2]]


def _rotate_vec(v, axis, angle_deg):
    return _rotate_point(v, [0, 0, 0], axis, angle_deg)


def _apply_rotation(rot, p0, eu, ev, n):
    """Apply an element rotation to the face frame. Supports BOTH vanilla forms:
      * single axis: {origin, axis:"x|y|z", angle}
      * Euler (newer templates, e.g. hanging signs): {origin, x, y, z}
        - applied X then Y then Z about the shared origin.
    `rescale` is a render-only UV hint and is ignored for hit geometry.
    """
    o = rot.get("origin", [8, 8, 8])
    if "axis" in rot:
        steps = [(rot["axis"], float(rot.get("angle", 0)))]
    else:
        steps = [(ax, float(rot[ax])) for ax in ("x", "y", "z")
                 if ax in rot and rot[ax]]
    for ax, ang in steps:
        p0 = _rotate_point(p0, o, ax, ang)
        eu = _rotate_vec(eu, ax, ang)
        ev = _rotate_vec(ev, ax, ang)
        n = _rotate_vec(n, ax, ang)
    return p0, eu, ev, n


def _normalize(v):
    m = math.sqrt(sum(c * c for c in v)) or 1.0
    return [round(c / m, 6) for c in v]


class ResolvedModel:
    def __init__(self, model_id: str):
        self.id = model_id                # "block/oak_stairs"
        self.parent: Optional[str] = None
        self.textures: dict[str, str] = {}
        self.elements: list[dict] = []    # engine face-geometry form

    def to_nbt(self) -> dict:
        return {"textures": self.textures, "elements": self.elements}


class ModelLibrary:
    def __init__(self, models_root: str):
        self.root = models_root
        self._models_dir = os.path.dirname(models_root)   # .../models
        self._raw: dict[str, dict] = {}
        self._resolved: dict[str, ResolvedModel] = {}
        self.missing: set[str] = set()                    # parents not on disk

    def _load_raw(self, model_id: str) -> dict:
        if model_id in self._raw:
            return self._raw[model_id]
        # models_root = .../models/block ; model_id is like "block/foo".
        path = os.path.join(self._models_dir, model_id + ".json")
        with open(path, "r", encoding="utf-8") as fh:
            data = json.load(fh)
        self._raw[model_id] = data
        return data

    def resolve(self, model_id: str) -> ResolvedModel:
        if model_id in self._resolved:
            return self._resolved[model_id]
        rm = ResolvedModel(model_id)
        chain: list[dict] = []
        cur: Optional[str] = model_id
        guard = 0
        while cur is not None and guard < 16:
            guard += 1
            try:
                data = self._load_raw(cur)
            except FileNotFoundError:
                self.missing.add(cur)
                break
            chain.append(data)
            cur = self._strip_ns(data.get("parent"))
        # Merge child-over-parent: walk parents first.
        for data in reversed(chain):
            rm.textures.update(data.get("textures", {}))
        # Elements come from the nearest ancestor that defines them.
        for data in chain:
            if "elements" in data:
                rm.elements = self._resolve_elements(data["elements"])
                break
        # Flatten texture variables so every value is a final path (no '#'
        # chains remain). The face list only needs a single lookup at runtime,
        # and the SHAPE stays texture-agnostic (shared across wood types).
        rm.textures = self._flatten_textures(rm.textures)
        self._resolved[model_id] = rm
        return rm

    @staticmethod
    def _flatten_textures(textures: dict[str, str]) -> dict[str, str]:
        out = {}
        for k in textures:
            v = textures[k]
            seen = set()
            while isinstance(v, str) and v.startswith("#") and v not in seen:
                seen.add(v)
                v = textures.get(v[1:], v)
            out[k] = v.split(":", 1)[-1] if isinstance(v, str) else v
        return out

    @staticmethod
    def _strip_ns(parent: Optional[str]) -> Optional[str]:
        if not parent:
            return None
        p = parent.split(":", 1)[-1]
        if p.startswith("builtin/"):
            return None
        return p

    def _resolve_elements(self, elements: list[dict]) -> list[dict]:
        out = []
        for el in elements:
            f = [float(c) for c in el["from"]]
            t = [float(c) for c in el["to"]]
            rot = el.get("rotation")
            faces_out = {}
            for d, face in el.get("faces", {}).items():
                if d not in _FACES:
                    continue
                p0, eu, ev, n = _face_geometry(d, f, t)
                if rot:
                    p0, eu, ev, n = _apply_rotation(rot, p0, eu, ev, n)
                uv = face.get("uv") or _default_uv(d, f, t)
                tex = face.get("texture", "#missing")
                faces_out[d] = {
                    "p0": [round(c, 5) for c in p0],
                    "eu": [round(c, 5) for c in eu],
                    "ev": [round(c, 5) for c in ev],
                    "n": _normalize(n),
                    "uv": [float(round(c, 4)) for c in uv],
                    "tex": tex,
                    "var": tex.lstrip("#"),
                    "rot": int(face.get("rotation", 0)),
                }
            out.append({"from": f, "to": t, "faces": faces_out})
        return out
