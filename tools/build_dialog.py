#!/usr/bin/env python3
"""Meccha Chameleon - colour-picker Dialog generator.

Emits:
1. data/meccha/dialog/color_picker.json (Raw JSON dialog)
2. data/meccha/function/dialog/open_macro.mcfunction (Inlined macro)
"""

from __future__ import annotations

import argparse
import colorsys
import json
import math
import os

# Palette layout.
OKLAB_ROWS = 4
SRGB_ROWS = 4

# Adjust action codes
ADJ_BRIGHTER, ADJ_DARKER, ADJ_SAT_UP, ADJ_SAT_DOWN = 1, 2, 3, 4

def oklch_to_srgb_hex(L: float, C: float, H_deg: float) -> str:
    a = C * math.cos(math.radians(H_deg))
    b = C * math.sin(math.radians(H_deg))

    l_ = L + 0.3963377774 * a + 0.2158037573 * b
    m_ = L - 0.1055613458 * a - 0.0638541728 * b
    s_ = L - 0.0894841775 * a - 1.2914855480 * b

    l = l_ ** 3
    m = m_ ** 3
    s = s_ ** 3

    r = 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s
    g = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s
    b = -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s

    return "#" + "".join(_lin_to_byte(c) for c in (r, g, b))


def _lin_to_byte(x: float) -> str:
    x = min(1.0, max(0.0, x))
    x = 12.92 * x if x <= 0.0031308 else 1.055 * (x ** (1 / 2.4)) - 0.055
    return f"{round(min(1.0, max(0.0, x)) * 255):02X}"


def _packed(hexstr: str) -> int:
    r = int(hexstr[1:3], 16)
    g = int(hexstr[3:5], 16)
    b = int(hexstr[5:7], 16)
    return (r << 16) | (g << 8) | b


def _swatch(hexstr: str) -> dict:
    val = _packed(hexstr) + 1
    return {
        "label": {"text": "███", "color": hexstr},
        "tooltip": hexstr,
        "width": 28,
        "action": {
            "type": "run_command",
            "command": f"trigger meccha.pick_rgb set {val}",
        },
    }


def _adjust(label: str, color: str, code: int, tip: str) -> dict:
    return {
        "label": {"text": label, "color": color, "bold": True},
        "tooltip": tip,
        "width": 96,
        "action": {
            "type": "run_command",
            "command": f"trigger meccha.pick_adj set {code}",
        },
    }


def build(datapack: str, hues: int):
    actions = []
    # 1. OKLCH palette
    chroma = 0.125
    for ri in range(OKLAB_ROWS):
        L = 0.92 - (ri / (OKLAB_ROWS - 1)) * 0.62
        for ci in range(hues):
            H = (360.0 / hues) * ci
            actions.append(_swatch(oklch_to_srgb_hex(L, chroma, H)))

    # 2. sRGB palette
    values = [1.00, 0.80, 0.60, 0.40]
    for value in values:
        for ci in range(hues):
            hue = ci / hues
            r, g, b = colorsys.hsv_to_rgb(hue, 1.0, value)
            actions.append(_swatch("#{0:02X}{1:02X}{2:02X}".format(round(r * 255), round(g * 255), round(b * 255))))

    # 3. Grayscale
    for ci in range(hues):
        L = 0.96 - (ci / max(1, hues - 1)) * 0.82
        actions.append(_swatch(oklch_to_srgb_hex(L, 0.0, 0.0)))

    actions.append(_adjust("☀ Brighter", "#FFE08A", ADJ_BRIGHTER, "Increase brightness"))
    actions.append(_adjust("☾ Darker", "#9AA0B5", ADJ_DARKER, "Decrease brightness"))
    actions.append(_adjust("✦ Saturate +", "#7ED0FF", ADJ_SAT_UP, "Increase saturation"))
    actions.append(_adjust("✧ Saturate −", "#B9B9B9", ADJ_SAT_DOWN, "Decrease saturation"))
    

    for act in actions[-4:]:
        act["width"] = 84

    brushes = [("▪ pixel", 0), ("🞤 cross", 1), ("■ face", 2), ("❒ cube", 3)]
    for label, val in brushes:
        actions.append({
            "label": {"text": label, "color": "gray"},
            "width": 63,
            "action": {
                "type": "run_command",
                "command": f"trigger meccha.brush_type set {val}"
            }
        })


    # ------------------------------------------------------------------
    # Dialog Object Base
    # ------------------------------------------------------------------
    dialog = {
        "type": "minecraft:multi_action",
        "title": {
            "text": "Meccha Colour Picker",
            "color": "white",
            "bold": True,
        },
        "external_title": "Colour Picker",
        "pause": False,
        "after_action": "none",
        "body": [
            {
                "type": "minecraft:plain_message",
                "width": 640,
                "contents": [
                    {"text": "Tap a swatch to set your colour. ", "color": "black"},
                    {"text": "Adjust brightness/saturation below.", "color": "white"},
                ],
            }
        ],
        "columns": hues,
        "actions": actions,
        "exit_action": {
            "label": {"text": "Done", "color": "green"},
            "width": 120,
            "action": {"type": "run_command", "command": "trigger meccha.pick_adj set 0"}
        },
    }

    # Generate directories
    os.makedirs(os.path.join(datapack, "data/meccha/dialog"), exist_ok=True)
    os.makedirs(os.path.join(datapack, "data/meccha/function/dialog"), exist_ok=True)

    # 1. Output the raw JSON
    json_path = os.path.join(datapack, "data/meccha/dialog/color_picker.json")
    with open(json_path, "w", encoding="utf-8") as fh:
        json.dump(dialog, fh, ensure_ascii=False, indent=2)

    # 2. Setup the Macro exit_action & output the inlined mcfunction
    dialog["exit_action"] = {
        "label": {
            "text": "Color: ████████████",
            "color": "$(rgb)"
        },
        "width": 256,
        "action": {
            "type": "run_command",
            "command": "trigger meccha.pick_adj set 0"
        }
    }
    
    macro_path = os.path.join(datapack, "data/meccha/function/dialog/open_macro.mcfunction")
    # Dumping to compact string for the inline macro command
    dialog_str = json.dumps(dialog, ensure_ascii=False, separators=(',', ':'))
    
    with open(macro_path, "w", encoding="utf-8") as fh:
        fh.write(f"$dialog show @s {dialog_str}\n")

    total_rows = OKLAB_ROWS + SRGB_ROWS + 1
    print(f"[meccha-dialog] Built {len(actions)} buttons ({hues}x{total_rows} palette + tools)")
    print(f" -> {json_path}")
    print(f" -> {macro_path}")

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--datapack", required=True)
    ap.add_argument("--hues", type=int, default=12)
    args = ap.parse_args()
    build(args.datapack, args.hues)