# meccha:dev/move_cuboid   (macro: $(rid) $(cuboid) $(dx) $(dy) $(dz))
# Translate a cuboid (all its co-located entities) by a relative offset.
$execute as @e[tag=cb_$(cuboid),tag=r$(rid)] run tp @s ~$(dx) ~$(dy) ~$(dz)
$tag @e[tag=cb_$(cuboid),tag=r$(rid),type=marker] add pose_dirty
$tellraw @s [{"text":"[dev] ","color":"green"},{"text":"r$(rid) $(cuboid) += ($(dx),$(dy),$(dz))","color":"gray"}]
