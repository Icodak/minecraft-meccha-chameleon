"""Shape Grouper (Model-to-Shape/UV source data).

Many models share identical geometry and differ only by textures (every wood
type of stairs is the same cuboids). Storing the elements once per *shape* and
having models reference a generic shape id collapses thousands of duplicate
geometries into a handful (Pillar 2.3), drastically shrinking the NBT loaded
into `storage`.

We hash the resolved face-geometry (texture variables are kept as their
*variable name*, not the resolved texture, so geometry-equal models collide)
and assign a canonical name when we recognise a well-known silhouette.
"""
from __future__ import annotations
import hashlib
import json

# Canonical fingerprints -> friendly names. Computed lazily from known vanilla
# parents; anything unrecognised gets a stable "shape_<8 hex>" id.
_KNOWN_PARENTS = {
    "block/cube_all": "full_block",
    "block/cube": "full_block",
    "block/slab": "slab_bottom",
    "block/slab_top": "slab_top",
    "block/stairs": "stairs",
    "block/inner_stairs": "stairs_inner",
    "block/outer_stairs": "stairs_outer",
    "block/cross": "cross",
    "block/fence_post": "fence_post",
}


def _signature(elements: list[dict]) -> str:
    """Stable hash of geometry only (positions, edges, normals, uv, rot)."""
    skel = []
    for el in elements:
        faces = {}
        for d, f in sorted(el["faces"].items()):
            faces[d] = {
                "p0": f["p0"], "eu": f["eu"], "ev": f["ev"],
                "n": f["n"], "uv": f["uv"], "rot": f["rot"],
            }
        skel.append({"from": el["from"], "to": el["to"], "faces": faces})
    blob = json.dumps(skel, sort_keys=True, separators=(",", ":"))
    return hashlib.sha1(blob.encode()).hexdigest()


class ShapeRegistry:
    def __init__(self):
        self.shapes: dict[str, dict] = {}        # shape_id -> {elements:[...]}
        self._sig_to_id: dict[str, str] = {}

    def intern(self, resolved_model, parent_hint: str | None = None,
               model_id: str | None = None) -> str:
        sig = _signature(resolved_model.elements)
        if sig in self._sig_to_id:
            return self._sig_to_id[sig]
        name = _KNOWN_PARENTS.get(parent_hint or "", None)
        if not name:
            # Unrecognised silhouette: prefer the source model's own file
            # name (e.g. "block/custom_gate" -> "custom_gate") over a bare
            # hash, so a human staring at generated shapes.mcfunction can
            # tell which model first produced this geometry. Falls back to
            # the hash only if we truly have no model id to work with.
            name = model_id.rsplit("/", 1)[-1] if model_id else f"shape_{sig[:8]}"
        # Avoid friendly-name collisions across differing geometry.
        if name in self.shapes and self.shapes[name]["sig"] != sig:
            name = f"{name}_{sig[:6]}"
        self.shapes[name] = {"sig": sig, "elements": resolved_model.elements}
        self._sig_to_id[sig] = name
        return name

    def shapes_nbt(self) -> dict:
        out = {}
        for k, v in self.shapes.items():
            elements = v["elements"]
            # Flat, ray-test-friendly face list (compounds are awkward to
            # iterate in mcfunction; a list can be popped recursively).
            face_list = []
            for ei, el in enumerate(elements):
                for d, f in el["faces"].items():
                    entry = {"dir": d, "el": ei}
                    entry.update(f)
                    face_list.append(entry)
            out[k] = {"elements": elements, "faces": face_list}
        return out