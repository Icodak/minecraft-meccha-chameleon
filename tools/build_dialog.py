#!/usr/bin/env python3
"""Meccha Chameleon - color-picker Dialog generator.

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
ADJ_BRIGHTER, ADJ_DARKER, ADJ_SAT_UP, ADJ_SAT_DOWN, ENABLE_DIR_LIGHTING, DISABLE_DIR_LIGHTING = 1, 2, 3, 4, 5, 6

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
        "width": 30,
        "action": {
            "type": "run_command",
            "command": f"trigger meccha.pick_rgb set {val}",
        },
    }


def _adjust(label: str, color: str, code: int, tip: str) -> dict:
    return {
        "label": {"text": label, "color": color, "bold": True},
        "tooltip": tip,
        "width": 84,
        "action": {
            "type": "run_command",
            "command": f"trigger meccha.pick_adj set {code}",
        },
    }


def _dummy(width: int = 1, text: str = "") -> dict:
    return {
        "label": {"text": text, "color": "gold"},
        "width": width,
        "action": {
            "type": "run_command",
            "command": "trigger meccha.pick_adj set 0",
        },
    }


def build(datapack: str, hues: int):
    actions = []

    # Map adjustments to rows dynamically
    # OKLCH Rows: 0, 1, 2, 3 -> Brightness updates on rows 0 and 1
    # sRGB Rows:  4, 5, 6, 7 -> Saturation updates moved to rows 6 and 7 (bottom rows)
    adjustments = {
        0: _adjust("☀ Brighter", "#FFE08A", ADJ_BRIGHTER, "Increase brightness"),
        1: _adjust("☾ Darker", "#9AA0B5", ADJ_DARKER, "Decrease brightness"),
        3: _adjust("✦ Sat +", "#7ED0FF", ADJ_SAT_UP, "Increase saturation"),
        4: _adjust("✧ Sat −", "#B9B9B9", ADJ_SAT_DOWN, "Decrease saturation"),
        6: _adjust("Auto light on", "#9AEE6A", ENABLE_DIR_LIGHTING, f"When painting, faces will have a directional shadow applied to them depending on their orientation akin to minecraft blocks\n{shaded_cube_ascii()}"),
        7: _adjust("Auto light off", "#F88253", DISABLE_DIR_LIGHTING, f"When painting, faces will have the same flat color applied to them, no matter the orientation\n{flat_cube_ascii()}"),
    }

    current_row = 0

    # 1. OKLCH palette rows
    chroma = 0.125
    for ri in range(OKLAB_ROWS):
        actions.append(adjustments.get(current_row, _dummy()))
        
        L = 0.92 - (ri / (OKLAB_ROWS - 1)) * 0.62
        for ci in range(hues):
            H = (360.0 / hues) * ci
            actions.append(_swatch(oklch_to_srgb_hex(L, chroma, H)))
        current_row += 1

    # 2. sRGB palette rows
    values = [1.00, 0.80, 0.60, 0.40]
    for value in values:
        actions.append(adjustments.get(current_row, _dummy()))

        for ci in range(hues):
            hue = ci / hues
            r, g, b = colorsys.hsv_to_rgb(hue, 1.0, value)
            actions.append(_swatch("#{0:02X}{1:02X}{2:02X}".format(round(r * 255), round(g * 255), round(b * 255))))
        current_row += 1

    # 3. Grayscale row
    actions.append(adjustments.get(current_row, _dummy()))
    for ci in range(hues):
        L = 0.96 - (ci / max(1, hues - 1)) * 0.82
        actions.append(_swatch(oklch_to_srgb_hex(L, 0.0, 0.0)))
    current_row += 1

    # 4. Final Row: Brush utilities
    # Left adjustment spot is replaced by a non-functional label button of width 84
    for i in range(hues + 1):
        actions.append(_dummy())

    actions.append(_dummy(width=100, text="Brush size"))
    
    brushes = [("▪ pixel ▪", 0, pixel_ascii()), ("🞤 cross 🞤", 1, cross_ascii()), ("■ face ■", 2, face_ascii()), ("❒ cube ❒", 3, cube_ascii())]
    for label, val, tooltip in brushes:
        actions.append({
            "label": {"text": label, "color": "white"},
            "tooltip": tooltip,
            "width": 80,
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
            "text": "Brush settings - Size & Color adjustments",
            "color": "white",
            "bold": True,
        },
        "external_title": "Color Picker",
        "pause": False,
        "after_action": "none",
        "body": [
            {
                "type": "minecraft:plain_message",
                "width": 640,
                "contents": [
                    {"text": "Adjust on the left. ", "color": "yellow"},
                    {"text": "Tap a swatch to set your color.", "color": "white"},
                ],
            }
        ],
        "columns": hues + 1,
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
            "text": "█████████ [Current color] █████████",
            "color": "$(rgb)"
        },
        "width": 256,
        "action": {
            "type": "run_command",
            "command": "trigger meccha.pick_adj set 0"
        }
    }
    
    macro_path = os.path.join(datapack, "data/meccha/function/dialog/open_macro.mcfunction")
    dialog_str = json.dumps(dialog, ensure_ascii=False, separators=(',', ':'))
    
    with open(macro_path, "w", encoding="utf-8") as fh:
        fh.write(f"$dialog show @s {dialog_str}\n")

    total_rows = OKLAB_ROWS + SRGB_ROWS + 2  # Included the brush row in count
    print(f"[meccha-dialog] Built {len(actions)} buttons ({hues + 1}x{total_rows} matrix layout)")
    print(f" -> {json_path}")
    print(f" -> {macro_path}")

def pixel_ascii() -> str:
    return " \u0020 \u0020 +------+\n \u0020 \u0020/ \u0020 \u0020 \u0020 \u0020 /|\n \u0020 / \u0020 \u0020 \u0020 \u0020/ \u0020|\n \u0020+-----+ \u0020 +\n \u0020| \u0020 \u0020 \u0020 \u0020 | \u0020 /\n \u0020| \u0020 \u0020\u2588 \u0020 | \u0020/\n \u0020| \u0020 \u0020 \u0020 \u0020 | /\n \u0020+-----+"

def cross_ascii() -> str:
    return " \u0020 \u0020 +------+\n \u0020 \u0020/ \u0020 \u0020 \u0020 \u0020 /|\n \u0020 / \u0020 \u0020 \u0020 \u0020/ \u0020|\n \u0020+-----+ \u0020 +\n \u0020| \u0020 \u0020\u2588 \u0020 | \u0020 /\n \u0020| \u0020\u2588\u2588\u2588 | \u0020/\n \u0020| \u0020 \u0020\u2588 \u0020 | /\n \u0020+-----+"

def face_ascii() -> str:
    return " \u0020 \u0020 +------+\n \u0020 \u0020/ \u0020 \u0020 \u0020 \u0020 /|\n \u0020 / \u0020 \u0020 \u0020 \u0020/ \u0020|\n \u0020+-----+ \u0020 +\n \u0020|\u2588\u2588\u2588\u2588| \u0020 /\n \u0020|\u2588\u2588\u2588\u2588| \u0020/\n \u0020|\u2588\u2588\u2588\u2588| /\n \u0020+-----+"

def cube_ascii() -> str:
    return " \u0020 \u0020 +\u2584\u2584\u2584\u2584+\n \u0020 \u0020\u25e2\u2588\u2588\u2588\u275a\u25e4\u25e2\u258d\n \u0020 \u25e2\u2588\u2588\u2588\u275a\u25e4\u25e2\u275a\u258d\n \u0020+\u2584\u2584\u2584 +\u25e2\u275a\u258d\u258d\n \u0020|\u2588\u2588\u2588\u2588 \u275a\u275a\u25e4\n \u0020|\u2588\u2588\u2588\u2588 \u275a\u25e4\n \u0020|\u2588\u2588\u2588\u2588 \u25e4\n \u0020+-----+"

def shaded_cube_ascii() -> str:
    return " \u0020 \u0020 \u0020 x---------x\n \u0020 \u0020 \u0020///////////.| \n \u0020 \u0020 ///////////...| \n \u0020 \u0020x---------x.....| \n \u0020 \u0020|\\\\\\\\\\\\\\\\\\\\|......| \n \u0020 \u0020|\\\\\\\\\\\\\\\\\\\\|.....x\n \u0020 \u0020|\\\\\\\\\\\\\\\\\\\\|.../ \n \u0020 \u0020|\\\\\\\\\\\\\\\\\\\\|/ \u0020\n \u0020 \u0020x---------x "

def flat_cube_ascii() -> str:
    return " \u0020 \u0020 \u0020 x---------x\n \u0020 \u0020 \u0020/\\\\\\\\\\\\\\\\\\\\| \n \u0020 \u0020 / \\\\\\\\\\\\\\\\\\\\| \n \u0020 \u0020x.\\\\\\\\\\\\\\\\x\\\\| \n \u0020 \u0020|\\\\\\\\\\\\\\\\\\\\\\\\| \n \u0020 \u0020|\\\\\\\\\\\\\\\\\\\\\\\\x\n \u0020 \u0020|\\\\\\\\\\\\\\\\\\\\\\/ \n \u0020 \u0020|\\\\\\\\\\\\\\\\\\\\/ \u0020\n \u0020 \u0020x---------x "


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--datapack", required=True)
    ap.add_argument("--hues", type=int, default=12)
    args = ap.parse_args()
    build(args.datapack, args.hues)