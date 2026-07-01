# meccha:role/clear   (executed AS a player)
# Remove this player's role entirely (items, tags, team, effects, bound rig).
function meccha:role/clear_items
function meccha:rig/unbind
tag @s remove meccha_hider
tag @s remove meccha_hunter
team leave @s
effect clear @s minecraft:blindness
effect clear @s minecraft:darkness
effect clear @s minecraft:slowness
effect clear @s minecraft:jump_boost
