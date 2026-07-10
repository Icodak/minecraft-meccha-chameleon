gamemode adventure @s
scoreboard players reset @s meccha.hider_state

attribute @s minecraft:scale base set 1.0
attribute @s minecraft:safe_fall_distance base set 300
effect clear @s invisibility
effect give @s saturation infinite 99 true

function meccha:items/hunter_kit