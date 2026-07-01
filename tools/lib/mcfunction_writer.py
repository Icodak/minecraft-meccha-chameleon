"""SNBT serialisation helpers + a small builder that batches `data modify`
commands into .mcfunction files.

The whole Pillar-2 pipeline funnels its writes through here so that the exact
NBT layout consumed in-game (see NBT_SCHEMA.md) is produced in exactly one
place. Keeping serialisation centralised avoids subtle SNBT quoting bugs.
"""
from __future__ import annotations
from typing import Any
import json
import os


class F(float):
    """Marker subclass: serialise as a 32-bit FLOAT (trailing 'f').

    Required for fields the game stores as floats - notably the display
    `transformation` (translation / left_rotation / right_rotation / scale).
    Passing doubles there can make a display entity fail to load.
    """


def snbt(value: Any) -> str:
    """Serialise a Python value to Minecraft SNBT.

    Rules we care about:
      * dict keys are emitted unquoted when they are simple identifiers,
        quoted otherwise (e.g. namespaced ids "minecraft:oak_stairs").
      * F(...) -> float ('f');  plain float -> double ('d').
      * bools become 1b / 0b.
      * lists of small ints we leave as plain lists (not typed arrays) because
        the values are read individually with `data get`.
    """
    if isinstance(value, bool):
        return "1b" if value else "0b"
    if isinstance(value, F):
        return f"{float(value):.6f}".rstrip("0").rstrip(".") + "f"
    if isinstance(value, int):
        return str(value)
    if isinstance(value, float):
        # Trim noise but keep a decimal so MC parses a double.
        return f"{value:.6f}".rstrip("0").rstrip(".") + "d"
    if isinstance(value, str):
        escaped = value.replace("\\", "\\\\").replace('"', '\\"')
        return f'"{escaped}"'
    if isinstance(value, list):
        return "[" + ",".join(snbt(v) for v in value) + "]"
    if isinstance(value, dict):
        parts = []
        for k, v in value.items():
            key = k if _is_bare_key(k) else f'"{k}"'
            parts.append(f"{key}:{snbt(v)}")
        return "{" + ",".join(parts) + "}"
    raise TypeError(f"Cannot serialise {type(value)!r} to SNBT")


def _is_bare_key(k: str) -> bool:
    return bool(k) and all(c.isalnum() or c in "_-+." for c in k) and not k[0].isdigit()


class FunctionWriter:
    """Accumulates lines for a single .mcfunction file."""

    def __init__(self, mcfunction_id: str, header: str = ""):
        self.id = mcfunction_id          # e.g. "meccha:generated/textures"
        self.lines: list[str] = []
        if header:
            for line in header.splitlines():
                self.lines.append(f"# {line}")

    def comment(self, text: str) -> None:
        self.lines.append(f"# {text}")

    def raw(self, line: str) -> None:
        self.lines.append(line)

    def set_storage(self, storage: str, path: str, value: Any) -> None:
        self.lines.append(f"data modify storage {storage} {path} set value {snbt(value)}")

    def append_storage(self, storage: str, path: str, value: Any) -> None:
        self.lines.append(f"data modify storage {storage} {path} append value {snbt(value)}")

    def write(self, datapack_root: str) -> str:
        ns, rel = self.id.split(":", 1)
        out_path = os.path.join(datapack_root, "data", ns, "function", rel + ".mcfunction")
        os.makedirs(os.path.dirname(out_path), exist_ok=True)
        with open(out_path, "w", encoding="utf-8") as fh:
            fh.write("\n".join(self.lines) + "\n")
        return out_path
