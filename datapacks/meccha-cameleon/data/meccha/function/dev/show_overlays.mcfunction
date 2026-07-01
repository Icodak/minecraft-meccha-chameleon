# meccha:dev/show_overlays
# Force the shading pass to recompute every overlay this tick.
tag @e[tag=meccha_cuboid,type=marker] add pose_dirty
tellraw @s [{"text":"[dev] ","color":"green"},{"text":"shading overlays refreshed.","color":"gray"}]
