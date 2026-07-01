# meccha:dev/show_axes   (run directly; draws once)
# Visualise each cuboid's local orientation: a particle along its rotated
# +X (red/flame), +Y (crit) and +Z (happy_villager) axes, plus the origin.
execute as @e[tag=meccha_cuboid] at @s run function meccha:dev/axes_at
tellraw @s [{"text":"[dev] ","color":"green"},{"text":"drew cuboid axes (run again to refresh).","color":"gray"}]
