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
# parents; anything unrecognised gets a name derived from the source model
# file (or a stable "shape_<8 hex>" id if we truly have nothing to go on).
#
# IMPORTANT: `elements` (and therefore each face's texture *variable name*)
# always comes from the nearest ancestor that actually defines an `elements`
# block - for the whole "cube_all / cube_column / cube_bottom_top / cube_top
# / cube_directional / leaves" family that ancestor is cube.json itself, and
# cube.json's own faces are hardcoded to "#down"/"#up"/"#north"/"#south"/
# "#east"/"#west". Intermediate templates like cube_column only re-point
# their OWN `textures` dict (down/up -> "#end", sides -> "#side") - that
# aliasing only affects the resolved *texture* per model, never the shape's
# face-variable names. So every member of this family produces a BYTE-
# IDENTICAL shape signature no matter which one a given block's model
# actually parents from. They must all map to the SAME canonical name here.
# If they don't, naming becomes a race: `intern()` returns the cached name
# on a signature hit without even consulting this table, so whichever model
# in the family happens to be processed first silently wins the name for
# every other member - which is exactly how a log ended up named
# "acacia_leaves": neither `block/cube_column` nor `block/leaves` were in
# this table yet, so both fell to the per-model filename fallback, and the
# alphabetically-first one (a leaves model) won.
_KNOWN_PARENTS = {
    # --- full cubes: ALL of these share cube.json's literal elements, so
    # they MUST all resolve to one name (see note above) -------------------
    "block/cube": "full_block",
    "block/cube_all": "full_block",
    "block/cube_bottom_top": "full_block",
    "block/cube_top": "full_block",
    "block/cube_directional": "full_block",
    "block/cube_column": "full_block",
    "block/cube_column_horizontal": "full_block",
    "block/leaves": "full_block",              # leaves.json has no elements of its own; inherits cube.json via cube_all
    # NOTE: cube_mirrored / cube_north_west_mirrored / cube_column_mirrored /
    # cube_column_uv_locked_* / *_inner_faces are NOT verified against real
    # files yet. If they turn out to also just alias textures (no elements
    # override) they belong in the group above too - upload them to
    # confirm before trusting these as distinct shapes.
    "block/cube_bottom_top_inner_faces": "cube_top_bottom_inner_faces",
    "block/cube_all_inner_faces": "full_block_inner_faces",
    "block/cube_mirrored": "cube_mirrored",
    "block/cube_mirrored_all": "full_block_mirrored",
    "block/cube_north_west_mirrored": "cube_nw_mirrored",
    "block/cube_north_west_mirrored_all": "full_block_nw_mirrored",
    "block/cube_column_mirrored": "column_mirrored",
    "block/cube_column_uv_locked_x": "column_uvlock_x",
    "block/cube_column_uv_locked_y": "column_uvlock_y",
    "block/cube_column_uv_locked_z": "column_uvlock_z",
    # --- slabs / stairs ---------------------------------------------------
    "block/slab": "slab_bottom",
    "block/slab_top": "slab_top",
    "block/stairs": "stairs",
    "block/inner_stairs": "stairs_inner",
    "block/outer_stairs": "stairs_outer",
    # --- crosses / plants ---------------------------------------------------
    "block/cross": "cross",
    "block/cross_emissive": "cross_emissive",
    "block/tinted_cross": "cross_tinted",
    "block/template_azalea": "azalea",
    "block/template_potted_azalea_bush": "potted_azalea_bush",
    "block/template_seagrass": "seagrass",
    "block/template_leaf_litter_1": "leaf_litter_1",
    "block/template_leaf_litter_2": "leaf_litter_2",
    "block/template_leaf_litter_3": "leaf_litter_3",
    "block/template_leaf_litter_4": "leaf_litter_4",
    # --- fences / walls / panes ---------------------------------------------
    "block/fence_post": "fence_post",
    "block/fence_side": "fence_side",
    "block/fence_inventory": "fence_inventory",
    "block/template_fence_gate": "fence_gate",
    "block/template_fence_gate_open": "fence_gate_open",
    "block/template_fence_gate_wall": "fence_gate_wall",
    "block/template_fence_gate_wall_open": "fence_gate_wall_open",
    "block/template_custom_fence_gate": "custom_fence_gate",
    "block/template_custom_fence_gate_open": "custom_fence_gate_open",
    "block/template_custom_fence_gate_wall": "custom_fence_gate_wall",
    "block/template_custom_fence_gate_wall_open": "custom_fence_gate_wall_open",
    "block/template_wall_post": "wall_post",
    "block/template_wall_side": "wall_side",
    "block/template_wall_side_tall": "wall_side_tall",
    "block/template_glass_pane_post": "glass_pane_post",
    "block/template_glass_pane_side": "glass_pane_side",
    "block/template_glass_pane_side_alt": "glass_pane_side_alt",
    "block/template_glass_pane_noside": "glass_pane_noside",
    "block/template_glass_pane_noside_alt": "glass_pane_noside_alt",
    "block/template_bars_post": "bars_post",
    "block/template_bars_post_ends": "bars_post_ends",
    "block/template_bars_side": "bars_side",
    "block/template_bars_side_alt": "bars_side_alt",
    "block/template_bars_cap": "bars_cap",
    "block/template_bars_cap_alt": "bars_cap_alt",
    # --- doors / trapdoors --------------------------------------------------
    "block/door_bottom_left": "door_bottom_left",
    "block/door_bottom_left_open": "door_bottom_left_open",
    "block/door_bottom_right": "door_bottom_right",
    "block/door_bottom_right_open": "door_bottom_right_open",
    "block/door_top_left": "door_top_left",
    "block/door_top_left_open": "door_top_left_open",
    "block/door_top_right": "door_top_right",
    "block/door_top_right_open": "door_top_right_open",
    "block/template_trapdoor_bottom": "trapdoor_bottom",
    "block/template_trapdoor_open": "trapdoor_open",
    "block/template_trapdoor_top": "trapdoor_top",
    "block/template_orientable_trapdoor_bottom": "trapdoor_bottom_orientable",
    "block/template_orientable_trapdoor_open": "trapdoor_open_orientable",
    "block/template_orientable_trapdoor_top": "trapdoor_top_orientable",
    # --- buttons / plates / redstone ---------------------------------------
    "block/button": "button",
    "block/button_inventory": "button_inventory",
    "block/button_pressed": "button_pressed",
    "block/pressure_plate_up": "pressure_plate_up",
    "block/pressure_plate_down": "pressure_plate_down",
    "block/template_redstone_torch": "redstone_torch",
    "block/template_redstone_torch_wall": "redstone_torch_wall",
    "block/template_torch": "torch",
    "block/template_torch_unlit": "torch_unlit",
    "block/template_torch_wall": "torch_wall",
    "block/template_torch_wall_unlit": "torch_wall_unlit",
    "block/template_daylight_detector": "daylight_detector",
    "block/template_lightning_rod": "lightning_rod",
    "block/template_chain": "chain",
    "block/template_rail_raised_ne": "rail_raised_ne",
    "block/template_rail_raised_sw": "rail_raised_sw",
    # --- signs -------------------------------------------------------------
    "block/template_sign_rot_0": "sign_rot0",
    "block/template_sign_rot_1": "sign_rot1",
    "block/template_sign_rot_2": "sign_rot2",
    "block/template_sign_rot_3": "sign_rot3",
    "block/template_wall_sign": "wall_sign",
    "block/template_hanging_sign_rot_0": "hanging_sign_rot0",
    "block/template_hanging_sign_rot_1": "hanging_sign_rot1",
    "block/template_hanging_sign_rot_2": "hanging_sign_rot2",
    "block/template_hanging_sign_rot_3": "hanging_sign_rot3",
    "block/template_attached_hanging_sign_rot_0": "hanging_sign_attached_rot0",
    "block/template_attached_hanging_sign_rot_1": "hanging_sign_attached_rot1",
    "block/template_attached_hanging_sign_rot_2": "hanging_sign_attached_rot2",
    "block/template_attached_hanging_sign_rot_3": "hanging_sign_attached_rot3",
    "block/template_wall_hanging_sign": "wall_hanging_sign",
    # --- shelves / bookshelves -----------------------------------------------
    "block/template_shelf_body": "shelf_body",
    "block/template_shelf_center": "shelf_center",
    "block/template_shelf_inventory": "shelf_inventory",
    "block/template_shelf_left": "shelf_left",
    "block/template_shelf_right": "shelf_right",
    "block/template_shelf_unconnected": "shelf_unconnected",
    "block/template_shelf_unpowered": "shelf_unpowered",
    "block/template_chiseled_bookshelf_slot_bottom_left": "bookshelf_slot_bottom_left",
    "block/template_chiseled_bookshelf_slot_bottom_mid": "bookshelf_slot_bottom_mid",
    "block/template_chiseled_bookshelf_slot_bottom_right": "bookshelf_slot_bottom_right",
    "block/template_chiseled_bookshelf_slot_top_left": "bookshelf_slot_top_left",
    "block/template_chiseled_bookshelf_slot_top_mid": "bookshelf_slot_top_mid",
    "block/template_chiseled_bookshelf_slot_top_right": "bookshelf_slot_top_right",
    # --- misc decor / functional blocks --------------------------------------
    "block/chest": "chest",
    "block/thin_block": "thin_block",
    "block/template_single_face": "single_face",
    "block/template_anvil": "anvil",
    "block/template_bed": "bed",
    "block/template_bed_foot": "bed_foot",
    "block/template_bed_head": "bed_head",
    "block/template_cake_with_candle": "cake_with_candle",
    "block/template_campfire": "campfire",
    "block/template_candle": "candle_1",
    "block/template_two_candles": "candle_2",
    "block/template_three_candles": "candle_3",
    "block/template_four_candles": "candle_4",
    "block/template_turtle_egg": "turtle_egg_1",
    "block/template_two_turtle_eggs": "turtle_egg_2",
    "block/template_three_turtle_eggs": "turtle_egg_3",
    "block/template_four_turtle_eggs": "turtle_egg_4",
    "block/template_cauldron_full": "cauldron_full",
    "block/template_cauldron_level1": "cauldron_level1",
    "block/template_cauldron_level2": "cauldron_level2",
    "block/template_chorus_flower": "chorus_flower",
    "block/template_command_block": "command_block",
    "block/template_farmland": "farmland",
    "block/template_fire_floor": "fire_floor",
    "block/template_fire_side": "fire_side",
    "block/template_fire_side_alt": "fire_side_alt",
    "block/template_fire_up": "fire_up",
    "block/template_fire_up_alt": "fire_up_alt",
    "block/template_glazed_terracotta": "glazed_terracotta",
    "block/template_hanging_lantern": "hanging_lantern",
    "block/template_lantern": "lantern",
    "block/template_item_frame": "item_frame",
    "block/template_item_frame_map": "item_frame_map",
    "block/template_piston": "piston",
    "block/template_piston_head": "piston_head",
    "block/template_piston_head_short": "piston_head_short",
    "block/template_sculk_shrieker": "sculk_shrieker",
    "block/template_vault": "vault",
}


def _signature(elements: list[dict]) -> str:
    """Stable hash of geometry AND the per-face texture-variable mapping.

    Only the *resolved* texture value is allowed to vary between models that
    share a shape (that's the whole point of the shape/model split); the
    variable name each face is bound to ("side", "end", "all", ...) is part
    of the shape's identity. Two models can be geometrically identical unit
    cubes (e.g. a log's cube_column vs leaves' cube_all) yet wire their faces
    to completely different variables - if the signature ignores `var`,
    interning collapses them into one shape and whichever model is resolved
    first silently freezes its face->variable mapping for every other model
    that shares it, corrupting their texture lookups at runtime.
    """
    skel = []
    for el in elements:
        faces = {}
        for d, f in sorted(el["faces"].items()):
            faces[d] = {
                "p0": f["p0"], "eu": f["eu"], "ev": f["ev"],
                "n": f["n"], "uv": f["uv"], "rot": f["rot"],
                "var": f["var"],
            }
        skel.append({"from": el["from"], "to": el["to"], "faces": faces})
    blob = json.dumps(skel, sort_keys=True, separators=(",", ":"))
    return hashlib.sha1(blob.encode()).hexdigest()


class ShapeRegistry:
    def __init__(self):
        self.shapes: dict[str, dict] = {}        # shape_id -> {elements:[...]}
        self._sig_to_id: dict[str, str] = {}
        self._contributors: dict[str, list[str]] = {}   # shape_id -> [model_id, ...]
        self.clashes: list[dict] = []             # friendly-name collisions we had to disambiguate
        self.alias_mismatches: list[dict] = []    # _KNOWN_PARENTS disagreeing with itself

    def intern(self, resolved_model, parent_hint: str | None = None,
               model_id: str | None = None) -> str:
        sig = _signature(resolved_model.elements)
        if sig in self._sig_to_id:
            name = self._sig_to_id[sig]
            self._contributors[name].append(model_id or parent_hint or "?")
            # This exact geometry+var signature already has a name. If THIS
            # model's own parent is also in _KNOWN_PARENTS but points at a
            # DIFFERENT name, the table is internally inconsistent - two
            # "known" parents that actually produce the same shape have been
            # given different canonical names, and whichever got processed
            # first silently won. This is precisely how a log ended up named
            # "acacia_leaves": catch it here instead of via a bug report.
            expected = _KNOWN_PARENTS.get(parent_hint or "", None)
            if expected and expected != name:
                self.alias_mismatches.append({
                    "parent_hint": parent_hint,
                    "expected_name": expected,
                    "actual_name": name,
                    "model_id": model_id,
                })
            return name
        name = _KNOWN_PARENTS.get(parent_hint or "", None)
        known = name is not None
        if not name:
            # Unrecognised silhouette: prefer the source model's own file
            # name (e.g. "block/custom_gate" -> "custom_gate") over a bare
            # hash, so a human staring at generated shapes.mcfunction can
            # tell which model first produced this geometry. Falls back to
            # the hash only if we truly have no model id to work with.
            name = model_id.rsplit("/", 1)[-1] if model_id else f"shape_{sig[:8]}"
        # A friendly-name collision means two DIFFERENT shapes both want the
        # same name (either two unmapped models share a filename basename, or
        # a _KNOWN_PARENTS entry is itself conflating two distinct silhouettes
        # - e.g. cube.json and cube_all.json are both "full cubes" but wire
        # up different face variables). We still disambiguate automatically
        # so the pipeline never produces a broken/overwritten shape, but we
        # record it: a clash on a *known* parent points at a bad entry in
        # _KNOWN_PARENTS; a clash on a *fallback* filename usually means that
        # parent should be added to the table.
        if name in self.shapes and self.shapes[name]["sig"] != sig:
            self.clashes.append({
                "wanted_name": name,
                "resolved_name": f"{name}_{sig[:6]}",
                "parent_hint": parent_hint,
                "model_id": model_id,
                "known_parent": known,
            })
            name = f"{name}_{sig[:6]}"
        self.shapes[name] = {"sig": sig, "elements": resolved_model.elements,
                              "parent_hint": parent_hint, "known": known}
        self._sig_to_id[sig] = name
        self._contributors[name] = [model_id or parent_hint or "?"]
        return name

    def unmapped_shared_shapes(self, min_contributors: int = 2) -> list[tuple[str, str | None, int]]:
        """Shapes reused by 2+ models but named from a fallback filename, not
        a _KNOWN_PARENTS entry. A high contributor count here is a strong
        signal that `parent_hint` belongs in _KNOWN_PARENTS - otherwise the
        shape's canonical name is just whichever model happened to be
        processed first, which is misleading for everything else that shares it.
        """
        out = []
        for name, info in self.shapes.items():
            if info["known"]:
                continue
            count = len(self._contributors.get(name, []))
            if count >= min_contributors:
                out.append((name, info["parent_hint"], count))
        return sorted(out, key=lambda x: -x[2])

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