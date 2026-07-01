"""Blockstate Parser (State-to-Model source data).

Handles BOTH vanilla hierarchies described in the task schema:

  * "variants"  : { "<state_predicate>": <apply> | [ <apply>, ... ] }
  * "multipart" : [ { "when": <cond>, "apply": <apply> | [ <apply>...] }, ... ]
                  where <cond> is a flat state map, or {"OR":[...]}, {"AND":[...]}.

Each <apply> carries: model (path), x, y, z (rotation), uvlock, weight.
We normalise everything to a single in-game-friendly form and let the
in-game State-to-Model lookup (Pillar 4.1 Step 2) pick the matching entry.
"""
from __future__ import annotations
import json
import os


def _norm_apply(apply) -> list[dict]:
    """A variant/case `apply` may be one object or a weighted list."""
    items = apply if isinstance(apply, list) else [apply]
    out = []
    for it in items:
        model = it["model"].split(":", 1)[-1]
        # Strip the conventional "block/" we re-add at lookup time? Keep full.
        out.append({
            "model": model,                       # e.g. "block/oak_stairs"
            "x": int(it.get("x", 0)),
            "y": int(it.get("y", 0)),
            "z": int(it.get("z", 0)),
            "uvlock": bool(it.get("uvlock", False)),
            "weight": int(it.get("weight", 1)),
        })
    return out


def _norm_when(when) -> dict:
    """Normalise a multipart `when` into {mode, terms}.

    mode = "AND" (default, flat map), "OR", or "ANDOR" when explicit.
    Each term is a {key: [allowed,...]} map (vanilla allows "a|b" alternatives).
    """
    if when is None:
        return {"mode": "ALWAYS", "terms": []}
    if "OR" in when:
        return {"mode": "OR", "terms": [_flat_terms(w) for w in when["OR"]]}
    if "AND" in when:
        return {"mode": "AND", "terms": [_flat_terms(w) for w in when["AND"]]}
    return {"mode": "AND", "terms": [_flat_terms(when)]}


def _flat_terms(cond: dict) -> dict:
    out = {}
    for k, v in cond.items():
        out[k] = [s for s in str(v).split("|")]
    return out


def _variant_key_to_when(key: str) -> dict:
    """'facing=east,half=bottom' -> {mode:'AND', terms:[{facing:[east],half:[bottom]}]}.
    The empty variant key ('') means the default/always case."""
    if key == "":
        return {"mode": "ALWAYS", "terms": []}
    terms = {}
    for pair in key.split(","):
        if "=" not in pair:
            continue
        k, v = pair.split("=", 1)
        terms[k] = v.split("|")
    return {"mode": "AND", "terms": [terms]}


def _itertools_product(lists):
    if not lists:
        yield []
        return
    head, rest = lists[0], lists[1:]
    for h in head:
        for r in _itertools_product(rest):
            yield [h] + r


def _term_to_subsets(term: dict) -> list[dict]:
    """{facing:[east], half:[a,b]} -> [{facing:east,half:a},{facing:east,half:b}]."""
    keys = list(term.keys())
    choices = [term[k] for k in keys]
    subsets = []
    for combo in _itertools_product(choices):
        subsets.append({k: combo[i] for i, k in enumerate(keys)})
    return subsets


def _when_to_tests(when: dict) -> list[dict]:
    """Flatten a normalised `when` into concrete property subsets.

    Case matches at runtime iff the live block properties CONTAIN any subset.
    AND -> intersection across terms (cartesian product of subsets, merged).
    OR  -> union of each term's subsets. ALWAYS -> [] (unconditional).
    """
    mode = when.get("mode", "ALWAYS")
    terms = when.get("terms", [])
    if mode == "ALWAYS" or not terms:
        return []
    if mode == "OR":
        out = []
        for t in terms:
            out += _term_to_subsets(t)
        return out
    # AND: merge one subset choice per term.
    per_term = [_term_to_subsets(t) for t in terms]
    merged = []
    for combo in _itertools_product(per_term):
        m = {}
        for sub in combo:
            m.update(sub)
        merged.append(m)
    return merged


class Blockstate:
    def __init__(self, block_id: str):
        self.block_id = block_id          # "minecraft:oak_stairs"
        self.kind = "variants"
        self.variants: dict[str, list[dict]] = {}
        self.multipart: list[dict] = []

    def to_nbt(self) -> dict:
        # Unified, iterable `cases` form so the in-game matcher has ONE code
        # path for both hierarchies:
        #   match="first" (variants: exactly one case applies)
        #   match="all"   (multipart: every matching case contributes)
        if self.kind == "variants":
            cases = []
            for key, apply in self.variants.items():
                when = _variant_key_to_when(key)
                cases.append({"tests": _when_to_tests(when), "apply": apply})
            return {"kind": "variants", "match": "first", "cases": cases}
        cases = []
        for case in self.multipart:
            cases.append({"tests": _when_to_tests(case["when"]), "apply": case["apply"]})
        return {"kind": "multipart", "match": "all", "cases": cases}


def parse_blockstate(block_id: str, path: str) -> Blockstate:
    with open(path, "r", encoding="utf-8") as fh:
        data = json.load(fh)
    bs = Blockstate(block_id)
    if "multipart" in data:
        bs.kind = "multipart"
        for case in data["multipart"]:
            bs.multipart.append({
                "when": _norm_when(case.get("when")),
                "apply": _norm_apply(case["apply"]),
            })
    else:
        bs.kind = "variants"
        for key, apply in data.get("variants", {}).items():
            bs.variants[key] = _norm_apply(apply)
    return bs


def iter_blockstates(blockstates_dir: str):
    for fname in sorted(os.listdir(blockstates_dir)):
        if not fname.endswith(".json"):
            continue
        block_id = "minecraft:" + fname[:-5]
        yield parse_blockstate(block_id, os.path.join(blockstates_dir, fname))
