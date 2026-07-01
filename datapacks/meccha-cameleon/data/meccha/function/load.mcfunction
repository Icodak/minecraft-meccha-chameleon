# meccha:load
# =====================================================================
# PILLAR 1 - Entry point registered in #minecraft:load
# Runs on world start AND every /reload. We therefore split work into:
#   (a) cheap runtime scaffolding -> rebuilt every reload (idempotent)
#   (b) heavy relational data     -> built ONCE, then persisted in storage
# =====================================================================

# ---- (a) cheap, idempotent runtime scaffolding -----------------------
function meccha:init/scoreboards
function meccha:init/constants
function meccha:init/hex_table
function meccha:init/int2hex_table
function meccha:init/trig_table
function meccha:init/storage_scaffold
function meccha:init/game_defaults
function meccha:init/teams

# ---- (b) heavy relational asset data (guarded) -----------------------
# The Python pipeline (Pillar 2) emits builder functions that populate
# storage meccha:registry. Re-running them on every /reload would copy
# megabytes of NBT each time and stall the server, so we guard on a flag.
execute unless data storage meccha:registry meta.loaded run function meccha:init/build_registry

# ---- ready banner ----------------------------------------------------
execute if data storage meccha:registry meta.loaded run tellraw @a [{"text":"[Meccha] ","color":"green","bold":true},{"text":"engine loaded - registry ready.","color":"gray","bold":false}]