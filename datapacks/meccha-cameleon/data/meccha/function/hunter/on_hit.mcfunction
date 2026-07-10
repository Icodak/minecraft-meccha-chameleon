# meccha:hunter/on_hit   (executed AS the shooter)
# React to the nearest limb hit: feedback + dock that limb's hp.
function meccha:hunter/on_hit_msg with storage meccha:rt hunter
execute as @e[tag=meccha_cuboid,tag=hunter_target,limit=1] run function meccha:hunter/damage_limb
playsound minecraft:entity.firework_rocket.blast master @s ~ ~ ~ 1 0.8
