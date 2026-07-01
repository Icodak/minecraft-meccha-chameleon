# meccha:dev/list_cuboids
# List every cuboid with its world origin + rotation (reuses rig debug lines).
tellraw @s [{"text":"\u2500\u2500 cuboids \u2500\u2500","color":"gold","bold":true}]
execute as @e[tag=meccha_cuboid] run function meccha:rig/debug_cuboid
