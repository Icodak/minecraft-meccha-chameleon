# meccha:role/make_hider   (executed AS the target player)
# Assign the Hider role: tag, team, fresh kit. Usable as
#   /execute as <player> run function meccha:role/make_hider
tag @s remove meccha_hunter
tag @s add meccha_hider
team join meccha_hiders @s
function meccha:role/clear_items
function meccha:give/hider_kit
# Give the hider their own rig (bound + following). Replace any previous one.
function meccha:rig/unbind
function meccha:rig/spawn_for
title @s title [{"text":"HIDER","color":"green","bold":true}]
title @s subtitle [{"text":"Blend in. Avoid the hunters.","color":"gray"}]
playsound minecraft:entity.player.levelup player @s ~ ~ ~ 1 1.4
