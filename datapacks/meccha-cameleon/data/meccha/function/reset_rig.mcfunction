# meccha:reset_rig
# Despawn ALL rigs (every rig entity) and clear all bindings. Storage registry
# is left intact (it is asset data, not rig state).
kill @e[tag=meccha_rig_part]
execute if data storage meccha:players color run data modify storage meccha:rt reset_colors set from storage meccha:players color
execute if data storage meccha:rt reset_colors run data modify storage meccha:players color set from storage meccha:rt reset_colors
tag @a remove meccha_bound
scoreboard players reset * meccha.rig
tellraw @s [{"text":"[Meccha] ","color":"green"},{"text":"all rigs cleared.","color":"gray"}]
