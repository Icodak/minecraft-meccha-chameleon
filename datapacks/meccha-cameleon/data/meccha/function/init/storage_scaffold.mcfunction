# meccha:init/storage_scaffold
# Runtime (non-relational) storage. Rebuilt every reload - cheap & safe.
# Relational asset data (meccha:registry) is NOT touched here.

# Per-tick scratch space used by raycast callbacks and the paintbrush.
data modify storage meccha:rt scratch set value {}

# Live list of tracked hider rigs (BVH roots live in meccha:players, see Pillar 7).
data modify storage meccha:rt active_rigs set value []

# Per-player colour map, keyed by stringified UUID.
data modify storage meccha:players color set value {}

# Active brush colour (shared by the eyedropper, paintbrush and dialog picker).
# Only initialised if missing, so a chosen colour survives /reload.
execute unless data storage meccha:rt last_sample run data modify storage meccha:rt last_sample set value "#000000FF"
