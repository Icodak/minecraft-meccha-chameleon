# meccha:game/stop
# End the round: mark it over and lift any lingering hunter effects.
# (Roles/items are kept so a new round can start quickly; use game/reset or
#  role/clear_all to fully tear down.)
data modify storage meccha:game phase set value "over"
data modify storage meccha:game timer set value 0
effect clear @a
clear @a
execute as @a run attribute @s minecraft:scale base reset
execute as @a run attribute @s minecraft:safe_fall_distance base reset
title @a actionbar [{"text":"Round over","color":"gray"}]

function meccha:items/cancel_scheduled
function meccha:highlight_rig/stop_highlight_blink

function meccha:game/suggest_start_new_game