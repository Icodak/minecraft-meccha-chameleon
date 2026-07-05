#!/usr/bin/env bash
# Regenerate all precomputed datapack data from source assets + rig spec.
set -euo pipefail
PY="${PYTHON:-python3}"
ASSETS="${1:-tools/sample_assets/assets}"
echo "==> Asset pipeline (Pillar 2)"
"$PY" tools/parse_assets.py --assets "$ASSETS" --datapack ./datapacks/meccha-cameleon
echo "==> Rig generator (Pillar 5)"
"$PY" tools/build_rig.py --datapack ./datapacks/meccha-cameleon --scale 0.5
echo "==> Colour-picker dialog"
"$PY" tools/build_dialog.py --datapack ./datapacks/meccha-cameleon
echo "==> Validate"
"$PY" tools/validate_pack.py
