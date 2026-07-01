# meccha:hunter/register_hit   (executed AS the struck cuboid marker)
# Record this limb as the new nearest hit (cuboid + its rig id).
scoreboard players operation #BEST_T meccha.math = #TMIN meccha.math
data modify storage meccha:rt hunter.found set value 1b
data modify storage meccha:rt hunter.limb set from entity @s data.cuboid
data modify storage meccha:rt hunter.rid set from entity @s data.rid
execute store result storage meccha:rt hunter.t int 1 run scoreboard players get #TMIN meccha.math
# Remember the entity so on_hit can react (flash it, dock hp, etc.).
tag @e[tag=meccha_cuboid,tag=hunter_target] remove hunter_target
tag @s add hunter_target
