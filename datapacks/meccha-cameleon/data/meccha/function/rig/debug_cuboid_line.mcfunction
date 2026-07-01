# meccha:rig/debug_cuboid_line   (macro: $(rid) $(id) $(x) $(y) $(z) $(yaw) $(pitch))
$tellraw @s [{"text":"  r$(rid) $(id)","color":"green"},{"text":"  @ ($(x),$(y),$(z))  rot($(yaw),$(pitch))","color":"gray"}]
