# meccha:reset_rig
# Despawn ALL rigs (every rig entity) and clear all bindings. Storage registry
# is left intact (it is asset data, not rig state).
kill @e[tag=meccha_rig_part]
data modify storage meccha:players {} set value {}
tag @a remove meccha_bound
scoreboard players reset * meccha.rig
tellraw @s [{"text":"[Meccha] ","color":"green"},{"text":"all rigs cleared.","color":"gray"}]
