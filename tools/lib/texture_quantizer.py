"""Texture Builder source data.

Reads a PNG (RGBA) and flattens it into a row-major list of `#RRGGBBAA`
strings. The alpha channel is ALWAYS preserved (Pillar 2.4): fully transparent
pixels become "#00000000" and the in-game eyedropper treats any color whose
final two hex digits are "00" as a miss.

Falls back gracefully if Pillow is unavailable so the rest of the pipeline can
still be exercised in CI / dry runs.
"""
from __future__ import annotations
from typing import Optional
import os

try:
    from PIL import Image
    _HAVE_PIL = True
except Exception:  # pragma: no cover - environment without Pillow
    _HAVE_PIL = False


class Texture:
    def __init__(self, key: str, width: int, height: int, pixels: list[str]):
        self.key = key            # e.g. "block/oak_planks"
        self.width = width
        self.height = height
        self.pixels = pixels      # row-major, len == width*height, "#RRGGBBAA"

    def to_nbt(self) -> dict:
        # `frames` lets an animated texture (e.g. .mcmeta strip) be addressed
        # later; for a static sprite we expose the single 16x16 (or NxN) grid.
        return {"w": self.width, "h": self.height, "px": self.pixels}


def _hex(r: int, g: int, b: int, a: int) -> str:
    return f"#{r:02X}{g:02X}{b:02X}{a:02X}"


def load_texture(key: str, png_path: str) -> Optional[Texture]:
    if not os.path.isfile(png_path):
        return None
    if not _HAVE_PIL:
        # Deterministic placeholder so downstream wiring still validates:
        # a single opaque magenta pixel marks "texture not decoded".
        return Texture(key, 1, 1, ["#FF00FFFF"])

    img = Image.open(png_path).convert("RGBA")
    w, h = img.size
    # Many block sprites are vertical animation strips (h = N*w). We only keep
    # the first frame so geometry UVs (which address a 16x16 sprite) stay valid.
    if h > w and h % w == 0:
        h = w
        img = img.crop((0, 0, w, h))
    px = []
    data = img.load()
    for y in range(h):
        for x in range(w):
            r, g, b, a = data[x, y]
            px.append(_hex(r, g, b, a))
    return Texture(key, w, h, px)
