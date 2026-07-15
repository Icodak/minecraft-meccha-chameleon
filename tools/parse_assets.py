#!/usr/bin/env python3
"""Meccha Chameleon - Pillar 2 pre-computation pipeline.

Parses a vanilla asset tree (assets/minecraft/{blockstates,models,textures})
and emits the generated NBT builder .mcfunction files consumed once at
first-load by meccha:init/build_registry.

Emitted (into data/meccha/function/generated/):
    textures.mcfunction   Texture Builder        -> registry.textures.<key>
    shapes.mcfunction     Vertex & Face Builder  -> registry.shapes.<shape>
    models.mcfunction     Model-to-Shape/UV       -> registry.models.<model>
    states.mcfunction     State-to-Model          -> registry.states.<block>
    _index.mcfunction     ordered dispatcher (textures->shapes->models->states)

Usage:
    python tools/parse_assets.py       --assets tools/sample_assets/assets       --datapack .       [--chunk 256]

--chunk splits very large builders into _partN files so no single function
exceeds the command limit on huge asset sets.
"""
from __future__ import annotations
import argparse
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "lib"))

from mcfunction_writer import FunctionWriter, snbt          # noqa: E402
from texture_quantizer import load_texture                  # noqa: E402
from model_resolver import ModelLibrary                     # noqa: E402
from blockstate_parser import iter_blockstates              # noqa: E402
from shape_grouper import ShapeRegistry                     # noqa: E402


def qpath(*keys: str) -> str:
    """Build a quoted NBT storage path, e.g. textures."block/oak"."""
    out = []
    for k in keys:
        if all(c.isalnum() or c in "_-" for c in k):
            out.append(k)
        else:
            out.append(f'"{k}"')
    return ".".join(out)


def _model_parent_hint(lib: ModelLibrary, model_id: str) -> str | None:
    try:
        raw = lib._load_raw(model_id)
    except Exception:
        return None
    p = raw.get("parent")
    return p.split(":", 1)[-1] if p else None


def _variant_suffix(apply: dict) -> str:
    """Build-time rotation tag for a variant's apply block, or "" for the
    identity rotation. Shared by the variant model id and the shape name so
    both stay in lockstep (e.g. apply {y:180} -> "__x0_y180_z0")."""
    x = int(apply.get("x", 0))
    y = int(apply.get("y", 0))
    z = int(apply.get("z", 0))
    uvlock = bool(apply.get("uvlock", False))
    if x == 0 and y == 0 and z == 0 and not uvlock:
        return ""
    suffix = f"__x{x}_y{y}_z{z}"
    if uvlock:
        suffix += "_uvlock"
    return suffix


def _variant_model_id(model_id: str, apply: dict) -> str:
    return f"{model_id}{_variant_suffix(apply)}"


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--assets", required=True, help="path to assets/ root")
    ap.add_argument("--datapack", required=True, help="datapack root (has pack.mcmeta)")
    ap.add_argument("--chunk", type=int, default=256)
    args = ap.parse_args()

    mc = os.path.join(args.assets, "minecraft")
    bs_dir = os.path.join(mc, "blockstates")
    models_dir = os.path.join(mc, "models", "block")
    tex_dir = os.path.join(mc, "textures")

    lib = ModelLibrary(models_dir)
    shapes = ShapeRegistry()

    states_entries: list[tuple[str, dict]] = []
    model_entries: dict[str, dict] = {}     # model_id -> {shape, textures, ...}
    needed_models: set[str] = set()
    variant_specs: dict[str, tuple[str, dict]] = {}

    # ---- pass 1: blockstates -> model refs + state table -----------------
    for bstate in iter_blockstates(bs_dir):
        nbt = bstate.to_nbt()
        applies = []
        if bstate.kind == "variants":
            for lst in nbt["cases"]:
                applies += lst["apply"]
        else:
            for case in nbt["cases"]:
                applies += case["apply"]
        for ap_ in applies:
            variant_id = _variant_model_id(ap_["model"], ap_)
            if variant_id not in variant_specs:
                variant_specs[variant_id] = (ap_["model"], ap_)
            ap_["model"] = variant_id
            needed_models.add(ap_["model"])
        states_entries.append((bstate.block_id, nbt))

    # ---- pass 2: resolve models, intern shapes, collect textures ---------
    texture_vars: set[str] = set()
    no_geometry: list[str] = []
    for model_id in sorted(needed_models):
        base_model_id, apply = variant_specs.get(model_id, (model_id, {}))
        rm = lib.resolve(base_model_id)
        rm = rm.transformed(apply)
        if not rm.elements:
            no_geometry.append(model_id)
            continue
        shape_id = shapes.intern(rm, _model_parent_hint(lib, base_model_id),
                                 model_id, rot_suffix=_variant_suffix(apply))
        model_entries[model_id] = {"shape": shape_id, "textures": rm.textures}

        for tex in rm.textures.values():
            if isinstance(tex, dict):
                tex = tex.get("sprite")
                if tex is None:
                    continue

            if not isinstance(tex, str):
                continue

            if not tex.startswith("#"):
                texture_vars.add(tex.split(":", 1)[-1])

    # ---- pass 3: load textures -------------------------------------------
    textures: dict[str, dict] = {}
    for tkey in sorted(texture_vars):
        png = os.path.join(tex_dir, tkey + ".png")
        tex = load_texture(tkey, png)
        if tex is not None:
            textures[tkey] = tex.to_nbt()

    # ---- emit builders ---------------------------------------------------
    # Wipe previously generated part files so a smaller run never leaves stale
    # orphans behind (they would be committed but unreferenced by _index).
    _clean_generated(args.datapack)
    emitted: list[str] = []
    emitted += _emit_textures(args.datapack, textures, args.chunk)
    emitted += _emit_shapes(args.datapack, shapes.shapes_nbt(), args.chunk)
    emitted += _emit_models(args.datapack, model_entries, args.chunk)
    emitted += _emit_states(args.datapack, states_entries, args.chunk)
    _emit_index(args.datapack, emitted)

    print(f"[meccha] blockstates : {len(states_entries)}")
    print(f"[meccha] models      : {len(model_entries)}")
    print(f"[meccha] shapes       : {len(shapes.shapes)}  (deduped)")
    print(f"[meccha] textures     : {len(textures)}")
    print(f"[meccha] emitted fns  : {len(emitted)} (+ _index)")
    if lib.missing:
        print(f"[meccha] WARN missing parent models ({len(lib.missing)}): "
              f"{', '.join(sorted(lib.missing)[:8])}"
              f"{' ...' if len(lib.missing) > 8 else ''}")
    if shapes.alias_mismatches:
        print(f"[meccha] WARN _KNOWN_PARENTS inconsistencies ({len(shapes.alias_mismatches)}) "
              f"- these parents produce the SAME shape but are mapped to DIFFERENT names:")
        for m in shapes.alias_mismatches:
            print(f"[meccha]   parent={m['parent_hint']!r} expected "
                  f"'{m['expected_name']}' but shape is already named "
                  f"'{m['actual_name']}' (model={m['model_id']}) - merge these "
                  f"two entries in _KNOWN_PARENTS to the same name")
    if shapes.clashes:
        print(f"[meccha] WARN shape name clashes ({len(shapes.clashes)}) - "
              f"auto-disambiguated, but check these:")
        for c in shapes.clashes:
            reason = ("a _KNOWN_PARENTS entry conflates two different shapes"
                      if c["known_parent"] else
                      "two unmapped models share a filename; consider adding "
                      f"{c['parent_hint']!r} to _KNOWN_PARENTS")
            print(f"[meccha]   '{c['wanted_name']}' -> '{c['resolved_name']}' "
                  f"(model={c['model_id']}, parent={c['parent_hint']}) - {reason}")
    shared_unmapped = shapes.unmapped_shared_shapes()
    if shared_unmapped:
        print(f"[meccha] note: {len(shared_unmapped)} shape(s) are reused by "
              f"multiple models but named from a fallback filename - add "
              f"their parent to _KNOWN_PARENTS for a stable canonical name:")
        for name, parent_hint, count in shared_unmapped[:8]:
            print(f"[meccha]   '{name}' used by {count} models (parent={parent_hint})")
    if no_geometry:
        print(f"[meccha] note: {len(no_geometry)} models have no in-world "
              f"geometry (block entities / missing parents / cross-only) - "
              f"they are skipped, e.g. {', '.join(no_geometry[:5])}")
    return 0


def _chunks(items, n):
    for i in range(0, len(items), n):
        yield i // n, items[i:i + n]


def _clean_generated(root):
    """Remove stale generated/*.mcfunction files before a fresh emit."""
    gdir = os.path.join(root, "data", "meccha", "function", "generated")
    if not os.path.isdir(gdir):
        return
    for name in os.listdir(gdir):
        if name.endswith(".mcfunction"):
            os.remove(os.path.join(gdir, name))


def _emit_textures(root, textures, chunk):
    ids = []
    items = list(textures.items())
    for part, batch in _chunks(items, chunk) or []:
        fn = FunctionWriter(f"meccha:generated/textures_part{part}",
                            "AUTO-GENERATED Texture Builder (#RRGGBBAA, alpha preserved)")
        for key, nbt in batch:
            fn.set_storage("meccha:registry", "textures." + qpath(key), nbt)
        fn.write(root)
        ids.append(fn.id)
    if not ids:
        fn = FunctionWriter("meccha:generated/textures_part0", "AUTO-GENERATED Texture Builder")
        fn.comment("no textures decoded")
        fn.write(root)
        ids.append(fn.id)
    return ids


def _emit_shapes(root, shapes_nbt, chunk):
    ids = []
    items = list(shapes_nbt.items())
    for part, batch in _chunks(items, max(1, chunk // 4)):
        fn = FunctionWriter(f"meccha:generated/shapes_part{part}",
                            "AUTO-GENERATED Vertex & Face Builder (p0/eu/ev/normal/uv/uvm per face)")
        for shape_id, nbt in batch:
            fn.set_storage("meccha:registry", "shapes." + qpath(shape_id), nbt)
        fn.write(root)
        ids.append(fn.id)
    return ids or [_empty(root, "shapes_part0")]


def _emit_models(root, model_entries, chunk):
    ids = []
    items = list(model_entries.items())
    for part, batch in _chunks(items, chunk):
        fn = FunctionWriter(f"meccha:generated/models_part{part}",
                            "AUTO-GENERATED Model-to-Shape/UV Builder")
        for model_id, nbt in batch:
            fn.set_storage("meccha:registry", "models." + qpath(model_id), nbt)
        fn.write(root)
        ids.append(fn.id)
    return ids or [_empty(root, "models_part0")]


def _emit_states(root, states_entries, chunk):
    ids = []
    for part, batch in _chunks(states_entries, chunk):
        fn = FunctionWriter(f"meccha:generated/states_part{part}",
                            "AUTO-GENERATED State-to-Model Builder (variants + multipart)")
        for block_id, nbt in batch:
            fn.set_storage("meccha:registry", "states." + qpath(block_id), nbt)
        fn.write(root)
        ids.append(fn.id)
    return ids or [_empty(root, "states_part0")]


def _empty(root, name):
    fn = FunctionWriter(f"meccha:generated/{name}", "AUTO-GENERATED (empty)")
    fn.comment("nothing to emit")
    fn.write(root)
    return fn.id


def _emit_index(root, emitted):
    fn = FunctionWriter("meccha:generated/_index",
                        "AUTO-GENERATED dispatcher - called once by build_registry")
    fn.comment("Order matters: textures -> shapes -> models -> states")
    for fid in emitted:
        fn.raw(f"function {fid}")
    fn.write(root)


if __name__ == "__main__":
    raise SystemExit(main())