# meccha:rig/assign_rid   (macro: $(rid))
# Stamp the freshly-spawned (rig_unassigned) entities with this rig id, record
# data.rid on the markers, join the display team, then drop the transient tag.
$tag @e[tag=rig_unassigned] add r$(rid)
$execute as @e[tag=rig_unassigned,tag=meccha_cuboid] run data modify entity @s data.rid set value $(rid)
$execute as @e[tag=rig_unassigned,tag=meccha_rig_root] run data modify entity @s data.rid set value $(rid)
team join meccha_rig @e[tag=rig_unassigned,tag=meccha_pixel]
team join meccha_rig @e[tag=rig_unassigned,tag=meccha_overlay]
tag @e[tag=rig_unassigned] remove rig_unassigned
