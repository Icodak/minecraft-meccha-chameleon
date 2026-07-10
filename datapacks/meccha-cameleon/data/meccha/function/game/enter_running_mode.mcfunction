gamemode adventure @s
scoreboard players operation @s meccha.hider_state = #RUNNING meccha.hider_state
function meccha:items/running_kit

attribute @s minecraft:scale base set 0.53
effect give @s invisibility infinite 1 true

execute store result storage meccha:rt fol.rid int 1 run scoreboard players get @s meccha.rig
execute as @s run function meccha:rig/teleport_to_rig with storage meccha:rt fol