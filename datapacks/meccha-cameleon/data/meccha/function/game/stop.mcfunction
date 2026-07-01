# meccha:game/stop
# End the round: mark it over and lift any lingering hunter effects.
# (Roles/items are kept so a new round can start quickly; use game/reset or
#  role/clear_all to fully tear down.)
data modify storage meccha:game phase set value "over"
data modify storage meccha:game timer set value 0
effect clear @a[tag=meccha_hunter] minecraft:blindness
effect clear @a[tag=meccha_hunter] minecraft:darkness
effect clear @a[tag=meccha_hunter] minecraft:slowness
effect clear @a[tag=meccha_hunter] minecraft:jump_boost
title @a actionbar [{"text":"Round over","color":"gray"}]
