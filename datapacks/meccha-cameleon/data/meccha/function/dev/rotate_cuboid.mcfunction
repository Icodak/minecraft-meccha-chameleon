# meccha:dev/rotate_cuboid   (macro: $(rid) $(cuboid) $(yaw) $(pitch))
# Set a cuboid's world rotation directly (tests shading + OBB hit math).
$tp @e[tag=cb_$(cuboid),tag=r$(rid)] ~ ~ ~ $(yaw) $(pitch)
$tag @e[tag=cb_$(cuboid),tag=r$(rid),type=marker] add pose_dirty
$tellraw @s [{"text":"[dev] ","color":"green"},{"text":"r$(rid) $(cuboid) -> rot($(yaw),$(pitch))","color":"gray"}]
