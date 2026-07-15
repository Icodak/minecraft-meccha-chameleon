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

# ==========================================================================
# AUTO-GENERATED _KNOWN_PARENTS MAPPING
# Paste this directly into shape_grouper.py
# ==========================================================================
_KNOWN_PARENTS = {
    # --- Signature Group: ebfccc34 (Shared by 1 parents) ---
    "block/button": "button",
    # --- Signature Group: 71c55ad2 (Shared by 1 parents) ---
    "block/button_inventory": "button_inventory",
    # --- Signature Group: e565a43f (Shared by 1 parents) ---
    "block/button_pressed": "button_pressed",
    # --- Signature Group: 763d88ff (Shared by 1 parents) ---
    "block/calibrated_sculk_sensor": "calibrated_sculk_sensor",
    # --- Signature Group: b62e4bdd (Shared by 1 parents) ---
    "block/carpet": "carpet",
    # --- Signature Group: 962e44e8 (Shared by 1 parents) ---
    "block/coral_fan": "coral_fan",
    # --- Signature Group: 02e99761 (Shared by 1 parents) ---
    "block/coral_wall_fan": "coral_wall_fan",
    # --- Signature Group: 4eb12930 (Shared by 3 parents) ---
    "block/crafter": "crafter",
    "block/crafter_crafting": "crafter",
    "block/crafter_triggered": "crafter",
    # --- Signature Group: daa5a2bb (Shared by 1 parents) ---
    "block/crop": "crop",
    # --- Signature Group: 23176cb3 (Shared by 3 parents) ---
    "block/cross": "cross",
    "block/pointed_dripstone": "cross",
    "block/tinted_cross": "cross",
    # --- Signature Group: ea2fafa5 (Shared by 1 parents) ---
    "block/cross_emissive": "cross_emissive",
    # --- Signature Group: fabf0e5e (Shared by 9 parents) ---
    "block/cube": "full_block",
    "block/cube_all": "full_block",
    "block/cube_bottom_top": "full_block",
    "block/cube_column": "full_block",
    "block/cube_column_uv_locked_y": "full_block",
    "block/cube_top": "full_block",
    "block/orientable": "full_block",
    "block/orientable_vertical": "full_block",
    "block/orientable_with_bottom": "full_block",
    # --- Signature Group: cb76a639 (Shared by 1 parents) ---
    "block/cube_all_inner_faces": "cube_all_inner_faces",
    # --- Signature Group: 5bad2169 (Shared by 1 parents) ---
    "block/cube_bottom_top_inner_faces": "cube_bottom_top_inner_faces",
    # --- Signature Group: 7d960536 (Shared by 1 parents) ---
    "block/cube_column_horizontal": "cube_column_horizontal",
    # --- Signature Group: 2cd6b0a5 (Shared by 3 parents) ---
    "block/cube_column_mirrored": "cube_mirrored",
    "block/cube_mirrored": "cube_mirrored",
    "block/cube_mirrored_all": "cube_mirrored",
    # --- Signature Group: 1bf04677 (Shared by 1 parents) ---
    "block/cube_column_uv_locked_x": "cube_column_uv_locked_x",
    # --- Signature Group: a2666cc5 (Shared by 1 parents) ---
    "block/cube_column_uv_locked_z": "cube_column_uv_locked_z",
    # --- Signature Group: d5ee08b3 (Shared by 2 parents) ---
    "block/cube_directional": "cube_directional",
    "block/template_command_block": "cube_directional",
    # --- Signature Group: 27693f4d (Shared by 2 parents) ---
    "block/cube_north_west_mirrored": "cube_north_west_mirrored",
    "block/cube_north_west_mirrored_all": "cube_north_west_mirrored",
    # --- Signature Group: 2a031312 (Shared by 1 parents) ---
    "block/custom_fence_inventory": "custom_fence_inventory",
    # --- Signature Group: de9d7d89 (Shared by 1 parents) ---
    "block/custom_fence_post": "custom_fence_post",
    # --- Signature Group: 2ac9ac91 (Shared by 1 parents) ---
    "block/custom_fence_side_east": "custom_fence_side_east",
    # --- Signature Group: 66ffd2f6 (Shared by 1 parents) ---
    "block/custom_fence_side_north": "custom_fence_side_north",
    # --- Signature Group: a051d770 (Shared by 1 parents) ---
    "block/custom_fence_side_south": "custom_fence_side_south",
    # --- Signature Group: 228a938c (Shared by 1 parents) ---
    "block/custom_fence_side_west": "custom_fence_side_west",
    # --- Signature Group: 23ec3f66 (Shared by 1 parents) ---
    "block/door_bottom_left": "door_bottom_left",
    # --- Signature Group: d4ea7b30 (Shared by 1 parents) ---
    "block/door_bottom_left_open": "door_bottom_left_open",
    # --- Signature Group: b3bb0c8e (Shared by 1 parents) ---
    "block/door_bottom_right": "door_bottom_right",
    # --- Signature Group: ccb9154a (Shared by 1 parents) ---
    "block/door_bottom_right_open": "door_bottom_right_open",
    # --- Signature Group: 563cc189 (Shared by 1 parents) ---
    "block/door_top_left": "door_top_left",
    # --- Signature Group: 8f66ec21 (Shared by 1 parents) ---
    "block/door_top_left_open": "door_top_left_open",
    # --- Signature Group: beeb6e37 (Shared by 1 parents) ---
    "block/door_top_right": "door_top_right",
    # --- Signature Group: a52eef8b (Shared by 1 parents) ---
    "block/door_top_right_open": "door_top_right_open",
    # --- Signature Group: 1abfca61 (Shared by 1 parents) ---
    "block/dried_ghast": "dried_ghast",
    # --- Signature Group: 3fc63a0e (Shared by 1 parents) ---
    "block/fence_inventory": "fence_inventory",
    # --- Signature Group: af2ddf8f (Shared by 1 parents) ---
    "block/fence_post": "fence_post",
    # --- Signature Group: 73bd81f8 (Shared by 1 parents) ---
    "block/fence_side": "fence_side",
    # --- Signature Group: fe290fa2 (Shared by 2 parents) ---
    "block/flower_pot_cross": "flower_pot_cross",
    "block/tinted_flower_pot_cross": "flower_pot_cross",
    # --- Signature Group: 31dd4e64 (Shared by 1 parents) ---
    "block/flower_pot_cross_emissive": "flower_pot_cross_emissive",
    # --- Signature Group: b627e80e (Shared by 1 parents) ---
    "block/flowerbed_1": "flowerbed_1",
    # --- Signature Group: 8da6dc5a (Shared by 1 parents) ---
    "block/flowerbed_2": "flowerbed_2",
    # --- Signature Group: dcb642d4 (Shared by 1 parents) ---
    "block/flowerbed_3": "flowerbed_3",
    # --- Signature Group: 0f01ca80 (Shared by 1 parents) ---
    "block/flowerbed_4": "flowerbed_4",
    # --- Signature Group: b85ff6f6 (Shared by 1 parents) ---
    "block/inner_stairs": "inner_stairs",
    # --- Signature Group: f5295bfb (Shared by 1 parents) ---
    "block/leaves": "leaves",
    # --- Signature Group: 0d7340d2 (Shared by 1 parents) ---
    "block/mossy_carpet_side": "mossy_carpet_side",
    # --- Signature Group: 49af632e (Shared by 1 parents) ---
    "block/observer": "observer",
    # --- Signature Group: 7e978c59 (Shared by 1 parents) ---
    "block/outer_stairs": "outer_stairs",
    # --- Signature Group: 204610fd (Shared by 1 parents) ---
    "block/piston_extended": "piston_extended",
    # --- Signature Group: 4c672782 (Shared by 1 parents) ---
    "block/pressure_plate_down": "pressure_plate_down",
    # --- Signature Group: 2390afa7 (Shared by 1 parents) ---
    "block/pressure_plate_up": "pressure_plate_up",
    # --- Signature Group: a68f3fd5 (Shared by 2 parents) ---
    "block/rail_curved": "rail_flat",
    "block/rail_flat": "rail_flat",
    # --- Signature Group: ba3ca910 (Shared by 1 parents) ---
    "block/redstone_dust_side": "redstone_dust_side",
    # --- Signature Group: 1186f37b (Shared by 1 parents) ---
    "block/redstone_dust_side_alt": "redstone_dust_side_alt",
    # --- Signature Group: 715ed3d8 (Shared by 1 parents) ---
    "block/sculk_sensor": "sculk_sensor",
    # --- Signature Group: 18e1ad85 (Shared by 1 parents) ---
    "block/slab": "slab",
    # --- Signature Group: 8921ece0 (Shared by 1 parents) ---
    "block/slab_top": "slab_top",
    # --- Signature Group: 1a59aa6f (Shared by 1 parents) ---
    "block/sniffer_egg": "sniffer_egg",
    # --- Signature Group: 0772c93b (Shared by 1 parents) ---
    "block/stairs": "stairs",
    # --- Signature Group: 9f514eff (Shared by 1 parents) ---
    "block/stem_fruit": "stem_fruit",
    # --- Signature Group: cf7933bd (Shared by 1 parents) ---
    "block/stem_growth0": "stem_growth0",
    # --- Signature Group: a2469de7 (Shared by 1 parents) ---
    "block/stem_growth1": "stem_growth1",
    # --- Signature Group: bd18da06 (Shared by 1 parents) ---
    "block/stem_growth2": "stem_growth2",
    # --- Signature Group: 0d05684a (Shared by 1 parents) ---
    "block/stem_growth3": "stem_growth3",
    # --- Signature Group: b09ce190 (Shared by 1 parents) ---
    "block/stem_growth4": "stem_growth4",
    # --- Signature Group: 50d14de6 (Shared by 1 parents) ---
    "block/stem_growth5": "stem_growth5",
    # --- Signature Group: 5fdf1c14 (Shared by 1 parents) ---
    "block/stem_growth6": "stem_growth6",
    # --- Signature Group: 614af54c (Shared by 1 parents) ---
    "block/stem_growth7": "stem_growth7",
    # --- Signature Group: d4c6744e (Shared by 1 parents) ---
    "block/template_anvil": "anvil",
    # --- Signature Group: 392c9264 (Shared by 1 parents) ---
    "block/template_attached_hanging_sign_rot_0": "attached_hanging_sign_rot_0",
    # --- Signature Group: 85721df1 (Shared by 1 parents) ---
    "block/template_attached_hanging_sign_rot_1": "attached_hanging_sign_rot_1",
    # --- Signature Group: 251375cf (Shared by 1 parents) ---
    "block/template_attached_hanging_sign_rot_2": "attached_hanging_sign_rot_2",
    # --- Signature Group: 09dea284 (Shared by 1 parents) ---
    "block/template_attached_hanging_sign_rot_3": "attached_hanging_sign_rot_3",
    # --- Signature Group: 9e6ab5b3 (Shared by 1 parents) ---
    "block/template_azalea": "azalea",
    # --- Signature Group: 8e2731ed (Shared by 1 parents) ---
    "block/template_bars_cap": "bars_cap",
    # --- Signature Group: f6c9f1d6 (Shared by 1 parents) ---
    "block/template_bars_cap_alt": "bars_cap_alt",
    # --- Signature Group: 3159a48f (Shared by 1 parents) ---
    "block/template_bars_post": "bars_post",
    # --- Signature Group: 95f30b5b (Shared by 1 parents) ---
    "block/template_bars_post_ends": "bars_post_ends",
    # --- Signature Group: 5c8fffd6 (Shared by 1 parents) ---
    "block/template_bars_side": "bars_side",
    # --- Signature Group: 39144f4a (Shared by 1 parents) ---
    "block/template_bars_side_alt": "bars_side_alt",
    # --- Signature Group: cf5cecbb (Shared by 1 parents) ---
    "block/template_bed_foot": "bed_foot",
    # --- Signature Group: e48d7f60 (Shared by 1 parents) ---
    "block/template_bed_head": "bed_head",
    # --- Signature Group: 5c7f506f (Shared by 1 parents) ---
    "block/template_cake_with_candle": "cake_with_candle",
    # --- Signature Group: 7166d0db (Shared by 1 parents) ---
    "block/template_campfire": "campfire",
    # --- Signature Group: e0e87074 (Shared by 1 parents) ---
    "block/template_candle": "candle",
    # --- Signature Group: 1a04a917 (Shared by 1 parents) ---
    "block/template_cauldron_full": "cauldron_full",
    # --- Signature Group: 233ea0b4 (Shared by 1 parents) ---
    "block/template_cauldron_level1": "cauldron_level1",
    # --- Signature Group: 9ea1bb90 (Shared by 1 parents) ---
    "block/template_cauldron_level2": "cauldron_level2",
    # --- Signature Group: 90a82f75 (Shared by 1 parents) ---
    "block/template_chain": "chain",
    # --- Signature Group: 79726145 (Shared by 1 parents) ---
    "block/template_chiseled_bookshelf_slot_bottom_left": "chiseled_bookshelf_slot_bottom_left",
    # --- Signature Group: f4f5ad12 (Shared by 1 parents) ---
    "block/template_chiseled_bookshelf_slot_bottom_mid": "chiseled_bookshelf_slot_bottom_mid",
    # --- Signature Group: 23996d3c (Shared by 1 parents) ---
    "block/template_chiseled_bookshelf_slot_bottom_right": "chiseled_bookshelf_slot_bottom_right",
    # --- Signature Group: fbc5f61f (Shared by 1 parents) ---
    "block/template_chiseled_bookshelf_slot_top_left": "chiseled_bookshelf_slot_top_left",
    # --- Signature Group: dfe74ebb (Shared by 1 parents) ---
    "block/template_chiseled_bookshelf_slot_top_mid": "chiseled_bookshelf_slot_top_mid",
    # --- Signature Group: 09f08a16 (Shared by 1 parents) ---
    "block/template_chiseled_bookshelf_slot_top_right": "chiseled_bookshelf_slot_top_right",
    # --- Signature Group: 41bd79f7 (Shared by 1 parents) ---
    "block/template_chorus_flower": "chorus_flower",
    # --- Signature Group: 41b85052 (Shared by 1 parents) ---
    "block/template_custom_fence_gate": "custom_fence_gate",
    # --- Signature Group: 25dbe2ff (Shared by 1 parents) ---
    "block/template_custom_fence_gate_open": "custom_fence_gate_open",
    # --- Signature Group: 77b35dcd (Shared by 1 parents) ---
    "block/template_custom_fence_gate_wall": "custom_fence_gate_wall",
    # --- Signature Group: 78d1a106 (Shared by 1 parents) ---
    "block/template_custom_fence_gate_wall_open": "custom_fence_gate_wall_open",
    # --- Signature Group: 1b253c22 (Shared by 1 parents) ---
    "block/template_daylight_detector": "daylight_detector",
    # --- Signature Group: aa822225 (Shared by 1 parents) ---
    "block/template_farmland": "farmland",
    # --- Signature Group: c5dfa891 (Shared by 1 parents) ---
    "block/template_fence_gate": "fence_gate",
    # --- Signature Group: f07c663c (Shared by 1 parents) ---
    "block/template_fence_gate_open": "fence_gate_open",
    # --- Signature Group: 21806562 (Shared by 1 parents) ---
    "block/template_fence_gate_wall": "fence_gate_wall",
    # --- Signature Group: db1d8d0c (Shared by 1 parents) ---
    "block/template_fence_gate_wall_open": "fence_gate_wall_open",
    # --- Signature Group: ba569fb9 (Shared by 1 parents) ---
    "block/template_fire_floor": "fire_floor",
    # --- Signature Group: 45dde691 (Shared by 1 parents) ---
    "block/template_fire_side": "fire_side",
    # --- Signature Group: 817c885e (Shared by 1 parents) ---
    "block/template_fire_side_alt": "fire_side_alt",
    # --- Signature Group: 96c7ad85 (Shared by 1 parents) ---
    "block/template_fire_up": "fire_up",
    # --- Signature Group: eec43d5b (Shared by 1 parents) ---
    "block/template_fire_up_alt": "fire_up_alt",
    # --- Signature Group: 8db873f7 (Shared by 1 parents) ---
    "block/template_four_candles": "four_candles",
    # --- Signature Group: d3b30a9d (Shared by 1 parents) ---
    "block/template_four_turtle_eggs": "four_turtle_eggs",
    # --- Signature Group: cf98c6e9 (Shared by 1 parents) ---
    "block/template_glass_pane_noside": "glass_pane_noside",
    # --- Signature Group: 4774e1cc (Shared by 1 parents) ---
    "block/template_glass_pane_noside_alt": "glass_pane_noside_alt",
    # --- Signature Group: 1956a8fc (Shared by 1 parents) ---
    "block/template_glass_pane_post": "glass_pane_post",
    # --- Signature Group: c4d860d1 (Shared by 1 parents) ---
    "block/template_glass_pane_side": "glass_pane_side",
    # --- Signature Group: b358f689 (Shared by 1 parents) ---
    "block/template_glass_pane_side_alt": "glass_pane_side_alt",
    # --- Signature Group: 24571476 (Shared by 1 parents) ---
    "block/template_glazed_terracotta": "glazed_terracotta",
    # --- Signature Group: a71b7fbc (Shared by 1 parents) ---
    "block/template_hanging_lantern": "hanging_lantern",
    # --- Signature Group: 3621115c (Shared by 1 parents) ---
    "block/template_hanging_sign_rot_0": "hanging_sign_rot_0",
    # --- Signature Group: 95ed7e0e (Shared by 1 parents) ---
    "block/template_hanging_sign_rot_1": "hanging_sign_rot_1",
    # --- Signature Group: 3e5a0d93 (Shared by 1 parents) ---
    "block/template_hanging_sign_rot_2": "hanging_sign_rot_2",
    # --- Signature Group: d4bc78a4 (Shared by 1 parents) ---
    "block/template_hanging_sign_rot_3": "hanging_sign_rot_3",
    # --- Signature Group: 062fdd44 (Shared by 1 parents) ---
    "block/template_item_frame": "item_frame",
    # --- Signature Group: 500ecadc (Shared by 1 parents) ---
    "block/template_item_frame_map": "item_frame_map",
    # --- Signature Group: df664ac0 (Shared by 1 parents) ---
    "block/template_lantern": "lantern",
    # --- Signature Group: af283685 (Shared by 1 parents) ---
    "block/template_leaf_litter_1": "leaf_litter_1",
    # --- Signature Group: 7dc4e334 (Shared by 1 parents) ---
    "block/template_leaf_litter_2": "leaf_litter_2",
    # --- Signature Group: 0abe125d (Shared by 1 parents) ---
    "block/template_leaf_litter_3": "leaf_litter_3",
    # --- Signature Group: 6f3b647c (Shared by 1 parents) ---
    "block/template_leaf_litter_4": "leaf_litter_4",
    # --- Signature Group: 7c9608f8 (Shared by 1 parents) ---
    "block/template_lightning_rod": "lightning_rod",
    # --- Signature Group: 40112b47 (Shared by 1 parents) ---
    "block/template_orientable_trapdoor_bottom": "orientable_trapdoor_bottom",
    # --- Signature Group: daeb22ca (Shared by 1 parents) ---
    "block/template_orientable_trapdoor_open": "orientable_trapdoor_open",
    # --- Signature Group: 71b7e2f1 (Shared by 1 parents) ---
    "block/template_orientable_trapdoor_top": "orientable_trapdoor_top",
    # --- Signature Group: f42256ca (Shared by 1 parents) ---
    "block/template_piston": "piston",
    # --- Signature Group: 1827d371 (Shared by 1 parents) ---
    "block/template_piston_head": "piston_head",
    # --- Signature Group: 04dc78b6 (Shared by 1 parents) ---
    "block/template_piston_head_short": "piston_head_short",
    # --- Signature Group: 40d43234 (Shared by 1 parents) ---
    "block/template_potted_azalea_bush": "potted_azalea_bush",
    # --- Signature Group: d3925923 (Shared by 1 parents) ---
    "block/template_rail_raised_ne": "rail_raised_ne",
    # --- Signature Group: cb9fda7a (Shared by 1 parents) ---
    "block/template_rail_raised_sw": "rail_raised_sw",
    # --- Signature Group: 977f6664 (Shared by 1 parents) ---
    "block/template_redstone_torch": "redstone_torch",
    # --- Signature Group: de135316 (Shared by 1 parents) ---
    "block/template_redstone_torch_wall": "redstone_torch_wall",
    # --- Signature Group: 8b15c7a8 (Shared by 1 parents) ---
    "block/template_sculk_shrieker": "sculk_shrieker",
    # --- Signature Group: 37758fb4 (Shared by 1 parents) ---
    "block/template_seagrass": "seagrass",
    # --- Signature Group: 226027b5 (Shared by 1 parents) ---
    "block/template_shelf_body": "shelf_body",
    # --- Signature Group: b36143f7 (Shared by 1 parents) ---
    "block/template_shelf_center": "shelf_center",
    # --- Signature Group: ddd2c8f1 (Shared by 1 parents) ---
    "block/template_shelf_inventory": "shelf_inventory",
    # --- Signature Group: 754e021f (Shared by 1 parents) ---
    "block/template_shelf_left": "shelf_left",
    # --- Signature Group: df92c199 (Shared by 1 parents) ---
    "block/template_shelf_right": "shelf_right",
    # --- Signature Group: 066aeb5f (Shared by 1 parents) ---
    "block/template_shelf_unconnected": "shelf_unconnected",
    # --- Signature Group: c1c215a1 (Shared by 1 parents) ---
    "block/template_shelf_unpowered": "shelf_unpowered",
    # --- Signature Group: a349bb1a (Shared by 1 parents) ---
    "block/template_sign_rot_0": "sign_rot_0",
    # --- Signature Group: fbcfcb07 (Shared by 1 parents) ---
    "block/template_sign_rot_1": "sign_rot_1",
    # --- Signature Group: 7fc600a7 (Shared by 1 parents) ---
    "block/template_sign_rot_2": "sign_rot_2",
    # --- Signature Group: 3b842fdb (Shared by 1 parents) ---
    "block/template_sign_rot_3": "sign_rot_3",
    # --- Signature Group: e4a2a0d4 (Shared by 1 parents) ---
    "block/template_single_face": "single_face",
    # --- Signature Group: e8d5415f (Shared by 1 parents) ---
    "block/template_three_candles": "three_candles",
    # --- Signature Group: 3b19c8ab (Shared by 1 parents) ---
    "block/template_three_turtle_eggs": "three_turtle_eggs",
    # --- Signature Group: 3f0534de (Shared by 2 parents) ---
    "block/template_torch": "torch",
    "block/template_torch_unlit": "torch",
    # --- Signature Group: b15f9342 (Shared by 2 parents) ---
    "block/template_torch_wall": "torch_wall",
    "block/template_torch_wall_unlit": "torch_wall",
    # --- Signature Group: aa738b9b (Shared by 1 parents) ---
    "block/template_trapdoor_bottom": "trapdoor_bottom",
    # --- Signature Group: 525e0a83 (Shared by 1 parents) ---
    "block/template_trapdoor_open": "trapdoor_open",
    # --- Signature Group: f81be6cc (Shared by 1 parents) ---
    "block/template_trapdoor_top": "trapdoor_top",
    # --- Signature Group: 5bb807f6 (Shared by 1 parents) ---
    "block/template_turtle_egg": "turtle_egg",
    # --- Signature Group: a8a66b55 (Shared by 1 parents) ---
    "block/template_two_candles": "two_candles",
    # --- Signature Group: 5e5a4d61 (Shared by 1 parents) ---
    "block/template_two_turtle_eggs": "two_turtle_eggs",
    # --- Signature Group: daa603dc (Shared by 1 parents) ---
    "block/template_vault": "vault",
    # --- Signature Group: 926f3dd5 (Shared by 1 parents) ---
    "block/template_wall_hanging_sign": "wall_hanging_sign",
    # --- Signature Group: 3002f680 (Shared by 1 parents) ---
    "block/template_wall_post": "wall_post",
    # --- Signature Group: 423d1099 (Shared by 1 parents) ---
    "block/template_wall_side": "wall_side",
    # --- Signature Group: e2897749 (Shared by 1 parents) ---
    "block/template_wall_side_tall": "wall_side_tall",
    # --- Signature Group: cc599e2e (Shared by 1 parents) ---
    "block/template_wall_sign": "wall_sign",
    # --- Signature Group: 9569ef04 (Shared by 1 parents) ---
    "block/wall_inventory": "wall_inventory",
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
               model_id: str | None = None, rot_suffix: str = "") -> str:
        # rot_suffix is the build-time rotation tag (e.g. "__x0_y180_z0" or
        # "__x0_y90_z0_uvlock") that parse_assets derives from a variant's
        # apply block. _KNOWN_PARENTS is rotation-agnostic (it names only the
        # base silhouette), so the same base template rotated four ways would
        # otherwise all fight for one name and get hash-disambiguated. We
        # instead append the rotation tag to the base canonical name, giving
        # stable, human-readable names like "button__x0_y180_z0" that still
        # dedupe across wood types (same rotation of the same base shares one
        # texture-agnostic signature, hence one name).
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
            if expected:
                expected += rot_suffix
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
        if name:
            # Known base silhouette: append the rotation tag so each rotated
            # variant gets its own stable name off the shared base canonical.
            name += rot_suffix
        else:
            # Unrecognised silhouette: prefer the source model's own file
            # name (e.g. "block/custom_gate" -> "custom_gate") over a bare
            # hash, so a human staring at generated shapes.mcfunction can
            # tell which model first produced this geometry. Falls back to
            # the hash only if we truly have no model id to work with. The
            # variant model id already carries the rotation tag here, so we
            # deliberately do NOT re-append rot_suffix.
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