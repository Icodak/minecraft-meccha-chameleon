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
function meccha:init/empty_string
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
execute if data storage meccha:registry meta.loaded run tellraw @a [{"text":"═════════════════════════════════\n","color":"dark_gray"},{"text":"                                Welcome to\n","color":"white"},{"text":"                  "},{color:"#ff2dea",text:"✦ "},{color:"#ff4baf",text:"M"},{color:"#ff5a91",text:"i"},{color:"#ff6973",text:"n"},{color:"#ff7756",text:"e"},{color:"#ff8638",text:"c"},{color:"#ff951a",text:"r"},{color:"#ffa217",text:"a"},{color:"#ffae1c",text:"f"},{color:"#ffbb21",text:"t "},{color:"#ffd32b",text:"M"},{color:"#ffe030",text:"e"},{color:"#ffec35",text:"c"},{color:"#f8f334",text:"c"},{color:"#e9f52d",text:"h"},{color:"#daf626",text:"a "},{color:"#bcfa18",text:"C"},{color:"#adfc11",text:"h"},{color:"#9efe0a",text:"a"},{color:"#8eff0c",text:"m"},{color:"#7aff27",text:"e"},{color:"#65ff42",text:"l"},{color:"#51ff5c",text:"e"},{color:"#3dff77",text:"o"},{color:"#29ff92",text:"n "},{color:"#00ffc8",text:"✦"},{"text":"\n"},{"text":"                         "},{"text":"▶ Start the Game ◀\n\n","color":"green","bold":true,"underlined":true,"click_event":{"action":"run_command","command":"trigger meccha.start_new_round set 1"},"hover_event":{"action":"show_text","value":{"text":"Click to start the game","color":"green"}}},{"text":"Configuration & Setup Tools:\n","color":"yellow"},{"text":"• Set Hide Time (ex: 45s) ","color":"gray"},{"text":"[✎ Edit]","color":"aqua","underlined":true,"click_event":{"action":"suggest_command","command":"/function meccha:game/set_hide_time {seconds:45}"},"hover_event":{"action":"show_text","value":{"text":"Click to copy command","color":"aqua"}}},{"text":"\n• Set Round Time (ex: 240s) ","color":"gray"},{"text":"[✎ Edit]","color":"aqua","underlined":true,"click_event":{"action":"suggest_command","command":"/function meccha:game/set_round_time {seconds:240}"},"hover_event":{"action":"show_text","value":{"text":"Click to copy command","color":"aqua"}}},{"text":"\n• View Current Settings ","color":"gray"},{"text":"[✎ Edit]","color":"aqua","underlined":true,"click_event":{"action":"suggest_command","command":"/function meccha:game/settings"},"hover_event":{"action":"show_text","value":{"text":"Click to copy command","color":"aqua"}}},{"text":"\n• Add Map Spawn Location ","color":"gray"},{"text":"[✎ Edit]","color":"aqua","underlined":true,"click_event":{"action":"suggest_command","command":"/dialog show @s meccha:add_spawn_location"},"hover_event":{"action":"show_text","value":{"text":"Click to copy command","color":"aqua"}}},{"text":"\n═════════════════════════════════","color":"dark_gray"}]