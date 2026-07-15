#!/usr/bin/env python3
"""
Meccha Chameleon - Known Parents Dictionary Generator
Scans the vanilla block models directory, finds all models acting as parents,
groups them by their unique geometry/UV variable signature, and outputs
a safe, collision-free `_KNOWN_PARENTS` dictionary configuration.

NOTE ON GROUPING: This table is intentionally ROTATION-AGNOSTIC. It names only
the base silhouette of each parent template (keyed by the texture-agnostic
`_signature`, identical to the one shape_grouper.intern uses). At build time
parse_assets derives a rotation tag from each variant's apply block (e.g.
"__x0_y180_z0" or "__x0_y90_z0_uvlock") and shape_grouper.intern appends it to
the base canonical name below. So a base template like block/button yields
names such as "button", "button__x0_y180_z0", ... - all sharing this single
base entry. Do NOT add rotated entries here; emit base names only.
"""
from __future__ import annotations
import os
import json
import sys

# Ensure the script can see neighbor modules in tools/lib/
sys.path.insert(0, os.path.dirname(__file__))

try:
    from model_resolver import ModelLibrary
    from shape_grouper import _signature
except ImportError:
    print("[Error] Could not import modules. Ensure this script is placed in tools/lib/.")
    sys.exit(1)

def generate_clean_parents(assets_root: str):
    block_models_dir = os.path.join(assets_root, "minecraft", "models", "block")

    print(f"[Diagnostic] Provided Assets Root: {assets_root}")
    print(f"[Diagnostic] Targeting Block Models: {block_models_dir}")

    if not os.path.isdir(block_models_dir):
        print(f"[Error] Target directory does not exist or structure is invalid.")
        print(f"Please check that this path exists: {block_models_dir}")
        return

    # Fix 1: Initialize ModelLibrary targeting 'models/block' exactly like parse_assets.py does
    lib = ModelLibrary(block_models_dir)
    
    # Scan the folder contents
    all_files = [f[:-5] for f in os.listdir(block_models_dir) if f.endswith(".json")]
    print(f"[Diagnostic] Found {len(all_files)} total block model files.")

    parent_models = set()
    for m_id in all_files:
        file_path = os.path.join(block_models_dir, f"{m_id}.json")
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)
                parent = data.get("parent")
                if parent:
                    # Clean the string (e.g., "minecraft:block/cube" -> "block/cube")
                    parent_clean = parent.split(":", 1)[-1]
                    if parent_clean.startswith("block/"):
                        parent_models.add(parent_clean)
        except Exception:
            continue

    print(f"[Diagnostic] Collected {len(parent_models)} unique parent template references.")

    sig_groups: dict[str, list[str]] = {}
    resolution_failures = 0
    empty_geometries = 0
    
    for parent_id in sorted(parent_models):
        resolved = None
        # Fix 2: Try both namespaced and raw identifiers to guarantee a match with ModelLibrary logic
        for candidate in [f"minecraft:{parent_id}", parent_id]:
            try:
                resolved = lib.resolve(candidate)
                if resolved and resolved.elements:
                    break
            except Exception:
                continue
        
        if not resolved:
            resolution_failures += 1
            continue
        if not resolved.elements:
            empty_geometries += 1
            continue
            
        try:
            sig = _signature(resolved.elements)
            sig_groups.setdefault(sig, []).append(parent_id)
        except Exception:
            continue

    print(f"[Diagnostic] Processing complete. (Failures: {resolution_failures}, Empty Shapes: {empty_geometries}, Groups: {len(sig_groups)})")

    # Output the finalized block configuration mapping
    print("\n# ==========================================================================")
    print("# AUTO-GENERATED _KNOWN_PARENTS MAPPING")
    print("# Paste this directly into shape_grouper.py")
    print("# Rotation-agnostic: base silhouette names only. shape_grouper.intern")
    print("# appends the build-time rotation tag (e.g. __x0_y180_z0) per variant.")
    print("# ==========================================================================")
    print("_KNOWN_PARENTS = {")
    
    for sig, models in sig_groups.items():
        # Force standard full block definitions to "full_block"
        if any(m in ["block/cube", "block/cube_all"] for m in models):
            canonical_name = "full_block"
        else:
            shortest_model = min(models, key=len)
            base_name = shortest_model.split("/")[-1]
            if base_name.startswith("template_"):
                base_name = base_name[len("template_"):]
            canonical_name = base_name

        print(f"    # --- Signature Group: {sig[:8]} (Shared by {len(models)} parents) ---")
        for m in models:
            print(f'    "{m}": "{canonical_name}",')
            
    print("}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python tools/lib/discover_parents.py <path_to_assets_root>")
        sys.exit(1)
        
    generate_clean_parents(sys.argv[1])