#!/usr/bin/env python3
"""Meccha Chameleon \u2014 colour-picker Dialog generator.

Emits data/meccha/dialog/color_picker.json: a `minecraft:multi_action` dialog
(1.21.6+ Dialog system, available in 26.2) whose body is a perceptually-uniform
swatch grid laid out in OKLCH space (hue across columns, lightness down rows,
plus a grayscale row). Each swatch is a tinted "\u25a0\u25a0" button; clicking it runs a
non-op-safe `/trigger meccha.pick_rgb set <packed+1>` that the datapack decodes
and applies as the active colour. Brightness / saturation adjust buttons sit
below the grid (`meccha.pick_adj`).

This picker is fully DECORRELATED from the in-world eyedropper \u2014 it is a second,
independent way to choose the brush colour.

Usage: python tools/build_dialog.py --datapack . [--hues 12 --rows 8]
"""
from __future__ import annotations
import argparse
import json
import math
import os

# Adjust action codes (must match dialog/apply_adj.mcfunction).
ADJ_BRIGHTER, ADJ_DARKER, ADJ_SAT_UP, ADJ_SAT_DOWN = 1, 2, 3, 4


def oklch_to_srgb_hex(L: float, C: float, H_deg: float) -> str:
    a = C * math.cos(math.radians(H_deg))
    b = C * math.sin(math.radians(H_deg))
    # OKLab -> linear sRGB (Bjorn Ottosson).
    l_ = L + 0.3963377774 * a + 0.2158037573 * b
    m_ = L - 0.1055613458 * a - 0.0638541728 * b
    s_ = L - 0.0894841775 * a - 1.2914855480 * b
    l, m, s = l_ ** 3, m_ ** 3, s_ ** 3
    r = 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s
    g = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s
    bch = -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
    return "#" + "".join(_lin_to_byte(c) for c in (r, g, bch))


def _lin_to_byte(x: float) -> str:
    x = min(1.0, max(0.0, x))                 # gamut clamp
    x = 12.92 * x if x <= 0.0031308 else 1.055 * (x ** (1 / 2.4)) - 0.055
    return f"{round(min(1.0, max(0.0, x)) * 255):02X}"


def _packed(hexstr: str) -> int:
    r = int(hexstr[1:3], 16); g = int(hexstr[3:5], 16); b = int(hexstr[5:7], 16)
    return (r << 16) | (g << 8) | b


def _swatch(hexstr: str) -> dict:
    # +1 offset so pure black (packed 0) is still detected by scores=1..
    val = _packed(hexstr) + 1
    return {
        "label": {"text": "\u25a0\u25a0", "color": hexstr},
        "tooltip": hexstr,
        "width": 28,
        "action": {"type": "run_command",
                   "command": f"trigger meccha.pick_rgb set {val}"},
    }


def _adjust(label: str, color: str, code: int, tip: str) -> dict:
    return {
        "label": {"text": label, "color": color, "bold": True},
        "tooltip": tip,
        "width": 96,
        "action": {"type": "run_command",
                   "command": f"trigger meccha.pick_adj set {code}"},
    }


def build(datapack: str, hues: int, rows: int):
    actions = []
    chroma = 0.125
    # Hue x Lightness grid (lightness high -> low down the rows).
    for ri in range(rows):
        L = 0.92 - (ri / max(1, rows - 1)) * 0.62      # ~0.92 .. 0.30
        for ci in range(hues):
            H = (360.0 / hues) * ci
            actions.append(_swatch(oklch_to_srgb_hex(L, chroma, H)))
    # Grayscale row (C = 0) spanning light -> dark.
    for ci in range(hues):
        L = 0.96 - (ci / max(1, hues - 1)) * 0.82
        actions.append(_swatch(oklch_to_srgb_hex(L, 0.0, 0.0)))

    # Brightness / saturation controls, BELOW the grid.
    actions.append(_adjust("\u2600 Brighter", "#FFE08A", ADJ_BRIGHTER, "Increase brightness"))
    actions.append(_adjust("\u263e Darker", "#9AA0B5", ADJ_DARKER, "Decrease brightness"))
    actions.append(_adjust("\u25c8 Saturate +", "#7ED0FF", ADJ_SAT_UP, "Increase saturation"))
    actions.append(_adjust("\u25c7 Saturate \u2212", "#B9B9B9", ADJ_SAT_DOWN, "Decrease saturation"))

    dialog = {
        "type": "minecraft:multi_action",
        "title": {"text": "Meccha Colour Picker", "color": "white", "bold": True},
        "external_title": "Colour Picker",
        # Keep the menu open after each click so colours can be tried live.
        "pause": False,
        "after_action": "none",
        "body": [{
            "type": "minecraft:plain_message",
            "width": 320,
            "contents": [
                {"text": "Tap a swatch to set your colour. ", "color": "gray"},
                {"text": "Adjust brightness/saturation below.", "color": "dark_gray"},
            ],
        }],
        "columns": hues,
        "actions": actions,
        "exit_action": {
            "label": {"text": "Done", "color": "green"},
            "width": 120,
            "action": {"type": "run_command", "command": "trigger meccha.pick_adj set 0"},
        },
    }

    out = os.path.join(datapack, "data", "meccha", "dialog", "color_picker.json")
    os.makedirs(os.path.dirname(out), exist_ok=True)
    with open(out, "w", encoding="utf-8") as fh:
        json.dump(dialog, fh, ensure_ascii=False, indent=2)
    print(f"[meccha-dialog] {len(actions)} buttons "
          f"({hues}x{rows} grid + {hues} grays + 4 adjust) -> {out}")


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--datapack", required=True)
    ap.add_argument("--hues", type=int, default=12)
    ap.add_argument("--rows", type=int, default=8)
    args = ap.parse_args()
    build(args.datapack, args.hues, args.rows)
