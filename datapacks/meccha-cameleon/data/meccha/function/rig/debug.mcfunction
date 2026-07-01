# meccha:rig/debug
# List every live rig (root) with its id, pose and world origin + rotation.
tellraw @s [{"text":"── Meccha Rigs ──","color":"gold","bold":true}]
execute as @e[tag=meccha_rig_root] run function meccha:rig/debug_root
tellraw @s [{"text":"total pixels: ","color":"gray"},{"selector":"@e[tag=meccha_pixel]","color":"yellow"}]
