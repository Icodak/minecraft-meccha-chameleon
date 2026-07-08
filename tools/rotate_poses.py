#!/usr/bin/env python3
"""
rotate_poses.py

Takes a "pose" .mcfunction file (of the meccha:rig/poses/<name>_apply shape)
and generates four direction variants (north / east / south / west) by
rigidly rotating every `$function meccha:rig/apply_pose {...}` call around
the vertical (Y) axis, pivoting at the rig root (0,0,0).

Usage:
    python rotate_poses.py crawling_apply.mcfunction superhero_landing_apply.mcfunction
    python rotate_poses.py *.mcfunction -o out/

--------------------------------------------------------------------------
ROTATION MODEL
--------------------------------------------------------------------------
Each cuboid line encodes:
    dx, dy, dz  -> offset from the rig root (world space)
    yaw, pitch  -> orientation, built as   R = Ry(yaw) * Rx(pitch)
                   (yaw turns the part around the vertical axis, pitch then
                    tilts it forward/back around ITS OWN, already-yawed,
                    local horizontal axis - the standard "look direction"
                    Euler convention, same one Minecraft uses for entity
                    rotation).

Rotating the WHOLE rig by an extra angle theta around the vertical axis
(to make it face a different compass direction) means left-multiplying
every part's orientation by Ry(theta):

    R' = Ry(theta) * R = Ry(theta) * Ry(yaw) * Rx(pitch)
                        = Ry(theta + yaw) * Rx(pitch)

Two rotations about the SAME axis (Y) simply add, so this collapses to:

    new_yaw   = yaw + theta
    new_pitch = pitch                       (unchanged!)
    (dx, dz)  = Ry(theta) applied to (dx, dz)
    dy        = unchanged

This is why pitch can never leave its original [-90, 90] range from this
operation alone: we're only ever adding to yaw. The clamp_pose() helper
below still performs the generic "flip around" correction
(yaw += 180, pitch = 180 - pitch) purely as a defensive safety net, in
case this script is ever reused for a transform that DOES need it
(e.g. a differently-ordered rotation convention, or mirroring).

--------------------------------------------------------------------------
DIRECTION -> ANGLE MAPPING
--------------------------------------------------------------------------
The rotation formulas below use Minecraft's real yaw handedness:

    x' = x*cos(theta) - z*sin(theta)
    z' = x*sin(theta) + z*cos(theta)

which makes yaw=0 point toward +Z (south), yaw=90 toward -X (west),
yaw=180 toward -Z (north), yaw=270 toward +X (east) - matching the
well-known Minecraft look-vector formula
(lookX = -cos(pitch)*sin(yaw), lookZ = cos(pitch)*cos(yaw)).
If your rig's yaw=0 does NOT correspond to "south" (+Z) in your world,
just edit DIRECTION_ANGLES below - everything else adapts automatically.
"""

import argparse
import math
import re
from pathlib import Path

# ---------------------------------------------------------------------------
# Configuration - edit this if your compass convention differs.
# The base file (theta=0) is treated as "south" facing here, matching
# Minecraft's real yaw convention: yaw=0 -> south(+Z), yaw=90 -> west(-X),
# yaw=180 -> north(-Z), yaw=270 -> east(+X). Swap the values around if your
# source poses actually represent a different base direction.
# ---------------------------------------------------------------------------
DIRECTION_ANGLES = {
    "south": 0,
    "west": 90,
    "north": 180,
    "east": 270,
}

POSE_LINE_RE = re.compile(
    r'^\$function meccha:rig/apply_pose \{'
    r'cuboid:"(?P<cuboid>[^"]+)",\s*'
    r'dx:(?P<dx>-?[\d.]+),\s*'
    r'dy:(?P<dy>-?[\d.]+),\s*'
    r'dz:(?P<dz>-?[\d.]+),\s*'
    r'yaw:(?P<yaw>-?[\d.]+),\s*'
    r'pitch:(?P<pitch>-?[\d.]+),\s*'
    r'rid:\$\(rid\)\}\s*$'
)

HEADER_RE = re.compile(r'^# (?P<path>[A-Za-z0-9_/:]+)(?P<rest>.*)$')


def fmt_num(n: float, decimals: int = 6) -> str:
    """Format a float like the source file: no needless trailing zeros,
    no '-0'."""
    n = round(n, decimals)
    if n == 0:
        n = 0.0
    if n == int(n):
        return str(int(n))
    s = f"{n:.{decimals}f}".rstrip('0').rstrip('.')
    return s


def rotate_xz(dx: float, dz: float, theta_deg: float) -> tuple[float, float]:
    """Rotate a (dx, dz) offset around the vertical axis at the pivot (0,0),
    using Minecraft's real yaw handedness (yaw=0 -> +Z, yaw=90 -> -X)."""
    t = math.radians(theta_deg)
    new_dx = dx * math.cos(t) - dz * math.sin(t)
    new_dz = dx * math.sin(t) + dz * math.cos(t)
    return new_dx, new_dz


def clamp_pose(yaw: float, pitch: float) -> tuple[float, float]:
    """Defensive safety net: keep pitch in [-90, 90] using the standard
    'flip around' trick, and normalize yaw to (-180, 180].
    For a pure vertical-axis rotation this is a no-op (pitch never leaves
    its original range), but it's kept here so the function stays correct
    if this script is ever reused for a transform that does need it."""
    if pitch > 90 or pitch < -90:
        pitch = 180 - pitch
        yaw += 180
    pitch = max(-90.0, min(90.0, pitch))
    yaw = ((yaw + 180) % 360) - 180
    return yaw, pitch


def transform_pose_line(match: re.Match, theta_deg: float) -> str:
    cuboid = match.group('cuboid')
    dx, dy, dz = (float(match.group(k)) for k in ('dx', 'dy', 'dz'))
    yaw, pitch = float(match.group('yaw')), float(match.group('pitch'))

    new_dx, new_dz = rotate_xz(dx, dz, theta_deg)
    new_dy = dy
    new_yaw = yaw + theta_deg
    new_yaw, new_pitch = clamp_pose(new_yaw, pitch)

    return (
        f'$function meccha:rig/apply_pose {{cuboid:"{cuboid}", '
        f'dx:{fmt_num(new_dx)}, dy:{fmt_num(new_dy)}, dz:{fmt_num(new_dz)}, '
        f'yaw:{fmt_num(new_yaw)}, pitch:{fmt_num(new_pitch)}, rid:$(rid)}}\n'
    )


def transform_header_line(line: str, direction: str) -> str:
    m = HEADER_RE.match(line)
    if not m:
        return line
    return f"# {m.group('path')}_{direction}{m.group('rest')}\n"


def generate_variant(lines: list[str], direction: str, theta_deg: float) -> list[str]:
    out = []
    header_done = False
    for line in lines:
        pose_match = POSE_LINE_RE.match(line)
        if pose_match:
            out.append(transform_pose_line(pose_match, theta_deg))
            continue
        if not header_done and line.lstrip().startswith('#') and 'poses/' in line:
            out.append(transform_header_line(line, direction))
            header_done = True
            continue
        out.append(line)
    return out


def process_file(input_path: Path, output_dir: Path) -> None:
    lines = input_path.read_text().splitlines(keepends=True)
    stem = input_path.stem
    suffix = input_path.suffix or '.mcfunction'

    for direction, theta in DIRECTION_ANGLES.items():
        variant_lines = generate_variant(lines, direction, theta)
        out_path = output_dir / f'{stem}_{direction}{suffix}'
        out_path.write_text(''.join(variant_lines))
        print(f'wrote {out_path}')


def main():
    parser = argparse.ArgumentParser(
        description='Generate north/east/south/west variants of a rig pose .mcfunction file.'
    )
    parser.add_argument('inputs', nargs='+', type=Path, help='Pose .mcfunction file(s)')
    parser.add_argument('-o', '--output-dir', type=Path, default=None,
                         help="Output directory (defaults to each input file's own directory)")
    args = parser.parse_args()

    for input_path in args.inputs:
        out_dir = args.output_dir or input_path.parent
        out_dir.mkdir(parents=True, exist_ok=True)
        process_file(input_path, out_dir)


if __name__ == '__main__':
    main()