gamemode adventure @s
scoreboard players operation @s meccha.hider_state = #RUNNING meccha.hider_state
function meccha:items/running_kit

attribute @s minecraft:scale base set 0.53
attribute @s minecraft:safe_fall_distance base set 300
effect give @s invisibility infinite 1 true
effect give @s saturation infinite 99 true

execute store result storage meccha:rt fol.rid int 1 run scoreboard players get @s meccha.rig
execute as @s run function meccha:rig/teleport_to_rig with storage meccha:rt fol