#!/usr/bin/env bash
#
# generate_rotations.sh
#
# Runs rotate_poses.py on every .mcfunction file directly inside
#   datapacks/meccha-cameleon/data/meccha/function/rig/poses/
# and writes the north/east/south/west variants into
#   datapacks/meccha-cameleon/data/meccha/function/rig/poses/generated_rotations/
#
# Run this from the repo root (the folder that contains "datapacks"),
# or pass the repo root as the first argument:
#     ./generate_rotations.sh /path/to/repo
#
# Expects rotate_poses.py to sit next to this script. Requires
# "python3" to be on PATH.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON="python3"
SCRIPT="$SCRIPT_DIR/tools/rotate_poses.py"

ROOT="${1:-.}"
SRC_DIR="$ROOT/datapacks/meccha-cameleon/data/meccha/function/rig/poses"
OUT_DIR="$SRC_DIR/generated_rotations"

if [ ! -f "$SCRIPT" ]; then
    echo "ERROR: could not find rotate_poses.py next to this script ($SCRIPT)" >&2
    exit 1
fi

if [ ! -d "$SRC_DIR" ]; then
    echo "ERROR: source folder not found: $SRC_DIR" >&2
    exit 1
fi

mkdir -p "$OUT_DIR"

count=0
shopt -s nullglob
for f in "$SRC_DIR"/*.mcfunction; do
    echo "Processing $(basename "$f") ..."
    "$PYTHON" "$SCRIPT" "$f" -o "$OUT_DIR"
    count=$((count + 1))
done
shopt -u nullglob

if [ "$count" -eq 0 ]; then
    echo "No .mcfunction files found in $SRC_DIR"
else
    echo "Done. Processed $count file(s). Output in $OUT_DIR"
fi