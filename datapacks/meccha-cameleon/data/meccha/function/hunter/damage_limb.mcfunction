# meccha:hunter/damage_limb   (executed AS the struck cuboid marker)
# Decrement the limb hp; at 0 mark it destroyed (its pixels could be hidden).
execute store result score #HP meccha.math run data get entity @s data.hp 1
scoreboard players remove #HP meccha.math 1
execute store result entity @s data.hp int 1 run scoreboard players get #HP meccha.math
execute if score #HP meccha.math matches ..0 run tag @s add limb_destroyed
